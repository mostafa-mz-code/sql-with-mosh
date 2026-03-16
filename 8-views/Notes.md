# VIEWS

Views are **virtual tables** that hold the result of **queries** or **subqueries**.

Views are useful when dealing with complex or repetitive queries, so instead of repeating ourselves we can create a viw object
and that holds the result of that query, so whenever we need that part of the information, we simply use that view.

views behave just like tables, **virtual tables**

example:

```sql

SELECT
c.client_id,
c.name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name
```

let's say we need this info in multiple places and writing the same query over and over again is not efficient! so we write a VIEW instead.

**Note**: Views do not store data! but they behave just like tables.

## Creating Views

to create a view you need use `CREATE VIEW view_name AS your-query-here`

```sql
CREATE VIEW sales_by_client AS
SELECT
c.client_id,
c.name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name;
```

now your view is store inside your database, under the **views** section

## Accessing Views

To access or use a **view** you start with your **database_name** and put a **dot** followed by **view_name**.
now this view returns the data/result of the query you put in this view.
or simply just by their name

```sql
SELECT * FROM sql_invoicing.sales_by_client
```

```sql
SELECT * FROM sales_by_client
```

## Altering or Dropping View

Let's say the view you just created doesn't return the correct result! you have tow ways to fix this:

- Drop the view and create a new one.
- Replace the view

To **drop** a view, you just type `DROP VIEW view_name` so if the view exists, this command will delete it.

To **Replace** a view you need to use `CREATE OR REPLACE VIEW ` command instead of just `CREATE VIEW`, with this command you run the view creation command as many times as you need to, without getting any error.

**Note**: always share your view, by adding them to under source-control, just in case your teammates lose access

## Updatable View

As we can use **views** as tables to retrieve data from, we can also use them to **Insert**, **Update** and **Delete** too
But! there is several conditions we need to keep in mind, otherwise the views cannot be used for these operations.

the tables that doesn't have any of the following conditions in a view, that's **Updatable View**

### conditions

- DISTINCT
- Aggregate Functions (MIN, MAX, SUM....)
- GROUP BY / HAVING
- UNION

let's create a **View** that includes the **balance** in the **invoices** table as well.

```sql
-- create a table that includes the balance for clients along with the invoices table data.

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
invoice_id,
number,
client_id,
payment_total,
invoice_total,
invoice_total - payment_total AS balance,
due_date,
payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
```

the **view** above is not using any of the **distinct**, **sum, min, max....**, **group by**, **having** or **union**.
which makes it an **updatable view** so we can use it to insert/update/delete data

```sql
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
invoice_id,
number,
client_id,
payment_total,
invoice_total,
invoice_total - payment_total AS balance,
due_date,
payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0


DELETE FROM invoices_with_balance WHERE invoice_id = 1;

UPDATE invoices_with_balance
SET due_date = DATE_ADD( due_date , INTERVAL 1 DAY)
WHERE invoice_id = 2;
```

updating rows using **updatable views** is a bit tricky, so if the view doesn't list all the underlying columns, the insert wouldn't work

A view is only "updatable" if there is a clear 1:1 correspondence between the rows in the view and the rows in the base table. It becomes hard or impossible when:

- Ambiguity in Multi-Table Joins: If a view joins two tables (e.g., Customers and Orders), updating a column makes it unclear which table should receive the change. Most databases restrict updates to only one base table at a time.
- Loss of Unique Identification: If the view doesn't include the Primary Key of the base table, the database cannot safely identify which exact row to modify.
- Computed or Aggregated Data: You cannot update columns created via functions like SUM(), AVG(), or arithmetic expressions (e.g., Price \* 1.1) because the database doesn't know how to "reverse-engineer" the change into the original raw data.
- Prohibited Clauses: The presence of DISTINCT, GROUP BY, HAVING, or UNION typically makes a view read-only by default.

## The WITH CHECK OPTION Clause

Use the WITH CHECK OPTION clause when you want to ensure that any data modified through a view remains visible within that view.

Without this option, it is possible to perform an update or insert that accidentally "removes" a row from the view’s scope while still changing the underlying table

## Benefits of using VIEWS

Using VIEWs in databases offers a layer of abstraction that separates the physical storage of data from how users and applications interact with it. A view is essentially a virtual table defined by a stored SQL query; it does not store data itself but displays it dynamically from underlying "base" tables.
Core Benefits of Database Views

- Security and Access Control: Views can restrict user access to specific rows or columns. For example, you can create a view that excludes sensitive columns like salaries or social security numbers, granting users access only to the view rather than the full base table.
- Simplification of Complex Queries: They encapsulate complex logic, such as multiple JOIN operations, aggregations (SUM, AVG), and filters, into a single virtual table. This allows users to run simple SELECT \* FROM view_name statements instead of writing intricate SQL every time.
- Logical Data Independence: Views provide a consistent interface even if the underlying table structure changes. If a table is renamed or split into multiple tables, you can update the view definition to maintain the original "look," preventing dependent applications from breaking.
- Data Consistency and Reusability: By centralizing business logic within a view, you ensure that all users and applications are using the exact same calculation or filtering criteria, reducing the risk of errors and redundant code.
- Storage Efficiency: Since standard views are just stored queries, they consume almost no disk space. The database only stores the view definition, not a copy of the actual data.
- Performance Optimization (Materialized Views): While standard views are computed on the fly, Materialized Views physically store the query results. This can significantly speed up performance for heavy analytical queries by providing pre-calculated data.
- Comparison Table: Standard View vs. Materialized View

| Feature        | Standard View                  | Materialized View             |
| -------------- | ------------------------------ | ----------------------------- |
| Data Storage   | No physical data stored        | Result set is stored on disk  |
| Data Freshness | Always reflects real-time data | Requires periodic refreshing  |
| Storage Cost   | Negligible (definition only)   | Consumes disk space           |
| Performance    | Depends on underlying query    | Faster for read-heavy queries |
