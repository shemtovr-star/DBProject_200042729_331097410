-- ============================================================
-- פונקציה 2: סיכום מטופל (fn_patient_summary)
-- ------------------------------------------------------------
-- מקבלת מזהה מטופל ומחזירה מחרוזת סיכום: שם, גיל מחושב
-- מתאריך הלידה, מספר הביקורים ותאריך הביקור האחרון.
-- אלמנטים: רשומה (RECORD), Exception, הסתעפות (IF/ELSE),
--          cursor סמוי (SELECT INTO), חישוב גיל מתאריך
-- ============================================================

CREATE OR REPLACE FUNCTION fn_patient_summary(p_patient_id INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_patient RECORD;
    v_age INTEGER;
    v_visit_count INTEGER;
    v_last_visit DATE;
BEGIN
    SELECT first_name, last_name, birth_date
    INTO v_patient
    FROM patient
    WHERE patient_id = p_patient_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'מטופל עם מזהה % לא קיים', p_patient_id;
    END IF;

    v_age := EXTRACT(YEAR FROM AGE(CURRENT_DATE, v_patient.birth_date));

    SELECT COUNT(*), MAX(visit_date)
    INTO v_visit_count, v_last_visit
    FROM visit
    WHERE patient_id = p_patient_id;

    IF v_visit_count = 0 THEN
        RETURN format('מטופל: %s %s, גיל %s. אין ביקורים רשומים.',
                      v_patient.first_name, v_patient.last_name, v_age);
    ELSE
        RETURN format('מטופל: %s %s, גיל %s. מספר ביקורים: %s. ביקור אחרון: %s.',
                      v_patient.first_name, v_patient.last_name, v_age,
                      v_visit_count, v_last_visit);
    END IF;
END;
$$;

-- הרצה לדוגמה:
-- SELECT fn_patient_summary(1);
-- SELECT fn_patient_summary(999999);  -- זורק חריגה
