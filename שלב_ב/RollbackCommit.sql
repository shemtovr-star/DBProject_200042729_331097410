-- ==========================================
-- שלב ב' - פרויקט מסדי נתונים: clinic_db
-- קובץ דוגמאות ROLLBACK ו-COMMIT
-- ==========================================


-- ===============================
-- חלק 1: ROLLBACK Example
-- ===============================

-- מצב 1: לפני השינוי
SELECT doctor_id, specialization FROM Doctor WHERE doctor_id = 1;

BEGIN;

-- שינוי בטעות
UPDATE Doctor SET specialization = 'Unknown' WHERE doctor_id = 1;

-- מצב 2: השינוי קרה בתוך הטרנזקציה
SELECT doctor_id, specialization FROM Doctor WHERE doctor_id = 1;

ROLLBACK;

-- מצב 3: הטרנזקציה בוטלה, הנתונים חזרו
SELECT doctor_id, specialization FROM Doctor WHERE doctor_id = 1;


-- ===============================
-- חלק 2: COMMIT Example
-- ===============================

-- מצב 1: לפני השינוי
SELECT appointment_id, status FROM Appointment WHERE appointment_id = 20003;

BEGIN;

-- שינוי
UPDATE Appointment SET status = 'cancelled' WHERE appointment_id = 20003;

-- מצב 2: השינוי קרה בתוך הטרנזקציה
SELECT appointment_id, status FROM Appointment WHERE appointment_id = 20003;

COMMIT;

-- מצב 3: השינוי נשמר לתמיד
SELECT appointment_id, status FROM Appointment WHERE appointment_id = 20003;
