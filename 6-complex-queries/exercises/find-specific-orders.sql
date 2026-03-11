-- Find customers who have ordered lettuce (id = 3)
-- select customer_id, first_name, last_name


USE sql_store;

-- subqueries
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (

  SELECT o.customer_id
  FROM order_items oi
  JOIN orders o USING(order_id)
  WHERE product_id = 3
)

-- joins
SELECT DISTINCT customer_id, first_name, last_name
FROM customers c
JOIN orders o USING(customer_id)
JOIN order_items oi USING(order_id)
WHERE oi.product_id = 3