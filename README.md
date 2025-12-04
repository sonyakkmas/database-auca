# Database Course (PostgreSQL)

This repository contains completed laboratory works for a university Database course. Each `LabN.txt` file is a real console transcript from `psql` (including prompts and output) showing exact commands and what Postgres returned.

* **Environment used:** PostgreSQL **14.18 → 14.19** on Ubuntu 22.04, `psql` CLI.


---

## Repository structure

```
Lab03.txt  — Basic psql commands: list DBs, switch connections, create/insert/select/drop a simple table
Lab04.txt  — First SQL Query: PK, NOT NULL/UNIQUE, inserts, filtering, ordering, limiting
Lab05.txt  — Databases: create/drop database workflow
Lab06.txt  — Tables, Data Types and Constraints: DROP/CREATE, ALTER TYPE, add UNIQUE, rename column/table, TEMP tables
Lab07.txt  — Primary keys: primary keys (inline/named), composite PKs, 
Lab08.txt  — Foreign Keys and Relationships: defining FKs, rebuilding tables, join queries
Lab09.txt  — Database Design Basics: normalization examples
Lab10.txt  — Viewing Database and Table Structure
Lab11.txt  — Basic Data Operations: Insert, Update, Delete Statements & Bulk Operations
Lab12.txt  — Querying Data: computed columns & aliases, LIKE/ILIKE/regex filters, CASE, EXISTS/IN, GROUP BY with CTE
Lab13.txt  — Aggregate Functions: COUNT(), SUM(), AVG(), MAX(), MIN(), STRING_AGG(), ARRAY_AGG(), GROUP BY, HAVING, and Window Functions.
Lab14.txt  — Joining Tables: NNER/LEFT/RIGHT/FULL joins, CROSS (cartesian), SELF join, multi-table joins, explicit vs implicit syntax
Lab15.txt  — Advanced Querying: ubqueries (scalar/correlated), CTE & recursive CTE, set ops UNION/INTERSECT/EXCEPT, window functions (ROW_NUMBER, SUM() OVER), conditional aggregation & FILTER, CASE bucketing
Lab16.txt  — Transactions and ACID properties: BEGIN/COMMIT/ROLLBACK, SAVEPOINT, isolation levels (READ COMMITTED/REPEATABLE READ/SERIALIZABLE),
Lab17.txt  — Data Import/Export and Backup: COPY/\copy (CSV/TSV, headers, NULLs, encodings), pg_dump formats (custom/dir/plain), pg_restore, schema-only/data-only dumps.
course_project/   - Implementation of the final project. 
```

---

## Final Project Declaration
#### Topic: Pharmacy Drug Management System
I take full responsibility for meeting all project deadlines and vow to stand by them.
The implementation of the final project will be carried out in this same repository, alongside previous lab assignments.

---

## Academic honesty & ownership

These are my own laboratory works for coursework. **Do not copy** for submissions where that would violate institution’s policy.

---

## License

No license. **All rights reserved.** If you want to reuse anything, please ask first.
