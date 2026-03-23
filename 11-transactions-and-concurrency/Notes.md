# Transactions

A transaction is a group of SQL statements that represent a single unit of work.

## 💡 What is a Transaction in SQL (MySQL)?

A **transaction** is a **group of one or more SQL operations** that are executed as a **single unit of work**.

👉 Either:

- ✅ **ALL operations succeed** → changes are saved
- ❌ **ANY operation fails** → everything is rolled back (undone)

---

## 🧠 Why Transactions Exist

Imagine this real-world scenario:

> You transfer $100 from Account A → Account B

That involves:

1. Subtract $100 from A
2. Add $100 to B

Now imagine:

- Step 1 succeeds
- Step 2 fails 😬

💥 Money disappears!

👉 Transactions **prevent this kind of inconsistency**.

---

## ⚙️ Core Commands in MySQL

### 1. Start a Transaction

```sql
START TRANSACTION;
-- or
BEGIN;
```

---

### 2. Commit (Save Changes)

```sql
COMMIT;
```

---

### 3. Rollback (Undo Everything)

```sql
ROLLBACK;
```

---

### 4. Savepoints (Partial Rollback)

```sql
SAVEPOINT sp1;

ROLLBACK TO sp1;
```

---

## 🔥 Example (MySQL – Bank Transfer)

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE id = 2;

COMMIT;
```

👉 If something fails:

```sql
ROLLBACK;
```

---

## 🧱 ACID Properties (VERY IMPORTANT)

In database systems, ACID is an acronym for four essential properties—Atomicity, Consistency, Isolation, and Durability—that guarantee the reliability of transactions. In MySQL, these properties are primarily implemented by the InnoDB storage engine. 

1. Atomicity ("All or Nothing")
   Atomicity ensures that a transaction is treated as a single, indivisible unit of work. If any part of the transaction fails, the entire transaction is rolled back as if it never happened. 

- MySQL Implementation: InnoDB manages this using undo logs, which keep track of all changes during a transaction so they can be reversed if a rollback is triggered.
- Commands: Controlled via START TRANSACTION, COMMIT, and ROLLBACK. 

1. Consistency ("Always Valid")
   Consistency guarantees that a transaction transitions the database from one valid state to another. It ensures that all predefined rules, such as data types, primary keys, and foreign keys, are strictly followed. 

- MySQL Implementation: The engine enforces data integrity through constraints (like NOT NULL and FOREIGN KEY) and doublewrite buffers to prevent data corruption during crashes. 

1. Isolation ("Mind Your Own Business")
   Isolation determines how and when changes made by one transaction become visible to others. It prevents concurrent transactions from interfering with each other. 

- MySQL Implementation: Uses Multiversion Concurrency Control (MVCC) and row-level locking to allow multiple users to access data simultaneously without conflict.
- Isolation Levels: MySQL supports four levels to balance performance and strictness:
- READ UNCOMMITTED: Highest performance but allows "dirty reads" (seeing uncommitted data).
  - READ COMMITTED: Only sees data that has been officially committed.
  - REPEATABLE READ: The default level in MySQL; ensures that if you read the same data twice in one transaction, it hasn't changed.
  - SERIALIZABLE: Most strict; transactions are executed as if they were in a single line. 

1. Durability ("Once Saved, Always Saved")
   Durability ensures that once a transaction is committed, its changes are permanent and will survive system failures or power outages. [6, 12]

- MySQL Implementation: InnoDB uses redo logs (write-ahead logging) to record all changes to disk before they are finalized, allowing the system to "replay" them if a crash occurs.
- Key Variable: The innodb_flush_log_at_trx_commit setting allows you to tune the balance between durability and performance. [1, 7, 8, 15]


## Creating Transactions

 Alright buddy 😎 now we go from **understanding transactions → mastering them like a backend engineer**.

We’re not just going to “use” transactions — we’ll break down:

* how they actually behave
* edge cases
* real production patterns
* MySQL-specific behavior

---

# 🔥 1. Creating a Transaction (The Right Way)

At the lowest level, a transaction looks simple:

```sql
START TRANSACTION;

-- your queries
UPDATE users SET balance = balance - 100 WHERE id = 1;
UPDATE users SET balance = balance + 100 WHERE id = 2;

COMMIT;
```

👉 But this is just the surface.

Let’s go deeper.

---

# 🧠 2. What REALLY Happens Internally (MySQL - InnoDB)

When you run:

```sql
START TRANSACTION;
```

MySQL (InnoDB):

* Creates a **transaction ID**
* Takes a **snapshot of the database state** (for isolation)
* Starts tracking:

  * changes (in memory + undo logs)
  * locks (rows/tables)

---

### When you run queries:

```sql
UPDATE users SET balance = balance - 100 WHERE id = 1;
```

MySQL:

* Locks that row 🔒
* Stores **previous value** in *undo log* (for rollback)
* Applies change in memory (not yet permanent)

---

### When you `COMMIT`:

```sql
COMMIT;
```

MySQL:

* Writes changes to disk (redo log)
* Releases locks
* Makes changes visible to others

---

### When you `ROLLBACK`:

```sql
ROLLBACK;
```

MySQL:

* Uses undo log to revert everything
* Releases locks

---

# ⚙️ 3. Step-by-Step Real Transaction Flow

Let’s simulate a real system:

---

## 💳 Scenario: Purchase Order

```sql
START TRANSACTION;

-- Step 1: check stock
SELECT stock FROM products WHERE id = 10;

-- Step 2: reduce stock
UPDATE products SET stock = stock - 1 WHERE id = 10;

-- Step 3: create order
INSERT INTO orders (user_id, product_id) VALUES (1, 10);

COMMIT;
```

---

## ❌ What if something fails?

```sql
START TRANSACTION;

UPDATE products SET stock = stock - 1 WHERE id = 10;

-- OOPS: error here (e.g., invalid insert)
INSERT INTO orders (user_id, product_id) VALUES (NULL, 10);

ROLLBACK;
```

👉 Stock goes back to original value
👉 No broken data

---

# 🧱 4. Advanced Control with SAVEPOINT

This is where things get powerful 🔥

```sql
START TRANSACTION;

UPDATE users SET balance = balance - 100 WHERE id = 1;

SAVEPOINT after_deduction;

UPDATE users SET balance = balance + 100 WHERE id = 2;

-- something fails
ROLLBACK TO after_deduction;

COMMIT;
```

👉 Only second update is undone
👉 First update stays

---

# ⚠️ 5. Common Mistakes (Real Dev Traps)

---

## ❌ 1. Forgetting COMMIT

```sql
START TRANSACTION;
UPDATE users SET balance = balance - 100 WHERE id = 1;
-- no commit 😬
```

👉 Changes:

* Not saved permanently
* Locks remain → system slows down

---

## ❌ 2. Mixing Autocommit

```sql
SET autocommit = 1;

START TRANSACTION;
UPDATE users SET balance = balance - 100 WHERE id = 1;
```

👉 If you're not careful:

* Some queries auto-commit
* Transaction logic breaks

---

## ❌ 3. Long Transactions 😬

```sql
START TRANSACTION;

-- waiting for user input 😬
-- or API call 😬
-- or long computation 😬

COMMIT;
```

👉 This causes:

* Locks held too long
* Other users blocked
* Performance issues

---

# 🔒 6. Locks Inside Transactions (CRITICAL)

When you update:

```sql
UPDATE users SET balance = balance - 100 WHERE id = 1;
```

👉 MySQL places:

* **Row-level lock**

---

## Example Problem:

User A:

```sql
START TRANSACTION;
UPDATE users SET balance = balance - 100 WHERE id = 1;
```

User B:

```sql
UPDATE users SET balance = balance - 50 WHERE id = 1;
```

👉 User B will:

* WAIT ⏳ (until A commits or rollbacks)

---

# ⚡ 7. Explicit Locking (Pro Level)

```sql
SELECT * FROM users WHERE id = 1 FOR UPDATE;
```

👉 This:

* Locks row before updating
* Prevents race conditions

---

## Example:

```sql
START TRANSACTION;

SELECT balance FROM users WHERE id = 1 FOR UPDATE;

-- safe logic here
UPDATE users SET balance = balance - 100 WHERE id = 1;

COMMIT;
```

---

# 🧠 8. Deadlocks (Very Important)

Deadlock = two transactions blocking each other 😬

---

## Example:

Transaction A:

```sql
UPDATE users SET balance = balance - 100 WHERE id = 1;
UPDATE users SET balance = balance + 100 WHERE id = 2;
```

Transaction B:

```sql
UPDATE users SET balance = balance - 50 WHERE id = 2;
UPDATE users SET balance = balance + 50 WHERE id = 1;
```

👉 Result:

* A waits for B
* B waits for A
* 💥 DEADLOCK

---

## MySQL Solution:

* Automatically detects deadlock
* Kills one transaction

---

# 🚀 9. Best Practices (Real World)

---

## ✅ Keep transactions SHORT

* No API calls inside
* No user input waiting

---

## ✅ Always handle errors

Backend example (Node.js mindset):

```js
try {
  await db.beginTransaction();

  await deductMoney();
  await addMoney();

  await db.commit();
} catch (err) {
  await db.rollback();
}
```

---

## ✅ Lock only what you need

* Avoid full table locks

---

## ✅ Use consistent order (prevent deadlocks)

Always:

```text
Update table A → then table B
```

Never mix order.

---

# 🧠 10. Pro Mental Model (Senior Level)

Think of a transaction as:

> 🎮 “A private workspace with locks + history”

Inside it:

* You see a controlled version of data
* You lock what you touch
* You can undo everything

---

# 🔥 11. Real Backend Mapping (Important for YOU)

Since you're building full-stack apps:

👉 Transactions = **business logic safety layer**

---

## Example: Expense App (Your Project 👀)

```sql
START TRANSACTION;

INSERT INTO expenses (user_id, amount) VALUES (1, 50);

UPDATE balances SET total = total - 50 WHERE user_id = 1;

COMMIT;
```

👉 Without transaction:

* Data mismatch
  👉 With transaction:
* 💎 Perfect consistency

---

# 🏁 Final Insight

Most beginners:

> “Transactions = optional feature”

Real engineers:

> “Transactions = foundation of data integrity”

## Concurrency and Locking

In MySQL, concurrency is the ability of the database to process multiple transactions at the same time, while blocking is the mechanism that occurs when one transaction must wait for another to release a lock before it can proceed. 
These concepts are primarily managed by the InnoDB storage engine using two key techniques: Locking and Multi-Version Concurrency Control (MVCC). 

1. Concurrency Mechanisms
To allow multiple users to work simultaneously without corrupting data, MySQL uses: [4] 

* Multi-Version Concurrency Control (MVCC): Instead of locking a row for every read, InnoDB creates "snapshots" of data. This allows "consistent reads," where a transaction sees data as it existed at a specific point in time, even if other transactions are currently modifying it.
* Isolation Levels: These settings define how strictly transactions are separated.
* REPEATABLE READ (Default): Ensures you see the same data throughout your transaction, even if others commit changes.
   * READ COMMITTED: Each query sees the latest committed data, which can change between queries in the same transaction.
   * SERIALIZABLE: The strictest level; it essentially turns concurrent access into sequential access by locking almost everything it reads. [2, 4, 5, 6, 7, 8, 9] 

2. Understanding Locking
Locking ensures that two transactions don't try to change the same data at the exact same time. [2, 3] 

* Shared Locks (S): Allow multiple transactions to read a row but prevent any from modifying it.
* Exclusive Locks (X): Required for writing (INSERT, UPDATE, DELETE). Only one transaction can hold an exclusive lock on a row, and it blocks all other S and X lock requests.
* Lock Granularity: InnoDB uses row-level locking, which is highly efficient because it only locks the specific rows being modified rather than the entire table. 

1. Blocking and Deadlocks
Blocking is a natural byproduct of locking designed to maintain data integrity. 

* How Blocking Happens: If Transaction A holds an exclusive lock on Row 1, and Transaction B attempts to update Row 1, Transaction B will "block" (hang) until Transaction A commits or rolls back.
* Lock Wait Timeout: If a transaction is blocked for too long (defaulting to 50 seconds in many setups), MySQL will abort it with a "Lock wait timeout exceeded" error.
* Deadlocks: This occurs when two transactions are stuck waiting for each other (e.g., A waits for a lock held by B, while B waits for a lock held by A). InnoDB automatically detects these "circular waits" and rolls back one of the transactions to break the cycle.  

1. Best Practices to Minimize Blocking

* Keep Transactions Short: Commit or roll back as soon as possible to release locks quickly.
* Use Indexes: If a query doesn't use an index, MySQL may have to scan and lock many more rows than intended, sometimes escalating to a full table lock.
* Consistent Access Order: Always update tables and rows in the same order across different parts of your application to prevent deadlocks. 


## Problems that come with Transactions

Using transactions in databases like MySQL (specifically with the InnoDB engine) is essential for maintaining data integrity, but it introduces several challenges related to concurrency and performance. These problems often manifest as "read phenomena" or locking conflicts.  
1. Concurrency Problems (Read Phenomena)
Simultaneous transactions can cause issues based on the isolation level used, with lower levels allowing for: 

* Dirty Reads: Reading uncommitted, potentially rolled-back data.
* Non-Repeatable Reads: Data changes between two reads in the same transaction.
* Phantom Reads: A transaction's second query returns different rows due to intermediate insertions or deletions by another transaction.
* Lost Updates: Two transactions attempt to update the same record, causing one update to overwrite and erase the other. 

1. Locking and Performance Issues
To maintain consistency, MySQL utilizes locking, which can cause: 

* Deadlocks: Two or more transactions are waiting for each other to release locks, causing a halt.
* Lock Contention: Performance bottlenecks occur when many transactions compete for the same resources, resulting in delays or "Lock wait timeout" errors.
* Resource Overhead: Maintaining undo/redo logs in InnoDB requires extra storage and processing power.  

1. MySQL-Specific Behavioral Risks

* Implicit Commits: DDL statements (e.g., ALTER TABLE) force an immediate commit, breaking transaction boundaries.
* Nested Transactions: MySQL does not support true nesting; a new START TRANSACTION forces an implicit commit of the current transaction. 


## Transaction Isolation Levels

 Transaction isolation levels define the rules that govern how much one transaction can "see" the data changes made by other concurrent transactions. In MySQL’s InnoDB engine, these levels balance the trade-off between data consistency and system performance.
The four standard isolation levels are detailed below from least to most restrictive: 
1. Read Uncommitted

* Behavior: The lowest level of isolation where no shared locks are issued. Transactions can read data that has been modified but not yet committed by others.
* Anomalies: Allows Dirty Reads. If Transaction A updates a row and Transaction B reads it before T1 commits, T2 is acting on "dirty" data that might later be rolled back.
* Use Case: Rarely used in production; only suitable for high-speed analytics where absolute accuracy isn't critical.  

1. Read Committed

* Behavior: A transaction only sees data that has been committed by other transactions before the specific SELECT statement begins. Each statement within the transaction creates its own fresh "snapshot" of committed data.
* Anomalies: Prevents dirty reads but allows Non-Repeatable Reads and Phantom Reads.
* Use Case: The default for many databases (like PostgreSQL and [Oracle](https://www.oracle.com/)), though not MySQL. It is often recommended for [clustered environments](https://dev.mysql.com/doc/refman/8.1/en/innodb-transaction-isolation-levels.html) like Galera Cluster. 

1. Repeatable Read (MySQL Default)

* Behavior: Once a transaction performs its first read, it establishes a consistent snapshot. All subsequent reads within the same transaction see the exact same data, even if other transactions commit changes in the meantime.
* Anomalies: Standard definitions allow Phantom Reads (where new rows appear in a range query), but InnoDB uses Next-Key Locking to prevent most phantoms.
* Use Case: Ideal for reporting or financial systems where data must remain stable throughout a multi-step process. 

1. Serializable

* Behavior: The strictest level; it treats all transactions as if they occur one after another (sequentially). MySQL implements this by implicitly converting all plain SELECT statements into SELECT ... FOR SHARE.
* Anomalies: Prevents all read phenomena (Dirty, Non-Repeatable, and Phantom Reads).
* Use Case: Critical systems like banking where data integrity is paramount, though it significantly increases the risk of deadlocks and reduces concurrency.  

Comparison Summary

| Isolation Level [14, 16, 17, 18] | Dirty Read | Non-Repeatable Read | Phantom Read |
|---|---|---|---|
| Read Uncommitted | Possible | Possible | Possible |
| Read Committed | Prevented | Possible | Possible |
| Repeatable Read | Prevented | Prevented | Prevented (in MySQL) |
| Serializable | Prevented | Prevented | Prevented |


### READ UNCOMMITTED isolation level

