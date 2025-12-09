-- 1. MASTER / LOOKUP TABLES
----------------------------------------------------

INSERT INTO permissions (id, code, description) VALUES
  (1,  'MANAGE_USERS',           'Create, edit and deactivate user accounts'),
  (2,  'MANAGE_ROLES',           'Create roles and assign permissions'),
  (3,  'VIEW_PATIENTS',          'View patient demographics and history'),
  (4,  'EDIT_PATIENTS',          'Create and edit patient records'),
  (5,  'VIEW_PRESCRIPTIONS',     'View prescriptions and their status'),
  (6,  'CREATE_PRESCRIPTIONS',   'Enter new prescriptions into the system'),
  (7,  'VERIFY_PRESCRIPTIONS',   'Clinically verify and approve prescriptions'),
  (8,  'DISPENSE_MEDICATION',    'Record dispensing / send to sale'),
  (9,  'PROCESS_SALES',          'Create sales and collect payment at POS'),
  (10, 'REFUND_SALES',           'Process returns / refunds'),
  (11, 'VIEW_INVENTORY',         'View stock levels and batch information'),
  (12, 'ADJUST_INVENTORY',       'Create stock adjustments and stock counts'),
  (13, 'MANAGE_PURCHASING',      'Create and manage purchase orders and receipts'),
  (14, 'MANAGE_PRICING',         'Maintain price lists and discounts'),
  (15, 'MANAGE_INSURANCE',       'Manage patient insurance and submit claims'),
  (16, 'VIEW_REPORTS',           'View management and financial reports'),
  (17, 'CONFIGURE_REFERENCE',    'Manage reference/lookup values (categories, forms, etc.)');

INSERT INTO roles (id, name, description) VALUES
  (1, 'Admin',           'System administrator with full access'),
  (2, 'Pharmacist',      'Licensed pharmacist with clinical and dispensing privileges'),
  (3, 'Technician',      'Pharmacy technician who prepares orders under supervision'),
  (4, 'Cashier',         'Front-desk user who handles sales and payments'),
  (5, 'InventoryManager','User responsible for inventory and purchasing'),
  (6, 'Manager',         'Branch manager with reporting and approval permissions');


INSERT INTO role_permissions (role_id, permission_id) VALUES
  -- Admin (full access)
  (1,  1),
  (1,  2),
  (1,  3),
  (1,  4),
  (1,  5),
  (1,  6),
  (1,  7),
  (1,  8),
  (1,  9),
  (1, 10),
  (1, 11),
  (1, 12),
  (1, 13),
  (1, 14),
  (1, 15),
  (1, 16),
  (1, 17),

  -- Pharmacist – clinical + some inventory/insurance/reporting
  (2,  3),
  (2,  4),
  (2,  5),
  (2,  6),
  (2,  7),
  (2,  8),
  (2,  9),
  (2, 11),
  (2, 12),
  (2, 14),
  (2, 15),
  (2, 16),

  -- Technician – operational, no verification
  (3,  3),
  (3,  4),
  (3,  5),
  (3,  6),
  (3,  8),
  (3,  9),
  (3, 11),
  (3, 12),
  (3, 13),

  -- Cashier – POS only
  (4,  3),
  (4,  5),
  (4,  9),
  (4, 10),

  -- InventoryManager – stock, purchasing, pricing
  (5, 11),
  (5, 12),
  (5, 13),
  (5, 14),
  (5, 16),
  (5, 17),

  -- Manager – branch-level operations
  (6,  1),
  (6,  3),
  (6,  4),
  (6,  5),
  (6,  6),
  (6,  7),
  (6,  8),
  (6,  9),
  (6, 10),
  (6, 11),
  (6, 12),
  (6, 13),
  (6, 14),
  (6, 15),
  (6, 16);

INSERT INTO branch_types (id, type, description) VALUES
  (1, 'RETAIL',   'Retail pharmacy'),
  (2, 'CLINIC',   'Pharmacy inside a clinic or ambulatory center'),
  (3, 'HOSPITAL', 'Inpatient hospital pharmacy');

INSERT INTO temperature_ranges (id, code, range, description) VALUES
  (1, 'ROOM',   '20-25 C',  'Room temperature'),
  (2, 'FRIDGE', '0-8 C',    'Refrigerated'),
  (3, 'COOL',   '8-15 C',   'Cool storage'),
  (4, 'FROZEN', '-27-0 C',  'Kept in the freezer');

INSERT INTO payment_methods (id, method, description) VALUES
  (1, 'CASH',          'Cash payment'),
  (2, 'CARD',          'Card payment'),
  (3, 'INSURANCE',     'Insurance coverage'),
  (4, 'CHECK',         'Paper check'),
  (5, 'MOBILE_WALLET', 'Apple Pay / Google Pay / mobile wallet');

INSERT INTO sale_types (id, type, description) VALUES
  (1, 'PRESCRIPTION_RETAIL',    'Prescription sale, paid out-of-pocket'),
  (2, 'PRESCRIPTION_INSURANCE', 'Prescription sale with insurance billing'),
  (3, 'OTC_RETAIL',             'Over-the-counter product sale'),
  (4, 'RETURN_REFUND',          'Return / refund transaction');

INSERT INTO doctors (id, first_name, last_name, license_number, specialty, phone, email) VALUES
  (1, 'Emily', 'Brown', 'LIC-001', 'General Practitioner', '+123456780', 'emily.brown@example.com'),
  (2, 'James', 'Green', 'LIC-002', 'Pediatrics',           '+123456781', 'james.green@example.com');

INSERT INTO prescriptions_statuses (id, status, description) VALUES
  (1, 'NEW',               'Entered into system, not yet processed'),
  (2, 'DISPENSED',         'Dispensed / picked up by patient'),
  (3, 'ON_HOLD',           'On hold'),
  (4, 'AWAITING_STOCK',    'Waiting for stock to arrive'),
  (5, 'READY_FOR_PICKUP',  'Filled, waiting for patient pickup'),
  (6, 'CANCELLED',         'Cancelled by prescriber/pharmacy/patient');

INSERT INTO insurance_companies (id, name, phone, email, address) VALUES
  (1, 'HealthPlus', '+111111111', 'info@healthplus.test', '1 Health St'),
  (2, 'CareShield', '+222222222', 'contact@careshield.test', '99 Care Ave');

INSERT INTO insurance_claim_statuses (id, status, description) VALUES
  (1, 'PENDING_REVIEW',  'Waiting for payer review'),
  (2, 'APPROVED',        'Approved / adjudicated successfully'),
  (3, 'REJECTED',        'Rejected claim'),
  (4, 'PAID',            'Payment received from payer');

INSERT INTO drug_categories (id, name, description) VALUES
  (1,  'Antibiotic',        'Antibacterial drugs'),
  (2,  'Analgesic',         'Pain relief'),
  (3,  'Antiinflammatory',  'Non-steroidal anti-inflammatory drugs (NSAIDs) and others'),
  (4,  'Antihypertensive',  'Blood pressure–lowering agents'),
  (5,  'Antidiabetic',      'Glucose-lowering medications'),
  (6,  'Lipid-lowering',    'Cholesterol and triglyceride–lowering agents'),
  (7,  'Antidepressant',    'Treatment for depressive and anxiety disorders'),
  (8,  'Antipsychotic',     'Treatment for psychotic disorders and severe mood disorders'),
  (9,  'Anxiolytic',        'Anxiety-reducing agents, sedatives'),
  (10, 'Antihistamine',     'Allergy and pruritus treatments'),
  (11, 'Antacid/PPI',       'Antacids, H2 blockers, proton pump inhibitors'),
  (12, 'Respiratory',       'Asthma/COPD inhalers and other respiratory drugs'),
  (13, 'Gastrointestinal',  'Laxatives, antidiarrheals, antiemetics, etc.'),
  (14, 'Cardiovascular',    'Other non-BP cardiovascular agents'),
  (15, 'Anticoagulant',     'Blood thinners, anticoagulants'),
  (16, 'Antiplatelet',      'Platelet aggregation inhibitors'),
  (17, 'Antiviral',         'Antiviral agents'),
  (18, 'Antifungal',        'Antifungal agents'),
  (19, 'Endocrine/Hormonal','Hormone therapies, thyroid drugs, contraceptives'),
  (20, 'Dermatologic',      'Topical dermatologic preparations'),
  (21, 'Vitamins',          'Vitamins and minerals'),
  (22, 'Nutritional',       'Nutritional supplements and oral nutrition'),
  (23, 'Vaccine',           'Vaccines and immunizations'),
  (24, 'Neurologic',        'Antiepileptics, Parkinson’s, migraine treatments'),
  (25, 'Miscellaneous',     'Other medicines not otherwise classified');


INSERT INTO drug_forms (id, name, description) VALUES
  (1,  'TABLET',                'Solid oral tablet'),
  (2,  'CAPSULE',               'Solid oral capsule'),
  (3,  'CAPLET',                'Caplet (capsule-shaped tablet)'),
  (4,  'CHEWABLE_TABLET',       'Chewable oral tablet'),
  (5,  'DISPERSIBLE_TABLET',    'Tablet to be dispersed in water before taking'),
  (6,  'ORAL_SOLUTION',         'Liquid oral solution'),
  (7,  'ORAL_SUSPENSION',       'Liquid oral suspension (shake before use)'),
  (8,  'SYRUP',                 'Sweetened oral syrup'),
  (9,  'DROPS_ORAL',            'Oral drops (usually for pediatrics)'),
  (10, 'INJECTION_VIAL',        'Injection in vial, to be drawn into syringe'),
  (11, 'INJECTION_PREFILLED',   'Pre-filled injection syringe or device'),
  (12, 'IV_BAG',                'Intravenous infusion bag'),
  (13, 'CREAM',                 'Topical cream'),
  (14, 'OINTMENT',              'Topical ointment'),
  (15, 'GEL',                   'Topical gel'),
  (16, 'LOTION',                'Topical lotion'),
  (17, 'PATCH_TRANSDERMAL',     'Transdermal patch'),
  (18, 'INHALER_MDI',           'Metered-dose inhaler'),
  (19, 'INHALER_DPI',           'Dry powder inhaler'),
  (20, 'NASAL_SPRAY',           'Nasal spray'),
  (21, 'OPHTHALMIC_DROPS',      'Eye drops'),
  (22, 'OTIC_DROPS',            'Ear drops'),
  (23, 'SUPPOSITORY',           'Rectal or vaginal suppository'),
  (24, 'LOZENGE',               'Lozenge / troche that dissolves in mouth'),
  (25, 'POWDER_FOR_RECONSTITUTION', 'Powder to be reconstituted before use');

INSERT INTO manufacturers (id, name, country, phone, email) VALUES
  (1, 'ACME Pharma',   'USA',     '+100000001', 'sales@acmepharma.test'),
  (2, 'Global Medics', 'Germany', '+100000002', 'info@globalmedics.test');

INSERT INTO suppliers (id, name, phone, email, address) VALUES
  (1, 'MediSupply Co',  '+300000001', 'orders@medisupply.test',       '10 Warehouse Rd'),
  (2, 'HealthLogistics','+300000002', 'sales@healthlogistics.test',   '25 Logistics Park');

INSERT INTO purchase_order_statuses (id, status, description) VALUES
  (1, 'DRAFT',            'Not yet sent'),
  (2, 'SENT',             'Sent to supplier'),
  (3, 'RECEIVED',         'Fully received'),
  (4, 'PENDING_APPROVAL', 'Awaiting management approval'),
  (5, 'CANCELLED',        'Order cancelled');

INSERT INTO transaction_types (id, type, description) VALUES
  (1, 'PURCHASE',             'Stock received from supplier (purchase order receipt)'),
  (2, 'SALE',                 'Stock reduced due to a sale / dispensation'),
  (3, 'ADJUSTMENT',           'Manual stock adjustment not tied to a count'),
  (4, 'STOCK_COUNT_VARIANCE', 'Adjustment created from stock count difference'),
  (5, 'RETURN_TO_SUPPLIER',   'Stock returned to supplier'),
  (6, 'PATIENT_RETURN',       'Stock returned by patient and removed from usable inventory');

INSERT INTO stock_adjustment_reasons (id, reason, description) VALUES
  (1, 'DAMAGE',               'Damaged / unusable stock'),
  (2, 'EXPIRED',              'Expired stock removed'),
  (3, 'PACKAGING_ERROR',      'Packaging error'),
  (4, 'STOCK_COUNT_VARIANCE', 'Difference found during stock count');

----------------------------------------------------
-- 2. DEPENDABLE TABLES
----------------------------------------------------

INSERT INTO branches (id, name, type_id, phone, email, address) VALUES
  (1, 'Main Pharmacy',  1, '+400000001', 'main@pharmacy.test',   '100 Main St'),
  (2, 'Clinic Branch',  2, '+400000002', 'clinic@pharmacy.test', '200 Clinic Rd');

INSERT INTO storage_areas (id, branch_id, area_name, temperature_range_id) VALUES
  (1, 1, 'Main Room',   1),
  (2, 1, 'Main Fridge', 2);

INSERT INTO users (id, branch_id, first_name, last_name, username, password_hash, is_active) VALUES
  (1, 1, 'Alice', 'Admin',   'alice.admin',   'HASHEDPASS1', TRUE),
  (2, 1, 'Bob',   'Pharm',   'bob.pharm',     'HASHEDPASS2', TRUE),
  (3, 1, 'Carol', 'Cashier', 'carol.cashier', 'HASHEDPASS3', TRUE);  -- hashed with scrypt / bcrypt

INSERT INTO user_roles (id, user_id, role_id) VALUES
  (1, 1, 1),   -- Alice Admin
  (2, 2, 2),   -- Bob Pharmacist
  (3, 3, 4);   -- Carol Cashier

INSERT INTO patients (id, first_name, last_name, date_of_birth, gender, phone, address, primary_branch_id) VALUES
  (1, 'John', 'Doe',   '1985-01-15', 'Male',   '+500000001', '12 Patient Ln', 1),
  (2, 'Mary', 'Smith', '1990-06-30', 'Female', '+500000002', '34 Health Rd', 1);


INSERT INTO drugs (id, name, generic_name, category_id, form_id, strength,
                   is_controlled, is_refrigerated, default_pack_size, is_active)
VALUES
  (1, 'Amoxil 500', 'Amoxicillin', 1, 1, '500 mg', FALSE, FALSE, 20, TRUE), 
  (2, 'Ibu 200',    'Ibuprofen',   2, 1, '200 mg', FALSE, FALSE, 30, TRUE);

INSERT INTO drug_manufacturers (id, drug_id, manufacturer_id, product_code) VALUES
  (1, 1, 1, 'AMOX-500-ACME'),
  (2, 2, 2, 'IBU-200-GLOB');

INSERT INTO inventory_batches (id, drug_id, storage_area_id, batch_number,
                               expiry_date, initial_qty, unit_cost)
VALUES
  (1, 1, 1, 'BATCH-AMOX-001', '2026-12-31', 100, 3.00),
  (2, 2, 1, 'BATCH-IBU-001',  '2025-12-31', 200, 1.00);

INSERT INTO price_list_items (id, drug_id, unit_price, discount_amount, start_date, end_date) VALUES
  (1, 1, 5.00, 0.100, '2025-01-01 00:00:00', NULL),  -- 10% discount as 0.100
  (2, 2, 2.00, 0.050, '2025-01-01 00:00:00', NULL);  -- 5% discount


INSERT INTO prescriptions (id, patient_id, doctor_id, branch_id,
                           prescription_date, status_id, notes)
VALUES
  (1, 1, 1, 1, '2025-03-01', 1, 'Take with food'),
  (2, 2, 2, 1, '2025-03-02', 1, 'For pain as needed');

INSERT INTO prescription_items (id, prescription_id, drug_id, dosage,
                                frequency, duration_days, quantity_prescribed)
VALUES
  (1, 1, 1, '500 mg', '3x daily', 7, 21),
  (2, 2, 2, '200 mg', '2x daily', 5, 10);

INSERT INTO dispensations (id, prescription_id, dispensed_by, dispense_date) VALUES
  (1, 1, 2, '2025-03-01 10:00:00');  -- Bob dispenses prescription 1

INSERT INTO dispensation_items (id, dispensation_id, batch_id, quantity_dispensed) VALUES
  (1, 1, 1, 21);


INSERT INTO sales (id, branch_id, patient_id, sold_by, sale_date, sale_type_id) VALUES
  (1, 1, 1, 2, '2025-03-01 10:05:00', 1),  -- Retail
  (2, 1, 2, 3, '2025-03-02 11:00:00', 2);  -- Insurance

INSERT INTO sale_items (id, sale_id, price_id, quantity, batch_id) VALUES
  (1, 1, 1, 21, 1),  -- John, Amoxil
  (2, 2, 2, 10, 2);  -- Mary, Ibuprofen

INSERT INTO payments (id, sale_id, payment_date, amount, payment_method_id) VALUES
  (1, 1, '2025-03-01 10:06:00', 105.00, 1),  -- Cash
  (2, 2, '2025-03-02 11:01:00', 20.00,  3);  -- Insurance


INSERT INTO insurance_plans (id, insurance_company_id, plan_name, coverage_pct) VALUES
  (1, 1, 'HealthPlus Basic',    80.00),
  (2, 2, 'CareShield Standard', 70.00);

INSERT INTO patient_insurance (id, patient_id, insurance_plan_id,
                               member_number, valid_from, valid_to)
VALUES
  (1, 2, 1, 'HP-0001', '2024-01-01', NULL);

INSERT INTO insurance_claims (id, sale_id, insurance_plan_id, claim_date, status_id) VALUES
  (1, 2, 1, '2025-03-03', 1);  -- Pending claim for Mary’s sale

INSERT INTO purchase_orders (id, branch_id, supplier_id, created_by, order_date, status_id) VALUES
  (1, 1, 1, 2, '2025-02-20', 3);  -- Received

INSERT INTO purchase_order_items (id, purchase_order_id, drug_id, ordered_qty, expected_unit_cost) VALUES
  (1, 1, 1, 100, 2.80),
  (2, 1, 2, 200, 0.90);

INSERT INTO receipts (id, purchase_order_id, received_by, supplier_invoice_no) VALUES
  (1, 1, 2, 'INV-2025-0001');

INSERT INTO receipt_items (id, receipt_id, drug_id, received_qty, unit_cost) VALUES
  (1, 1, 1, 100, 3.00),
  (2, 1, 2, 200, 1.00);

INSERT INTO stock_counts (id, branch_id, count_date, counted_by, remarks) VALUES
  (1, 1, '2025-03-10', 2, 'Monthly stock take');

INSERT INTO stock_count_items (id, stock_count_id, batch_id, system_qty, counted_qty) VALUES
  (1, 1, 1, 79, 78),
  (2, 1, 2, 190, 190);

INSERT INTO stock_transactions (id, batch_id, branch_id, transaction_type_id,
                                quantity_change, transaction_date, performed_by, remarks)
VALUES
  (1, 1, 1, 1,  100, '2025-02-21 09:00:00', 2, 'Initial purchase of Amoxil'),
  (2, 2, 1, 1,  200, '2025-02-21 09:00:00', 2, 'Initial purchase of Ibu'),
  (3, 1, 1, 2,  -21, '2025-03-01 10:05:00', 2, 'Sale to John Doe'),
  (4, 2, 1, 2,  -10, '2025-03-02 11:00:00', 3, 'Sale to Mary Smith');

INSERT INTO stock_adjustments (id, batch_id, old_qty, new_qty, reason_id,
                               adjustment_date, approved_by)
VALUES
  (1, 1, 79, 78, 1, '2025-03-10 17:00:00', 1);  -- Damage adjustment
