-- ==========================================
-- שלב ב' - פרויקט מסדי נתונים: clinic_db
-- קובץ אילוצים (Constraints)
-- ==========================================


-- אילוץ 1: תאריך לידה לא יכול להיות בעתיד
-- מוטיבציה: אדם לא יכול להיוולד בעתיד
ALTER TABLE Patient DROP CONSTRAINT IF EXISTS chk_patient_birth_date;
ALTER TABLE Patient ADD CONSTRAINT chk_patient_birth_date 
    CHECK (birth_date <= CURRENT_DATE);

-- ניסיון הפרה - מטופל שנולד בעתיד
-- INSERT INTO Patient (first_name, last_name, birth_date) 
-- VALUES ('Future', 'Person', '2050-01-01');


-- אילוץ 2: שעת תור חייבת להיות בין 08:00 ל-20:00
-- מוטיבציה: הקליניקה פועלת בשעות מוגדרות
ALTER TABLE Appointment DROP CONSTRAINT IF EXISTS chk_appointment_time;
ALTER TABLE Appointment ADD CONSTRAINT chk_appointment_time 
    CHECK (appointment_time >= '08:00:00' AND appointment_time <= '20:00:00');

-- ניסיון הפרה - תור בשעה 23:00
-- INSERT INTO Appointment (appointment_date, appointment_time, status, patient_id, doctor_id) 
-- VALUES ('2026-12-01', '23:00:00', 'scheduled', 1, 1);


-- אילוץ 3: מחיר תרופה חייב להיות חיובי
-- מוטיבציה: מחירים שליליים אינם הגיוניים
ALTER TABLE Medication DROP CONSTRAINT IF EXISTS chk_medication_price;
ALTER TABLE Medication ADD CONSTRAINT chk_medication_price 
    CHECK (price >= 0);

-- ניסיון הפרה - מחיר שלילי
-- UPDATE Medication SET price = -100 WHERE medication_id = 1;
