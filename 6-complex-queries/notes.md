## Writing Complex Queries

### Subqueries

In MySQL, a subquery is a SELECT statement nested inside another SQL statement,
such as SELECT, INSERT, UPDATE, or DELETE. It is always enclosed in parentheses and acts as
an "inner query" that provides data to the "outer query"

**subqueries** are executed first

#### Types of Subqueries

**Non-Correlated**: An independent query that runs once and passes its fixed result to the outer query.
**Correlated**: A query that refers to columns from the outer query. It is executed once for every row processed by the outer query, which can impact performance on large datasets.

```sql
SELECT
  *
FROM
  products
WHERE
  unit_price > (
    SELECT
      unit_price
    FROM
      products
    WHERE
      product_id = 3
  )
```

## The IN Operator

use the **IN** operator to check for a specific value/data in a list of value/data's.

for example: finding the products that's never been ordered? in a store

solution: get a distinct list of the products that've been ordered then check the products that aren't in this list.

```sql
SELECT
*
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id from order_items)
```

## SUBQUERIES vs JOINS

sometimes we can replace a **subquery** with a **join**, but it doesn't mean we should always rely on **joins**,
the goal is to make the query more intuitive and easier to read, which it can be a bit hard with **joins**.

So there is no one size fit all! think about the problem you're solving and chose the way that makes it easier to read/maintain.

## The ALL Keyword

The ALL keyword is a logical operator used in a WHERE or HAVING clause to compare a single value against every value returned by a subquery.
It is most useful for enforcing a strict condition that must be true for an entire set of data.

### When to Use ALL

- Comparing against a full set: Use it when you need a value to be greater than, less than, or equal to every record in a subquery.
- Example: Finding the "top performer" by checking if their sales are > ALL other individual sales.

- Handling empty subqueries: If the subquery returns no rows, the ALL condition evaluates to TRUE.
  This is a critical logical difference from using MAX(). If Client 3 has no invoices, > ALL will return all records, whereas > (SELECT MAX...) would return nothing because MAX() of an empty set is NULL.

- Complex logical checks: It is useful when you want to ensure a condition holds across different departments or categories simultaneously without manually finding a single aggregate value first

## The ANY or SOME keyword

The ANY operator is a logical operator that returns TRUE if any of the subquery values meet a specified condition.
It is the less restrictive counterpart to ALL.

**Key Characteristics**

- "At Least One" Logic: A condition using ANY evaluates to true if it matches at least one value in the result set.
- Interchangeable with SOME: In most SQL implementations, ANY and SOME are identical and can be used interchangeably.
- Comparison Operators: It must be preceded by a standard comparison operator, such as =, <>, !=, >, >=, <, or <=.

**NOTE**: the SOME and ANY operators are the exact same thing

```SQL
SELECT *
FROM clients
WHERE client_id = ANY(

  SELECT client_id
  FROM invoices
  GROUP BY client_id
  HAVING COUNT(*) > 2
)
```

## Correlated Subqueries

A query that refers to columns from the outer query. It is executed once for every row processed by the outer query, which can impact performance on large datasets.

```sql
-- select employees whose salary is above the average in their office

-- pseudo code

-- for each employee

-- -- calculate the avg salary for employee.office
-- -- return the employee if salary > avg

SELECT
*
FROM employees e
WHERE salary > (
  SELECT AVG(salary)
  FROM employees
  WHERE office_id = e.office_id
)
```

## The EXISTS operator

The EXISTS operator is used to test for the existence of rows in a subquery. Unlike ANY or ALL, which compare a specific column value, EXISTS only cares if the subquery returns at least one record.

**How it Works**

- Boolean Result: It evaluates to TRUE if the subquery finds one or more rows and FALSE if it finds none.
- Efficiency: It is designed for performance. As soon as the database engine finds a single matching row in the subquery, it stops looking (this is called short-circuit evaluation).
- Correlation: It is almost always used with a correlated subquery, meaning the inner query is linked to the outer query via a common column.


## Subqueries in SELECT clause
In SQL, a subquery placed in the SELECT clause is often called a scalar subquery because it must return exactly one value (one row and one column). If it returns more, the query will fail with an error.
Here are the primary use cases for using them:
1. Including Aggregate Values in Non-Grouped Queries 
Standard aggregate functions (like SUM or AVG) normally require a GROUP BY clause, which collapses your rows. A subquery in the SELECT clause allows you to keep all individual rows while still showing a total or average next to them. 

* Example: Showing each employee's salary alongside the company-wide average.

1. Performing Row-Level Mathematical Calculations
You can use the single value from a subquery to perform calculations for every row in your main result set.  

* Example: Calculating the difference between an individual match's score and the season average.
* Example: Finding the percentage of a specific category (e.g., "What % of total sales does this specific order represent?").

1. Correlated Data Retrieval (Row-by-Row Lookups)
A correlated subquery in the SELECT clause can reference columns from the outer query to pull specific related data. 

* Example: For each customer in your list, run a subquery to count how many orders they have placed.
* Example: Retrieving the "latest order date" for every customer in a summary report. 

1. Handling Dynamic or Unknown Values
When you don't know a specific value (like the highest price in a table) but want to display it as a reference point in every row, a subquery can retrieve it dynamically. 

1. Replacing Complex Joins for Readability
In some cases, using a subquery in the SELECT clause is more intuitive and readable than writing a complex LEFT JOIN with a GROUP BY, especially when you only need a single summary number from another table. 
Important Performance Note
Using subqueries in the SELECT clause—especially correlated ones—can be slow on large datasets. This is because the database may execute the inner query once for every single row of the outer query. For better performance with large data, refactoring these into a JOIN or a Common Table Expression (CTE) is often recommended. 
Would you like to see a side-by-side comparison of a SELECT subquery versus a JOIN for the same problem?

**Note**: You cannot use a column's **alias** in an expression.