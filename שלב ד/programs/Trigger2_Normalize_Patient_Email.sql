-- ============================================================
-- טריגר 2: נורמליזציית אימייל מטופל (על INSERT)
-- ------------------------------------------------------------
-- לפני הוספת מטופל חדש, ממיר את האימייל לאותיות קטנות
-- ומסיר רווחים מיותרים. מונע כפילויות וחוסר אחידות בנתונים.
-- אלמנטים: פונקציית טריגר, NEW, הסתעפות (IF), פונקציות מחרוזת
-- ============================================================

CREATE OR REPLACE FUNCTION trg_normalize_patient_email()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.email IS NOT NULL THEN
        NEW.email := LOWER(TRIM(NEW.email));
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tr_patient_email_normalize
BEFORE INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION trg_normalize_patient_email();

-- הרצה לדוגמה:
-- INSERT INTO patient (patient_id, first_name, last_name, birth_date, email)
-- VALUES (90001, 'Test', 'User', '1990-05-15', '  TEST.USER@EXAMPLE.COM  ');
-- SELECT patient_id, email FROM patient WHERE patient_id = 90001;  -- האימייל יהיה קטן
