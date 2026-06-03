-- ============================================================
-- תוכנית ראשית 2 (Main Program 2)
-- ------------------------------------------------------------
-- בלוק אנונימי DO המזמן פונקציה אחת ופרוצדורה אחת:
--   - fn_patient_summary  (פונקציה 2)
--   - sp_transfer_doctors  (פרוצדורה 2)
-- אלמנטים: משתנה TEXT, קריאה לפונקציה, קריאה לפרוצדורה (CALL)
-- ============================================================

DO $$
DECLARE
    v_patient_info TEXT;
BEGIN
    RAISE NOTICE '=== Main Program 2 ===';

    -- קריאה לפונקציה 2
    v_patient_info := fn_patient_summary(5);
    RAISE NOTICE 'Patient summary: %', v_patient_info;

    -- קריאה לפרוצדורה 2
    CALL sp_transfer_doctors(5, 6);

    RAISE NOTICE '=== Done ===';
END;
$$;
