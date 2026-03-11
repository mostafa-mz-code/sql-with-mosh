
-- select client_id, name, total sales, avg sales, total sales - avg sales => difference
USE invoicing;

SELECT
  client_id,
  name,
  (
    SELECT
      SUM(invoice_total)
    FROM
      invoices
    WHERE
      client_id = c.client_id
  ) AS total_sales,
  (
    SELECT
      AVG(invoice_total)
    FROM
      invoices
  ) AS avg_sales,
  (
    SELECT
      total_sales - avg_sales
  ) AS difference
FROM
  clients c