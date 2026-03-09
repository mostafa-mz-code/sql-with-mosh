-- Get the customers
-- -- located in Virginia
-- -- who have spent more that 100$
USE sql_store;

SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  SUM(oi.quantity * oi.unit_price) AS total_spent
FROM
  customers c
  JOIN orders o USING (customer_id)
  join order_items oi USING (order_id)
WHERE
  state = "VA"
GROUP BY
  customer_id,
  first_name,
  last_name
HAVING
  total_spent > 100