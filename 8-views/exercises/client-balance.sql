-- Create a view to see the balance
-- for each client.
--
-- client_balance
-- client_id
-- name
--balance.  balance = invoice_total - payment_total
CREATE VIEW
  client_balance AS
SELECT
  name,
  client_id,
  SUM(invoice_total - payment_total) AS balance
FROM
  clients c
  JOIN invoices i USING (client_id)
GROUP BY
  client_id,
  name;
  
  -- just testing the query
SELECT client_id, name, invoice_total, payment_total, (invoice_total - payment_total) AS balance, payment_date
FROM invoices
JOIN clients
USING(client_id)