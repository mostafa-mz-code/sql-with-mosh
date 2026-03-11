-- -----------------Subqueries
-- Find products that are more expensive than lettuce (id = 4)
USE sql_store;

SELECT
  *
FROM
  products
WHERE
  unit_price > (
    SELECT
      unit_price
    FROM
      products
    WHERE
      product_id = 3
  );

------------ the IN operator
-- Find the products that have never been ordered
USE sql_store;

SELECT
  *
FROM
  products
WHERE
  product_id NOT IN (
    SELECT DISTINCT
      product_id
    from
      order_items
  );

-- the same result using JOIN
SELECT
  *
FROM
  products
  LEFT JOIN order_items USING (product_id)
WHERE
  order_id IS NULL;

-- ------- ALL operator
-- Select all invoices larger than all invoices of
-- client 3
USE sql_invoicing;

SELECT
  *
FROM
  invoices
WHERE
  invoice_total > (
    SELECT
      MAX(invoice_total)
    FROM
      invoices
    WHERE
      client_id = 3
  )
  -- with ALL keyword
SELECT
  *
FROM
  invoices
WHERE
  invoice_total > ALL (
    SELECT
      invoice_total
    FROM
      invoices
    WHERE
      client_id = 3
  )
  -- ------- ANY operator
  -- select clients with at least two invoices
  -- find the clients that have more than 2 invoices (client id's)
SELECT
  client_id,
  COUNT(*)
FROM
  invoices
GROUP BY
  client_id
HAVING
  COUNT(*) > 2
  -- list the clients
SELECT
  *
FROM
  clients
WHERE
  client_id IN (
    SELECT
      client_id
    FROM
      invoices
    GROUP BY
      client_id
    HAVING
      COUNT(*) > 2
  )
  -- or using ANY
SELECT
  *
FROM
  clients
WHERE
  client_id = ANY (
    SELECT
      client_id
    FROM
      invoices
    GROUP BY
      client_id
    HAVING
      COUNT(*) > 2
  )
  -- --------- correlated subqueries -----
  -- select employees whose salary is above the average in their office
  -- pseudo code
  -- for each employee
  -- -- calculate the avg salary for employee.office
  -- -- return the employee if salary > avg
SELECT
  *
FROM
  employees e
WHERE
  salary > (
    SELECT
      AVG(salary)
    FROM
      employees
    WHERE
      office_id = e.office_id
  );

-- --------- EXISTS operator
-- select clients that have an invoice
SELECT
  *
FROM
  clients
WHERE
  client_id IN (
    SELECT
      client_id
    FROM
      invoices
  );

SELECT
  *
FROM
  invoices
  LEFT JOIN clients USING (client_id);

-- using the EXISTS operator
SELECT
  *
FROM
  clients c
WHERE
  EXISTS (
    SELECT
      *
    FROM
      invoices i
    WHERE
      c.client_id = i.client_id
  );

-- subqueries in select clause

-- list all the invoices with the average invoice total and the difference between the invoice total and the average
USE invoicing;

SELECT
  invoice_id,
  invoice_total,
  (
    SELECT
      AVG(invoice_total)
    FROM
      invoices
  ) AS invoice_avg,
  invoice_total - (
    SELECT invoice_avg
  ) AS difference
FROM
  invoices