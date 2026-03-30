# Build an Online Courses Platform Database

We're gonna design and build a database for an online courses platform.

1. do research, talk to people, look at other solutions, basically understand the problem you're trying to solve.


2. build a conceptual model. 
   
right away we can pick `student` and `course` entities


3. build the logical model:

here we have the diagram like ER diagram, that shows tables, columns, data types and relationships.

4. we build the database, considering a specific DBMS

## Normalization

normalization is the process of checking our database and making sure we do not have repeated data or storing repeated data.

normalization has 7 forms, but the first 3 are the most important the the most used ones.

### 1NF 

Each cell should have a **single value** and we cannot have repeated columns.

### 2NF

Every **table** should describe **one entity**, and every column in that table should describe that entity


### 3NF 

A column in a table should not be derived from other columns.

## Mosh's Pragmatic Advice

when you see duplicated values and they are not foreign-keys it means your table is not normalized,
which normal form it's violating IT DOESN'T MATTER, think about your logical entities and the relationships between them, then turn your logical model into physical model, which you'd end up with separate tables.

always keep the requirements in mind and don't assume things that might never happen in the real world, DON'T MODEL THE UNIVERSE!

**NOTE** one solution that works perfectly fine in one project might completely violate the rules and requirements in another project.


## some of the most important sql queries to know

### Create Database

`CREATE DATABASE database_name;` creates new database, which will be an empty database.

`CREATE DATABASE IF NOT EXISTS database_name;` the safe version! if you execute this one multiple times you wouldn't get any error.

`DROP DATABASE database_name;` drops or deletes the database.

`DROP DATABASE IF EXITS database_name;` the safe version if the database doesn't exists and you try to drop it, you wouldn't get error.

### Create Table

`CREATE TABLE table_name (column_name data_type constraints, column_name data_type constraints )`
`CREATE TABLE IF EXISTS table_name (column_name data_type constraints, column_name data_type constraints )` safe version, if the table already exists you wouldn't get any error.


`DROP TABLE table_name;` to delete a table,
`DROP TABLE IF EXISTS table_name;` delete a table and not get an error if the table doesn't exist.



### Altering Tables


`ALTER TABLE table_name ADD column_name data_type constraints;` this query adds this newly created column at the end of the target table.

`ALTER TABLE table_name ADD column_name data_type constraints AFTER existing_column;` if you want to add a column after a specific column in the table

```sql
ALTER TABLE table_name

ADD new_column data_type constraints,
ADD new_column data_type constraints,
ADD new_column data_type constraints,
ADD new_column data_type constraints,
MODIFY COLUMN column_name data_type constraints,
DROP column_name
```

### Creating Relationships

Alright buddy, now we’re getting into the **real backbone of relational databases** 🔥
Relationships in MySQL are **not magic** — they’re created using **foreign keys + constraints**.

Let’s break it down step by step, deeply and visually (your style 😄).

---

# 🧠 1. The Core Idea

A relationship between tables is created using:

### 👉 **PRIMARY KEY (PK)**

* Uniquely identifies each row in a table

### 👉 **FOREIGN KEY (FK)**

* A column in one table that **points to the PK of another table**

---

# 🏗️ 2. Basic Syntax for Creating Relationships

## ✅ Creating a table with a foreign key

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 💡 What’s happening:

* `user_id` is a **foreign key**
* It references `users(id)`
* This means:

  > “Every order MUST belong to a valid user”

---

# 🔗 3. Types of Relationships (with SQL)

---

## 🔹 1. One-to-Many (1:N)

> One user → many orders

### 🧱 Tables:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 🧠 Rule:

* FK goes on the **"many" side**

✔ `users` → parent
✔ `orders` → child

---

## 🔹 2. One-to-One (1:1)

> One user → one profile

### 🧱 Option 1 (most common):

```sql
CREATE TABLE users (
    id INT PRIMARY KEY
);

CREATE TABLE profiles (
    id INT PRIMARY KEY,
    user_id INT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 💡 Key idea:

* `UNIQUE` makes sure:

  > One user → only one profile

---

## 🔹 3. Many-to-Many (N:M)

> Students ↔ Courses

### ❗ You CANNOT do this directly

You need a **junction table**

### 🧱 Example:

```sql
CREATE TABLE students (
    id INT PRIMARY KEY
);

CREATE TABLE courses (
    id INT PRIMARY KEY
);

CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

### 🧠 Key Concepts:

* Composite PK: `(student_id, course_id)`
* Prevents duplicate relationships
* This table = **relationship itself**

---

# ⚙️ 4. Adding Constraints (VERY IMPORTANT 🔥)

Foreign keys can control behavior when data changes.

---

## 🔹 ON DELETE

### ❌ RESTRICT (default)

```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
```

→ Prevent deleting a user if orders exist

---

### 🧹 CASCADE

```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
```

→ Delete user → delete all their orders

---

### 🧊 SET NULL

```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
```

→ Delete user → `user_id = NULL`

---

## 🔹 ON UPDATE

Same idea but for updates:

```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE
```

→ If user ID changes → update it everywhere

---

# 🛠️ 5. Adding Relationships AFTER Table Creation

You don’t always define relationships upfront.

---

## ✅ Using ALTER TABLE

```sql
ALTER TABLE orders
ADD CONSTRAINT fk_user
FOREIGN KEY (user_id) REFERENCES users(id);
```

---

## ❌ Removing a Foreign Key

```sql
ALTER TABLE orders
DROP FOREIGN KEY fk_user;
```

---

# ⚠️ 6. Rules You MUST Follow

---

### ✅ 1. Data types must match

```sql
users.id INT
orders.user_id INT ✅
```

---

### ✅ 2. Referenced column must be:

* PRIMARY KEY OR
* UNIQUE

---

### ✅ 3. Engine must support it

```sql
ENGINE=InnoDB
```

(MyISAM ❌ doesn’t support FK)

---

# 🧠 7. Mental Model (VERY IMPORTANT)

Think like this:

> A **foreign key is a rule**, not just a column

It enforces:

* ✅ Data integrity
* ❌ No “ghost” references
* 🔗 Real connections between tables

---

# 🎯 8. Real-World Example (Putting It All Together)

```sql
CREATE TABLE users (
    id INT PRIMARY KEY
);

CREATE TABLE posts (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);
```

### 🔥 Meaning:

* A post **belongs to a user**
* Delete user → all posts gone

---

# 🚀 9. Pro-Level Tip

When designing:

* Ask:

  * “Who owns who?”
  * “Can this exist alone?”
* Then:

  * Put FK on dependent entity

