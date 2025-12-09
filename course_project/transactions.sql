---------- New patient registration ----------
BEGIN;

INSERT INTO patients (
    id, first_name, last_name, date_of_birth,
    gender, phone, address, primary_branch_id
) VALUES (
    3, 'Peter', 'Jones', '1975-09-10',
    'Male', '+500000010', '45 New St', 1
);

COMMIT;

---------- Prescription dispensation ----------
BEGIN;

INSERT INTO dispensations (
    id, prescription_id, dispensed_by, dispense_date
) VALUES (
    2, 3, 2, '2025-03-05 14:00:00'
);

INSERT INTO dispensation_items (
    id, dispensation_id, batch_id, quantity_dispensed
) VALUES
    (2, 2, 1, 21),  -- Amoxil batch 1
    (3, 2, 2, 10);  -- Ibu batch 2

COMMIT;


---------- OTC retail sale + payment + stock movement ----------
BEGIN;

-- Create the sale
INSERT INTO sales (
    id, branch_id, patient_id, sold_by, sale_date, sale_type_id
) VALUES (
    3, 1, 1, 3, '2025-03-06 09:30:00', 3
);

-- Add item 
INSERT INTO sale_items (
    id, sale_id, price_id, quantity, batch_id
) VALUES (
    3, 3, 2, 5, 2
);

-- Record the payment 
INSERT INTO payments (
    id, sale_id, payment_date, amount, payment_method_id
) VALUES (
    3, 3, '2025-03-06 09:31:00', 10.00, 1
);

-- Decrease stock 
INSERT INTO stock_transactions (
    id, batch_id, branch_id, transaction_type_id,
    quantity_change, transaction_date, performed_by, remarks
) VALUES (
    5, 2, 1, 2,
    -5, '2025-03-06 09:30:00', 3, 'OTC sale to John Doe'
);

COMMIT;

---------- Prescriptino sale billed to insurance + claim creation ----------
BEGIN;

-- Create sale 
INSERT INTO sales (
    id, branch_id, patient_id, sold_by, sale_date, sale_type_id
) VALUES (
    4, 1, 2, 2, '2025-03-06 10:15:00', 2
);

-- Add sale item
INSERT INTO sale_items (
    id, sale_id, price_id, quantity, batch_id
) VALUES (
    4, 4, 1, 21, 1
);

-- Insurance payment
INSERT INTO payments (
    id, sale_id, payment_date, amount, payment_method_id
) VALUES (
    4, 4, '2025-03-06 10:16:00', 0.00, 3
);

-- Insurance claim
INSERT INTO insurance_claims (
    id, sale_id, insurance_plan_id, claim_date, status_id
) VALUES (
    2, 4, 1, '2025-03-06', 1
);

-- Descrease stock
INSERT INTO stock_transactions (
    id, batch_id, branch_id, transaction_type_id,
    quantity_change, transaction_date, performed_by, remarks
) VALUES (
    6, 1, 1, 2,
    -21, '2025-03-06 10:15:00', 2, 'Insurance sale to Mary Smith'
);

COMMIT;

---------- New purchase order for two drugs ----------

BEGIN;

INSERT INTO purchase_orders (
    id, branch_id, supplier_id, created_by, order_date, status_id
) VALUES (
    2, 1, 2, 1, '2025-03-07', 1  
);

INSERT INTO purchase_order_items (
    id, purchase_order_id, drug_id, ordered_qty, expected_unit_cost
) VALUES
    (3, 2, 1, 120, 2.70),  -- Amoxil
    (4, 2, 2, 250, 0.85);  -- Ibu

COMMIT;


---------- A stock adjustment for damage + matching stock transaction ----------

BEGIN;

-- Adjustment record
INSERT INTO stock_adjustments (
    id, batch_id, old_qty, new_qty, reason_id,
    adjustment_date, approved_by
) VALUES (
    2, 2, 183, 180, 1,  
    '2025-03-15 18:00:00', 1
);

-- Stock transaction
INSERT INTO stock_transactions (
    id, batch_id, branch_id, transaction_type_id,
    quantity_change, transaction_date, performed_by, remarks
) VALUES (
    9, 2, 1, 3,
    -3, '2025-03-15 18:00:00', 1,
    'Damage adjustment from stock count 2'
);

COMMIT;
