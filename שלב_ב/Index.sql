-- ==========================================
-- שלב ב' - פרויקט מסדי נתונים: clinic_db
-- קובץ אינדקסים (Indexes)
-- ==========================================


-- אינדקס 1: שמות מטופלים (לחיפוש יעיל בקבלה)
-- שיפור: 7.3x מהיר יותר על טבלת Patient (20,000 רשומות)
DROP INDEX IF EXISTS idx_patient_name;
CREATE INDEX idx_patient_name ON Patient(last_name, first_name);


-- אינדקס 2: תאריכי תורים + רופא (לסינון מהיר ביומן המרפאה)
-- שיפור: 44x מהיר יותר על טבלת Appointment (20,000 רשומות)
DROP INDEX IF EXISTS idx_appointment_date_doctor;
CREATE INDEX idx_appointment_date_doctor ON Appointment(appointment_date, doctor_id);


-- אינדקס 3: תוקף פוליסות ביטוח (לזיהוי פוליסות שעומדות לפוג)
-- שיפור: 5.3x מהיר יותר על טבלת InsurancePolicy
DROP INDEX IF EXISTS idx_insurance_expiry;
CREATE INDEX idx_insurance_expiry ON InsurancePolicy(expiry_date);


-- ==========================================
-- בדיקות EXPLAIN ANALYZE לפני ואחרי
-- ==========================================

-- בדיקת אינדקס 1
-- EXPLAIN ANALYZE SELECT * FROM Patient WHERE last_name = 'Smith';

-- בדיקת אינדקס 2
-- EXPLAIN ANALYZE SELECT * FROM Appointment 
-- WHERE appointment_date = '2026-12-01' AND doctor_id = 5;

-- בדיקת אינדקס 3
-- EXPLAIN ANALYZE SELECT * FROM InsurancePolicy 
-- WHERE expiry_date BETWEEN '2026-01-01' AND '2026-12-31';
