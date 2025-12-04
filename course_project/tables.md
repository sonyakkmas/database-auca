# Pharmacy Management Database – Tables Overview

This document explains **what each table means** and **why it is needed** in the pharmacy management system.  

---

## 1. Organization & Locations

### `branches`
**What it is:**  
Represents each physical location in the organization: individual pharmacies, warehouses, etc.

**Why it’s needed:**
- Many parts of the system are branch-specific: stock, sales, prescriptions.
- Allows reports like “sales per branch”, “stock per branch”, “expiring drugs in branch A”.

---

### `storage_areas`
**What it is:**  
Sub-locations inside a branch (e.g. “Fridge 1”, “Narcotics Safe”, “Main Shelf A”).

**Why it’s needed:**
- Some drugs have special storage (refrigerated, controlled).
- Lets you track **where exactly** inside a branch a batch is stored.
- Useful for audits and safety: “all narcotics are in the safe”, “all insulin is in fridge areas”.

---

## 2. Users, Roles & Permissions (Security / RBAC)

### `users`
**What it is:**  
All system users (pharmacists, cashiers, admins, managers).

**Why it’s needed:**
- Authentication: who can log in.
- Ownership: who created orders, sales, adjustments, etc.
- Permissions: combined with roles to control access.

---

### `roles`
**What it is:**  
Logical roles like “Admin”, “Pharmacist”, “Junior Pharmacist”, “Cashier”.

**Why it’s needed:**
- Defines **job roles** in the system.
- Used to group permissions and assign them to users.

---

### `permissions`
**What it is:**  
Low-level permission codes such as `VIEW_INVENTORY`, `EDIT_PRICES`, `DISPENSE_CONTROLLED`.

**Why it’s needed:**
- Fine-grained security: not every pharmacist can do everything.
- Lets you say “this role can do these actions” instead of hard-coding behavior.

---

### `user_roles`
**What it is:**  
Bridge table between `users` and `roles` (many-to-many).

**Why it’s needed:**
- A user can have multiple roles (e.g. Pharmacist + Branch Manager).
- A role can be assigned to many users.
- Keeps the model flexible without putting a single `role` column in `users`.

---

### `role_permissions`
**What it is:**  
Bridge table between `roles` and `permissions` (many-to-many).

**Why it’s needed:**
- Lets each role have a set of permissions.
- Changing what a role can do is just editing these rows, not code.

---

## 3. Patients, Doctors & Clinical Data

### `patients`
**What it is:**  
Information about customers/patients whose prescriptions and sales are tracked.

**Why it’s needed:**
- For prescriptions, insurance, and clinical history.
- Lets you see medication history per patient.
- Connects to allergies, insurance, sales, and dispensations.

---

### `doctors`
**What it is:**  
Prescribing doctors (name, license, specialty).

**Why it’s needed:**
- Every prescription should know *who* prescribed it.
- Supports reports: “top prescribing doctors”, “doctor X’s patients”, etc.

---

## 4. Drug Master Data

### `drug_categories`
**What it is:**  
High-level classification of drugs (e.g. “Antibiotic”, “Analgesic”).

**Why it’s needed:**
- Helps organize drug catalog.
- Useful for reporting and filtering (“show all antibiotics”, category-wise stock).

---

### `drug_forms`
**What it is:**  
Forms in which drugs are available (tablet, capsule, syrup, injection, cream).

**Why it’s needed:**
- Each drug row references one form.
- Useful for dosage, stock, and display (“Paracetamol 500 mg tablet”).

---

### `manufacturers`
**What it is:**  
Companies that produce drugs (pharmaceutical manufacturers).

**Why it’s needed:**
- Some drugs can come from multiple manufacturers.
- Needed for traceability, quality recalls, and supplier relationships.

---

### `drug_manufacturers`
**What it is:**  
Bridge table linking `drugs` and `manufacturers` (many-to-many).

**Why it’s needed:**
- One drug may be produced by multiple manufacturers.
- One manufacturer produces many drugs.
- Supports per-manufacturer product codes if needed.

---

### `drugs`
**What it is:**  
Central catalog of all products the pharmacy manages (medicines, sometimes non-drug items).

**Why it’s needed:**
- Everything else references this: inventory, prescriptions, sales, pricing.
- Stores key attributes: name, generic name, category, form, strength, unit, flags like `is_controlled` or `is_refrigerated`.

---

## 5. Inventory: Batches & Movement

### `inventory_batches` (sometimes referenced as `batches`)
**What it is:**  
Each row represents a **specific batch** of a drug in a particular branch/storage area.

**Why it’s needed:**
- Batches have expiry dates and batch numbers.
- Pharmacies must know which batch was given to which patient (for recalls).
- Allows per-branch, per-batch stock management.

---

### `stock_transactions`
**What it is:**  
History of all stock movements (like a “bank statement” for inventory).

Each row = one stock change:
- purchase received
- sale/dispense
- transfer in/out
- write-off / disposal
- manual adjustment, etc.

**Why it’s needed:**
- To calculate current stock from all past movements.
- For audit trail: see who did what, when, and why.
- Supports reporting like “total usage of drug X last month”.

---

### `stock_adjustments`
**What it is:**  
Records the **official corrections** when the system quantity is wrong and must be updated.

**Why it’s needed:**
- When a stock count reveals differences (lost, damaged, counting error).
- Keeps a record of: old quantity, new quantity, reason, and approval user.
- Often tied to a corresponding `stock_transactions` row for the numerical change.

---

### `stock_counts`
**What it is:**  
A stocktaking session. Example: “2025-12 end-of-month count for Branch 1”.

**Why it’s needed:**
- Groups all counted items (`stock_count_items`) into one event.
- Stores who performed the count and when.
- Necessary for audit and process control.

---

### `stock_count_items`
**What it is:**  
Details of what was counted in a stock count (per drug / batch).

**Why it’s needed:**
- Compares **system quantity** vs **physically counted quantity**.
- Basis for deciding if `stock_adjustments` are needed.
- Allows analysis: which drugs frequently have discrepancies.

---

## 6. Suppliers & Purchasing

### `suppliers`
**What it is:**  
Companies from which the pharmacy purchases drugs and other products.

**Why it’s needed:**
- For purchase orders and receipts.
- For supplier-wise analysis and tracking credit, performance, reliability.

---

### `purchase_orders`
**What it is:**  
Orders placed to suppliers (what the branch requested).

**Why it’s needed:**
- Track what was ordered, from whom, and by which branch.
- Manage order status: pending, partially received, completed, cancelled.
- Base for comparing ordered vs received quantities and costs.

---

### `purchase_order_items`
**What it is:**  
Line items inside a purchase order (which drugs and how much were ordered).

**Why it’s needed:**
- Links specific drugs to a given order.
- Later compared with receipt items to detect partial deliveries or backorders.

---

### `receipts` (or `goods_receipts`)
**What it is:**  
Actual physical receipt of goods from a supplier against a purchase order.

**Why it’s needed:**
- Records when the goods arrived and which PO they belong to.
- Basis for creating inventory batches and stock transactions.
- Lets you capture supplier invoice numbers separately from the PO.

---

### `receipt_items`
**What it is:**  
Line items of a receipt (which drugs, what quantity, what batch, what cost).

**Why it’s needed:**
- Detail of what was physically received vs what was ordered.
- Each receipt item usually corresponds to:
  - a new row in `inventory_batches`, and  
  - an incoming `stock_transaction`.

---

## 7. Prescriptions & Dispensations (Clinical Flow)

### `prescriptions`
**What it is:**  
Doctor’s orders for a patient: what medicines they should receive.

**Why it’s needed:**
- Connects doctor, patient, branch, and date.
- Basis for clinical checking (interactions, dosage, allergies).
- Status tracking: new, partially dispensed, completed, cancelled.

---

### `prescription_items`
**What it is:**  
Line items within a prescription (which drug, how much, dosage instructions).

**Why it’s needed:**
- Detailed instructions per drug: frequency, duration, quantity prescribed.
- For calculating how many units should be dispensed.
- Supports clinical audits: “what was prescribed, not just sold.”

---

### `dispensations`
**What it is:**  
Clinical record of actually giving medicine to a patient.

**Why it’s needed:**
- Separates **clinical act** of dispensing from **financial sale**.
- Handles cases:
  - partial dispensing of a prescription,
  - non-billed samples, or special programs.
- Used for patient medication history (what they actually received).

---

### `dispensation_items`
**What it is:**  
Line items for each dispensation (which drug, from which batch, how much was given).

**Why it’s needed:**
- Ties dispensing to specific batches for recall and expiry tracking.
- Often drives stock out transactions.
- Supports clinical reports like “how much of drug X was dispensed to patient Y”.

---

## 8. Insurance & Claims

### `insurance_companies`
**What it is:**  
Insurance providers.

**Why it’s needed:**
- Base entity for plans.
- Reporting by insurance company.

---

### `insurance_plans`
**What it is:**  
Specific plans offered by an insurance company (e.g. “Gold Plan, 80% coverage”).

**Why it’s needed:**
- Each plan can have different coverage rules.
- Patients enroll into specific plans.

---

### `patient_insurance`
**What it is:**  
Link between `patients` and `insurance_plans` with membership details.

**Why it’s needed:**
- Records which plan a patient is on, and validity dates.
- Used when billing sales to insurance and creating claims.

---

### `insurance_claims`
**What it is:**  
Claims sent to insurance companies for reimbursement of sales.

**Why it’s needed:**
- Tracks status: submitted, approved, denied, paid.
- Links sales to an insurance plan and company.
- Critical for financial reconciliation and cash flow.

---

## 9. Sales, Payments & Prices

### `sales`
**What it is:**  
Financial transaction representing a sale of items to a patient (or walk-in customer).

**Why it’s needed:**
- Stores branch, patient (optional), who sold, and sale time.
- Basis for revenue reporting, cashier accountability, and receipts.

---

### `sale_items`
**What it is:**  
Line items of a sale: which drugs, from which batches, and at what price.

**Why it’s needed:**
- Detailed breakdown of each sale.
- Each row ties to a batch, often triggers stock out.
- Supports item-level sales analysis.

---

### `payments`
**What it is:**  
Actual payments made against a sale (could be multiple per sale).

**Why it’s needed:**
- Supports partial payments and multiple payment methods.
- Distinguishes sale **amount** from actual **money received**.
- Important for accounting and reconciliation.

---

### `price_lists`
**What it is:**  
Price catalog definitions, often per branch and date range (e.g. “Branch 1 2025 price list”).

**Why it’s needed:**
- Allows time-based and branch-based pricing.
- You can change prices over time without losing history.

---

### `price_list_items`
**What it is:**  
Prices of individual drugs in a specific price list.

**Why it’s needed:**
- Provides the unit price used when creating sales.
- Enables different prices per branch or period for the same drug.

---

## Summary

- **Master data tables** (`drugs`, `drug_categories`, `drug_forms`, `branches`, `patients`, `users`, etc.)

- **Transaction tables** (`stock_transactions`, `sales`, `dispensations`, `receipts`, etc.)

- **Link/bridge tables** (`user_roles`, `role_permissions`, `drug_manufacturers`, `patient_allergies`, `patient_insurance`)

- **Control/audit tables** (`stock_counts`, `stock_count_items`, `stock_adjustments`) 

