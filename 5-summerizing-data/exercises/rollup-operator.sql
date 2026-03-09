-- write a query that lists
-- all payment methods
-- how much each payment method has been used
-- and the total amount paid
USE sql_invoicing;

SELECT
  pm.name,
  SUM(amount) AS total
FROM
  payments p
  JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY
  pm.name
WITH
  ROLLUP