# SQL with Mosh

## 1. **What is a Database?**

Think of a **database** as a super-organized digital filing cabinet.

- Instead of storing paper files in folders, we store **data** (like customer names, emails, products, transactions, etc.) in digital form.
- A database isn’t just storage — it’s also about **managing** that data: making sure it’s easy to **find, update, secure, and back up**.

👉 Quick check: Can you think of a real-life example of a “database” you use daily, even if it’s not called that?

---

## 2. **What is SQL?**

SQL stands for **Structured Query Language**.

- It’s like the language we use to “talk” to a database.
- With SQL, we can:

  - **Create** tables (like setting up new folders in the cabinet).
  - **Insert** data (putting new files inside).
  - **Query** data (searching for a specific file).
  - **Update** data (editing a file).
  - **Delete** data (removing a file).

Example SQL command:

```sql
SELECT name, email FROM users WHERE age > 18;
```

This means: _“Show me the names and emails of all users older than 18.”_

---

## 3. **SQL vs NoSQL**

Now, not all databases work the same way. The two big families are:

### **SQL Databases (Relational Databases)**

- Data stored in **tables** (rows & columns).
- Every table has a clear **structure** (schema).
- Great for data that fits into a structured, predictable format.
- Examples: **MySQL, PostgreSQL, SQL Server, Oracle**.

### **NoSQL Databases**

- Data is more **flexible** — no strict tables.
- Can store data as documents, key-value pairs, graphs, or wide columns.
- Great for unstructured or rapidly changing data.
- Examples: **MongoDB, Redis, Cassandra, Neo4j**.

---

🔑 **Quick Comparison**:

| Feature   | SQL (Relational)           | NoSQL (Non-Relational)             |
| --------- | -------------------------- | ---------------------------------- |
| Structure | Tables with rows & columns | Documents, key-value, graphs, etc. |
| Schema    | Fixed, must be defined     | Flexible, can change anytime       |
| Best For  | Banking, ecommerce, CRM    | Social media, real-time apps, IoT  |
| Examples  | MySQL, PostgreSQL          | MongoDB, Firebase, Redis           |
