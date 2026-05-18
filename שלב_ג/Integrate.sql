-- Integrate.sql

-- 1. הוספת עמודת הקישור לטבלת המחלקות שלכם
ALTER TABLE Department 
ADD COLUMN institution_id BIGINT;

-- 2. עדכון זמני של המחלקות כדי שיצביעו למוסד הראשון הקיים במערכת של הזוג השני
UPDATE Department 
SET institution_id = (SELECT MIN(institution_id) FROM medical_institution);

-- 3. הגדרת העמודה כמפתח זר המקשר בין המערכות לשמירת שלמות הנתונים
ALTER TABLE Department 
ADD CONSTRAINT fk_dept_institution 
FOREIGN KEY (institution_id) REFERENCES medical_institution(institution_id);