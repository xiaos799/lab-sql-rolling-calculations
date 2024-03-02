use sakila;

# 1.Get number of monthly active customers.
select * from rental;

create or replace view active_customer as
select year(rental_date) as year, month(rental_date) as month, count(customer_id) as num_customer
from rental
group by year, month;

select * from active_customer;


# 2.Active users in the previous month.
select year, month, num_customer, lag(num_customer) over () as previous_num_customer from active_customer where year = 2005;


# 3.Percentage change in the number of active customers.
select year, month, (num_customer - lag(num_customer) over ())/lag(num_customer) over ()*100 as variance_percent
from (select year, month, num_customer, lag(num_customer) over () as previous_num_customer from active_customer where year = 2005) sub;


# 4.Retained customers every month.
with cte as (
select month(rental_date) as month, customer_id
from rental
where year(rental_date) = 2005)
select c1.month, c1.customer_id from cte c1 
join cte c2 on c1.customer_id = c2.customer_id and c1.month = c2.month + 1;




