-- ============================================================
-- פרוצדורה 2: העברת רופאים בין מחלקות (sp_transfer_doctors)
-- ------------------------------------------------------------
-- מעבירה את כל הרופאים ממחלקת מקור למחלקת יעד.
-- כוללת ארבע בדיקות תקינות לפני הביצוע.
-- (ההודעות באנגלית עקב מגבלת כיווניות RTL ב-pgAdmin)
-- אלמנטים: הסתעפויות מרובות (IF), Exception, DML (UPDATE),
--          cursor סמוי (SELECT INTO), RAISE NOTICE, RETURN מוקדם
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_transfer_doctors(p_from_dept INTEGER, p_to_dept INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_from_exists INTEGER;
    v_to_exists INTEGER;
    v_doctor_count INTEGER;
BEGIN
    IF p_from_dept = p_to_dept THEN
        RAISE EXCEPTION 'Source and target department are identical (%)', p_from_dept;
    END IF;

    SELECT COUNT(*) INTO v_from_exists
    FROM department WHERE department_id = p_from_dept;
    IF v_from_exists = 0 THEN
        RAISE EXCEPTION 'Source department % does not exist', p_from_dept;
    END IF;

    SELECT COUNT(*) INTO v_to_exists
    FROM department WHERE department_id = p_to_dept;
    IF v_to_exists = 0 THEN
        RAISE EXCEPTION 'Target department % does not exist', p_to_dept;
    END IF;

    SELECT COUNT(*) INTO v_doctor_count
    FROM doctor WHERE department_id = p_from_dept;
    IF v_doctor_count = 0 THEN
        RAISE NOTICE 'No doctors in department % to transfer', p_from_dept;
        RETURN;
    END IF;

    UPDATE doctor
    SET department_id = p_to_dept
    WHERE department_id = p_from_dept;

    RAISE NOTICE 'Transferred % doctors from department % to department %', v_doctor_count, p_from_dept, p_to_dept;
END;
$$;

-- הרצה לדוגמה:
-- CALL sp_transfer_doctors(1, 2);
-- CALL sp_transfer_doctors(3, 999);  -- זורק חריגה
