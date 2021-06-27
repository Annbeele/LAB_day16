# We'd like to do a marketing campaign in order to engage less active renters.
# Question: Which top 3 film categories do the 50 less active renters prefer?


# 1) 50 less active renters:
select * from category;
select * from film_category;

select customer_id, first_name, last_name, count(rental_id) as num_rentals, country
from category cat
join film_category fc
using (category_id)
join film
using (film_id)
join inventory i
using (film_id)
join rental r
using (inventory_id)
join customer cus
using (customer_id)
join address a
using (address_id)
join city ci
using(city_id)
join country co
using (country_id)
WHERE cus.active = True
GROUP BY customer_id
ORDER BY num_rentals ASC
limit 50;



# Top 3 film categories preferred by the 50 less active renters
select c.customer_id,
concat(c.first_name, ' ', c.last_name) as custname,
ca.name as filmcategory, count(distinct r.rental_id) as noofrentals,
row_number() over(partition by customer_id order by count(distinct r.rental_id) DESC) as ranking
FROM customer c
join rental r using(customer_id)
join inventory using(inventory_id)
join film using(film_id)
join film_category using(film_id)
join category ca using(category_id)
where c.customer_id in
(
select customer_id from
(SELECT
customer_id, first_name, last_name,
count(distinct r.rental_id) as noofrentals,
row_number() over (order by count(distinct r.rental_id) ASC) as activerank
FROM customer c
join rental r using(customer_id)
group by customer_id) sub1
where activerank <=50
)
group by ca.name, c.customer_id, c.last_name, c.first_name
order by ranking
limit 150;




#  -------------------------------



#Just some queries I was testing (at the end, decided not to use them):

select customer_id
from category cat
join film_category fc
using (category_id)
join film
using (film_id)
join inventory i
using (film_id)
join rental r
using (inventory_id)
join customer cus
using (customer_id)
join address a
using (address_id)
join city ci
using(city_id)
join country co
using (country_id)
WHERE cus.active = True
GROUP BY customer_id
ORDER BY count(rental_id)
limit 50;



SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, category.name as category, count(rental_id) as rentals
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday, category
ORDER BY category DESC;

#rentals per weekday

SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, count(rental_id) as rentals
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday
ORDER BY rentals DESC;


#rentals by cat
select category.name, count(rental_id) as rentals_by_cat
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY category.name
ORDER BY rentals_by_cat DESC;


#rentals by cat per weekday
SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, category.name as category, count(rental_id) as rentals
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday, category
ORDER BY rental_weekday DESC;


#---

#rentals by cat per weekday ranking

SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, category.name as category, count(rental_id) as rentals,
row_number() OVER (partition by DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') order by count(category.name) DESC) as rowno
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday, category
ORDER BY rental_weekday;

#top 3 per weekday --> creo una vista i llavors obro la vista i ordeno per
#rental_weekday
create or replace view top_3 as 
SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, category.name as category, count(rental_id) as rentals,
row_number() OVER (partition by DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') order by count(category.name) DESC) as rowno
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday, category
ORDER BY rowno
limit 21;



