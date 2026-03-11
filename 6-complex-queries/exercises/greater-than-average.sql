-- get invoices that are larger than the client's average invoice amount

USE sql_invoicing;

-- for each client 
-- calculate the invoice avg for each client
-- return invoices that are larger than the avg

SELECT
*
FROM invoices i
WHERE invoice_total > (
  SELECT AVG(invoice_total)
  FROM invoices
  WHERE i.client_id = client_id
)