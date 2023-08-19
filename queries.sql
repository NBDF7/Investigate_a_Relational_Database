--Question Set1

--Query 1 - the query used for Question 1 insight

SELECT
    sub.category_name,
    SUM(sub.rental_count)
FROM (
    SELECT
        f.title AS film_title,
        c.name AS category_name,
        COUNT(f.title) AS rental_count
    FROM
        film_category fc
        JOIN category c ON fc.category_id = c.category_id
        JOIN film f ON fc.film_id = f.film_id
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r  ON i.inventory_id = r.inventory_id
    WHERE
        c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    GROUP BY
        1,
        2
    ORDER BY
        2)sub
WHERE
    sub.category_name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
    1
ORDER BY
    2 DESC;



--Query 2 - the query used for Question 2 insight

SELECT
    sub.name,
    COUNT(sub.name)
FROM(
   SELECT
       f.title AS title,
       c.name AS name,
       f.rental_duration AS rental_duration,
       NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
   FROM
       film_category fc
       JOIN category c ON fc.category_id = c.category_id
       JOIN film f ON fc.film_id = f.film_id
  WHERE
       c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))sub
 WHERE
     sub.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
   AND
     sub.rental_duration='7'
 GROUP BY
     1
 ORDER BY
     2 DESC;


--Query 3 - the query used for Question 3 insight

WITH t1 AS (
    SELECT
        c.name AS name,
        NTILE(4) OVER (ORDER BY f.rental_duration  ) AS standard_quartile
    FROM
        film_category fc
        JOIN category c ON fc.category_id = c.category_id
        JOIN film f ON fc.film_id = f.film_id
   WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))

SELECT
    name,
    standard_quartile,
    count(*)
FROM
    t1
GROUP BY
    1,
    2
ORDER BY
    1,
    2;




--Question Set2

--Query 4 - the query used for Question 2 insight

WITH t1 AS (
    SELECT
        CONCAT(c.first_name,' ',c.last_name) AS full_name,
        SUM(p.amount) AS amount_total
    FROM
        customer c
        JOIN payment p ON p.customer_id = c.customer_id
    GROUP BY
        1
    ORDER BY
        2 DESC
    LIMIT
        10)

SELECT
    DATE_TRUNC('month', p.payment_date) AS pay_mon,
    CONCAT(c.first_name,' ',c.last_name) AS fullname,
    COUNT(p.amount) AS pay_countpermon,
    SUM(p.amount) AS pay_amount
FROM
    customer c
    JOIN payment p ON p.customer_id = c.customer_id
WHERE
    CONCAT(c.first_name,' ',c.last_name) IN (SELECT t1.full_name FROM t1)
  AND
    (p.payment_date BETWEEN '2007-01-01' AND '2008-01-01')
GROUP BY
    2,
    1
ORDER BY
    2,
    1,
    3;
