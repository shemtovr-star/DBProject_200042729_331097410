ALTER TABLE Patient ADD CONSTRAINT chk_patient_birth_date CHECK (birth_date <= CURRENT_DATE);
ALTER TABLE Appointment ADD CONSTRAINT chk_appointment_time CHECK (appointment_time >= '08:00:00' AND appointment_time <= '20:00:00');
ALTER TABLE Medication ADD CONSTRAINT chk_medication_price CHECK (price >= 0);