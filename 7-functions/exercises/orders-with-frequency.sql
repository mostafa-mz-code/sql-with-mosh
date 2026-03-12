-- list products with their names and the number of times they are ordered, then create a frequency column 'once' or 'many times'

USE sql_store;

SELECT
product_id,
name,
COUNT(order_id) AS orders,
IF(COUNT(order_id) = 1, 'once', 'many times') AS frequency
FROM
products 
JOIN order_items  USING(product_id)
GROUP BY product_id