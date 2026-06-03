-- ============================================================
-- טריגר 1: בדיקת תאריך תור (על UPDATE)
-- ------------------------------------------------------------
-- לפני כל עדכון של תור, בודק שהתאריך החדש אינו בעבר.
-- אם מנסים לקבוע תאריך שעבר - נזרקת חריגה והעדכון נחסם.
-- אלמנטים: פונקציית טריגר, NEW, הסתעפות (IF), Exception
-- זהו הטריגר הנדרש "בזמן UPDATE".
-- ============================================================

CREATE OR REPLACE FUNCTION trg_check_appointment_date()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.appointment_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Cannot set appointment date % in the past', NEW.appointment_date;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tr_appointment_date_check
BEFORE UPDATE ON appointment
FOR EACH ROW
EXECUTE FUNCTION trg_check_appointment_date();

-- הרצה לדוגמה:
-- UPDATE appointment SET appointment_date = '2020-01-01' WHERE appointment_id = 20001;  -- נחסם
-- UPDATE appointment SET appointment_date = '2027-01-01' WHERE appointment_id = 20001;  -- עובר
