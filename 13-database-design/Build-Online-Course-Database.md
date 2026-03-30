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