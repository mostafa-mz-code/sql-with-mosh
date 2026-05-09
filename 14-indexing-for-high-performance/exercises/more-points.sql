-- Write a query to find customers with more than 1000 points.


SELECT * FROM customers WHERE points > 1000;

EXPLAIN SELECT * FROM customers WHERE points > 1000;
EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;

CREATE INDEX idx_points ON customers(points);

DROP INDEX idx_points ON customers;
SHOW INDEXES IN customers;