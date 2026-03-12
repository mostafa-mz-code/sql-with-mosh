-- write a query that lists users as the following rankings:
-- gold => points >= 3000
-- silver => points >= 2000
-- bronze => points < 2000
USE sql_store;

SELECT
  CONCAT (first_name, " ", last_name),
  points,
  CASE
    WHEN points >= 3000 THEN 'GOLD'
    WHEN points >= 2000 THEN 'Silver'
    WHEN points < 2000 THEN 'Bronze'
  END AS category
FROM
  customers
ORDER BY points DESC