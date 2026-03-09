USE store;

INSERT INTO
  customers (
    first_name,
    last_name,
    birth_date,
    address,
    city,
    state
  )
VALUES
  (
    'John',
    'Smith',
    '1990-01-01',
    'address',
    'city',
    'CA'
  )
INSERT INTO
  shippers (name)
VALUES
  ('shipper_1'),
  ('shipper_2'),
  ('shipper_3');

SELECT
  *
FROM
  products;

-- insert into hierarchical rows
INSERT INTO
  orders (customer_id, order_date, status)
VALUES
  (1, '2019-01-02', 1);

INSERT INTO
  order_items
VALUES
  (LAST_INSERT_ID (), 1, 1, 2.55),
  (LAST_INSERT_ID (), 2, 2, 4.95);

SELECT
  LAST_INSERT_ID ();

-- returns the id of the last inserted row
-- copy data from one table to another
CREATE TABLE
  orders_archived AS
SELECT
  *
FROM
  orders;

-- selectively copy data from one table to another
INSERT INTO
  orders_archived
SELECT
  *
FROM
  orders
WHERE
  order_date < '2019-01-01';

-- update a single row
USE invoicing;

UPDATE invoices
SET
  payment_total = 10,
  payment_date = '2019-01-04'
WHERE
  invoice_id = 1;

UPDATE invoices
SET
  payment_total = DEFAULT,
  payment_date = null
WHERE
  invoice_id = 1;

-- another way to update a row
UPDATE invoices
SET
  payment_total = invoice_total * 0.5,
  payment_date = due_date
WHERE
  invoice_id = 4;