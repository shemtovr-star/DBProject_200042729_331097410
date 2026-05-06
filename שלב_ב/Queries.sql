-- ==========================================
-- חלק 1: 4 שאילתות SELECT כפולות (להשוואת יעילות)
-- ==========================================

-- שאילתה 1: מטופלים עם תורים עתידיים לקרדיולוגיה (פירוק תאריך)
-- דרך א': INNER JOIN (הדרך היעילה)
SELECT p.first_name, p.last_name, p.phone, a.appointment_date, EXTRACT(MONTH FROM a.appointment_date) as appt_month
FROM Patient p
INNER JOIN Appointment a ON p.patient_id = a.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Department dep ON d.department_id = dep.department_id
WHERE dep.name = 'Cardiology' AND a.appointment_date > CURRENT_DATE;

-- דרך ב': תת-שאילתה מקוננת (IN)
SELECT first_name, last_name, phone, birth_date, EXTRACT(YEAR FROM birth_date) as birth_year
FROM Patient
WHERE patient_id IN (
    SELECT patient_id 
    FROM Appointment 
    WHERE appointment_date > CURRENT_DATE AND doctor_id IN (
        SELECT doctor_id FROM Doctor WHERE department_id = (
            SELECT department_id FROM Department WHERE name = 'Cardiology'
        )
    )
);

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

-- שאילתה 3: פוליסות ביטוח שתוקפן פג בחודש הקרוב
-- דרך א': שימוש ב- EXISTS (הדרך היעילה)
SELECT p.patient_id, p.first_name, p.last_name, p.email, p.phone
FROM Patient p
WHERE EXISTS (
    SELECT 1 
    FROM InsurancePolicy ip 
    WHERE ip.patient_id = p.patient_id 
    AND EXTRACT(MONTH FROM ip.expiry_date) = EXTRACT(MONTH FROM CURRENT_DATE) + 1
    AND EXTRACT(YEAR FROM ip.expiry_date) = EXTRACT(YEAR FROM CURRENT_DATE)
);

-- דרך ב': שימוש ב- INNER JOIN
SELECT p.patient_id, p.first_name, p.last_name, p.email
FROM Patient p
INNER JOIN InsurancePolicy ip ON p.patient_id = ip.patient_id
WHERE EXTRACT(MONTH FROM ip.expiry_date) = EXTRACT(MONTH FROM CURRENT_DATE) + 1
AND EXTRACT(YEAR FROM ip.expiry_date) = EXTRACT(YEAR FROM CURRENT_DATE);

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
SELECT p.first_name || ' ' || p.last_name AS patient_name, v.visit_date, EXTRACT(YEAR FROM v.visit_date) as visit_year, v.diagnosis, d.last_name AS doctor_name, m.name AS medication_prescribed
FROM Patient p
INNER JOIN Visit v ON p.patient_id = v.patient_id
INNER JOIN Doctor d ON v.doctor_id = d.doctor_id
LEFT JOIN Prescription pr ON v.visit_id = pr.visit_id
LEFT JOIN Medication m ON pr.medication_id = m.medication_id
WHERE p.patient_id = 1 
ORDER BY v.visit_date DESC;

-- שאילתה 6: בדיקות רפואיות למטופלים מעל גיל 60
SELECT mt.test_date, mt.test_type, mt.result, p.first_name, p.last_name, EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) AS age
FROM MedicalTest mt
INNER JOIN Patient p ON mt.patient_id = p.patient_id
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) > 60
ORDER BY mt.test_date DESC;

-- שאילתה 7: כמות התורים שבוטלו לפי מחלקה
SELECT dep.name AS department_name, COUNT(a.appointment_id) AS cancelled_appointments
FROM Appointment a
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Department dep ON d.department_id = dep.department_id
WHERE a.status = 'cancelled'
GROUP BY dep.name
ORDER BY cancelled_appointments DESC;

-- שאילתה 8: אחיות שהחלו לעבוד לפני 2020 וכמות שנות השירות
SELECT first_name, last_name, email, start_date, EXTRACT(YEAR FROM AGE(CURRENT_DATE, start_date)) as years_of_service
FROM Nurse
WHERE EXTRACT(YEAR FROM start_date) < 2020
ORDER BY years_of_service DESC;

-- ==========================================
-- חלק 3: שאילתות UPDATE
-- ==========================================

-- 1. עדכון סטטוס תורים שעבר התאריך שלהם
UPDATE Appointment SET status = 'completed', notes = COALESCE(notes, '') || ' (Auto)' WHERE appointment_date < CURRENT_DATE AND status = 'scheduled';

-- 2. העלאת סכום הכיסוי הביטוחי למסיימים בשנה הבאה
UPDATE InsurancePolicy SET coverage_amount = coverage_amount * 1.10 WHERE company_name = 'Harel' AND EXTRACT(YEAR FROM expiry_date) = EXTRACT(YEAR FROM CURRENT_DATE) + 1;

-- 3. הנחה של 5% על משככי כאבים
UPDATE Medication SET price = price * 0.95 WHERE type = 'Painkiller';

-- ==========================================
-- חלק 4: שאילתות DELETE
-- ==========================================

-- 1. מחיקת תורים שבוטלו לפני יותר מ-3 שנים
DELETE FROM Appointment WHERE status = 'cancelled' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, appointment_date)) > 3;

-- 2. מחיקת מרשמים ללא כמות ימים
DELETE FROM Prescription WHERE duration_days IS NULL OR dosage = '';

-- 3. מחיקת בדיקות רפואיות ישנות ללא תוצאה
DELETE FROM MedicalTest WHERE result IS NULL AND test_date < CURRENT_DATE - INTERVAL '6 months';