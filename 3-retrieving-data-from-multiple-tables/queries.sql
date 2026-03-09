
--  ---------- join customers and orders tables where customer has placed an order --------------
SELECT *
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id ;


-- ----------- using alias -------------
SELECT c.customer_id, c.first_name, o.order_id
FROM customers  c
JOIN orders  o
ON c.customer_id = o.customer_id;


-- -----------what if we join tables with no condition? -------
--  well the result will be a giant table consisting of all the data in all the tables!
--  this is a really poor way of joining tables "Cross Join" which is not useful
--  this giant table would have "m x n" tables "m" being columns of first-table, "n" being columns of second-column:  3 x 2 = 6

SELECT *
FROM customers
INNER JOIN orders;


-- selecting column names that are unique for the tables
SELECT first_name, last_name, order_date, order_id
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id ;


-- selecting column names that are present in both tables
SELECT first_name, last_name, order_date, order_id, customer_id
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id ;

-- with query above we get an error ``Error: Column 'customer_id' in field list is ambiguous``
-- because the "customer_id" exists on both tables and MySQL gets confused, from which table to select the column!

-- Joining Across Databases

SELECT *
FROM order_items AS oi
JOIN sql_inventory.products AS p
  ON oi.product_id = p.product_id;


USE sql_hr;

SELECT *
FROM employees e
JOIN employees m
  ON e.reports_to = m.employee_id

SELECT e.first_name, e.employee_id, e.reports_to
FROM employees e
JOIN employees m
  ON e.reports_to = m.employee_id;


--  ------------------- joining multiple tables -------------------
USE sql_store;
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_statuses os
  ON o.status = os.order_status_id


-- Compound Join Condition

USE sql_store;

SELECT * FROM order_items oi
JOIN order_item_notes oin
  ON oi.order_id = oin.order_id
  AND oi.product_id = oin.product_id;


SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id


-- Outer Joins
USE sql_store;
SELECT p.product_id, p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
  ON p.product_id = oi.product_id;
