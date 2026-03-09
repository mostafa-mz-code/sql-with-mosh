-- Write a SQL statement to
--    give any customer born before 1990
--    5o extra points
USE sql_store;

UPDATE customers
SET
  points = points + 50
WHERE
  birth_date < '1990-01-01';