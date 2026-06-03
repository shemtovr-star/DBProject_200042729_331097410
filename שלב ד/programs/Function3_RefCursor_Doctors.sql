-- ============================================================
-- פונקציית עזר 3: רופאים לפי מחלקה - Ref Cursor
-- (fn_doctors_by_department)
-- ------------------------------------------------------------
-- מקבלת מזהה מחלקה ושם cursor, פותחת cursor על כל הרופאים
-- במחלקה, ומחזירה אותו (refcursor) לקריאה חיצונית.
-- מכסה את דרישת "החזרת Ref Cursor" (סעיף b).
-- אלמנטים: Ref Cursor (refcursor), OPEN FOR, החזרת מצביע
-- ============================================================

CREATE OR REPLACE FUNCTION fn_doctors_by_department(p_department_id INTEGER, p_cursor refcursor)
RETURNS refcursor
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT doctor_id, first_name, last_name, specialization
        FROM doctor
        WHERE department_id = p_department_id;
    RETURN p_cursor;
END;
$$;

-- הרצה לדוגמה (בתוך טרנזקציה):
-- BEGIN;
-- SELECT fn_doctors_by_department(2, 'doctor_cur');
-- FETCH ALL IN doctor_cur;
-- COMMIT;
