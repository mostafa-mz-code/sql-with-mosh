SELECT
  customer_id
FROM
  customers
WHERE
  state = 'CA';

EXPLAIN
SELECT
  customer_id
FROM
  customers
WHERE
  state = 'CA';

CREATE INDEX idx_state ON customers (state);

CREATE INDEX idx_points ON customers (points);

-- viewing indexes
SHOW INDEXES IN customers;

EXPLAIN
SELECT
  *
FROM
  customers
WHERE
  points > 1000;

EXPLAIN ANALYZE
SELECT
  *
FROM
  customers
WHERE
  points > 1000;

SELECT
  COUNT(*),
  COUNT(DISTINCT state)
FROM
  customers;

-- add index to the last_name of the customers in customer table
CREATE INDEX idx_lastname ON customers (last_name (5));

-- in the query bellow you can see that we get a decent number of unique values for the specified number of characters
-- but if we increase the number of characters we don't see much gain, indicating that 5 characters is the best number for prefix indexing
SELECT
  COUNT(DISTINCT LEFT (last_name, 1)),
  COUNT(DISTINCT LEFT (last_name, 5)),
  COUNT(DISTINCT LEFT (last_name, 10)),
  COUNT(DISTINCT LEFT (last_name, 15))
FROM
  customers;