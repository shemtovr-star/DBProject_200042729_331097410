-- חלק 1: ROLLBACK
SELECT doctor_id, specialization FROM Doctor WHERE doctor_id = 1;
BEGIN;
UPDATE Doctor SET specialization = 'Unknown' WHERE doctor_id = 1;
SELECT doctor_id, specialization FROM Doctor WHERE doctor_id = 1;
ROLLBACK;
SELECT doctor_id, specialization FROM Doctor WHERE doctor_id = 1;

-- חלק 2: COMMIT
SELECT appointment_id, status FROM Appointment WHERE appointment_id = 1;
BEGIN;
UPDATE Appointment SET status = 'cancelled' WHERE appointment_id = 1;
COMMIT;
SELECT appointment_id, status FROM Appointment WHERE appointment_id = 1;