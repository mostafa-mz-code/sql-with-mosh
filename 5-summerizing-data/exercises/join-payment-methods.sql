USE sql_invoicing;

SELECT
  date,
  pm.name AS payment_method,
  SUM(amount) AS total_payment
FROM
  payments p
  JOIN payment_methods pm ON pm.payment_method_id = p.payment_method
GROUP BY
  date,
  payment_method
ORDER BY
  date