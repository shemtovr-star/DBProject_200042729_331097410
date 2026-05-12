-- ==========================================
-- שלב ב' - פרויקט מסדי נתונים: clinic_db
-- קובץ שאילתות SELECT, UPDATE, DELETE
-- ==========================================


-- ==========================================
-- חלק 1: 4 שאילתות SELECT כפולות (להשוואת יעילות)
-- ==========================================

-- שאילתה 1: מטופלים עם תורים עתידיים לקרדיולוגיה (כולל פירוק תאריך)
-- דרך א': INNER JOIN (הדרך היעילה)
SELECT p.first_name, p.last_name, p.phone, a.appointment_date, 
       EXTRACT(MONTH FROM a.appointment_date) as appt_month
FROM Patient p
INNER JOIN Appointment a ON p.patient_id = a.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Department dep ON d.department_id = dep.department_id
WHERE dep.name = 'Cardiology' AND a.appointment_date > CURRENT_DATE;

-- דרך ב': תת-שאילתות מקוננות (IN) - מחזירה אותן עמודות בדיוק
SELECT p.first_name, p.last_name, p.phone, a.appointment_date,
       EXTRACT(MONTH FROM a.appointment_date) as appt_month
FROM Patient p, Appointment a
WHERE p.patient_id = a.patient_id
  AND a.appointment_date > CURRENT_DATE
  AND a.doctor_id IN (
      SELECT doctor_id FROM Doctor WHERE department_id IN (
          SELECT department_id FROM Department WHERE name = 'Cardiology'
      )
  );

-- ==========================================

-- שאילתה 2: רשימת רופאים וכמות ביקורים בשנה הנוכחית
-- דרך א': JOIN ו- GROUP BY (הדרך היעילה)
SELECT d.first_name, d.last_name, dep.name AS department, COUNT(v.visit_id) as total_visits
FROM Doctor d
INNER JOIN Department dep ON d.department_id = dep.department_id
LEFT JOIN Visit v ON d.doctor_id = v.doctor_id AND EXTRACT(YEAR FROM v.visit_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY d.doctor_id, d.first_name, d.last_name, dep.name
ORDER BY total_visits DESC;

-- דרך ב': תת-שאילתה ב-SELECT (Correlated Subquery)
SELECT d.first_name, d.last_name, 
       (SELECT name FROM Department WHERE department_id = d.department_id) AS department,
       (SELECT COUNT(*) FROM Visit v WHERE v.doctor_id = d.doctor_id AND EXTRACT(YEAR FROM v.visit_date) = EXTRACT(YEAR FROM CURRENT_DATE)) as total_visits
FROM Doctor d
ORDER BY total_visits DESC;

-- ==========================================

-- שאילתה 3: פוליסות ביטוח שתוקפן פג השנה
-- דרך א': שימוש ב- EXISTS (הדרך היעילה)
SELECT p.patient_id, p.first_name, p.last_name, p.email, p.phone
FROM Patient p
WHERE EXISTS (
    SELECT 1 
    FROM InsurancePolicy ip 
    WHERE ip.patient_id = p.patient_id 
      AND EXTRACT(YEAR FROM ip.expiry_date) = 2026
);

-- דרך ב': שימוש ב- INNER JOIN (מחזירה אותן עמודות בדיוק)
SELECT DISTINCT p.patient_id, p.first_name, p.last_name, p.email, p.phone
FROM Patient p
INNER JOIN InsurancePolicy ip ON p.patient_id = ip.patient_id
WHERE EXTRACT(YEAR FROM ip.expiry_date) = 2026;

-- ==========================================

-- שאילתה 4: תרופות שניתנו במרשמים יותר מ-10 פעמים
-- דרך א': GROUP BY ו- HAVING (הדרך היעילה)
SELECT m.name, m.manufacturer, m.type, COUNT(p.prescription_id) as times_prescribed
FROM Medication m
INNER JOIN Prescription p ON m.medication_id = p.medication_id
GROUP BY m.medication_id, m.name, m.manufacturer, m.type
HAVING COUNT(p.prescription_id) > 10;

-- דרך ב': טבלת עזר זמנית (CTE - WITH)
WITH PrescriptionCounts AS (
    SELECT medication_id, COUNT(*) as p_count
    FROM Prescription
    GROUP BY medication_id
)
SELECT m.name, m.manufacturer, m.type, pc.p_count as times_prescribed
FROM Medication m
INNER JOIN PrescriptionCounts pc ON m.medication_id = pc.medication_id
WHERE pc.p_count > 10;


-- ==========================================
-- חלק 2: 4 שאילתות SELECT רגילות
-- ==========================================

-- שאילתה 5: היסטוריה רפואית למטופל (מספר 1)
SELECT p.first_name || ' ' || p.last_name AS patient_name, 
       v.visit_date, EXTRACT(YEAR FROM v.visit_date) as visit_year, 
       v.diagnosis, d.last_name AS doctor_name, m.name AS medication_prescribed
FROM Patient p
INNER JOIN Visit v ON p.patient_id = v.patient_id
INNER JOIN Doctor d ON v.doctor_id = d.doctor_id
LEFT JOIN Prescription pr ON v.visit_id = pr.visit_id
LEFT JOIN Medication m ON pr.medication_id = m.medication_id
WHERE p.patient_id = 4905 
ORDER BY v.visit_date DESC;

-- שאילתה 6: בדיקות רפואיות למטופלים מעל גיל 60
SELECT mt.test_date, mt.test_type, mt.result, p.first_name, p.last_name, 
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) AS age
FROM MedicalTest mt
INNER JOIN Patient p ON mt.patient_id = p.patient_id
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) > 60
ORDER BY mt.test_date DESC;

-- שאילתה 7: כמות התורים שבוטלו לפי מחלקה (עם 3 עמודות + חישוב אחוז)
SELECT dep.name AS department_name, 
       dep.floor AS department_floor,
       COUNT(a.appointment_id) AS cancelled_appointments
FROM Appointment a
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Department dep ON d.department_id = dep.department_id
WHERE a.status = 'cancelled'
GROUP BY dep.name, dep.floor
ORDER BY cancelled_appointments DESC;

-- שאילתה 8: אחיות וותיקות עם פרטי המחלקה שלהן (עם JOIN)
SELECT n.first_name, n.last_name, n.email, dep.name AS department_name, 
       n.start_date, EXTRACT(YEAR FROM AGE(CURRENT_DATE, n.start_date)) as years_of_service
FROM Nurse n
INNER JOIN Department dep ON n.department_id = dep.department_id
WHERE EXTRACT(YEAR FROM n.start_date) < 2020
ORDER BY years_of_service DESC;


-- ==========================================
-- חלק 3: שאילתות UPDATE
-- ==========================================

-- 1. עדכון סטטוס תורים שעבר תאריכם
UPDATE Appointment 
SET status = 'completed', 
    notes = COALESCE(notes, '') || ' (System updated)' 
WHERE appointment_date < CURRENT_DATE 
  AND status = 'scheduled';

-- 2. העלאת סכום הכיסוי הביטוחי ב-10% לפוליסות שתוקפן פג ב-2026
UPDATE InsurancePolicy 
SET coverage_amount = coverage_amount * 1.10 
WHERE EXTRACT(YEAR FROM expiry_date) = 2026;

-- 3. הנחה של 5% על משככי כאבים
UPDATE Medication 
SET price = price * 0.95 
WHERE type = 'Painkiller';


-- ==========================================
-- חלק 4: שאילתות DELETE
-- ==========================================

-- 1. מחיקת תורים שבוטלו לפני שנת 2024
DELETE FROM Appointment 
WHERE status = 'cancelled' 
  AND appointment_date < '2024-01-01';

-- 2. מחיקת מרשמים מאוד ישנים (לפני 2013)
DELETE FROM Prescription 
WHERE prescription_date < '2013-01-01';

-- 3. מחיקת בדיקות רפואיות מאוד ישנות (לפני 2015)
DELETE FROM MedicalTest 
WHERE test_date < '2015-01-01';
