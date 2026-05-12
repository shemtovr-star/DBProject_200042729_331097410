-- ==========================================
-- שלב ב' - פרויקט מסדי נתונים: clinic_db
-- קובץ תיעוד שינויי טבלאות (ALTER TABLE)
-- ==========================================
-- הערה: כל השינויים כאן בוצעו במהלך שלב ב' כדי לתמוך
-- בשאילתות, אילוצים ואינדקסים שנדרשו.

-- ==========================================
-- שינויים בטבלת Patient
-- ==========================================
-- הוספת שדות first_name ו-last_name (במקום name)
-- הוספת phone, email, address

-- ALTER TABLE Patient ADD COLUMN first_name VARCHAR(50);
-- ALTER TABLE Patient ADD COLUMN last_name VARCHAR(50);
-- ALTER TABLE Patient ADD COLUMN phone VARCHAR(15);
-- ALTER TABLE Patient ADD COLUMN email VARCHAR(100);
-- ALTER TABLE Patient ADD COLUMN address VARCHAR(200);


-- ==========================================
-- שינויים בטבלת Doctor
-- ==========================================
-- שינוי name ל-first_name + last_name
-- שינוי specialty ל-specialization

-- ALTER TABLE Doctor ADD COLUMN first_name VARCHAR(50);
-- ALTER TABLE Doctor ADD COLUMN last_name VARCHAR(50);
-- ALTER TABLE Doctor RENAME COLUMN specialty TO specialization;


-- ==========================================
-- שינויים בטבלת Nurse
-- ==========================================
-- הוספת first_name, last_name, email

-- ALTER TABLE Nurse ADD COLUMN first_name VARCHAR(50);
-- ALTER TABLE Nurse ADD COLUMN last_name VARCHAR(50);
-- ALTER TABLE Nurse ADD COLUMN email VARCHAR(100);


-- ==========================================
-- שינויים בטבלת Appointment
-- ==========================================
-- הוספת status (scheduled/completed/cancelled)
-- הוספת appointment_time (לאילוץ שעות פעילות)
-- הוספת notes

-- ALTER TABLE Appointment ADD COLUMN status VARCHAR(20);
-- ALTER TABLE Appointment ADD COLUMN appointment_time TIME;
-- ALTER TABLE Appointment ADD COLUMN notes TEXT;


-- ==========================================
-- שינויים בטבלת Visit
-- ==========================================
-- הוספת visit_id (PK), patient_id, doctor_id

-- ALTER TABLE Visit ADD COLUMN visit_id SERIAL PRIMARY KEY;
-- ALTER TABLE Visit ADD COLUMN patient_id INTEGER REFERENCES Patient(patient_id);
-- ALTER TABLE Visit ADD COLUMN doctor_id INTEGER REFERENCES Doctor(doctor_id);


-- ==========================================
-- שינויים בטבלת Medication
-- ==========================================
-- הוספת manufacturer, type, price

-- ALTER TABLE Medication ADD COLUMN manufacturer VARCHAR(100);
-- ALTER TABLE Medication ADD COLUMN type VARCHAR(50);
-- ALTER TABLE Medication ADD COLUMN price NUMERIC(10,2);


-- ==========================================
-- שינויים בטבלת Prescription
-- ==========================================
-- הוספת prescription_id (PK), visit_id, duration_days, instructions

-- ALTER TABLE Prescription ADD COLUMN prescription_id SERIAL PRIMARY KEY;
-- ALTER TABLE Prescription ADD COLUMN visit_id INTEGER REFERENCES Visit(visit_id);
-- ALTER TABLE Prescription ADD COLUMN duration_days INTEGER;
-- ALTER TABLE Prescription ADD COLUMN instructions TEXT;
-- ALTER TABLE Prescription ADD COLUMN prescription_date DATE;


-- ==========================================
-- שינויים בטבלת MedicalTest
-- ==========================================
-- הוספת test_id (PK)

-- ALTER TABLE MedicalTest ADD COLUMN test_id SERIAL PRIMARY KEY;


-- ==========================================
-- שינויים בטבלת InsurancePolicy
-- ==========================================
-- הוספת policy_id (PK), patient_id, company_name, coverage_amount

-- ALTER TABLE InsurancePolicy ADD COLUMN policy_id SERIAL PRIMARY KEY;
-- ALTER TABLE InsurancePolicy ADD COLUMN patient_id INTEGER REFERENCES Patient(patient_id);
-- ALTER TABLE InsurancePolicy ADD COLUMN company_name VARCHAR(100);
-- ALTER TABLE InsurancePolicy ADD COLUMN coverage_amount NUMERIC(12,2);


-- הערה: הפקודות מוצגות כהערות כי הן כבר בוצעו בבסיס הנתונים.
-- הקובץ הזה משמש לתיעוד בלבד.
