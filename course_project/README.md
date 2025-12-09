# Pharmacy Management System Database Project

This repository contains the final project for my database course, implementing a comprehensive pharmacy management system using PostgreSQL. The system handles patient prescriptions, inventory tracking, sales, purchasing, insurance claims, and more, while demonstrating key database concepts like normalization, transactions, indexing, and backup strategies.

## Project Overview

The database models a multi-branch pharmacy chain, supporting operations such as:
- Managing users with role-based access control (RBAC).
- Tracking patients, doctors, prescriptions, and dispensations.
- Handling drug inventory with batch-level traceability, expiry management, and stock transactions.
- Processing sales, payments, and insurance claims.
- Managing purchases from suppliers, including orders and receipts.
- Performing stock counts and adjustments.

The design emphasizes data integrity through foreign keys, constraints, and normalized tables. It includes sample data, queries, and transaction examples to illustrate real-world usage.

## Requirements Covered

This project meets the following requirements:

### 1. Database Schema and ER-Diagram
- **Schema**: Defined in `schema.sql`, which includes table creations, constraints, foreign keys, and indexes for performance.
- **ER-Diagram**: Visualized in `ERD.pdf` and `ERD.svg`. The ERD shows entities, relationships, and cardinalities.
- Tables are normalized to at least 3NF, with bridge tables for many-to-many relationships (e.g., `user_roles`, `role_permissions`).

### 2. Implementation in PostgreSQL
- All SQL scripts are PostgreSQL-compatible.
- **Schema Creation**: Run `schema.sql` to create tables, lookups, and indexes.
- **Sample Data**: `sample_implementation_data.sql` inserts initial data for lookup tables, branches, users, drugs, patients, prescriptions, inventory, sales, and more.

### 3. SQL Queries (Basic and Advanced)
- **Queries File**: `queries.sql` contains:
  - **Basic Queries**: Simple SELECTs like listing branch types, drug categories, controlled drugs, doctors by specialty, patient counts per branch, prescriptions by year, active users, prescriptions with names, inventory batches, and payments.
  - **Advanced Queries**: Complex queries using JOINs, GROUP BY, aggregates, subqueries, and WITH clauses, such as daily sales summaries, stock on hand per drug/branch, expiring drugs with stock, patient medication history, and top-selling drugs.

### 4. Transactions and Indexing Demonstration
- **Transactions**: Explicit BEGIN/COMMIT blocks in `transactions.sql` show atomic operations, e.g.:
  - Registering a new patient.
  - Dispensing a prescription with multiple items.
  - Processing an OTC sale with payment and stock decrement.
  - Creating a prescription sale billed to insurance with claim creation.
  - Issuing a new purchase order.
  - Performing a stock adjustment for damage.
- **Indexing**: `schema.sql` includes targeted indexes for common query patterns, such as:
  - Composite indexes on frequently filtered/sorted columns (e.g., `idx_prescriptions_patient_date` on `patient_id` and `prescription_date DESC`).
  - Indexes on foreign keys for faster JOINs (e.g., `idx_sales_branch_date`).


### 5. Backup and Recovery Strategy

* Detailed in `backup_strategy.md`:
  * **Backup**: Daily logical `pg_dump` + daily physical `pg_basebackup` with WAL archiving; keep 3 days local, 30 days on backup server.
  * **Recovery**: Logical restore for bad migrations/deletes; PITR from base backup + WAL for full server failure.



## Setup and Usage

1. **Prerequisites**: PostgreSQL 12+ installed. Access via `psql` or a GUI like pgAdmin.
2. **Create Database**:
   ```
   createdb pharmacy_db
   psql -d pharmacy_db -f schema.sql
   ```
3. **Load Sample Data**:
   ```
   psql -d pharmacy_db -f sample_implementation_data.sql
   ```
4. **Run Queries and Transactions**:
   - Execute `queries.sql` for reports.
   - Run sections of `transactions.sql` to simulate operations.
5. **Testing**:
   - Use `EXPLAIN`/`EXPLAIN ANALYZE` on queries to see index usage.