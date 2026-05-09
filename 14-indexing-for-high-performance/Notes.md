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
