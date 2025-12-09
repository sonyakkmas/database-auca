----------------------------------------------------
-- 1. BASIC QUERIES
----------------------------------------------------

---------- All branch types ----------

SELECT id, type, description
FROM branch_types
ORDER BY type;

--  id |   type   |                  description                  
-- ----+----------+-----------------------------------------------
--   2 | CLINIC   | Pharmacy inside a clinic or ambulatory center
--   3 | HOSPITAL | Inpatient hospital pharmacy
--   1 | RETAIL   | Retail pharmacy
-- (3 rows)


---------- All drug categories ----------

SELECT id, name, description
FROM drug_categories
ORDER BY name;

--  id |        name        |                         description                         
-- ----+--------------------+-------------------------------------------------------------
--   2 | Analgesic          | Pain relief
--  11 | Antacid/PPI        | Antacids, H2 blockers, proton pump inhibitors
--   1 | Antibiotic         | Antibacterial drugs
--  15 | Anticoagulant      | Blood thinners, anticoagulants
--   7 | Antidepressant     | Treatment for depressive and anxiety disorders
--   5 | Antidiabetic       | Glucose-lowering medications
--  18 | Antifungal         | Antifungal agents
--  10 | Antihistamine      | Allergy and pruritus treatments
--   4 | Antihypertensive   | Blood pressure–lowering agents
--   3 | Antiinflammatory   | Non-steroidal anti-inflammatory drugs (NSAIDs) and others
--  16 | Antiplatelet       | Platelet aggregation inhibitors
--   8 | Antipsychotic      | Treatment for psychotic disorders and severe mood disorders
--  17 | Antiviral          | Antiviral agents
--   9 | Anxiolytic         | Anxiety-reducing agents, sedatives
--  14 | Cardiovascular     | Other non-BP cardiovascular agents
--  20 | Dermatologic       | Topical dermatologic preparations
--  19 | Endocrine/Hormonal | Hormone therapies, thyroid drugs, contraceptives
--  13 | Gastrointestinal   | Laxatives, antidiarrheals, antiemetics, etc.
--   6 | Lipid-lowering     | Cholesterol and triglyceride–lowering agents
--  25 | Miscellaneous      | Other medicines not otherwise classified
--  24 | Neurologic         | Antiepileptics, Parkinson’s, migraine treatments
--  22 | Nutritional        | Nutritional supplements and oral nutrition
--  12 | Respiratory        | Asthma/COPD inhalers and other respiratory drugs
--  23 | Vaccine            | Vaccines and immunizations
--  21 | Vitamins           | Vitamins and minerals
-- (25 rows)

---------- Controlled drugs ----------

SELECT id, name, strength, is_controlled
FROM drugs
WHERE is_controlled = TRUE;

--  id | name | strength | is_controlled 
-- ----+------+----------+---------------
-- (0 rows)

---------- Doctors with "Pediatrics" specialty ----------

SELECT id, first_name, last_name, specialty
FROM doctors
WHERE specialty = 'Pediatrics';

--  id | first_name | last_name | specialty  
-- ----+------------+-----------+------------
--   2 | James      | Green     | Pediatrics
-- (1 row)

---------- Number of patients per branch ----------

SELECT
    b.name AS branch_name,
    COUNT(p.id) AS patient_count
FROM branches b
LEFT JOIN patients p ON p.primary_branch_id = b.id
GROUP BY b.name
ORDER BY b.name;

--   branch_name  | patient_count 
-- ---------------+---------------
--  Clinic Branch |             0
--  Main Pharmacy |             2
-- (2 rows)


---------- Prescriptions in 2025 only ----------

SELECT
    id,
    patient_id,
    prescription_date,
    status_id
FROM prescriptions
WHERE prescription_date >= DATE '2025-01-01'
  AND prescription_date <  DATE '2026-01-01'
ORDER BY prescription_date;

--  id | patient_id | prescription_date | status_id 
-- ----+------------+-------------------+-----------
--   1 |          1 | 2025-03-01        |         1
--   2 |          2 | 2025-03-02        |         1
-- (2 rows)

---------- List all active users with their branch ----------

SELECT
    u.id,
    u.first_name,
    u.last_name,
    u.username,
    b.name AS branch_name,
    u.is_active
FROM users u
JOIN branches b ON b.id = u.branch_id
WHERE u.is_active = TRUE
ORDER BY b.name, u.last_name, u.first_name;

--  id | first_name | last_name |   username    |  branch_name  | is_active 
-- ----+------------+-----------+---------------+---------------+-----------
--   1 | Alice      | Admin     | alice.admin   | Main Pharmacy | t
--   3 | Carol      | Cashier   | carol.cashier | Main Pharmacy | t
--   2 | Bob        | Pharm     | bob.pharm     | Main Pharmacy | t
-- (3 rows)


---------- All prescriptions with patient & doctor names and status ----------

SELECT
    pr.id AS prescription_id,
    pr.prescription_date,
    ps.status AS prescription_status,
    pa.first_name || ' ' || pa.last_name AS patient_name,
    d.first_name  || ' ' || d.last_name  AS doctor_name,
    pr.notes
FROM prescriptions pr
JOIN patients              pa ON pa.id = pr.patient_id
JOIN doctors               d  ON d.id  = pr.doctor_id
JOIN prescriptions_statuses ps ON ps.id = pr.status_id
ORDER BY pr.prescription_date DESC, pr.id;

--  prescription_id | prescription_date | prescription_status | patient_name | doctor_name |       notes        
-- -----------------+-------------------+---------------------+--------------+-------------+--------------------
--                2 | 2025-03-02        | NEW                 | Mary Smith   | James Green | For pain as needed
--                1 | 2025-03-01        | NEW                 | John Doe     | Emily Brown | Take with food
-- (2 rows)


---------- Inventory batches with basic info ----------

SELECT
    ib.id AS batch_id,
    dr.name AS drug_name,
    ib.batch_number,
    ib.expiry_date,
    ib.initial_qty,
    ib.unit_cost,
    sa.area_name,
    b.name AS branch_name
FROM inventory_batches ib
JOIN drugs        dr ON dr.id = ib.drug_id
JOIN storage_areas sa ON sa.id = ib.storage_area_id
JOIN branches     b  ON b.id  = sa.branch_id
ORDER BY dr.name, ib.expiry_date;


--  batch_id | drug_name  |  batch_number  | expiry_date | initial_qty | unit_cost | area_name |  branch_name  
-- ----------+------------+----------------+-------------+-------------+-----------+-----------+---------------
--         1 | Amoxil 500 | BATCH-AMOX-001 | 2026-12-31  |         100 |      3.00 | Main Room | Main Pharmacy
--         2 | Ibu 200    | BATCH-IBU-001  | 2025-12-31  |         200 |      1.00 | Main Room | Main Pharmacy
-- (2 rows)


---------- Payments with method and sale info ----------

SELECT
    p.id AS payment_id,
    p.payment_date,
    p.sale_id,
    pm.method AS payment_method,
    p.amount
FROM payments p
JOIN payment_methods pm ON pm.id = p.payment_method_id
ORDER BY p.payment_date DESC;

--  payment_id |    payment_date     | sale_id | payment_method | amount 
-- ------------+---------------------+---------+----------------+--------
--           2 | 2025-03-02 11:01:00 |       2 | INSURANCE      |  20.00
--           1 | 2025-03-01 10:06:00 |       1 | CASH           | 105.00
-- (2 rows)


----------------------------------------------------
-- 2. COMPLEX QUERIES
----------------------------------------------------

---------- Daily sales summary by branch ----------

SELECT
    s.branch_id,
    b.name AS branch_name,
    DATE(s.sale_date) AS sale_day,
    COUNT(DISTINCT s.id) AS number_of_sales,
    SUM(si.quantity * pli.unit_price * (1 - pli.discount_amount)) AS total_revenue
FROM sales s
JOIN branches        b   ON b.id   = s.branch_id
JOIN sale_items      si  ON si.sale_id = s.id
JOIN price_list_items pli ON pli.id    = si.price_id
GROUP BY s.branch_id, b.name, DATE(s.sale_date)
ORDER BY sale_day DESC, branch_name;

--  branch_id |  branch_name  |  sale_day  | number_of_sales | total_revenue 
-- -----------+---------------+------------+-----------------+---------------
--          1 | Main Pharmacy | 2025-03-02 |               1 |      19.00000
--          1 | Main Pharmacy | 2025-03-01 |               1 |      94.50000
-- (2 rows)

---------- Stock on hand per drug and branch ----------

SELECT
    dr.id AS drug_id,
    dr.name AS drug_name,
    b.id  AS branch_id,
    b.name AS branch_name,
    SUM(st.quantity_change) AS current_qty
FROM stock_transactions st
JOIN inventory_batches ib ON ib.id = st.batch_id
JOIN drugs            dr  ON dr.id = ib.drug_id
JOIN branches         b   ON b.id  = st.branch_id
GROUP BY dr.id, dr.name, b.id, b.name
ORDER BY dr.name, branch_name;

--  drug_id | drug_name  | branch_id |  branch_name  | current_qty 
-- ---------+------------+-----------+---------------+-------------
--        1 | Amoxil 500 |         1 | Main Pharmacy |          79
--        2 | Ibu 200    |         1 | Main Pharmacy |         190
-- (2 rows)

---------- Drugs expiring in the next 90 days with remaining stock ----------

WITH current_stock AS (
    SELECT
        ib.id AS batch_id,
        SUM(st.quantity_change) AS batch_qty
    FROM inventory_batches ib
    JOIN stock_transactions st ON st.batch_id = ib.id
    GROUP BY ib.id
)
SELECT
    dr.name AS drug_name,
    ib.batch_number,
    ib.expiry_date,
    b.name AS branch_name,
    COALESCE(cs.batch_qty, 0) AS current_qty
FROM inventory_batches ib
JOIN drugs         dr ON dr.id = ib.drug_id
JOIN storage_areas sa ON sa.id = ib.storage_area_id
JOIN branches      b  ON b.id  = sa.branch_id
LEFT JOIN current_stock cs ON cs.batch_id = ib.id
WHERE ib.expiry_date <= (CURRENT_DATE + INTERVAL '90 days')
  AND COALESCE(cs.batch_qty, 0) > 0
ORDER BY ib.expiry_date, dr.name;

--  drug_name | batch_number  | expiry_date |  branch_name  | current_qty 
-- -----------+---------------+-------------+---------------+-------------
--  Ibu 200   | BATCH-IBU-001 | 2025-12-31  | Main Pharmacy |         190
-- (1 row)

---------- Patient medication history with last prescription date ----------

SELECT
    p.id,
    p.first_name,
    p.last_name,
    COUNT(DISTINCT pr.id) AS total_prescriptions,
    COUNT(DISTINCT pri.id) AS total_prescribed_items,
    MAX(pr.prescription_date) AS last_prescription_date
FROM patients p
LEFT JOIN prescriptions      pr  ON pr.patient_id = p.id
LEFT JOIN prescription_items pri ON pri.prescription_id = pr.id
GROUP BY p.id, p.first_name, p.last_name
ORDER BY last_prescription_date DESC NULLS LAST;

--  id | first_name | last_name | total_prescriptions | total_prescribed_items | last_prescription_date 
-- ----+------------+-----------+---------------------+------------------------+------------------------
--   2 | Mary       | Smith     |                   1 |                      1 | 2025-03-02
--   1 | John       | Doe       |                   1 |                      1 | 2025-03-01
-- (2 rows)

---------- Top-selling drug by quantity ----------

SELECT
    dr.id AS drug_id,
    dr.name AS drug_name,
    SUM(si.quantity) AS total_quantity_sold
FROM sale_items si
JOIN inventory_batches ib ON ib.id = si.batch_id
JOIN drugs            dr  ON dr.id = ib.drug_id
GROUP BY dr.id, dr.name
ORDER BY total_quantity_sold DESC, dr.name;

--  drug_id | drug_name  | total_quantity_sold 
-- ---------+------------+---------------------
--        1 | Amoxil 500 |                  21
--        2 | Ibu 200    |                  10
-- (2 rows)
