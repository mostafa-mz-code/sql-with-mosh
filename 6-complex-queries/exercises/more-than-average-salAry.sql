-- In sql_hr:
-- Find employees that earn more that the average
USE sql_hr;

SELECT
  *
FROM
  employees
WHERE
  salAry > (
    SELECT
      AVG(salary)
    FROM
      employees
  )