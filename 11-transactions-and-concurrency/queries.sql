USE sql_store;

START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2026-01-01', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1,1,1)

COMMIT;

-- ------------------ READ UNCOMMITTED ------------------

USE sql_store;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT points
FROM customers
WHERE customer_id = 1;

-- ------------------ READ COMMITTED ------------------

USE sql_store;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT points
FROM customers
WHERE customer_id = 1; 