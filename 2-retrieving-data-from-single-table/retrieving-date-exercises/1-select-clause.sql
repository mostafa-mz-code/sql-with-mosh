USE sql_store

-- Return all the products
-- name
-- unit price
-- new price (unit price * 1.1)

SELECT name, unit_price, unit_price * 1.1 as "new price"
FROM products