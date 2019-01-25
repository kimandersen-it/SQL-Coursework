/*SQL Homework */
-- Kim Andersen
-- 01/24/2019

use Sakila;

#will not update without where clause
set SQL_SAFE_UPDATES = 1;

-- Display the first and last names of all actors from the table actor.
SELECT
    first_name,
    last_name
FROM actor;

-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT 
    upper(concat(first_name, " ", last_name)) AS 'Actor Name'
FROM actor;


-- You need to find the ID number, first name, and last name of an actor, 
-- whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT
    actor_id,
    first_name,
    last_name
FROM 
    actor
WHERE first_name = 'Joe';

-- Find all actors whose last name contain the letters GEN:
SELECT * 
FROM actor
WHERE last_name LIKE '%GEN%';

-- Find all actors whose last names contain the letters LI. This time, order the rows 
-- last name and first name, in that order:  
SELECT * 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY
    last_name, first_name;
    

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country IN ("Afghanistan", "Bangladesh", "China");   

-- You want to keep a description of each actor. You don't think you will be performing 
-- queries on a description, so create a column in the table actor named description and 
-- use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
    ADD COLUMN description blob;
    
-- Very quickly you realize that entering descriptions for each actor is 
-- too much effort. Delete the description column.
ALTER TABLE actor
    DROP COLUMN description;
 
 -- List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name,
    COUNT(actor_id)

FROM actor

GROUP BY
    last_name
   
ORDER BY last_name;
 
-- List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT 
    last_name,
    COUNT(actor_id) 

FROM actor

GROUP  BY
    last_name
    
HAVING COUNT(actor_id) > '1' 
   
ORDER BY last_name;

-- check out table before making change  
SELECT * FROM actor
ORDER BY first_name;

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "harpo"
WHERE first_name = "groucho" AND last_name = "williams"
ORDER BY first_name;

-- check out table after change
SELECT * FROM actor
ORDER BY first_name;

-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that 
-- GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name = "groucho"
WHERE last_name = "williams";


-- You cannot locate the schema of the address table. Which query would you use to re-create it?
SELECT * 

FROM
  	INFORMATION_SCHEMA.TABLES
    WHERE table_name = "address";


-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT 
    first_name,
    last_name,
    address
FROM staff INNER JOIN address ON address.address_id = staff.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT 
    st.staff_id,
    first_name,
    last_name,
    format(sum(amount), 2) AS Total
    
FROM 
    staff st INNER JOIN payment pm ON st.staff_id = pm.staff_id
    
WHERE payment_date BETWEEN '2005-08-01% 00:00:00' AND '2005-08-31 11:59:59'

GROUP BY 
    st.staff_id,
    first_name,
    last_name
;
-- List each film and the number of actors who are listed for that film. 
SELECT * FROM staff;

-- List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT 
    fl.title,
    COUNT(act.actor_id) AS NumberActors

    
FROM
    film fl INNER JOIN film_actor act ON fl.film_id = act.film_id
    
GROUP BY
    fl.title
;
    
-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT
    fl.title,
    COUNT(fl.film_id) AS NumberofCopies
    
    
FROM
    film fl INNER JOIN inventory inv ON fl.film_id = inv.film_id
    
WHERE fl.title = 'Hunchback Impossible'

GROUP BY
    fl.title    
;

-- Using the tables payment and customer and the JOIN command, list the total 
-- paid by each customer. List the customers alphabetically by last name:

SELECT
    last_name,
    first_name,
    sum(amount) AS 'Total Paid'
    
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id

GROUP BY
    last_name,
    first_name

ORDER BY
    last_name,
    first_name
;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared 
-- in popularity. Use subqueries to display the titles of movies starting with the letters
-- K and Q whose language is English.

SELECT
    title
   
FROM film
   
WHERE 
    (title LIKE 'k%' OR title LIKE 'q%')
        AND language_id = (SELECT language_id FROM language WHERE name = 'english')
    
ORDER BY title
;

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    first_name,
    last_name
        
FROM
    actor 
    
    WHERE actor_id IN 
    
    (SELECT DISTINCT
        film_actor.actor_id
        FROM film_actor INNER JOIN film ON film_actor.film_id = film.film_id
        WHERE film.title = 'Alone Trip'
        )

;
    
    -- You want to run an email marketing campaign in Canada, for which you will 
    -- need the names and email addresses of all Canadian customers. 
    -- Use joins to retrieve this information.

SELECT
    cust.first_name,
    cust.last_name,
    cust.email,
    country.country
FROM
    customer cust INNER JOIN address ad ON cust.address_id = ad.address_id
    INNER JOIN city ON ad.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    
WHERE
    country.country = 'Canada'

;

-- Sales have been lagging among young families, and you wish to target 
-- all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT 
    film.title AS 'Film Title',
    category.name AS Category

FROM
    film INNER JOIN film_category ON film.film_id = film_category.film_id
    INNER JOIN category ON film_category.category_id = category.category_id
    
WHERE category.name = 'Family'
;    

-- Display the most frequently rented movies in descending order.

SELECT 
    film.title,
    COUNT(rental.inventory_id) AS 'Times Rented'
 
FROM 
    rental INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film ON inventory.film_id = film.film_id
    
GROUP BY film.title

ORDER BY 
     COUNT(rental.inventory_id) DESC
;     
-- Write a query to display how much business, in dollars, each store brought in.

SELECT 
    store.store_id,
     format(sum(amount), 2) AS Total
    
FROM payment pay 
    INNER JOIN staff ON pay.staff_id = staff.staff_id
    INNER JOIN store ON staff.store_id = store.store_id
    
GROUP BY 
    store.store_id

;
-- checking results of last query
SELECT SUM(amount) FROM payment;

-- Write a query to display for each store its store ID, city, and country.

SELECT  
    store.store_id,
    city.city,
    country.country
    
FROM
    store INNER JOIN address ON store.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    
;
-- List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables:
--  category, film_category, inventory, payment, and rental.)    
    
 SELECT * FROM film_category   
 ;       
use sakila;

SELECT 
    category.name,
    format(sum(payment.amount), 2) AS Total

FROM film_category INNER JOIN category ON film_category.category_id = category.category_id
    INNER JOIN inventory ON inventory.film_id = film_category.category_id
    INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
      category.name
      
ORDER BY
    SUM(payment.amount) DESC
    
LIMIT 5
;
   
   
   -- In your new role as an executive, you would like to have an easy way of viewing 
   -- the Top five genres by gross revenue. Use the solution from the problem above
   -- to create a view. If you haven't solved 7h, you can substitute another query 
   -- to create a view.
CREATE VIEW Top_Genres AS     
SELECT 
    category.name,
    format(sum(amount), 2) AS Total

FROM film_category INNER JOIN category ON film_category.category_id = category.category_id
    INNER JOIN inventory ON inventory.film_id = film_category.category_id
    INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
      category.name  
ORDER BY
    SUM(payment.amount) DESC
LIMIT 5
;
       
-- How would you display the view that you created in 8a?    
SELECT * FROM top_genres;

-- You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_genres;

