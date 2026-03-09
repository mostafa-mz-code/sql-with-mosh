-- create a new table "archived_invoices" add only those rows that have payment, and list client names instead of client_id
USE invoicing;

CREATE TABLE
  archived_invoices AS
SELECT
  i.invoice_id,
  c.name AS client,
  i.number,
  i.invoice_total,
  i.payment_total,
  i.invoice_date,
  i.due_date,
  i.payment_date
FROM
  invoices i
  INNER JOIN clients c ON i.client_id = c.client_id
WHERE
  i.payment_date is not null