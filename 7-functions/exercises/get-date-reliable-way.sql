
USE sql_store;
SELECT 
*
FROM orders
WHERE order_date >= '2019-01-01';


SELECT 
*
FROM orders
WHERE YEAR(order_date) = YEAR(NOW()); -- This query check if the order date is in the same year as the current year