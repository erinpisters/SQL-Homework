USE sakila;

-- 1a --
SELECT first_name, last_name FROM actor;

-- 1b -- 
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS ACTOR_NAME FROM actor;

-- 2a -- 
SELECT last_name, actor_id FROM actor
WHERE first_name = "Joe";

-- 2b --
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c --
SELECT last_name, first_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d --
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');


-- 3a --
ALTER TABLE actor 
ADD COLUMN description BLOB;

-- 3b --
ALTER TABLE actor
DROP COLUMN description; 

-- 4a -- 
SELECT DISTINCT last_name, COUNT(last_name) FROM actor
GROUP BY last_name; 

-- 4b --
SELECT DISTINCT last_name, COUNT(last_name) AS count_name FROM actor 
GROUP BY last_name
HAVING count_name >=2;

-- 4c --
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d --  
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a -- 
SHOW CREATE TABLE address;
CREATE TABLE IF NOT EXISTS address (
	address_id SMALLINT(5) NOT NULL,
    address VARCHAR(50),
    address2 VARCHAR(50),
    district VARCHAR(20),
    city_id SMALLINT(5),
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    location GEOMETRY,
    last_update TIMESTAMP,
    PRIMARY KEY(address_id)
);

-- 6a --
SELECT first_name, last_name, address
FROM staff s
INNER JOIN address a 
ON s.address_id = a.address_id;

-- 6b --
SELECT first_name, last_name, SUM(amount)
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY p.staff_id;

-- 6c --
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;


-- 6d --
SELECT title, (
SELECT COUNT(*) FROM inventory
WHERE film.film_id = inventory.film_id
) AS 'Number of Hunchback Copies'
FROM film
WHERE title = "Hunchback Impossible";

-- 6e --
SELECT c.last_name,c.first_name, SUM(p.amount) AS 'Total Paid'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.last_name; 

-- 7a -- 

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film
WHERE language_id = 1
);

-- 7b --
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

-- 7c --
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city 
ON city.city_id = a.city_id
JOIN country
ON country.country_id = city.country_id
WHERE country.country = 'Canada';

-- 7d --
SELECT title, description
FROM film
WHERE film_id IN
(
SELECT film_id
FROM film_category
WHERE category_id IN
(
SELECT category_id 
FROM category
WHERE name = "Family"
));

-- 7e --
SELECT f.title, COUNT(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f 
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f--
SELECT s.store_id, SUM(amount) AS 'Profit'
FROM payment p
JOIN rental r 
ON p.rental_id = r.rental_id
JOIN inventory i 
ON i.inventory_id = r.inventory_id
JOIN store s 
ON s.store_id = i.store_id
GROUP BY s.store_id;

-- 7g --
SELECT s.store_id, city.city, country.country
FROM store s
JOIN address a 
ON s.address_id = a.address_id
JOIN city 
ON city.city_id = a.city_id
JOIN country
ON country.country_id = city.country_id;

-- 7h--
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross_Rev'
FROM category c
JOIN film_category fc
ON c.category_id=fc.category_id
JOIN inventory i 
ON fc.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name ORDER BY Gross_Rev LIMIT 5;

-- 8a -- 
CREATE VIEW Genre_Top5GrossRev AS 
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross_Rev'
FROM category c
JOIN film_category fc
ON c.category_id=fc.category_id
JOIN inventory i 
ON fc.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name ORDER BY Gross_Rev LIMIT 5;


-- 8b -- 
SELECT * FROM Genre_Top5GrossRev;

-- 8c -- 
DROP VIEW Genre_Top5GrossRev;






















