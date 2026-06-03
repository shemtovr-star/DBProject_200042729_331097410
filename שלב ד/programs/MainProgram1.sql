-- ============================================================
-- תוכנית ראשית 1 (Main Program 1)
-- ------------------------------------------------------------
-- בלוק אנונימי DO המזמן פונקציה אחת ופרוצדורה אחת:
--   - fn_institution_summary  (פונקציה 1)
--   - sp_cancel_old_appointments  (פרוצדורה 1)
-- אלמנטים: רשומה (RECORD), קריאה לפונקציה, קריאה לפרוצדורה (CALL)
-- ============================================================

DO $$
DECLARE
    v_summary RECORD;
BEGIN
    RAISE NOTICE '=== Main Program 1 ===';

    -- קריאה לפונקציה 1
    SELECT * INTO v_summary FROM fn_institution_summary(1);
    RAISE NOTICE 'Institution: %, Departments: %, Doctors: %',
                 v_summary.institution_name, v_summary.department_count, v_summary.doctor_count;

    -- קריאה לפרוצדורה 1
    CALL sp_cancel_old_appointments('2026-09-01');

    RAISE NOTICE '=== Done ===';
END;
$$;
