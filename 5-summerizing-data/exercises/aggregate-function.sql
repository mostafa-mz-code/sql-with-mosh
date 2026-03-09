USE invoicing;

SELECT
  'First half of the 2019' as date_range,
  SUM(invoice_total) AS total_sales,
  SUM(payment_total) AS total_payments,
  SUM(invoice_total - payment_total) AS what_we_expect
FROM
  invoices
WHERE
  invoice_date > "2019-01-01"
  AND invoice_date < "2019-06-30"
UNION
SELECT
  'First half of the 2019' as date_range,
  SUM(invoice_total) AS total_sales,
  SUM(payment_total) AS total_payments,
  SUM(invoice_total - payment_total) AS what_we_expect
FROM
  invoices
WHERE
  invoice_date > "2019-07-01"
  AND invoice_date < "2019-12-31"
UNION
SELECT
  'Total' as date_range,
  SUM(invoice_total) AS total_sales,
  SUM(payment_total) AS total_payments,
  SUM(invoice_total - payment_total) AS what_we_expect
FROM
  invoices
WHERE
  invoice_date > "2019-01-01"
  AND invoice_date < "2019-12-31";