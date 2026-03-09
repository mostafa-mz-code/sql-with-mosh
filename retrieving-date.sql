USE sql_store;

SELECT *
FROM customers;

SELECT *
FROM customers
WHERE state IN ('va', 'ma', 'co', 'tx');


SELECT state
FROM customers;

SELECT *
FROM customers
WHERE birth_date > '1990-01-01' OR
      (points > 1000 AND state = 'va');



SELECT *
FROM customers
WHERE NOT (birth_date > '1990-01-01' OR points > 1000);

-- Here is a trick for situations when we have "NOT" operator involved
-- to negate a statement/condition do the following:
-- negative of ">" is "<="
-- negative of "<" is ">="
-- negative of "=" is "!="
-- negative of "OR" is "AND" and vice versa
