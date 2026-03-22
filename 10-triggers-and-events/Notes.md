# Triggers and Events

## Trigger

A trigger is a block of code that automatically gets executed before or after an **Insert**, **Update** or **Delete** statement.

and are often used to enforce data-consistency

for example:

in our course database, we can have multiple **payments** towards one **invoice**, and to make sure our **payment_total** column gets updated every time, we can implement a **trigger**.

```sql

DELIMITER $$

CREATE TRIGGER trigger_name
BEFORE/AFTER  INSERT/UPDATE/DELETE ON table_name
FOR EACH ROW
BEGIN

.......... your queries...........
.......... your queries...........
.......... your queries...........

END $$

DELIMITER ;


```

**Note**: we have `OLD` and `NEW` keywords that allow us to access the data that's just saved (OLD) or will be saved (NEW)

```sql


DELIMITER $$

-- Trigger naming convention: start with **table_name**, then the trigger time  **before** or **after** then the operation **insert**, **update** or **delete**
CREATE TRIGGER payment_after_insert
-- now we define the timing and the direction of the trigger
-- AFTER or BEFORE comes first
-- operation itself, INSERT, UPDATE, DELETE
-- lastly the table_name comes in
AFTER INSERT ON payments
-- with FOR EACH ROW the trigger would run for each row of the table
FOR EACH ROW

-- the begin of the trigger body
BEGIN
UPDATE invoices
-- with the OLD or NEW keywords we have access to the columns in "payments" table! cause we've set this trigger to rum when an insert is happening on "payments" table
-- with OLD and OLD now we can get the data for each column of the "payments" table. before or after the insert.
SET payment_total = payment_total + NEW.amount

-- define where you wanna update. in this case just one invoice
WHERE invoice_id = NEW.invoice_id;

-- end of trigger body
END $$

DELIMITER ;

```

**Note**:
In a trigger, You can modify data in any table, except THE ONE TABLE THE TRIGGER IS FOR, otherwise you would create an infinite loop.

## Viewing Triggers

to view the trigger present in your database, you can check your database-GUI tool or run a query that shows and can even find specific trigger.\

`SHOW TRIGGERS LIKE 'the_pattern_or_name_you_might_search_for'`

`SHOW TRIGGERS` list all existing triggers.

`SHOW TRIGGERS LIKE 'payment%'` the triggers that contain `payment` in their names.

### Deleting a Trigger

to delete a trigger you simply run `DROP TRIGGER trigger_name ` or even better

`DROP TRIGGER IF EXITS trigger_name`

**Note**: As a best practice you should include the `DROP` and `CREATE` trigger statements in the same sql file

```SQL

-- create a trigger that gets fired when we delete a payment.


DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete ;

CREATE TRIGGER payments_after_delete
AFTER DELETE ON payments
FOR EACH ROW

BEGIN
UPDATE invoices
SET payment_total = payment_total - OLD.amount
WHERE invoice_id = OLD.invoice_id;
END $$
DELIMITER ;

-- delete the payment we just inserted to see the trigger in action.

DELETE FROM payments WHERE payment_id = 9;
```

### Using Triggers for Auditing

In MySQL, SQL triggers are automated programs that fire when specific data changes occur, making them a common tool for building audit trails. They capture who changed what and when, ensuring that every modification is recorded regardless of whether it came from an application, a manual query, or a script.
How Audit Triggers Work
Triggers for auditing are typically defined as AFTER triggers. This ensures the change is already committed to the main table before the audit record is written.

- Events: You generally need three separate triggers per table to cover all modifications: AFTER INSERT, AFTER UPDATE, and AFTER DELETE.
- Accessing Data: MySQL provides two special keywords to access row values:
- OLD: References the column values before the change (used in UPDATE and DELETE).
  - NEW: References the column values after the change (used in INSERT and UPDATE).
- Metadata: Audits typically include the database user (CURRENT_USER()), the operation type (e.g., 'UPDATE'), and a timestamp (NOW()).

Example Implementation
To audit a table named employees, you first create a log table and then the triggers.

1. Create Audit Table

CREATE TABLE employee_audit (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
employee_id INT,
action_type VARCHAR(10), -- INSERT, UPDATE, or DELETE
old_salary DECIMAL(10,2),
new_salary DECIMAL(10,2),
changed_by VARCHAR(100),
changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

2. Create Audit Trigger (Example: After Update)

DELIMITER $$
CREATE TRIGGER after_employee_update
AFTER UPDATE ON employeesFOR EACH ROWBEGIN
    -- Only log if the salary actually changed
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO employee_audit (employee_id, action_type, old_salary, new_salary, changed_by)
        VALUES (OLD.id, 'UPDATE', OLD.salary, NEW.salary, CURRENT_USER());
    END IF;END$$

DELIMITER ;

Key Considerations for MySQL

- Performance: MySQL triggers are row-level only (FOR EACH ROW), meaning if you update 1,000 rows, the trigger runs 1,000 times. This can slow down bulk operations.
- No DDL Auditing: Unlike some other databases, MySQL triggers only respond to data changes (DML). They cannot audit schema changes like CREATE or DROP TABLE.
- Limited Context: CURRENT_USER() captures the database account. If your application uses a single "app_user" to connect, you may need to pass application-level user IDs into a session variable for the trigger to read.
- JSON Snapshots: A modern approach is to store the entire OLD and NEW row states as [JSON objects](https://vladmihalcea.com/mysql-audit-logging-triggers/) within the audit table. This prevents the audit table from breaking if you add new columns to the main table later.

**NOTE**:

In MySQL triggers, the OLD and NEW keywords are aliases used to access specific row data during a data modification event. They return the values of columns for the row currently being processed by the trigger. [1, 2, 3]
Key Differences and Data Returned

| Event [3, 4, 5, 6, 7, 8] | OLD Keyword                                                | NEW Keyword                                        |
| ------------------------ | ---------------------------------------------------------- | -------------------------------------------------- |
| INSERT                   | Not available (there is no previous row state).            | Returns the values to be inserted.                 |
| UPDATE                   | Returns the column values before the update occurs.        | Returns the column values after the update occurs. |
| DELETE                   | Returns the column values of the row before it is deleted. | Not available (there is no subsequent row state).  |

Usage Rules

- Column Access: You must prefix the column name with the keyword (e.g., OLD.salary or NEW.username).
- Read vs. Write:
- OLD columns are read-only; you can reference them but never modify them.
  - NEW columns can be modified using SET NEW.column_name = value, but only in BEFORE triggers.
- Case Sensitivity: These keywords are not case-sensitive in MySQL.
- Scope: They are only available for row-level triggers, which MySQL uses by default (FOR EACH ROW). [1, 3, 6, 9, 10, 11]

Example Scenario
If you update an employee's salary from 5000 to 6000:

- OLD.salary returns 5000.
- NEW.salary returns 6000. [5]

## Events

An event is a (block of SQL code) that gets executed according to a scheduled time.

Alright—MySQL **events** are one of those features that separate _basic CRUD developers_ from _serious backend engineers_. Let’s go deep and make it crystal clear with practical thinking.

---

# 🧠 What Are MySQL Events?

A **MySQL Event** is basically:

> ⏱️ A **scheduled task** that runs automatically inside the database at a specific time or interval.

Think of it like:

- **Cron jobs** (Linux)
- Scheduled background jobs
- Automated scripts

…but **inside MySQL itself**.

---

# ⚙️ Real-Life Mental Model

Imagine you want:

- Delete expired sessions every day
- Archive old orders every week
- Update user stats every hour

Instead of writing backend code + cron job…

👉 You tell MySQL:

> “Run this query every X time”

That’s an **event**.

---

# 🔥 Basic Syntax

```sql
CREATE EVENT event_name
ON SCHEDULE schedule
DO
  sql_statement;
```

---

# 🧩 Types of Scheduling

## 1. Run Once

```sql
CREATE EVENT delete_temp_data
ON SCHEDULE AT '2026-03-25 10:00:00'
DO
  DELETE FROM temp_table;
```

👉 Runs **only once at that exact time**

---

## 2. Run Repeatedly (MOST COMMON)

```sql
CREATE EVENT cleanup_sessions
ON SCHEDULE EVERY 1 DAY
DO
  DELETE FROM sessions WHERE expires_at < NOW();
```

👉 Runs every day forever

---

## 3. Advanced Interval Example

```sql
ON SCHEDULE EVERY 2 HOUR
```

You can use:

- SECOND
- MINUTE
- HOUR
- DAY
- WEEK
- MONTH
- YEAR

---

## 4. Start + End Time

```sql
CREATE EVENT limited_event
ON SCHEDULE
  EVERY 1 DAY
  STARTS '2026-03-22 00:00:00'
  ENDS '2026-04-01 00:00:00'
DO
  UPDATE stats SET count = count + 1;
```

👉 Runs only within a time window

---

# 🚨 VERY IMPORTANT: Enable Event Scheduler

By default, MySQL events are often **disabled**.

Check status:

```sql
SHOW VARIABLES LIKE 'event_scheduler';
```

Enable it:

```sql
SET GLOBAL event_scheduler = ON;
```

Or permanently in config:

```ini
event_scheduler=ON
```

---

# 🏗️ Real-World Use Cases (This is where it gets interesting)

## 1. 🧹 Automatic Cleanup

```sql
DELETE FROM logs WHERE created_at < NOW() - INTERVAL 30 DAY;
```

👉 Prevents DB from growing forever

---

## 2. 📊 Analytics / Aggregation

```sql
UPDATE user_stats
SET daily_logins = (
  SELECT COUNT(*) FROM logins WHERE DATE(created_at) = CURDATE()
);
```

👉 Pre-compute stats → faster dashboards

---

## 3. 📦 Archiving Old Data

```sql
INSERT INTO orders_archive
SELECT * FROM orders WHERE created_at < NOW() - INTERVAL 1 YEAR;

DELETE FROM orders WHERE created_at < NOW() - INTERVAL 1 YEAR;
```

---

## 4. 🔔 Expiring Data

```sql
UPDATE coupons
SET status = 'expired'
WHERE expiry_date < NOW();
```

---

## 5. 💰 Financial Systems (VERY COMMON)

- Daily balance calculations
- Interest updates
- Subscription renewals

---

# 🆚 Events vs Cron Jobs (IMPORTANT for architecture)

| Feature     | MySQL Events | Cron Jobs                |
| ----------- | ------------ | ------------------------ |
| Location    | Inside DB    | OS / Server              |
| Language    | SQL only     | Any (Node, Python, etc.) |
| Flexibility | Limited      | Very high                |
| Scaling     | DB-dependent | App-level control        |
| Debugging   | Harder       | Easier                   |

---

## 🧠 When to Use Events

Use MySQL Events when:

✅ Logic is **pure SQL**
✅ Task is **database-related only**
✅ You want **simple automation**
✅ You don’t want extra backend jobs

---

## 🚫 When NOT to Use Events

Avoid events when:

❌ You need API calls
❌ Complex logic / business rules
❌ Logging / monitoring
❌ Distributed systems

👉 In these cases → use backend + cron (Node.js, etc.)

---

# 🛠️ Managing Events

## Show Events

```sql
SHOW EVENTS;
```

---

## View Event Definition

```sql
SHOW CREATE EVENT cleanup_sessions;
```

---

## Alter Event

```sql
ALTER EVENT cleanup_sessions
ON SCHEDULE EVERY 2 DAY;
```

---

## Drop Event

```sql
DROP EVENT cleanup_sessions;
```

---

# 🧪 Advanced Example (Professional Level)

```sql
CREATE EVENT update_user_rank
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
  UPDATE users u
  JOIN (
    SELECT user_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY user_id
  ) o ON u.id = o.user_id
  SET u.rank =
    CASE
      WHEN o.total_orders > 100 THEN 'VIP'
      WHEN o.total_orders > 50 THEN 'Gold'
      ELSE 'Regular'
    END;
END;
```

👉 This is **production-level thinking**

---

# ⚠️ Limitations & Gotchas

- No external API calls
- Harder to debug
- Runs silently (can fail without notice)
- Needs proper privileges (`EVENT` privilege)
- Timezone matters (VERY important in production)

---

# 💡 Pro Insight (This is what senior devs think about)

In real-world systems:

- Small apps → MySQL Events are OK
- Scalable systems → move to:
  - Queue systems (BullMQ, RabbitMQ)
  - Workers
  - Cron jobs in backend

---

# 🧠 Final Mental Model

> MySQL Events = “Database-level automation engine”

- Triggers → react to changes
- Events → run on time

---
 ### Viewing and Dropping Events
 
To view all the **Events** use `SHOW EVENTS` command and if need to filter them `SHOW EVENTS LIKE 'keyword'` to filter events based on that **keyword**