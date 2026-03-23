# Data Types in SQL


- String types
- Numeric types
- Date and Time types
- Blob types
- Spatial types

## String Types

1. `CHAR(X)` fix-length strings, like sates



2. `VARCHAR(X)` variable length strings, like username, email, name, numbers that are not used for mathematical operations, numbers containing separators.

**max** 65,535 characters (˜64KB) more than that, it will get truncated


**Note**: be consistent!
when setting lengths for your string values, it's great habit to be consistent and with the values you use.

- `VARCHAR(50)`for short strings, names, passwords
- `VARCHAR(255)` for medium-length strings, addresses

3. `MEDIUMTEXT`: for medium length strings, like: JSON objects, CSV file and short to medium length books.

**max**: 16MB

4. `LONGTEXT` stores huge textual data like, super big books, years of log data

**max**: 4GB


5. `TINYTEXT`: can store strings up to 255 characters long

**max**: 255 bytes

6. `TEXT`: can store strings up to 65000 characters long

**max**: 64KB

### BYTES

`English` -> 1 byte

`European` and `Middle-eastern` -> 2 bytes

`Asian` -> 3 bytes


## Integer Types

`TINYINT` 1b [-128, 127] can store both positive and negative values in the specified range

`UNSIGNED TINYINT` [0, 255], use `UNSIGNED` keyword to make `TINYINT` store only positive values

`SMALLINT` 2b [-32k, 32k]

`MEDIUMINT`3b [-8M, 8M]

`INT` 4b [-2B, 2B]

`BIGINT` 8b [-9Z, 9Z]

### ZEROFILL

The **ZEROFILL** attribute in MySQL is used to pad the displayed value of a numeric column with leading zeros up to the display width specified in the column definition. 

**Note**: always prefer to choose the smallest possible data type, that results in smaller database size and faster execution of queries.


## Fixed-point and Floating-point types



### Rationals

we have **three** ways for storing **decimal numbers**

- `DECIMAL(p, s)`. used to store numbers with fixed point numbers "numbers with fixed number of digits after the decimal point".
 p -> precession "maximum number of digits, 1 - 65",
 s -> scale "number of digits after the decimal point", 
 
 `DECIMAL(9, 2) => 1234567.89`
 
 SYNONYMS: `DEC`, `NUMERIC`, `FIXED`
 
- `FLOAT` and `DOUBLE` used for scientific calculations with really large or really small number, they don't store the exact value, instead they use approximation
`FLOAT` 4b and `DOUBLE` 8b


## Boolean Types

When you need a boolean value like, **yes** or **no**

`TRUE` "internally represented as 1" or `1`, but `TRUE` is more descriptive

`FALSE` "internally represented as 0" or `0` but `FALSE` is more descriptive

**Note**: `TRUE` and `FALSE` are synonyms for `1` and `0`


## Enums and Set Types

### Enums

when we need to restrict values for a column to a limited list of values, use `ENUM`

like limiting the values for a column to these `small, medium, large` => `ENUM('small', 'medium', 'large')`

**Note**: while `ENUM`s look appealing, but you should avoid using them, as they can cause a lot of headache later when you need to add new members, or update them.

### Sets

Set is just like Enum that allows to store a specific values for a column

`SET('value1', 'value2', 'value3')`


## Date and Time Types

In MySQL we have **four** ways to store date/time values

- `DATE` for storing date value without **time** component.
- `TIME` for storing a **time** value
- `DATETIME` for storing date and time at one go, 8b
- `TIMESTAMP` the TIMESTAMP is a temporal data type used to store a combination of date and time, often for tracking record changes. It automatically converts values between the server's local time zone and Coordinated Universal Time (UTC) for storage, which makes it ideal for applications that operate across different time zones.  4b (up to 2038)
- `YEAR` to store just the **year**

## Blob Types

Blob types are used to store large binary data, like images, videos, pdf, word file and etc...

in MySQK we gave these binary types

- `TINYBLOB` good for storing 255b data
- `BLOB` good for 65KB of data
- `MEDIUMBLOB` good for 16MB of data
- `LONGBLOB` good for 4GB of data

**Note**: Never store your file in your database, it increases the database size by massive amount and drops performance too much


## JSON types


# 🧠 1. What is JSON Data Type in MySQL?

In **MySQL**, the `JSON` data type allows you to store **structured data (like objects and arrays)** directly inside a column.

👉 Think of it like storing JavaScript objects in your database.

### Example JSON:

```json
{
  "name": "Mostafa",
  "skills": ["JavaScript", "React", "Node.js"],
  "experience": 3,
  "isActive": true
}
```

---

## 🔍 Why not just use TEXT?

Before JSON type existed, people stored JSON as plain text:

```sql
TEXT
```

❌ Problems:

* No validation
* No indexing
* Hard to query

✅ JSON type solves this:

* Validates JSON format automatically
* Optimized storage
* Built-in JSON functions
* Can query inside the JSON!

---

# ⚡ 2. When Should You Use JSON? (Use-Cases)

Let’s be real — you **should NOT use JSON everywhere**.

Use it when it makes sense 👇

---

## ✅ Good Use Cases

### 1. Flexible / Dynamic Data

When structure changes often.

```json
{
  "theme": "dark",
  "notifications": true
}
```

Different users → different settings

---

### 2. Semi-Structured Data (API Responses)

Example:

```json
{
  "payment_id": "abc123",
  "gateway_response": { ... }
}
```

You don’t need strict columns.

---

### 3. Metadata Storage

```json
{
  "ip": "192.168.1.1",
  "device": "mobile",
  "browser": "chrome"
}
```

---

### 4. Logging / Analytics

Store events:

```json
{
  "event": "login",
  "time": "2026-03-23",
  "location": "Kabul"
}
```

---

## ❌ Bad Use Cases

🚫 Don’t use JSON when:

* You need **frequent filtering/sorting on fields**
* Data has a **fixed structure**
* You need **relationships (joins)**

👉 In those cases → use normal columns!

---

# 🏗️ 3. How to Create JSON Column

### Create a table with JSON:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    profile JSON
);
```

---

# ✍️ 4. Insert JSON Data

```sql
INSERT INTO users (name, profile)
VALUES (
    'Mostafa',
    JSON_OBJECT(
        'age', 25,
        'skills', JSON_ARRAY('JS', 'React', 'Node'),
        'isActive', true
    )
);
```

👉 MySQL provides helpers:

* `JSON_OBJECT()`
* `JSON_ARRAY()`

---

# 🔎 5. Query JSON Data (THIS IS THE POWER PART 🔥)

---

## Access fields

```sql
SELECT profile->'$.age' FROM users;
```

👉 Output:

```
25
```

---

## Extract as text

```sql
SELECT profile->>'$.age' FROM users;
```

👉 Difference:

* `->` → JSON
* `->>` → plain value

---

## Filter data

```sql
SELECT *
FROM users
WHERE profile->>'$.isActive' = 'true';
```

---

## Nested access

```sql
SELECT profile->'$.skills[0]' FROM users;
```

---

# 🛠️ 6. Update JSON Data

---

## Update a field

```sql
UPDATE users
SET profile = JSON_SET(profile, '$.age', 30)
WHERE id = 1;
```

---

## Add new field

```sql
UPDATE users
SET profile = JSON_SET(profile, '$.country', 'Afghanistan')
WHERE id = 1;
```

---

## Remove field

```sql
UPDATE users
SET profile = JSON_REMOVE(profile, '$.age')
WHERE id = 1;
```

---

# 🚀 7. Indexing JSON (Advanced but IMPORTANT)

You **can’t directly index JSON**, but you can create a virtual column:

```sql
ALTER TABLE users
ADD COLUMN age INT GENERATED ALWAYS AS (profile->>'$.age'),
ADD INDEX (age);
```

👉 Now queries on `age` become FAST ⚡

---

# 🧩 Real-World Example (Your Level 💪)

Imagine your **portfolio / SaaS app**

Instead of:

```sql
users:
- theme
- notifications
- language
```

You do:

```sql
settings JSON
```

And store:

```json
{
  "theme": "dark",
  "notifications": true,
  "language": "en"
}
```

👉 Flexible + scalable

---

# 🧠 Mental Model (IMPORTANT)

Think of JSON in MySQL as:

> 🧱 “A mini database inside a column”

But:

* Use it for **flexibility**
* Not as a replacement for proper schema

---

# ⚔️ Pro Tip (Senior-Level Thinking)

The best systems use **hybrid design**:

* Structured columns → important data
* JSON → flexible/additional data

Example:

```sql
users:
- id
- email
- password
- profile JSON
```

---

# 🧪 Practice Challenge (for you)

Try this:

1. Create `products` table
2. Add `attributes JSON`
3. Store:

```json
{
  "color": "red",
  "size": "L",
  "tags": ["new", "sale"]
}
```

4. Query products where color = red

