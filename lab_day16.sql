#top 10 renters, which film category do they prefer?

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
GROUP BY customer_id
ORDER BY num_rentals DESC
limit 37;


SELECT customer_id, first_name, last_name, count(rental_id) as num_rentals
FROM customer
JOIN rental using (customer_id)
JOIN inventory using (inventory_id)
JOIN film using (film_id)
JOIN film_category using (film_id)
JOIN category using (category_id)
GROUP BY customer_id
ORDER BY num_rentals DESC
limit 37;



SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, count(rental_id) as rentals
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday
ORDER BY rentals DESC;

#good
SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, category.name as category, count(rental_id) as rentals
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday, category
ORDER BY rental_weekday DESC;
#good
select category.name, count(rental_id) as rentals_by_cat
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY category.name;

#---



SELECT DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') AS rental_weekday, category.name as category, count(rental_id) as rentals,
row_number() OVER (partition by DATE_FORMAT(CONVERT(substring_index(rental_date, ' ', 1), DATE), '%W') order by count(category.name) DESC) as rowno
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY rental_weekday, category
ORDER BY rental_weekday;


