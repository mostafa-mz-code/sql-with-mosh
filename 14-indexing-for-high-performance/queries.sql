
SELECT customer_id FROM customers WHERE state = 'CA';

EXPLAIN SELECT customer_id FROM customers WHERE state = 'CA';


CREATE INDEX idx_state ON customers(state);
CREATE INDEX idx_points ON customers(points);

-- viewing indexes

SHOW INDEXES IN customers;

EXPLAIN SELECT * FROM customers WHERE points > 1000;

EXPLAIN ANALYZE SELECT * FROM customers WHERE points > 1000;

SELECT COUNT(*), COUNT( DISTINCT state) FROM customers;