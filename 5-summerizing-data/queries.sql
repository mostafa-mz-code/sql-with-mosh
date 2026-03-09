USE sql_invoicing;

-- If you don't give a name to the result of an aggregate function, it will be called the same as the function. In this case, the column will be called `MAX(invoice_total)`.
-- You can give it a different name using `AS`:
SELECT
  MAX(invoice_total)
FROM
  invoices;

-- given a name
SELECT
  MAX(invoice_total) AS highest,
  MIN(invoice_total) AS lowest,
  AVG(invoice_total) AS average,
  MAX(payment_date) AS latest_payment,
  MIN(payment_date) AS earliest_payment,
  COUNT(invoice_total) AS number_of_invoices,
  COUNT(payment_date) AS payment_count
FROM
  invoices;

-- you can also have expressions with aggregate functions:
-- in the following example, "1.1" is first multiplied by the value of `invoice_total` for each row, and then the results are summed together.
SELECT
  SUM(invoice_total * 1.1) AS total_with_tax
FROM
  invoices;

-- filter the results:
SELECT
  MAX(invoice_total) AS highest,
  MIN(invoice_total) AS lowest,
  AVG(invoice_total) AS average,
  MAX(payment_date) AS latest_payment,
  MIN(payment_date) AS earliest_payment,
  COUNT(invoice_total) AS number_of_invoices,
  COUNT(payment_date) AS payment_count,
  COUNT(DISTINCT client_id) AS total
FROM
  invoices
WHERE
  invoice_date > '2019-01-01';

------ group by
SELECT
  client_id,
  SUM(invoice_total) AS total_sales
FROM
  invoices
WHERE
  invoice_date > '2019-01-01'
GROUP BY
  client_id;

-- if you select a column that is not part of an aggregate function, you need to include it in the `GROUP BY` clause. Otherwise, you will get an error:
SELECT
  invoice_date,
  client_id,
  SUM(invoice_total) AS total_sales
FROM
  invoices
WHERE
  invoice_date > '2019-01-01'
GROUP BY
  client_id;

-- group by multiple columns:
SELECT
  state,
  city,
  SUM(invoice_total) as total_sales
FROM
  invoices
  JOIN clients USING (client_id)
GROUP BY
  state,
  city;

--- the HAVING clause
SELECT
  client_id,
  SUM(invoice_total) AS total_sales
FROM
  invoices
WHERE
  total_sales > 5000
GROUP BY
  client_id;

-- the right way
SELECT
  client_id,
  SUM(invoice_total) AS total_sales
FROM
  invoices
GROUP BY
  client_id
HAVING
  total_sales > 500;

-- the ROLLUP operator
SELECT
  client_id,
  SUM(invoice_total) AS total_sales
FROM
  invoices
GROUP BY
  client_id
WITH
  ROLLUP;

--
SELECT
  state,
  city,
  SUM(invoice_total) AS total_sales
FROM
  invoices
  JOIN clients USING (client_id)
GROUP BY
  state,
  city
WITH
  ROLLUP;