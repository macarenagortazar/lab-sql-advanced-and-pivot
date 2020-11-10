#Lab | Advanced SQL and Pivot tables

-- In this lab, you will be using the Sakila database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official installation link.
use sakila;

-- Instructions
-- Write the SQL queries to answer the following questions:

-- 1.Select the first name, last name, and email address of all the customers who have rented a movie.
select concat(first_name," ",last_name), email, count(rental_id) as nber_films_rented from sakila.customer as c
left join sakila.rental as r
on c.customer_id=r.customer_id
group by concat(first_name," ",last_name)
having count(rental_id)>0
order by concat(first_name," ",last_name);



-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select c.customer_id, concat(first_name," ",last_name) as full_name, round(avg(p.amount),2) as average_payment from sakila.customer as c
left join sakila.payment as p
on c.customer_id=p.customer_id
group by customer_id;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies. 

-- Write the query using multiple join statements
select distinct concat(first_name," ",last_name), email, name from sakila.customer as c
join sakila.rental as r 
on c.customer_id=r.customer_id
join sakila.inventory as i
on i.inventory_id=r.inventory_id
join sakila.film_category as fc
on i.film_id=fc.film_id
join category as cat
on fc.category_id=cat.category_id
where name="Action"
order by concat(first_name," ",last_name);

-- Write the query using sub queries with multiple WHERE clause and IN condition

select concat(first_name," ",last_name), email from sakila.customer 
where customer_id in (select customer_id from sakila.rental
where rental_id in (select inventory_id from sakila.inventory 
where film_id in (select film_id from sakila.film_category 
where category_id in (select category_id from sakila.category 
where name="Action"))) )
order by concat(first_name," ",last_name);

-- Verify if the above two queries produce the same results or not
#They don´t 

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select payment_id,
(case when amount<2 and amount>=0 then amount end ) as "Low",
(case when amount>=2 and amount<4 then amount end) as "Medium",
(case when amount>=4 then amount end) as "High"
from sakila.payment;

select customer_id,
count(case when amount<2 and amount>=0 then amount end ) as "Low",
count(case when amount>=2 and amount<4 then amount end) as "Medium",
count(case when amount>=4 then amount end) as "High"
from sakila.payment
group by customer_id;

