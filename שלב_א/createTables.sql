-- ==============================
-- createTables.sql
-- Clinic Database
-- ==============================

-- Table: Department
CREATE TABLE Department (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    floor INT,
    phone VARCHAR(15)
);

-- Table: Doctor
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
CREATE TABLE Visit (
    visit_id SERIAL PRIMARY KEY,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(200),
    treatment VARCHAR(200),
    notes TEXT,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctor(doctor_id)
);

-- Table: Medication
CREATE TABLE Medication (
    medication_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    type VARCHAR(50),
    price NUMERIC(10,2)
);

-- Table: Prescription
CREATE TABLE Prescription (
    prescription_id SERIAL PRIMARY KEY,
    prescription_date DATE NOT NULL,
    dosage VARCHAR(100),
    instructions TEXT,
    duration_days INT CHECK (duration_days > 0),
    visit_id INT REFERENCES Visit(visit_id),
    medication_id INT REFERENCES Medication(medication_id)
);

-- Table: MedicalTest
CREATE TABLE MedicalTest (
    test_id SERIAL PRIMARY KEY,
    test_date DATE NOT NULL,
    test_type VARCHAR(100),
    result VARCHAR(200),
    notes TEXT,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctor(doctor_id)
);

-- Table: InsurancePolicy
CREATE TABLE InsurancePolicy (
    policy_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    policy_number VARCHAR(50) UNIQUE,
    expiry_date DATE NOT NULL,
    coverage_amount NUMERIC(12,2),
    patient_id INT REFERENCES Patient(patient_id)
);