# Pharmacy Management Database – Tables Overview

This document explains **what each table means** and **why it is needed** in the pharmacy management system, based on the current schema.

---

## 1. Organization & Locations

### `branch_types`
**What it is:**  
Lookup table for types of branches (e.g. *Pharmacy*, *Warehouse*).

**Why it’s needed:**
- Normalizes branch type labels.
- Allows adding new types without changing the `branches` table.

---

### `branches`
**What it is:**  
Each physical location in the organization.

**Why it’s needed:**
- Many processes are branch-specific: stock, sales, prescriptions, stock counts.
- Enables reporting like “stock per branch”, “sales per branch”.

---

### `temperature_ranges`
**What it is:**  
Lookup table for storage temperature ranges (e.g. *2–8°C*).

**Why it’s needed:**
- Encodes temperature codes and descriptions in one place.
- Lets you declare that certain storage areas must meet specific temperature ranges.

---

### `storage_areas`
**What it is:**  
Sub-locations inside a branch (e.g. “Fridge 1”, “Narcotics Safe”).

**Why it’s needed:**
- Some drugs require special storage (fridge, safe).
- Lets you track **where exactly** within a branch each batch is stored.

---

## 2. Users, Roles & Permissions (Security / RBAC)

### `users`
**What it is:**  
All system users (pharmacists, cashiers, admins, etc.).

**Why it’s needed:**
- Authentication: who can log in.
- Ownership: who created orders, receipts, adjustments, etc.

---

### `roles`
**What it is:**  
Job roles (e.g. *Admin*, *Pharmacist*, *Cashier*).

**Why it’s needed:**
- Groups permissions logically.
- Easier to assign capabilities via roles rather than per-user.

---

### `permissions`
**What it is:**  
Fine-grained permission codes (e.g. “VIEW_INVENTORY”).

**Why it’s needed:**
- Allows detailed control over what actions are allowed.
- Used via `role_permissions`.

---

### `user_roles`
**What it is:**  
Bridge table between `users` and `roles`.

**Why it’s needed:**
- A user can have multiple roles.
- A role can be given to many users.

---

### `role_permissions`
**What it is:**  
Bridge table between `roles` and `permissions`.

**Why it’s needed:**
- Defines which permissions belong to which role.
- Changing a role’s abilities is done here, not in code.

---

## 3. Patients, Prescriptions & Dispensations

### `patients`
**What it is:**  
Information about patients whose prescriptions and sales are tracked.

**Why it’s needed:**
- For prescriptions, insurance and sales.
- Links patients to a “home branch” for primary care.

---

### `doctors`
**What it is:**  
Prescribing doctors.

**Why it’s needed:**
- Every prescription references a doctor.
- Used in clinical reports (e.g., prescriptions per doctor).

### `prescriptions_statuses`
**What it is:**  
Lookup table for prescription statuses (e.g. *NEW*, *COMPLETED*).

**Why it’s needed:**
- Normalizes status labels.
- Supports workflow reporting.

---

### `prescriptions`
**What it is:**  
Doctor’s orders for medications for a patient.

**Why it’s needed:**
- Core clinical document in the system.
- Everything dispensed for the patient stems from prescriptions.

---

### `prescription_items`
**What it is:**  
Line items within a prescription.

**Why it’s needed:**
- Stores specific medication instructions per drug.
- Basis for calculating how much must be dispensed.

---

### `dispensations`
**What it is:**  
Records of actual dispensing events linked to a prescription.

**Why it’s needed:**
- Separates clinical dispensing from financial sales.
- Enables partial dispensing and clinical history tracking.

---

### `dispensation_items`
**What it is:**  
Line items for each dispensation.

**Why it’s needed:**
- Tells exactly which batch and how much was given.
- Supports batch-level traceability and expiry control.

---

## 4. Drug Master Data

### `drug_categories`
**What it is:**  
High-level classification of drugs (e.g. Antibiotic, Analgesic).

**Why it’s needed:**
- Organizes the drug catalog.
- Useful for filters and category-based reports.

---

### `drug_forms`
**What it is:**  
Drug forms (tablet, capsule, syrup, injection, etc.).

**Why it’s needed:**
- Each drug points to a single form.
- Important for dosage and packaging.

---

### `manufacturers`
**What it is:**  
Pharmaceutical manufacturers.

**Why it’s needed:**
- For traceability and quality issues.
- A manufacturer can produce many drugs.

---

### `drug_manufacturers`
**What it is:**  
Bridge table between `drugs` and `manufacturers`.

**Why it’s needed:**
- One drug can be produced by multiple manufacturers.
- Stores optional `product_code` per manufacturer–drug combination.

---

### `drugs`
**What it is:**  
Central catalog of all products managed by the pharmacy.

**Why it’s needed:**
- Almost every other table references `drugs`.
- Holds key clinical and logistical attributes of each product.

---

## 5. Inventory & Stock Control

### `transaction_types`
**What it is:**  
Lookup table listing different kinds of stock transactions (e.g. *PURCHASE*, *SALE*, *ADJUSTMENT*).

**Why it’s needed:**
- Normalizes transaction types instead of hard-coding text.
- Makes reports easier (group by transaction type).

---

### `inventory_batches`
**What it is:**  
Each row is a **specific batch** of a drug in a specific storage area.

**Why it’s needed:**
- Batches have expiry dates and batch numbers.
- Needed for recalls and expiry management.
- Branch is implied through the storage area.

---

### `stock_transactions`
**What it is:**  
History of every change in stock for a batch.

**Why it’s needed:**
- Lets you calculate current stock by summing movements.
- Provides an audit trail of who changed stock and why.

---

### `stock_counts`
**What it is:**  
A stocktaking session at a branch (e.g. monthly stock count).

**Why it’s needed:**
- Groups physical counts into a single event.
- Used to compare system vs actual stock.

---

### `stock_count_items`
**What it is:**  
Per-batch results for a given stock count session.

**Why it’s needed:**
- Shows discrepancies between expected and counted stock.
- Forms the basis for stock adjustments.

---

### `stock_adjustment_reasons`
**What it is:**  
Lookup table listing reasons for stock adjustments (e.g. *Damage*, *Theft*).

**Why it’s needed:**
- Standardizes reasons for non-transactional stock changes.
- Makes reporting by reason possible.

---

### `stock_adjustments`
**What it is:**  
Official corrections to the quantity of a batch.

**Why it’s needed:**
- Records manual corrections with reason and approver.
- Usually linked to corresponding `stock_transactions` entries.

---

## 6. Suppliers & Purchasing

### `suppliers`
**What it is:**  
Companies that supply drugs and other items.

**Why it’s needed:**
- Source of purchase orders and receipts.
- Supports supplier-wise reporting.

---

### `purchase_order_statuses`
**What it is:**  
Lookup table for purchase order statuses (e.g. *PENDING*, *RECEIVED*).

**Why it’s needed:**
- Normalizes status names.
- Makes it easier to add or change statuses.

---

### `purchase_orders`
**What it is:**  
Orders placed by branches to suppliers.

**Why it’s needed:**
- Tracks what each branch requested and from whom.
- Base for comparing ordered vs received quantities.

---

### `purchase_order_items`
**What it is:**  
Line items in a purchase order.

**Why it’s needed:**
- Stores which drugs and how many were ordered.
- Used to validate supplier deliveries.

---

### `receipts`
**What it is:**  
Physical receipts of goods against purchase orders.

**Why it’s needed:**
- When the goods actually arrive, this records the reception.
- Links supplier invoice numbers to internal POs.

---

### `receipt_items`
**What it is:**  
Line items in a receipt.

**Why it’s needed:**
- Shows what was actually received.
- Typically used to create `inventory_batches` and related stock transactions.

---

## 7. Insurance & Claims

### `insurance_companies`
**What it is:**  
Insurance providers.

**Why it’s needed:**
- Top-level entity for organizing insurance plans and claims.

---

### `insurance_plans`
**What it is:**  
Specific plans from an insurance company.

**Why it’s needed:**
- Different plans can have different coverage percentages.
- Patients enrol into specific plans.

---

### `patient_insurance`
**What it is:**  
Links patients to insurance plans.

**Why it’s needed:**
- Records coverage details per patient.
- Used when creating insurance claims.

---

### `insurance_claim_statuses`
**What it is:**  
Lookup table with allowed statuses for insurance claims (e.g. *SUBMITTED*, *PAID*).

**Why it’s needed:**
- Normalizes claim statuses for reporting and workflow logic.

---

### `insurance_claims`
**What it is:**  
Claims sent to insurance companies for specific sales.

**Why it’s needed:**
- Tracks the state of each claim (submitted, approved, denied, etc.).
- Connects financial data (sales) to insurance reimbursements.

---

## 8. Sales, Payments & Prices

### `sale_types`
**What it is:**  
Lookup table for types of sales (e.g. *CASH*, *INSURANCE*).

**Why it’s needed:**
- Tells what kind of sale it is overall.
- Used for high-level revenue analysis.

---

### `payment_methods`
**What it is:**  
Lookup table for ways customers can pay (e.g. *CASH*, *CARD*).

**Why it’s needed:**
- Normalizes payment method labels.
- Multiple payments with different methods can exist per sale.

---

### `price_list_items`
**What it is:**  
Effective prices per drug with time range.

**Why it’s needed:**
- Stores time-bounded pricing for each drug.
- `sale_items` reference the specific price row used.

---

### `sales`
**What it is:**  
Each sale transaction with header information.

**Why it’s needed:**
- Core financial record capturing “who bought what, where, and when”.

---

### `sale_items`
**What it is:**  
Line items inside a sale.

**Why it’s needed:**
- Connects sales to specific batches and price records.
- Drives stock decrements via `stock_transactions`.

---

### `payments`
**What it is:**  
Individual payments made towards a sale.

**Why it’s needed:**
- Supports partial and multi-method payments.
- Keeps payment details separate from the sale header.

---

## Summary

- **Master data tables**: `branches`, `branch_types`, `temperature_ranges`, `storage_areas`, `drugs`, `drug_categories`, `drug_forms`, `manufacturers`, `patients`, `doctors`, etc.
- **Lookup / status tables**: `transaction_types`, `purchase_order_statuses`, `sale_types`, `payment_methods`, `insurance_claim_statuses`, `prescriptions_statuses`, `stock_adjustment_reasons`.
- **Bridge tables**: `user_roles`, `role_permissions`, `drug_manufacturers`, `patient_insurance`.
- **Transaction tables**: `stock_transactions`, `purchase_orders`, `receipts`, `sales`, `prescriptions`, `dispensations`, `insurance_claims`.
- **Control & audit tables**: `stock_counts`, `stock_count_items`, `stock_adjustments`.

