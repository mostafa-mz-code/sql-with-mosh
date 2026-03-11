-- find the products that's never been ordered

USE sql_store;

SELECT 
*
FROM products p
WHERE NOT EXISTS (
  SELECT product_id
  FROM order_items oi
  WHERE oi.product_id = p.product_id
)

-- The other way

SELECT
*
FROM products p
WHERE product_id NOT IN (
  SELECT product_id
  FROM order_items oi
) 