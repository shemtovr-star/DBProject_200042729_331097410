-- ============================================================
-- פונקציה 1: סיכום מוסד רפואי (fn_institution_summary)
-- ------------------------------------------------------------
-- מקבלת מזהה מוסד רפואי ומחזירה רשומה עם שם המוסד,
-- מספר המחלקות ומספר הרופאים המשויכים אליו.
-- חוצה את שתי המערכות: medical_institution -> department -> doctor
-- אלמנטים: Exception, הסתעפות (IF), צירוף מרובה טבלאות, RETURN QUERY
-- ============================================================

CREATE OR REPLACE FUNCTION fn_institution_summary(p_institution_id BIGINT)
RETURNS TABLE (
    institution_name VARCHAR,
    department_count BIGINT,
    doctor_count BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM medical_institution
    WHERE institution_id = p_institution_id;

    IF v_exists = 0 THEN
        RAISE EXCEPTION 'מוסד רפואי עם מזהה % לא קיים', p_institution_id;
    END IF;

    RETURN QUERY
    SELECT
        mi.name,
        COUNT(DISTINCT d.department_id),
        COUNT(DISTINCT doc.doctor_id)
    FROM medical_institution mi
    LEFT JOIN department d ON d.institution_id = mi.institution_id
    LEFT JOIN doctor doc ON doc.department_id = d.department_id
    WHERE mi.institution_id = p_institution_id
    GROUP BY mi.name;
END;
$$;

-- הרצה לדוגמה:
-- SELECT * FROM fn_institution_summary(1);
-- SELECT * FROM fn_institution_summary(999999);  -- זורק חריגה
