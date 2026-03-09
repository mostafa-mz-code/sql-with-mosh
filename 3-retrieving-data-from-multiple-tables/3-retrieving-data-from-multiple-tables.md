# Joins

## 1. **What is a JOIN?**

A JOIN combines rows from two or more tables based on a related column.
Think of it like:
👉 Table A = “Users” (who they are)
👉 Table B = “Orders” (what they bought)
👉 JOIN them = “Which user bought what”

**Note**: in MySQL you can just type `JOIN` or `INNER JOIN` it works the same way, the `INNER` word is optional.

**Syntax**:

```sql
SELECT *  "your columns selection"
FROM table_1   "the first table you want to combine columns"
JOIN table_2    "the second table you want to combine columns with"
ON  condition    "the condition that you want to join columns based on "

```

---

## 2. **INNER JOIN**

An **INNER JOIN** returns only the rows that have a **match in both tables**.
If there’s no match, that row is excluded.

### Example

Suppose we have these tables:

**Users Table**

| user_id | name    | country |
| ------- | ------- | ------- |
| 1       | Alice   | USA     |
| 2       | Bob     | Canada  |
| 3       | Charlie | UK      |

**Orders Table**

| order_id | user_id | product  |
| -------- | ------- | -------- |
| 101      | 1       | Laptop   |
| 102      | 2       | Phone    |
| 103      | 2       | Keyboard |
| 104      | 4       | Mouse    |

### Query with INNER JOIN

```sql
SELECT users.user_id, users.name, orders.product
FROM users
INNER JOIN orders
    ON users.user_id = orders.user_id;
```

👉 Result:

| user_id | name  | product  |
| ------- | ----- | -------- |
| 1       | Alice | Laptop   |
| 2       | Bob   | Phone    |
| 2       | Bob   | Keyboard |

✅ Explanation:

- Alice (id=1) matched → Laptop
- Bob (id=2) matched twice → Phone, Keyboard
- Charlie (id=3) had no order → excluded
- order with user_id=4 → excluded (no matching user)

---

## 3. **Column Name Conflict (same column in both tables)**

Both `users` and `orders` have a column named **`user_id`**.
If you just write:

```sql
SELECT user_id FROM users INNER JOIN orders ...
```

👉 SQL will complain: **“Column 'user_id' is ambiguous”**
Because it doesn’t know if you mean `users.user_id` or `orders.user_id`.

### Solution

Always **prefix with the table (or alias)**:

```sql
SELECT users.user_id, orders.user_id
FROM users
INNER JOIN orders ON users.user_id = orders.user_id;
```

👉 Or shorter, use aliases:

```sql
SELECT u.user_id AS user_from_users, o.user_id AS user_from_orders
FROM users AS u
INNER JOIN orders AS o
    ON u.user_id = o.user_id;
```

This way you control exactly which `user_id` you want.

---

⚡ Recap:

- `INNER JOIN` → only matching rows
- If same column exists in both tables → must prefix with `table.column` or alias

## 4. Using aliases

Use alias to make your join query short and easy to understand:

```sql
SELECT u.user_id, u.name, o.product
FROM users u
JOIN orders o ON u.user_id = o.user_id;

```

```sql
SELECT u.user_id, u.name, o.product
FROM users AS u
JOIN orders AS o ON u.user_id = o.user_id;

```

- AS is optional for table aliases; both styles are fine.

- Prefer aliases in joins to keep the SELECT list tidy and to avoid typos.

## 5. Alternative syntax when the join keys share the same name: USING

```sql
SELECT
  user_id,        -- note: no qualifier now
  u.name,
  o.product
FROM users u
JOIN orders o
USING (user_id);

```

### What changes with USING

- The join key(s) named in USING are coalesced into a single output column called user_id.

- You now refer to it unqualified (user_id).

- Trying to reference u.user_id or o.user_id after USING will usually error, because the output has a single merged user_id.

Tip: USING is neat for common keys, but many teams still prefer ON ... = ... for clarity and portability.

## Importance of ON phrase in JOINs

# 1. What happens if you JOIN with **no `ON` condition**?

If you write:

```sql
SELECT *
FROM users
JOIN orders;
```

(or in some SQL flavors, if you omit `ON` but don’t use `USING`), what you actually get is a **CROSS JOIN** (also called a **Cartesian product**).

👉 This means: **every row from `users` is paired with every row from `orders`**.

---

### Example

**Users**

| user_id | name  |
| ------- | ----- |
| 1       | Alice |
| 2       | Bob   |

**Orders**

| order_id | user_id | product  |
| -------- | ------- | -------- |
| 101      | 1       | Laptop   |
| 102      | 2       | Phone    |
| 103      | 2       | Keyboard |

---

### CROSS JOIN result

Without `ON`, SQL pairs **each row from users with every row from orders**:

| user_id | name  | order_id | user_id | product  |
| ------- | ----- | -------- | ------- | -------- |
| 1       | Alice | 101      | 1       | Laptop   |
| 1       | Alice | 102      | 2       | Phone    |
| 1       | Alice | 103      | 2       | Keyboard |
| 2       | Bob   | 101      | 1       | Laptop   |
| 2       | Bob   | 102      | 2       | Phone    |
| 2       | Bob   | 103      | 2       | Keyboard |

- That’s **2 users × 3 orders = 6 rows**.
- In general: if table A has _m_ rows and table B has _n_ rows, a CROSS JOIN gives _m × n_ rows.
- Notice that most of these rows **don’t make sense** (e.g., Bob paired with Alice’s Laptop order).

This is why **joining with no condition is almost never what you want** (unless you’re deliberately building a grid of combinations, like all color–size pairs).

---

# 2. What happens when you add `ON users.user_id = orders.user_id`?

Now you’re telling SQL: _“Don’t just pair everything — only keep the pairs where the user IDs match.”_

```sql
SELECT u.user_id, u.name, o.product
FROM users u
JOIN orders o
  ON u.user_id = o.user_id;
```

---

### Step 1 — SQL still starts by doing a CROSS JOIN in theory

It considers every possible `(user, order)` pair. (Databases optimize this heavily behind the scenes, but logically, that’s what happens.)

### Step 2 — Apply the `ON` condition

Keep only the pairs where `u.user_id = o.user_id`.

From the big 6-row CROSS JOIN above, only these survive:

| user_id | name  | product  |
| ------- | ----- | -------- |
| 1       | Alice | Laptop   |
| 2       | Bob   | Phone    |
| 2       | Bob   | Keyboard |

✅ This is now an **INNER JOIN result**.

---

# 3. Why is `ON` so important?

- **Without `ON`:** you explode the dataset into meaningless combinations (CROSS JOIN).
- **With `ON`:** you filter down to meaningful matches between rows.

👉 So you can think of `ON` as the **rule that connects rows between tables**. Without it, there’s no relationship — just chaos.

---

# 4. Bonus: what if the `ON` condition isn’t equality?

The `ON` doesn’t _have_ to be `=` — it can be any boolean condition:

```sql
JOIN orders o
  ON u.user_id = o.user_id
     AND o.created_at >= DATE '2025-01-01'
```

- This still matches users to their orders, but only keeps **recent** orders.
- Some advanced cases even join on ranges (`u.birthday BETWEEN o.start_date AND o.end_date`), but equality on keys is the norm.

---

✅ **Summary:**

- No `ON` → CROSS JOIN (every row with every row).
- With `ON` → INNER JOIN (keep only pairs where condition is true).
- Internally, SQL thinks “CROSS JOIN first, then filter by ON.”

---

## Where could WHERE, ORDER BY, and LIMIT go?

```sql
SELECT u.user_id, u.name, o.product
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.created_at >= DATE '2025-01-01'   -- filter rows after the join
ORDER BY u.name ASC                        -- sort the final result
LIMIT 100;
```

- Remember the execution order: FROM/JOIN → WHERE → SELECT → ORDER BY → LIMIT.

- That’s why you can use table columns in WHERE, but can’t use a SELECT-alias there (the alias doesn’t exist yet).

## Joining Across Databases

To join tables across databases you need to prefix the tables with the name of their database! and only required for the tables that are not in the currently selected database

```sql
SELECT *
FROM order_items AS oi
JOIN sql_inventory.products AS p
  ON oi.product_id = p.product_id

```

## Self Joins

# 1. What is a **Self-Join**?

A **self-join** is when you join a table with itself.

- It’s the same physical table, but you treat it as if it were **two different tables** by giving each one an **alias**.
- This is useful when rows in a table relate to **other rows in the same table**.

---

# 2. Example Scenario — Employees & Managers

Suppose we have an `employees` table:

| emp_id | name    | manager_id |
| ------ | ------- | ---------- |
| 1      | Alice   | NULL       |
| 2      | Bob     | 1          |
| 3      | Charlie | 1          |
| 4      | David   | 2          |
| 5      | Eve     | 2          |

- `manager_id` points to the `emp_id` of that employee’s manager.
- Alice (id=1) has `NULL` → she’s the CEO.
- Bob and Charlie report to Alice.
- David and Eve report to Bob.

---

# 3. Query: Show each employee with their manager’s name

```sql
SELECT e.name AS employee,
       m.name AS manager
FROM employees e
JOIN employees m
  ON e.manager_id = m.emp_id;
```

---

### How it works line by line

1. `FROM employees e` → first copy of the table, alias `e` (“employees”).
2. `JOIN employees m` → second copy of the _same table_, alias `m` (“managers”).
3. `ON e.manager_id = m.emp_id` → match each employee’s manager_id to the manager’s emp_id.
4. `SELECT e.name AS employee, m.name AS manager` → pick out the two names, label them clearly.

---

### Result

| employee | manager |
| -------- | ------- |
| Bob      | Alice   |
| Charlie  | Alice   |
| David    | Bob     |
| Eve      | Bob     |

✅ Notice Alice isn’t listed as an employee because she has no manager (`NULL` didn’t match anything).

---

# 4. Why aliases are critical in a self-join

If you just wrote `SELECT name` without prefixes, SQL wouldn’t know whether you mean employee name or manager name — both come from the same table.
👉 That’s why you **must** use aliases (`e`, `m`) in self-joins.

---

# 5. Other real-life uses of self-joins

- **Hierarchy data**: managers & employees, categories & subcategories.
- **Comparisons within a table**: e.g., find pairs of students from the same city.
- **Detect duplicates**: compare a row against others in the same table.

---

✅ **Summary**

- A **self-join** is just a regular join, but with the _same_ table on both sides.
- Use **aliases** to treat them as two tables.
- Very useful for hierarchical or relational data inside one table.

## Joining Multiple Tables

to join more that two tables you simply use the `JOIN` clause

```sql

SELECT your_selection
FROM table_one
JOIN table_tow
  ON first_condition
JOIN table_three
  ON second_condition

```

and the same pattern repeats in case you need to join many many tables, which by the way is not uncommon.

```sql
USE sql_store;
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_statuses os
  ON o.status = os.order_status_id

```

## Compound Join Conditions

sometimes a table's primary-key is not enough to perform a `JOIN` operation, for example:
in our `order_items` table for each record we have `order-id` and `product-id` that have repeated values! in order to uniquely represent each row we need to use logical `AND`/`OR` operators when joining with these tables.

```sql
SELECT * FROM order_items oi
JOIN order_item_notes oin
  ON oi.order_id = oin.order_id
  AND oi.product_id = oin.product_id;
```

## Implicit Join Syntax (not recommended)

In `MySQL` you can implicitly join tables, as following:

```sql
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id

```

but this method is not recommended and you should never use it.

**Note**: if you forget the `WHERE` clause you would get a `cross join` instead of an `inner` join.

## Outer Joins

# 1. Recap: INNER JOIN

- **INNER JOIN** only returns rows where there’s a match in **both** tables.
- Example: Users who have placed at least one order.
  👉 But what if we also want users who have **no orders**? That’s where OUTER JOIN comes in.

---

# 2. What is an OUTER JOIN?

An **OUTER JOIN** returns not only the matching rows, but also the **unmatched rows from one or both tables**.

There are **three types**:

1. **LEFT OUTER JOIN** (or just `LEFT JOIN`)
2. **RIGHT OUTER JOIN** (or just `RIGHT JOIN`)
3. **FULL OUTER JOIN** (not directly supported in MySQL, but we’ll cover a trick later).

---

# 3. LEFT OUTER JOIN (most common)

👉 Returns **all rows from the left table**, plus matching rows from the right.
👉 If there’s no match, you still get the left table row, but the right side becomes `NULL`.

### Example

**Users table**

| user\_id | name    |
| -------- | ------- |
| 1        | Alice   |
| 2        | Bob     |
| 3        | Charlie |

**Orders table**

| order\_id | user\_id | product |
| --------- | -------- | ------- |
| 101       | 1        | Laptop  |
| 102       | 2        | Phone   |

### Query

```sql
SELECT u.user_id, u.name, o.product
FROM users u
LEFT JOIN orders o
  ON u.user_id = o.user_id;
```

### Result

| user\_id | name    | product |
| -------- | ------- | ------- |
| 1        | Alice   | Laptop  |
| 2        | Bob     | Phone   |
| 3        | Charlie | NULL    |

✅ Charlie is shown, even though he has no order.

---

# 4. RIGHT OUTER JOIN

👉 The opposite: return **all rows from the right table**, plus matching rows from the left.
👉 If no match, left side becomes `NULL`.

Same query but with RIGHT JOIN:

```sql
SELECT u.user_id, u.name, o.product
FROM users u
RIGHT JOIN orders o
  ON u.user_id = o.user_id;
```

### Result

| user\_id | name  | product |
| -------- | ----- | ------- |
| 1        | Alice | Laptop  |
| 2        | Bob   | Phone   |

- Charlie disappears (because he’s only in `users`).
- If there were an order with `user_id=999` that doesn’t exist in `users`, it would still show up → with `NULL` for the user columns.

---
