CREATE INDEX idx_patient_name ON Patient(last_name, first_name);
CREATE INDEX idx_appointment_date_doctor ON Appointment(appointment_date, doctor_id);
CREATE INDEX idx_insurance_expiry ON InsurancePolicy(expiry_date);