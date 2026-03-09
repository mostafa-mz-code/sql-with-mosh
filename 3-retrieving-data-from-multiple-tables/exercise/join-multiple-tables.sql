-- task: join "payment", "payment_methods" and "clients" then generate a report showing clients with their payments plus payment methods
USE sql_invoicing;

SELECT
  p.date,
  p.invoice_id,
  p.amount,
  c.name,
  pm.name
FROM
  clients c
  JOIN payments p ON c.client_id = p.client_id
  JOIN payment_methods pm ON p.payment_method = pm.payment_method_id