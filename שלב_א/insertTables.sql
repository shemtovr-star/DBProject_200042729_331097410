-- ==============================
-- insertTables.sql
-- Clinic Database
-- ==============================

-- שיטה 1: INSERT ידני
-- Department ו-Medication הוכנסו ידנית ב-pgAdmin

-- שיטה 2: Python Script
-- Patient ו-Appointment הוכנסו דרך סקריפט Python
-- ראה תיקיית Programming/generate_data.py

-- שיטה 3: Mockaroo
-- Nurse, Visit, Prescription, MedicalTest, InsurancePolicy
-- הוכנסו דרך Mockaroo
-- ראה תיקיית mockarooFiles

-- כדי לטעון את כל הנתונים מחדש יש להריץ לפי הסדר:
-- 1. createTables.sql
-- 2. קבצי ה-INSERT של Department ו-Medication
-- 3. insertPatients.sql
-- 4. insertAppointments.sql
-- 5. קבצי mockarooFiles