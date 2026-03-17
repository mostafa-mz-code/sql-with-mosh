# Stored Procedures

## What Are Stored Procedures in MySQL?

### What Are **Stored Procedures** in MySQL?

A **Stored Procedure** is a **pre-written SQL program stored inside the database** that you can execute whenever you need it.

Instead of writing the same SQL queries again and again in your application code, you **save them once in the database** and call them by name.

Think of it like a **function inside the database**.

---

## Simple Analogy

Imagine you frequently run this query:

```sql
SELECT * FROM users WHERE status = 'active';
```

Instead of writing it everywhere in your code, you create a stored procedure:

```sql
CALL getActiveUsers();
```

The database already knows what `getActiveUsers` does.

---

# Basic Structure

```sql
DELIMITER $$

CREATE PROCEDURE procedure_name()
BEGIN
   -- SQL statements
END $$

DELIMITER ;
```

Example:

```sql
DELIMITER $$

CREATE PROCEDURE getUsers()
BEGIN
  SELECT * FROM users;
END $$

DELIMITER ;
```

Then you call it like this:

```sql
CALL getUsers();
```

---

# Stored Procedure With Parameters

Stored procedures can accept inputs.

Example:

```sql
DELIMITER $$

CREATE PROCEDURE getUserById(IN userId INT)
BEGIN
  SELECT * FROM users WHERE id = userId;
END $$

DELIMITER ;
```

Call it:

```sql
CALL getUserById(5);
```

---

# Types of Parameters

MySQL supports three parameter types.

| Type      | Meaning                           |
| --------- | --------------------------------- |
| **IN**    | Input value passed into procedure |
| **OUT**   | Output value returned             |
| **INOUT** | Both input and output             |

Example:

```sql
CREATE PROCEDURE countUsers(OUT total INT)
BEGIN
  SELECT COUNT(*) INTO total FROM users;
END
```

---

# Stored Procedures Can Do Much More

Inside a stored procedure you can use:

- Variables
- Loops
- IF conditions
- Transactions
- Multiple queries

Example:

```sql
CREATE PROCEDURE deleteInactiveUsers()
BEGIN
  DELETE FROM users
  WHERE last_login < DATE_SUB(NOW(), INTERVAL 1 YEAR);
END
```

---

# Why Developers Use Stored Procedures

### 1️⃣ Performance

The SQL is **compiled and optimized once** by the database.

### 2️⃣ Reusability

Write once → use everywhere.

### 3️⃣ Security

You can give permission to execute a procedure without exposing the tables.

### 4️⃣ Cleaner Backend Code

Instead of:

```js
db.query("SELECT * FROM users WHERE id = ?", [id]);
```

You can do:

```sql
CALL getUserById(?)
```

---

# When They Are Commonly Used

Stored procedures are common in:

- **Enterprise systems**
- **Financial systems**
- **Large legacy applications**
- Some **POS systems** (like the one you worked on)

But in modern web apps (Node.js, Django, etc.), many teams prefer **application logic in the backend instead of the database**.

---

# Important Insight (Senior Developer Perspective)

You actually asked earlier:

> "Where should database queries live in an application?"

This connects directly to stored procedures.

There are two architectural styles:

### 1️⃣ App-driven logic (modern web apps)

```
Backend (Node/Django)
      ↓
SQL queries
      ↓
Database
```

### 2️⃣ Database-driven logic (stored procedures)

```
Backend
      ↓
CALL stored_procedure()
      ↓
Database handles logic
```

Most **modern startups prefer option 1** because it is easier to:

- maintain
- test
- version control

---

# Real Example

Instead of writing this in your backend:

```sql
INSERT INTO orders (user_id, total)
VALUES (?, ?);

INSERT INTO order_items ...
UPDATE inventory ...
```

You could create a procedure:

```sql
CALL createOrder(userId, items);
```

The database handles everything internally.

---

# One More Related Concept

Stored procedures are often used with:

- **Triggers**
- **Views**
- **Functions**

These are **advanced SQL features** you’ll see in large systems.

---

# My Honest Advice For You

Since you're already working with:

- **Next.js**
- **Node.js**
- **Supabase**
- **Django**
- **Full-stack apps**

You should:

✅ **Understand stored procedures**
❌ **Not rely on them heavily yet**

Most modern stacks use:

- ORM
- Query builders
- Raw SQL in backend

---

# If you'd like, I can also explain

A Stored Procedure is a pre-written SQL program stored inside the database that you can execute whenever you need it.

Instead of writing the same SQL queries again and again in your application code, you save them once in the database and call them by name.

Think of it like a function inside the database.

1. What problem do they solve?
   In standard development, an app often sends multiple individual queries to the database (e.g., check balance, subtract amount, log transaction). This causes "chatter"—too many round trips between the app and the server—which slows things down and increases the risk of data getting out of sync if one step fails.
2. Why use them (Benefits)?

- Reduced Network Traffic: Instead of sending 10 separate queries, the app sends one command: CALL MyProcedure().
- Centralized Logic: If your business logic changes (like how tax is calculated), you update it once in the database instead of updating every app (web, mobile, desktop) that uses it.
- Security: You can give a user permission to run a procedure without giving them direct access to the underlying tables.
- Performance: MySQL compiles and caches the execution plan for procedures, making repeated calls slightly faster.

1. How to use them
   To create one, you use the CREATE PROCEDURE command. Because procedures contain semicolons, you have to temporarily change the Delimiter so MySQL knows when the whole block ends.
   Example: A procedure to get user details by ID

```sql
DELIMITER //
CREATE PROCEDURE GetUser(IN userId INT)BEGIN
SELECT \* FROM users WHERE id = userId;END //

DELIMITER ;

```

To run it:

CALL GetUser(5);

When to skip them?
Stored procedures can be harder to version control (they aren't just files in Git) and they can put a heavy CPU load on your database server. Many modern teams prefer keeping logic in the application code using an ORM, but they remain a powerhouse for data-heavy tasks. [18, 19, 20, 21]
Would you like to see how to handle variables or conditional logic (IF/ELSE) inside a procedure?

## Creating a Stored Procedure

To create a procedure, first you need to change the default delimiter `;` which is used to end each statement! because procedures allow several statements inside a single procedure,
so terminating one statement would mean terminating the whole procedure mid-way.

```sql
-- change the default delimiter from ';' to by convention '$$'
-- and use it to mark the end of the procedure creation statement
DELIMITER $$
CREATE PROCEDURE procedure_name()
BEGIN
  statements;
  statement;
  statement;
END$$

-- change the delimiter back to it's normal form ';'
DELIMITER ;

```

now you can call the procedure and it would return the results of the queries you wrote within it.

but calling a stored procedure is often happen with application code, like python, java, etc...

```sql
CALL procedure_name();
```

## Dropping Procedures

To delete a procedure all you need to do is `DROP PROCEDURE procedure_name`

but a better preferred way is to use `DROP PROCEDURE IF EXISTS procedure_name` just to be safe, if you try to drop a procedure that doesn't exist you would get an error.

same as `VIEWS` you better store your procedure code in a separate sql file and keep them under source-control

## Parameters

we can also add `parameters` to procedures.

```sql

DELIMITER $$

CREATE PROCEDURE procedure_name( param_name PARAM_TYPE())
BEGIN
  statement.....;
  statement.....;
  statement.....;
END

DELIMITER ;


```

in the following query since the `parameter` and `column_name` are the exact same, we need to be specific about it,
when performing filtering and other logical operations.

there are some popular conventions:

- `p_param_name`
- `param_name_param`
- just giving the table an `alias` and use that to access table columns `c.name = name`

```sql

DELIMITER $$

CREATE PROCEDURE get_clients_by_state (state VARCHAR(2))
BEGIN
  SELECT * FROM clients c
  WHERE c.state = state;

END $$

DELIMITER ;

```

## Parameters with Default Values

to add return a default result for the procedure if the provided value for the parameter doesn't match or data doesn't exist.

1. using the `IF` clause

to use the **IF** clause it's applied as following:

```sql

IF condition THEN
...statement....;
ELSE
...statement...;
END IF
```

but using `IF/THEN/ELSE` can look amateurish.

```sql

DELIMITER $$
CREATE PROCEDURE get_clients_by_state( state CHAR(2))
BEGIN
-- use IF statement to set default value for state parameter
IF state IS NULL THEN
SET state = 'CA';
END IF;
-- always end the if statement with END IF
SELECT * FROM clients c
WHERE c.state = state ;
END $$
DELIMITER ;
```

2. we can use `IFNULL(nullable, fallbackValue)`

```sql

DELIMITER $$

CREATE PROCEDURE get_clients_by_state( state CHAR(2))

BEGIN

SELECT * FROM clients c
WHERE c.state = IFNULL(state, c.state);

END $$

DELIMITER;

CALL get_clients_by_state("ca");
```

## Parameter Validation

procedures can be used to select, update, delete data. too

when it comes to validating parameter in procedures, you need to stick to the bare minimum, because your application should handle all the validations, and these validations are just the last-resort not the main solution.

In MySQL stored procedures, parameter validation is primarily performed using IF statements combined with the SIGNAL statement to raise custom errors when validation fails.
Core Validation Techniques

- Raising Errors with SIGNAL SQLSTATE: This is the standard way to stop execution and return an error message to the caller. Use SQLSTATE '45000' for general unhandled user-defined errors.
- Conditional Logic (IF...THEN): Use IF blocks at the beginning of your procedure to check for invalid states, such as null values, out-of-range numbers, or empty strings.
- Business Logic Checks: You can use SELECT statements within your validation logic to verify if related data exists in other tables (e.g., checking if a foreign key exists before an update).

Implementation Example
The following procedure demonstrates basic range and existence validation:

DELIMITER $$
CREATE PROCEDURE update_invoice_amount(
IN p_invoice_id INT,
IN p_new_amount DECIMAL(10,2)
)BEGIN
-- 1. Range Check: Ensure amount is positive
IF p_new_amount <= 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Error: Invoice amount must be greater than zero.';
END IF;

    -- 2. Existence Check: Ensure the invoice exists
    IF NOT EXISTS (SELECT 1 FROM invoices WHERE id = p_invoice_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Provided invoice ID does not exist.';
    END IF;

    -- Actual Update Logic
    UPDATE invoices SET amount = p_new_amount WHERE id = p_invoice_id;END $$

DELIMITER ;

Common Validation Types

| Validation Type [1, 2, 9, 10, 11] | Description                                  | MySQL Example Snippet                             |
| --------------------------------- | -------------------------------------------- | ------------------------------------------------- |
| Null/Presence                     | Checks if required input is missing.         | IF p_param IS NULL THEN ...                       |
| Range Check                       | Ensures numbers fall within expected limits. | IF p_age < 18 OR p_age > 120 THEN ...             |
| Format/Length                     | Validates string lengths or patterns.        | IF CHAR_LENGTH(p_username) < 5 THEN ...           |
| Reference                         | Verifies data exists in another table.       | IF (SELECT COUNT(\*) FROM users ...) = 0 THEN ... |

Best Practices

- Early Exit: Perform all validations at the very start of the BEGIN...END block before any data manipulation occurs.
- Custom Messages: Use [MESSAGE_TEXT](https://dev.mysql.com/doc/refman/8.3/en/signal.html) to provide clear, actionable feedback to the application layer.
- Local Variables: If you need to build dynamic error messages, DECLARE a local variable first to concatenate strings before passing them to SIGNAL.

### Sending Signals to the caller of procedure

In MySQL, "signaling" is the process of raising an error or warning to stop execution and inform the user or application about a specific problem. [1, 2]
Setting and Sending Signals
You send a signal using the SIGNAL statement. This statement populates the Diagnostics Area, which stores information about the error.

- Syntax: SIGNAL SQLSTATE 'value' SET MESSAGE_TEXT = 'custom message', MYSQL_ERRNO = number;
- Location: SIGNAL can be used anywhere in a stored procedure, trigger, or function.
- Termination: If the SQLSTATE indicates an error (not a warning), the procedure terminates immediately unless there is a handler to catch it.
- Information Items: You can set several items in the SET clause, most commonly:
- MESSAGE_TEXT: The human-readable error message.
  - MYSQL_ERRNO: A MySQL-specific error number (e.g., 1001).
  - Others: You can also specify TABLE_NAME, COLUMN_NAME, or CONSTRAINT_NAME to provide more context.

Common Error Codes (SQLSTATE)
SQLSTATE codes are 5-character strings. The first two characters define the Class:

| SQLSTATE [10, 11, 13, 14, 15, 16, 17] | Meaning                          | Usage                                                            |
| ------------------------------------- | -------------------------------- | ---------------------------------------------------------------- |
| 45000                                 | Unhandled User-Defined Exception | The standard, recommended code for custom application errors.    |
| 01000                                 | Warning                          | General warning. Execution continues, but the message is logged. |
| 02000                                 | Not Found                        | Used when a query returns no results (common with cursors).      |
| 23000                                 | Constraint Violation             | Used for duplicate keys or foreign key failures.                 |
| 42000                                 | Syntax/Access Error              | Used for permission issues or invalid table names.               |

Note: You must never use a code starting with 00, as that indicates success and will cause an error if used with SIGNAL.
SIGNAL vs. RESIGNAL
While they look similar, they have different purposes:

- SIGNAL: Creates a new error condition from scratch.
- RESIGNAL: Passes on an existing error. It is only valid inside a condition handler (like a CATCH block). It allows you to catch an error, perform an action (like logging or rolling back), and then throw the error back to the caller.

## Output Parameters

In MySQL, output parameters are a way for a stored procedure to return one or more values back to the calling program after its execution. Unlike a standard RETURN statement in a function that returns a single value, a stored procedure can have multiple output parameters to return various pieces of data simultaneously. [1, 2, 3, 4]
Key Characteristics of Output Parameters

- Keyword: They are defined using the OUT keyword before the parameter name.
- Direction: Values flow strictly out of the procedure. When the procedure starts, an OUT parameter is initialized as NULL and cannot receive an initial value from the caller.
- Assignment: Inside the procedure body, you assign values to these parameters using SET or the SELECT ... INTO syntax.
- Retrieval: To capture the output, you must pass a user-defined session variable (starting with @) when calling the procedure. [2, 5, 6, 7, 8, 9, 10, 11]

Types of Parameters in MySQL

| Type [2, 5, 12, 13, 14] | Keyword | Description                                                                                             |
| ----------------------- | ------- | ------------------------------------------------------------------------------------------------------- |
| Input                   | IN      | Passes a value into the procedure. It is read-only within the procedure.                                |
| Output                  | OUT     | Passes a value back to the caller. Its initial value is always NULL inside the procedure.               |
| Input/Output            | INOUT   | Acts as both an input and an output. It can be initialized by the caller and modified by the procedure. |

Example Implementation
This example demonstrates how to create a procedure that calculates the total number of students and returns it via an OUT parameter. [15, 16, 17, 18, 19]

1. Create the Stored Procedure

DELIMITER //CREATE PROCEDURE GetStudentCount(OUT total_students INT)BEGIN
SELECT COUNT(\*) INTO total_students FROM students;END //
DELIMITER ;

2. Call the Procedure and View Results
   You must use a session variable (e.g., @total) to hold the returned value. [11, 20, 21, 22, 23]

-- Call the procedureCALL GetStudentCount(@total);
-- Retrieve the output valueSELECT @total;

```SQL

DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;

DELIMITER $$

CREATE PROCEDURE get_unpaid_invoices_for_client (client_id INT,
OUT invoices_count INT,
OUT invoices_total DECIMAL(9, 2))

BEGIN

SELECT COUNT(*), SUM(invoice_total)
INTO invoices_count, invoices_total
FROM invoices i
WHERE i.client_id = client_id AND payment_total = 0;

END $$
DELIMITER ;

-- here to capture the values returned by the stored-procedure, we needed to define **user-define-variables**

SET @invoices_count = 0;
SET @invoices_total = 0;
CALL get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);

SELECT @invoices_count, @invoices_total;

```

## Variables

In MySQL stored procedures, there are two main ways to handle data: Local Variables (internal to the procedure) and Session Variables (used to pass data in and out).

1. Local Variables
   These are used for temporary storage inside the procedure body. They disappear as soon as the procedure finishes (END).

- Declaration: Must be defined at the very beginning of the BEGIN...END block using DECLARE.
- Scope: Only accessible within the procedure where they were created.
- Naming: Do not use @ prefixes.

DECLARE item_price DECIMAL(10,2) DEFAULT 0.0;SET item_price = 19.99;

2. User-Defined (Session) Variables
   These are the variables you see with the @ symbol. They are used to bridge the gap between your procedure and the outside world.

- Declaration: No formal declaration needed; they are created when you assign a value.
- Scope: They persist for your entire database session (until you disconnect).
- Usage with OUT: You pass these into a CALL statement to "catch" the output.

-- Setting a session variable outside a procedureSET @my_result = 0;
-- Passing it to catch an OUT parameterCALL GetTotal(@my_result);
-- It still exists hereSELECT @my_result;

Key Differences at a Glance

| Feature        | Local Variable              | Session Variable                |
| -------------- | --------------------------- | ------------------------------- |
| Prefix         | None (e.g., total)          | @ (e.g., @total)                |
| Created with   | DECLARE                     | SET or SELECT                   |
| Where it lives | Only inside the BEGIN...END | Throughout your connection      |
| Primary Use    | Internal logic/calculations | Passing data to/from the caller |

Would you like to see how to use SELECT ... INTO to map table columns directly to these variables?

```sql
DELIMITER $$

CREATE PROCEDURE get_unpaid_invoices_for_client (client_id INT,
OUT invoices_count INT,
OUT invoices_total DECIMAL(9, 2))

BEGIN

SELECT COUNT(*), SUM(invoice_total)
INTO invoices_count, invoices_total
FROM invoices i
WHERE i.client_id = client_id AND payment_total = 0;

END $$
DELIMITER ;

-- session variables

SET @invoices_count = 0;
SET @invoices_total = 0;
CALL get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);

SELECT @invoices_count, @invoices_total;

```

## Functions

In SQL, a function is a stored routine that accepts input parameters, performs a specific calculation or transformation, and always returns a single value. In MySQL, they are primarily used to encapsulate reusable logic that can be called directly within other SQL statements like SELECT, WHERE, or UPDATE.
Types of Functions in MySQL
Functions are broadly categorized into two groups based on how they process data:

- Scalar Functions (Single-Row): These operate on individual values and return exactly one result for every row they process.
- Examples: UPPER() (text to uppercase), ROUND() (rounding numbers), or CURDATE() (getting the current date).
- Aggregate Functions (Multiple-Row): these take a set of values from multiple rows and "summarize" them into a single resulting value.
- Examples: SUM() (total of a column), AVG() (average), COUNT() (total records), MAX(), and MIN().
- Stored Functions (User-Defined): These are custom functions you write yourself using MySQL's procedural language to handle specific business logic that built-in functions cannot.

---

Step-by-Step: Creating a Stored Function in MySQL [12, 13]
Creating a function requires defining its name, parameters, return type, and the logic itself.
Step 1: Change the Delimiter [15, 16]
By default, MySQL uses a semicolon (;) to end a command. Since a function contains multiple lines that also end in semicolons, you must temporarily change the delimiter to something else (like $$) so MySQL doesn't try to run the code before you're finished.

DELIMITER $$

Step 2: Define the Function Header
Use CREATE FUNCTION followed by the function name, input parameters in parentheses, and the mandatory RETURNS clause to specify the data type of the output.

CREATE FUNCTION calculate_tax(price DECIMAL(10,2)) RETURNS DECIMAL(10,2)

Step 3: Set Characteristics (DETERMINISTIC)
MySQL requires you to specify if a function is DETERMINISTIC (it always gives the same result for the same input) or NOT DETERMINISTIC. This is often required for security and replication reasons.

DETERMINISTIC

Step 4: Write the Body
The logic goes between BEGIN and END. You can declare local variables and must use a RETURN statement to send the final value back.

BEGIN
DECLARE tax_rate DECIMAL(4,2);
SET tax_rate = 0.08;
RETURN price \* tax_rate;END$$

Step 5: Reset the Delimiter [27, 28]
Switch back to the standard semicolon so you can run regular queries again.

DELIMITER ;

---

Complete Code Example
Here is the full script to create and then use a custom function:

-- 1. Create the function
DELIMITER $$
CREATE FUNCTION get_discounted_price(original_price DECIMAL(10,2), discount_pct INT)RETURNS DECIMAL(10,2)DETERMINISTICBEGIN
    RETURN original_price - (original_price * (discount_pct / 100));END$$

DELIMITER ;
-- 2. Use the function in a querySELECT product_name, price, get_discounted_price(price, 15) AS black_friday_priceFROM products;

Key Differences: Functions vs. Procedures

| Feature [1, 2, 4, 12, 18, 29, 30, 31, 32, 33] | Function                                | Stored Procedure                               |
| --------------------------------------------- | --------------------------------------- | ---------------------------------------------- |
| Return Value                                  | Must return exactly one value.          | Optional; can return multiple results or none. |
| Invocation                                    | Used inside SELECT, WHERE, etc.         | Called using the CALL statement.               |
| Data Changes                                  | Generally cannot perform INSERT/UPDATE. | Can perform any DML (INSERT, UPDATE, DELETE).  |
| Parameters                                    | Only IN parameters are supported.       | Supports IN, OUT, and INOUT parameters.        |
