# Retrieving Data from a Table

## 1. **Selecting a Database**

In SQL systems like MySQL or PostgreSQL, once you connect to the server, you usually need to choose which database you want to work with:

```sql
USE my_database;
```

👉 This sets the “scope” — so when you run queries, the server knows _which database_ to look into.

---

## 2. **The `SELECT` Statement — The Core of SQL**

A `SELECT` query is how you **read data**.
The general structure looks like this:

```sql
SELECT [DISTINCT] column_list
FROM table_name
[WHERE condition]
[GROUP BY column_list]
[HAVING condition]
[ORDER BY column_list [ASC | DESC]]
[LIMIT number OFFSET number];
```

---

## 3. **Breaking it Down**

### **a. SELECT (Required)**

- Tells SQL _what columns_ you want.
- Example:

  ```sql
  SELECT name, email
  ```

- If you want everything:

  ```sql
  SELECT *
  ```

### **b. FROM (Required)**

- Tells SQL _which table(s)_ to get data from.
- Example:

  ```sql
  FROM users
  ```

### **c. WHERE (Optional)**

- Filters rows before grouping or ordering.
- Example:

  ```sql
  WHERE age > 18
  ```

### **d. GROUP BY (Optional)**

- Groups rows into categories (used with aggregate functions like `COUNT`, `SUM`, `AVG`).
- Example:

  ```sql
  GROUP BY department
  ```

### **e. HAVING (Optional)**

- Like `WHERE`, but applies **after grouping**.
- Example:

  ```sql
  HAVING COUNT(*) > 5
  ```

### **f. ORDER BY (Optional)**

- Sorts results by one or more columns.
- Example:

  ```sql
  ORDER BY age DESC
  ```

### **g. LIMIT / OFFSET (Optional, MySQL/Postgres-specific)**

- Restricts how many rows to return.
- Example:

  ```sql
  LIMIT 10 OFFSET 5
  ```

or

```sql
LIMIT 10, 5
```

it means: skip `10` first items and then only select `5` items

---

## 4. **Correct Order of Clauses (SQL Syntax Order)**

This is the order you must write them in:

1. **SELECT**
2. **FROM**
3. **WHERE**
4. **GROUP BY**
5. **HAVING**
6. **ORDER BY**
7. **LIMIT / OFFSET**

---

## 5. **BUT — SQL Execution Order (Behind the Scenes)**

Even though you **write** queries in the above order, SQL **executes them differently**. Internally:

1. **FROM** (and JOINs happen here)
2. **WHERE** (filter rows)
3. **GROUP BY** (make groups)
4. **HAVING** (filter groups)
5. **SELECT** (pick columns, calculate expressions)
6. **ORDER BY** (sort results)
7. **LIMIT/OFFSET** (return only part of results)

👉 This difference explains why you **can’t use an alias defined in SELECT inside WHERE** — because `WHERE` runs _before_ `SELECT`.

---

⚡ Quick Recap:

- `SELECT` + `FROM` → **required**
- `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT` → **optional**
- Written order ≠ execution order

---

## 1. **Alias (`AS`)**

An alias is a **temporary name** for a column or table. It makes results more readable and queries shorter.

- **Column Alias:**

```sql
SELECT name AS full_name, age AS years_old
FROM users;
```

👉 This renames `name → full_name` and `age → years_old` **only in the result set**.

- Without `AS` also works:

```sql
SELECT name full_name, age years_old
FROM users;
```

- **Table Alias:**

```sql
SELECT u.name, u.email
FROM users AS u;
```

👉 Here, `users` is renamed `u`. Handy when joining multiple tables.

---

## 2. **DISTINCT**

`DISTINCT` removes duplicate rows from results.

- Example without `DISTINCT`:

```sql
SELECT country FROM users;
```

Might return:

```
USA
USA
Canada
USA
Canada
```

- With `DISTINCT`:

```sql
SELECT DISTINCT country FROM users;
```

Result:

```
USA
Canada
```

👉 You can apply it to multiple columns:

```sql
SELECT DISTINCT city, country FROM users;
```

Here it removes duplicates **based on the combination** of both columns.

---

## 3. **Doing Math in `SELECT`**

SQL lets you **calculate values directly** when selecting.

### **Basic Arithmetic**

```sql
SELECT price, quantity, price * quantity AS total_cost
FROM orders;
```

👉 Multiplies `price × quantity` for each row and shows it as `total_cost`.

### **Using Built-in Functions**

- `ROUND(number, decimals)` → rounds numbers
- `LENGTH(text)` → length of a string
- `UPPER(text)` → uppercase
  Example:

```sql
SELECT name, UPPER(country) AS country_upper
FROM users;
```

### **Aggregates (when combined with GROUP BY)**

```sql
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

👉 Calculates the average salary per department.

---

## 4. ⚡ All Together Example

```sql
SELECT DISTINCT
    u.country AS nation,
    u.city AS town,
    ROUND(AVG(u.salary), 2) AS avg_income,
    COUNT(*) AS employee_count
FROM users AS u
WHERE u.age > 18
GROUP BY u.country, u.city
ORDER BY avg_income DESC
LIMIT 5;
```

### What happens here

1. Aliases (`AS nation`, `AS town`, `AS avg_income`, `AS employee_count`) → nicer names.
2. `DISTINCT` → ensures unique `country-city` pairs.
3. `ROUND(AVG(...), 2)` → math function with aggregation.
4. `COUNT(*)` → number of rows in each group.

---

👉 Do you want me to **draw up a mini “practice database table” (like a sample `users` or `orders` table)** so we can write and test example queries on it together? That way each new concept gets applied to real data.

## 1. **The `WHERE` Clause**

The `WHERE` clause is used to **filter rows** from a table — only rows that meet the condition(s) will be returned.
Think of it as the **gatekeeper**:

- If the condition is **true**, the row passes through.
- If the condition is **false**, the row is excluded.

### Example

```sql
SELECT name, age
FROM users
WHERE age > 18;
```

👉 Only users older than 18 will be shown.

---

### Common `WHERE` Operators

- `=` → Equal
- `<>` or `!=` → Not equal
- `>` → Greater than
- `<` → Less than
- `>=` → Greater than or equal
- `<=` → Less than or equal
- `BETWEEN a AND b` → Value in a range
- `IN (val1, val2, ...)` → Value matches one from a list
- `LIKE` → Pattern matching (`%` = wildcard, `_` = single char)
- `IS NULL` / `IS NOT NULL` → Check for empty values

---

## 2. **What does `<>` mean?**

The operator `<>` means **“NOT EQUAL TO”** in SQL.
It’s the same as `!=` (but `<>` is more “standard SQL”).

### Example

```sql
SELECT name, country
FROM users
WHERE country <> 'USA';
```

👉 Returns all users **except** those from the USA.

Another example:

```sql
SELECT *
FROM products
WHERE price <> 100;
```

👉 Shows all products where the price is anything **other than 100**.

---

✅ **Quick recap:**

- `WHERE` → filters rows
- `<>` → “not equal” operator

---

## 1. **`BETWEEN`**

Checks if a value falls **within a range** (inclusive of boundaries).

### Syntax

```sql
value BETWEEN low AND high
```

### Example

```sql
SELECT name, age
FROM users
WHERE age BETWEEN 18 AND 30;
```

👉 Returns users **18, 19, …, 30** years old.

⚡ Same as:

```sql
age >= 18 AND age <= 30
```

---

## 2. **`LIKE`**

Used for **pattern matching** in text.

- `%` → wildcard for **any number of characters**
- `_` → wildcard for **a single character**

### Examples

```sql
SELECT name
FROM users
WHERE name LIKE 'A%';
```

👉 Names starting with "A" (`Alice`, `Adam`, `Aria`).

```sql
SELECT name
FROM users
WHERE name LIKE '%son';
```

👉 Names ending in "son" (`Jackson`, `Emerson`).

```sql
SELECT name
FROM users
WHERE name LIKE 'J_n';
```

👉 Names with 3 letters, starting with J and ending with n (`Jon`, `Jan`).

---

## 3. **`REGEXP` (Regular Expressions)**

`LIKE` is limited — for complex patterns, SQL supports regex (in **MySQL** and **PostgreSQL**).

### REGEXP special characters

1. `^` at the beginning of a string
2. `$` at the end of a string, this character goes on the right-side of the pattern you want to match
3. `.` a single character
4. `[abcd]` a list of characters for a single character match
5. `[a-f]` a range of characters from `a` to `f`
6. `*` 0 or many
7. `+` 1 or many
8.

### Example

```sql
SELECT name
FROM users
WHERE name REGEXP '^A';
```

👉 Names starting with "A".

```sql
SELECT name
FROM users
WHERE name REGEXP 'son$';
```

👉 Names ending with "son".

```sql
SELECT name
FROM users
WHERE name REGEXP '^[J|K]';
```

👉 Names starting with **J or K**.

⚡ Regex is much more flexible than `LIKE` (e.g., you can match multiple rules at once).

---

## 4. **`IS NULL` and `IS NOT NULL`**

In SQL, `NULL` means **no value / missing data**.
You can’t use `= NULL`, you must use `IS NULL`.

### Example

```sql
SELECT name, email
FROM users
WHERE email IS NULL;
```

👉 Finds users with **no email**.

```sql
SELECT name, email
FROM users
WHERE email IS NOT NULL;
```

👉 Finds users **with an email address**.

---

## 5. ⚡ All Together Example

```sql
SELECT name, age, email
FROM users
WHERE age BETWEEN 20 AND 40
  AND name LIKE '%son'
  AND email IS NOT NULL
  AND country REGEXP '^(USA|Canada)$';
```

👉 Meaning:

- Age between 20–40
- Name ending with "son"
- Must have an email
- Country is either USA or Canada (via regex)
