/*

NAME: SAI VIGNESH GOLLA
CWID: 20008561



1) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t1 as (select cust, prod, month, state, avg(quant) from sales group by cust, prod, month, state),
t2 as (select t1.cust, t1.prod, t1.month, t1.state, avg(s.quant) from t1 left join sales s 
	   on t1.cust = s.cust and t1.prod != s.prod and t1.month = s.month and t1.state = s.state 
	   group by t1.cust, t1.prod, t1.month, t1.state),
t3 as (select t1.cust, t1.prod, t1.month, t1.state, avg(s.quant) from t1 left join sales s 
	   on t1.cust = s.cust and t1.prod = s.prod and t1.month != s.month and t1.state = s.state 
	   group by t1.cust, t1.prod, t1.month, t1.state),
t4 as (select t1.cust, t1.prod, t1.month, t1.state, avg(s.quant) from t1 left join sales s 
	   on t1.cust = s.cust and t1.prod = s.prod and t1.month = s.month and t1.state != s.state 
	   group by t1.cust, t1.prod, t1.month, t1.state)
select t1.cust as "CUSTOMER", t1.prod as "PRODUCT", t1.month as "MONTH", 
t1.state as "STATE", t1.avg as "CUST_AVG", 
t2.avg as "OTHER_PROD_AVG", 
t3.avg as "OTHER_MONTH_AVG", 
t4.avg as "OTHER_STATE_AVG" 
from t1, t2, t3, t4 where 
t1.cust = t2.cust and 
t1.prod = t2.prod and
t1.month = t2.month and
t1.state = t2.state and 
t1.cust = t3.cust and 
t1.prod = t3.prod and
t1.month = t3.month and
t1.state = t3.state and 
t1.cust = t4.cust and 
t1.prod = t4.prod and
t1.month = t4.month and
t1.state = t4.state 




/* 2) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t1 as (select cust, prod, state, month from sales group by cust, prod, state, month),
t2 as (select t1.cust, t1.prod, t1.state, t1.month, avg(s.quant) from t1 left join sales s on 
	   t1.cust = s.cust and 
	   t1.prod = s.prod and
	   t1.state = s.state and 
	   t1.month+1 = s.month 
	   group by t1.cust, t1.prod, t1.state, t1.month),
t3 as (select t1.cust, t1.prod, t1.state, t1.month, avg(s.quant) from t1 left join sales s on 
	   t1.cust = s.cust and 
	   t1.prod = s.prod and 
	   t1.state = s.state and 
	   t1.month-1 = s.month 
	   group by t1.cust, t1.prod, t1.state, t1.month)
select t1.cust as "CUSTOMER", t1.prod as "PRODUCT", t1.state as "STATE", t1.month as "MO", 
t3.avg as "BEFORE_AVG", t2.avg as "AFTER_AVG" 
 from t1 join t2 on  
 t1.cust = t2.cust and 
 t1.prod = t2.prod and 
 t1.state = t2.state and 
 t1.month = t2.month 
 join t3 on 
 t1.cust = t3.cust and 
 t1.prod = t3.prod and 
 t1.state = t3.state and 
 t1.month = t3.month 




/* 3) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t1 as (select prod, quant from sales group by prod, quant),
t2 as (select t1.prod, t1.quant, count(*) from t1 join sales s on 
	   t1.prod = s.prod and t1.quant>=s.quant group by t1.prod, t1.quant),
t3 as (select prod, count(*) from sales group by prod)
select t2.prod as "PRODUCT", min(t2.quant) as "MEDIAN QUANT" from t2 join t3 on 
t2.prod = t3.prod and t2.count >= (t3.count/2) group by t2.prod




/* 4) -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

with t1 as (select cust, prod, sum(quant)*0.75 s75 from sales group by cust, prod),
t2 as (select cust, prod, month, sum(quant) from sales group by cust, prod, month),
t3 as (select t2.cust, t2.prod, t2.month, sum(s.sum) from t2 join t2 s on 
	   t2.cust = s.cust and t2.prod = s.prod and t2.month >= s.month group by t2.cust, t2.prod, t2.month)
select t3.cust as "CUSTOMER", t3.prod as "PRODUCT", min(t3.month) as "75% PURCHASED BY MONTH" from t3 join t1 on 
t3.cust = t1.cust and t3.prod = t1.prod and t3.sum >= t1.s75 group by t3.cust, t3.prod


/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/