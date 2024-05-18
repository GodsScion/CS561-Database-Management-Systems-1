/*

NAME: SAI VIGNESH GOLLA
CWID: 20008561



1) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with tbl1 as ( select prod, max(quant), min(quant), avg(quant) from sales group by prod),
tbl2 as (select sales.prod, quant, cust, date, state from sales, tbl1 where sales.prod = tbl1.prod and sales.quant = tbl1.max),
tbl3 as (select sales.prod, quant, cust, date, state from sales, tbl1 where sales.prod = tbl1.prod and sales.quant = tbl1.min)
select tbl1.prod as "PRODUCT", tbl1.max as "MAX_Q", tbl2.cust as "MAX_CUST", tbl2.date as "MAX_DATE", tbl2.state as "ST", tbl1.min as "MIN_Q", tbl3.cust as "MIN_CUST", tbl3.date as "MIN_DATE", tbl3.state as "ST", round(tbl1.avg) as "AVG_Q" 
from tbl1, tbl2, tbl3 
where tbl1.prod = tbl2.prod and tbl1.prod = tbl3.prod



/* 2) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t1 as (select cust, prod, quant, date from sales 
			where state = 'NY' and 
			(cust,prod,quant) in (select cust, prod, max(quant) from sales where state = 'NY' group by cust, prod)),
t2 as (select cust, prod, quant, date from sales 
	   where state = 'NJ' and 
	   (cust,prod,quant) in (select cust, prod, min(quant) from sales where state = 'NJ' and year>2000 group by cust, prod)),
t3 as (select cust, prod, quant, date from sales 
	   where state = 'CT' and 
	   (cust,prod,quant) in (select cust, prod, min(quant) from sales where state = 'CT' and year>2000 group by cust, prod))
select t1.cust as "CUSTOMER", t1.prod as "PRODUCT", t1.quant as "NY_MAX", t1.date as "DATE", t2.quant as "NJ_MIN", t2.date as "DATE", t3.quant as "CT_MIN", t3.date as "DATE" 
from t1, t2, t3 
where t1.cust = t2.cust and t1.prod = t2.prod  and  t1.cust = t3.cust and t1.prod = t3.prod



/* 3) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t1 as (select month, state, sum(quant) from sales group by month,state),
t2 as (select month, max(sum) from t1 group by month),
t3 as (select month, state, sum from t1 where (month,sum) in (select month, min(sum) from t1 group by month))
select t1.month as "MONTH", t1.state as "MOST_POPULAR_ST", t1.sum as "MOST_POP_TOTAL_Q", t3.state as "LEAST_POPULAR_ST", t3.sum as "LEAST_POP_TOTAL_Q" 
from t1,t2,t3 where t1.month = t2.month and t1.month = t3.month and t1.sum = t2.max 
order by t1.month



/* 4) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with tp1 as (select cust, prod, sum(quant) from sales group by cust, prod),
tp2 as (select cust, max(sum) from tp1 group by cust),
tp3 as (select cust, prod, sum from tp1 where (cust,sum) in (select cust,min(sum) from tp1 group by cust)),
ts1 as (select cust, state, count(*) from sales group by cust, state order by cust, state),
ts2 as (select cust, max(count) from ts1 group by cust),
ts3 as (select cust, state, count from ts1 where (cust,count) in (select cust, min(count) from ts1 group by cust) )
select tp1.cust as "CUSTOMER", tp1.prod as "MOST_FAV_PROD", tp3.prod as "LEAST_FAV_PROD", ts1.state as "MOST_FAV_ST", ts3.state as "LEAST_FAV_ST" 
from tp1,tp2,tp3,ts1,ts2,ts3 where 
tp1.cust = tp2.cust and tp1.cust = tp3.cust and tp1.sum = tp2.max 
and tp1.cust = ts1.cust 
and ts1.cust = ts2.cust and ts1.cust = ts3.cust and ts1.count = ts2.max



/* 5) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t as (select cust, prod, sum(quant), avg(quant), count(*) from sales  group by cust, prod),
q1 as (select cust, prod, sum(quant) from sales where month<4 group by cust, prod),
q2 as (select cust, prod, sum(quant) from sales where month>3 and month<7 group by cust, prod),
q3 as (select cust, prod, sum(quant) from sales where month>6 and month<10 group by cust, prod),
q4 as (select cust, prod, sum(quant) from sales where month>9 group by cust, prod)
select t.cust as "CUSTOMER", t.prod as "PRODUCT", q1.sum as "Q1_TOT", q2.sum as "Q2_TOT", q3.sum as "Q3_TOT", q4.sum as "Q4_TOT", round(t.avg) as "AVERAGE", t.sum as "TOTAL", t.count as "COUNT" 
from t,q1,q2,q3,q4 
where t.cust = q1.cust and t.prod = q1.prod and 
t.cust = q2.cust and t.prod = q2.prod and 
t.cust = q3.cust and t.prod = q3.prod and 
t.cust = q4.cust and t.prod = q4.prod 


/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/