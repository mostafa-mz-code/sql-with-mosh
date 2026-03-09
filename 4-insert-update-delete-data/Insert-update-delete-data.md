# Inserting data

In mysql when inserting data in a table you have these options:

**Note**: in MySQL **date** and **string** values must be enclosed with quotes, either single or double

## Insert one row

### Insert into all columns

to insert into all the columns of a table you use the following command:

```sql
INSERT INTO table_name VALUES(col_1-val, col_2-val, col_3-val.....)

```

**Note**: in this approach column_names must come in the exact order as the table itself. otherwise you can insert into the wrong column!.

**Note**: use `DEFAULT` keyword while inserting to allow MySQL use the default/auto-generated value for that column.

```sql
INSERT INTO customer
VALUES (DEFAULT, 'John', 'Smith', '1990-01-01', NULL, 'address', 'city', 'CA', DEFAULT)
```

### Insert into columns selectively

in this approach you open a pair of `()` right after the `table_name` and type the name of the columns you want to insert into.

```sql
INSERT INTO customer (first_name, last_name, birth_date, address, city, state)
VALUES ('John', 'Smith', '1990-01-01', 'address', 'city', 'CA')
```

and the order column-names is not important

## Insert multiple rows

To insert multiple rows in one go, you just need to put a comma `,` after the first pair of `()` and open a new pair of `()`

```sql
INSERT INTO table_name (columns_names)
VALUES (row-1_values), (row-2_values), (row-3_values)
```

```sql
INSERT INTO shippers (name)
VALUES ('shipper_1'), ('shipper_2'), ('shipper_3')
```

## Inserting hierarchical rows

In SQL, hierarchical rows are sets of data items that are related to each other by parent-child relationships,
forming a tree-like structure. This type of data is typically stored in a single table where one or more columns act as a foreign key
that references the primary key of another row in the same table, often called an adjacency list model.

```sql
INSERT INTO orders (customer_id, order_date, status)
VALUE ( 1, '2019-01-01', 1); `Note 1`

INSERT INTO order_items
VALUES(LAST_INSERT_ID(),  1, 1, 2.95),
(LAST_INSERT_ID(),  1, 1, 2.95)
```

**Note 1**: MySQL has a set of predefined functions that we can call/use.

LAST_INSERT_ID() which gets and returns the id of last inserted row.

## Creating a copy of a table

in case you want to copy all the data from one table into another, you don't want to manually code each row! that would be very time consuming!

here is the technique:

```sql
CREATE TABLE table_name_to_copyTo AS
SELECT * FROM table_name_to_copyFrom
```

Using the CREATE TABLE table_name_to_copyTo AS SELECT \* FROM table_name_to_copyFrom command (often called CTAS) is a fast way to duplicate data,
but it primarily copies the column names, data types, and data.
It is important to know that this command does not create an identical twin; it creates a new table with limited metadata,
causing you to lose most structural constraints and indexes.

Here is what happens in detail:

1. What You Lose (Constraints & Objects)

- Primary Keys & Unique Keys: The new table will not have primary key or unique constraints.
- Foreign Keys: Relationships to other tables are not copied.
- Indexes: All indexes from the original table (except sometimes on the primary key, depending on the SQL flavor) are lost.
- Default Values: Column default definitions (e.g.DEFAULT 0 or DEFAULT SYSDATE) are not carried over.
- Triggers & Permissions: Triggers, grants, and security permissions are not transferred.
- Table Comments/Metadata: Comments on columns or tables are usually lost.

2. What You Keep (Structure & Data)

- Column Names: All columns from the SELECT statement are kept.
- Data Types: Data types (e.g., VARCHAR, INT) and lengths are preserved.
- Data: All rows (or filtered rows if you used a WHERE clause) are copied.
- NOT NULL Constraints: In many database systems (like Oracle)NOT NULL constraints are transferred.

3. What Else Changes
   - Empty Table Option: You can create an empty copy of the structure by adding a WHERE clause that is always false,
     such as WHERE 1=0 or WHERE 1=2.
   - Redo/Undo Logs: Because this is a DDL operation, in some systems (like Oracle),
     it can be faster than standard INSERT because it can be done with reduced logging (unrecoverable), depending on your database settings.
   - Identity/Auto-Increment: The IDENTITY property (SQL Server) or AUTO_INCREMENT (MySQL) is usually not copied,
     meaning the new column will just be a normal numerical column without auto-generation.

Alternative Approaches

1. If you need to preserve constraints, indexes, and keys, you should:
   Script the DDL: Script the creation of the original table in your IDE, rename it, and run it.
2. Use INSERT INTO ... SELECT: Manually create the table with constraints, then fill it with INSERT INTO new_table SELECT \* FROM old_table.
3. Use CREATE TABLE ... LIKE (MySQL): This is a better way to copy exact structure, including indexes.

this technique allows us to do cool things like this:

```sql
INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01'
```

## Updating a single row

To update a single row in a table you need to use the `UPDATE` clause

```sql
UPDATE table_name SET column-1_name = new_value, column-2_name = new_value
WHERE condition
```

```sql
UPDATE invoices SET payment_total = 10, payment_date = '2019-01-04'
WHERE invoice_id = 1
```

## Updating multiple rows

To update multiple rows, you use the same syntax as with updating a single row, but the condition is more general

```sql
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN (3, 4)
```

in case you want to update all the rows in a table you just leave the `WHERE` condition out.

### Using Subqueries in Updates

A subquery (also known as an inner or nested query) is a SQL query nested inside a larger SQL statement (the outer query), such as a SELECT, INSERT, UPDATE, or DELETE statement.
It is used to retrieve data that will be used as a condition or input for the main query.

#### Key Characteristics

**Parentheses**: A subquery must always be enclosed in parentheses ().

**Execution Order**: Generally, the inner query executes first, and its result is then used by the outer query.

**Flexibility**: Subqueries can be used in various clauses, including WHERE, FROM, SELECT, and HAVING.

**Alternatives**: Many queries that use subqueries can be reformulated as joins or Common Table Expressions (CTEs), depending on the specific situation and performance considerations.

#### Types of Subqueries

Subqueries are categorized based on their dependency on the outer query and the number of values they return.

**Independent** (Non-Correlated) Subqueries: These queries are self-contained and run once, passing their results to the outer query. They do not reference any columns from the outer query.
**Correlated Subqueries**: These subqueries reference one or more columns from the outer query. They are executed once for each row processed by the outer query, making them potentially slower for large datasets.
**Scalar Subqueries**: These return a single value (one column and one row) and can be used anywhere a single expression is valid.
**Multiple-Row Subqueries**: These return one or more rows (a list of values or a virtual table) and are typically used with operators like IN, NOT IN, ANY, or ALL.
**Table Subqueries (Derived Tables)**: These are used in the FROM clause and the outer query treats their result as a temporary table (which must be given an alias).
Microsoft Learn

## Deleting Rows

To delete rows from a table you just run

```sql
DELETE FROM table_name WHERE condition
```

never run `DELETE` command without a **condition**! it will delete everything from that table

you can use sub-queries with Delete clause too:

```sql

DELETE FROM invoices
WHERE client_id = (
  SELECT client_id FROM clients
  WHERE name = 'john'
)
```
