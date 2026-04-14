-- ==============================
-- dropTables.sql
-- Clinic Database
-- ==============================

-- חשוב: סדר המחיקה הפוך מסדר היצירה
-- כי צריך למחוק קודם טבלאות שתלויות באחרות

DROP TABLE IF EXISTS InsurancePolicy;
DROP TABLE IF EXISTS MedicalTest;
DROP TABLE IF EXISTS Prescription;
DROP TABLE IF EXISTS Medication;
DROP TABLE IF EXISTS Visit;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Nurse;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Department;