# Indexing

## The Problem Indexing Solves

Imagine a physical phone book with 1 million entries. If you want to find "Sarah Johnson," you don't start at page 1 and read every name — that would take forever. Instead, you flip to the "J" section immediately. **That's exactly what a database index does.**

Without an index, a database performs a **Full Table Scan** — it reads _every single row_ to find matches. With millions of rows, this is devastatingly slow.

---

## What Is an Index?

An index is a **separate data structure** that the database maintains alongside your table. It stores a **sorted copy of one or more columns**, plus a pointer back to the original row.

Think of it like the index at the back of a textbook — it doesn't contain the full content, just enough information to find it quickly.

---

## How Indexes Work Internally — The B-Tree

Most databases (MySQL, PostgreSQL, SQL Server) use a **B-Tree (Balanced Tree)** structure under the hood.The B-Tree has three levels. The **root** and **internal nodes** just store keys to guide the search. Only the **leaf nodes** store the actual row pointers — and crucially, leaf nodes are linked together (the dashed arrows), which makes range queries like `WHERE age BETWEEN 20 AND 50` super fast.

---

## Types of Indexes

**Primary Index (Clustered)**
The table's data is physically sorted on disk by this column. There can only be one per table — the data can only live in one physical order. In MySQL InnoDB, the Primary Key is always clustered.

**Secondary Index (Non-Clustered)**
A separate structure with sorted keys that point back to the primary key. You can have many of these. Looking up a row via a secondary index is a two-step process: find the key in the secondary index → follow the pointer to fetch the full row (this is called a **double lookup**).

**Composite (Multi-Column) Index**
An index on more than one column, like `(last_name, first_name)`. The leftmost-prefix rule applies: this index helps queries filtering on `last_name` or `last_name + first_name`, but does NOT help a query filtering only on `first_name`.

**Covering Index**
When an index contains all the columns a query needs, the database never has to touch the actual table — it answers the query entirely from the index. This is the fastest possible scenario.

**Full-Text Index**
Built for searching natural language text — `MATCH ... AGAINST` syntax in MySQL. Completely different from B-Tree; uses an inverted index (like a search engine).

---

## The Cost of Indexes

Indexes are not free. Every time you `INSERT`, `UPDATE`, or `DELETE` a row, MySQL must also update every relevant index. This means:

- Write operations become slower with more indexes
- Indexes consume disk space (sometimes a lot)
- Too many indexes can actually slow down your application

The golden rule: **index the columns you query by, not every column.**

---

## How to Create and Use Indexes in SQL

```sql
-- Create a basic index
CREATE INDEX idx_last_name ON customers(last_name);

-- Create a composite index
CREATE INDEX idx_name ON customers(last_name, first_name);

-- Create a unique index (also enforces uniqueness)
CREATE UNIQUE INDEX idx_email ON customers(email);

-- Drop an index
DROP INDEX idx_last_name ON customers;

-- See existing indexes on a table
SHOW INDEXES IN customers;
```

---

## How to Know if Your Index Is Being Used

Use `EXPLAIN` before any `SELECT` to see what MySQL's query optimizer is doing:

```sql
EXPLAIN SELECT * FROM customers WHERE last_name = 'Smith';
```

The key columns to look at in the output:

| Column  | What to look for                                                                         |
| ------- | ---------------------------------------------------------------------------------------- |
| `type`  | `ref` or `range` = index used ✅ · `ALL` = full table scan ❌                            |
| `key`   | Shows the name of the index chosen                                                       |
| `rows`  | How many rows MySQL estimates it will examine                                            |
| `Extra` | `Using index` = covering index (best!) · `Using filesort` = no useful index for ORDER BY |

---

## When NOT to Use an Index

Indexes are often ignored by the optimizer when:

- The table is very small (a full scan is faster than traversing the tree)
- The column has low cardinality (e.g., a `gender` column with only 2 values — not worth indexing)
- You use a function on the indexed column: `WHERE YEAR(created_at) = 2024` — the index on `created_at` is useless here. Write it as a range instead: `WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31'`
- You use a leading wildcard: `WHERE name LIKE '%Smith'` — can't use the B-Tree. `WHERE name LIKE 'Smith%'` can.

---

## Summary Mental Model

Think of your table as a massive unsorted pile of papers, and an index as a filing cabinet with labeled dividers that tell you exactly which pile to grab from. The database uses the cabinet instead of searching every sheet. The tradeoff: you need to keep the cabinet updated every time you add, change, or throw away a paper.

This is exactly what Mosh builds on when he gets to query optimization and `EXPLAIN` plans — so you're in great shape for what's coming!

## Viewing Indexes

Viewing Indexes is purely for developers and database administrators,

you can run `SHOW INDEXES ON table_name` to see the output.

When you run SHOW INDEXES FROM table_name; (or SHOW KEYS), MySQL returns a table where each row represents a part of an index.
Here is the breakdown of what those columns mean:

- Table: The name of the table.
- Non_unique: 0 if the index cannot contain duplicates (like a PRIMARY or UNIQUE key), and 1 if it can.
- Key_name: The name of the index. If it’s the primary key, this will always be PRIMARY.
- Seq_in_index: The column sequence number in the index, starting with 1. For multi-column (composite) indexes, this shows the order of the columns.
- Column_name: The name of the column being indexed.
- Collation: How the column is sorted in the index. A stands for ascending, D for descending, or NULL if not sorted.
- Cardinality: An estimate of the number of unique values in the index. Higher cardinality usually means the index is more effective for the optimizer.
- Sub_part: The number of indexed characters if the column is only partially indexed (e.g., prefix indexing on a TEXT column). NULL means the entire column is indexed.
- Packed: Indicates how the key is packed. NULL if it isn’t.
- Null: Contains YES if the column may contain NULL values and '' (blank) if it cannot.
- Index_type: The indexing method used (usually BTREE, but can be FULLTEXT, HASH, or SPATIAL).
- Comment: Information about the index not described in its own column (e.g., if the index is DISABLED).
- Index_comment: Any comment provided with the COMMENT attribute when the index was created.
- Visible: YES if the index is visible to the optimizer, NO if it is invisible (MySQL 8.0+).
- Expression: For functional indexes, this displays the expression for the column (MySQL 8.0+).

## Prefix Indexes

When creating indexes and the column we're adding index to it is of type `STRING COLUMN` like `CHAR, VARCHAR, TEXT, BLOB`, we don't wanna include the entire content of that column in out index, it's gonna take a lot of space and would be really slow. We want our indexes to be small as possible while maintaining a decent uniqueness to be fast as possible. so basically we take a few characters from the column for the prefix of the column so our index would be smaller.

A prefix index in MySQL is a specialized index that only stores the first $N$ characters of a string column rather than the entire value. This is commonly used for long VARCHAR, TEXT, or BLOB columns to save disk space and speed up indexing. [1, 2, 3, 4]

## Why Use Prefix Indexes?

- Space Savings: Storing just the first 10–20 characters of a long text field takes up significantly less space on disk and in memory (the InnoDB buffer pool) than indexing the full text.
- Mandatory for Large Types: In MySQL, you cannot create a full-column index on TEXT or BLOB columns; you must specify a prefix length.
- Bypass Key Size Limits: InnoDB has an index key length limit (767 or 3072 bytes depending on configuration). If your column exceeds this, a prefix index is the only way to index it. [2, 3, 5, 6]

## Syntax

You specify the prefix length in parentheses after the column name. [7]

-- Creates an index on only the first 10 characters of the 'email' columnCREATE INDEX idx_email_prefix ON users(email(10));

## Key Limitations

- No Covering Indexes: Because the index only contains part of the data, MySQL cannot use it to satisfy a query entirely from the index. It must always "look up" the actual table row to verify the full value.
- No Sorting/Grouping: Prefix indexes cannot be used for ORDER BY or GROUP BY operations because the index is only sorted based on the prefix, not the full string.
- Selectivity Loss: If many rows have the same prefix (e.g., many people sharing the same first 5 characters of a last name), the index becomes less effective at filtering results.

## How to Choose a Prefix Length

The goal is to find the smallest number of characters that still uniquely identifies most rows (high selectivity). You can test this by running:

```sql

SELECT
COUNT(DISTINCT LEFT(column*name, 5)) / COUNT(*) AS selectivity*at_5,
COUNT(DISTINCT LEFT(column_name, 10)) / COUNT(*) AS selectivity_at_10,
COUNT(DISTINCT column_name) / COUNT(\*) AS full_selectivityFROM table_name;

```

Look for the prefix length where the selectivity is close to the "full selectivity" of the column.

### The LEFT Function

Yes, LEFT() is a built-in string function in MySQL.
It extracts a specific number of characters from the left side (the beginning) of a string.

## How it works:

LEFT(string, length)

- string: The column or text you want to chop.
- length: How many characters you want to grab from the start.

## Example:

If you have a column with the value 'Database', running LEFT('Database', 4) will return 'Data'.

## Why we use it for indexing:

In the context of prefix indexes, we use LEFT() to test how unique the data is before actually creating the index.
For example, if you run:

SELECT LEFT(email, 5) FROM users;

It shows you what the database would "see" if you created a prefix index of 5 characters. If the first 5 characters are almost always the same (like admin...), a prefix index of that length won't be very helpful for performance.
Pro-tip: There is also a RIGHT() function that does the exact same thing but starts from the end of the string.
Do you want to see any other string manipulation functions like SUBSTRING or CONCAT?


## Full Text Indexes