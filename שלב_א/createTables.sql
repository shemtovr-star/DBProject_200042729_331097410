-- ==============================
-- createTables.sql
-- Clinic Database - MediFlow
-- Roy Shem Tov 200042729
-- Ori Winograd 331097410
-- ==============================

-- Table: Department
-- מחלקה רפואית בקליניקה
-- department_id: מזהה ייחודי של המחלקה
-- name: שם המחלקה (קרדיולוגיה, עור וכו')
-- floor: קומה בה נמצאת המחלקה
-- phone: טלפון של המחלקה
CREATE TABLE Department (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    floor INT,
    phone VARCHAR(15)
);

-- Table: Doctor
-- רופא העובד בקליניקה
-- doctor_id: מזהה ייחודי של הרופא
-- first_name: שם פרטי
-- last_name: שם משפחה
-- specialization: התמחות הרופא
-- phone: טלפון אישי
-- email: כתובת מייל ייחודית
-- start_date: תאריך תחילת עבודה
-- department_id: המחלקה בה עובד הרופא (FK)
CREATE TABLE Doctor (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    start_date DATE NOT NULL,
    department_id INT REFERENCES Department(department_id)
);

-- Table: Nurse
-- אחות/אח העובד בקליניקה
-- nurse_id: מזהה ייחודי של האחות
-- first_name: שם פרטי
-- last_name: שם משפחה
-- phone: טלפון אישי
-- email: כתובת מייל ייחודית
-- start_date: תאריך תחילת עבודה
-- department_id: המחלקה בה עובדת האחות (FK)
CREATE TABLE Nurse (
    nurse_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    start_date DATE NOT NULL,
    department_id INT REFERENCES Department(department_id)
);

-- Table: Patient
-- מטופל הרשום בקליניקה
-- patient_id: מזהה ייחודי של המטופל
-- first_name: שם פרטי
-- last_name: שם משפחה
-- birth_date: תאריך לידה (לחישוב גיל)
-- phone: טלפון אישי
-- email: כתובת מייל ייחודית
-- address: כתובת מגורים
CREATE TABLE Patient (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200)
);

-- Table: Appointment
-- תור שנקבע בקליניקה
-- appointment_id: מזהה ייחודי של התור
-- appointment_date: תאריך התור
-- appointment_time: שעת התור
-- status: סטטוס התור (scheduled/completed/cancelled)
-- notes: הערות נוספות
-- patient_id: המטופל שקבע את התור (FK)
-- doctor_id: הרופא אצלו נקבע התור (FK)
CREATE TABLE Appointment (
    appointment_id SERIAL PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) CHECK (status IN ('scheduled','completed','cancelled')),
    notes TEXT,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctor(doctor_id)
);

-- Table: Visit
-- ביקור בפועל של מטופל אצל רופא
-- visit_id: מזהה ייחודי של הביקור
-- visit_date: תאריך הביקור
-- diagnosis: אבחנה רפואית
-- treatment: טיפול שניתן
-- notes: הערות נוספות
-- patient_id: המטופל שביקר (FK)
-- doctor_id: הרופא שטיפל (FK)
CREATE TABLE Visit (
    visit_id SERIAL PRIMARY KEY,
    visit_date DATE NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    notes TEXT,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctor(doctor_id)
);

-- Table: Medication
-- תרופה הקיימת במערכת
-- medication_id: מזהה ייחודי של התרופה
-- name: שם התרופה
-- manufacturer: יצרן התרופה
-- type: סוג התרופה (אנטיביוטיקה, משכך כאבים וכו')
-- price: מחיר התרופה
CREATE TABLE Medication (
    medication_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    type VARCHAR(50),
    price NUMERIC(10,2)
);

-- Table: Prescription
-- מרשם תרופות שניתן למטופל
-- prescription_id: מזהה ייחודי של המרשם
-- prescription_date: תאריך המרשם
-- dosage: מינון התרופה
-- instructions: הוראות שימוש
-- duration_days: מספר ימי הטיפול
-- visit_id: הביקור בו ניתן המרשם (FK)
-- medication_id: התרופה שנרשמה (FK)
CREATE TABLE Prescription (
    prescription_id SERIAL PRIMARY KEY,
    prescription_date DATE NOT NULL,
    dosage TEXT,
    instructions TEXT,
    duration_days INT CHECK (duration_days > 0),
    visit_id INT REFERENCES Visit(visit_id),
    medication_id INT REFERENCES Medication(medication_id)
);

-- Table: MedicalTest
-- בדיקה רפואית שבוצעה למטופל
-- test_id: מזהה ייחודי של הבדיקה
-- test_date: תאריך הבדיקה
-- test_type: סוג הבדיקה (בדיקת דם, צילום רנטגן וכו')
-- result: תוצאת הבדיקה
-- notes: הערות נוספות
-- patient_id: המטופל שעבר את הבדיקה (FK)
-- doctor_id: הרופא שהזמין את הבדיקה (FK)
CREATE TABLE MedicalTest (
    test_id SERIAL PRIMARY KEY,
    test_date DATE NOT NULL,
    test_type VARCHAR(100),
    result TEXT,
    notes TEXT,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctor(doctor_id)
);

-- Table: InsurancePolicy
-- פוליסת ביטוח של מטופל
-- policy_id: מזהה ייחודי של הפוליסה
-- company_name: שם חברת הביטוח
-- policy_number: מספר הפוליסה הייחודי
-- expiry_date: תאריך תפוגת הביטוח
-- coverage_amount: סכום הכיסוי הביטוחי
-- patient_id: המטופל בעל הביטוח (FK)
CREATE TABLE InsurancePolicy (
    policy_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    policy_number VARCHAR(50) UNIQUE,
    expiry_date DATE NOT NULL,
    coverage_amount NUMERIC(12,2),
    patient_id INT REFERENCES Patient(patient_id)
);