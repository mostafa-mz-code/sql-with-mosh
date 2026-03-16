USE sql_invoicing;


SELECT
c.client_id,
c.name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name;

-- create a view

CREATE VIEW sales_by_client AS
SELECT
c.client_id,
c.name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name;

-- accessing a view

SELECT * FROM sql_invoicing.sales_by_client;

SELECT *
FROM sales_by_client sc
JOIN clients
USING(client_id);


-- drop a view

DROP VIEW sales_by_client;

-- alter a view, the preferred way

CREATE OR REPLACE VIEW sales_by_client AS
SELECT
c.client_id,
c.name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name;



-- create a table that includes the balance for clients along with the invoices table data.

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
invoice_id,
number,
client_id,
payment_total,
invoice_total,
invoice_total - payment_total AS balance,
due_date,
payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;


DELETE FROM invoices_with_balance WHERE invoice_id = 1;

UPDATE invoices_with_balance
SET due_date = DATE_ADD( due_date , INTERVAL 1 DAY)
WHERE invoice_id = 2;


UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;