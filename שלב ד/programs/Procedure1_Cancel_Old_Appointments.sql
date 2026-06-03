-- ============================================================
-- פרוצדורה 1: ביטול תורים ישנים (sp_cancel_old_appointments)
-- ------------------------------------------------------------
-- עוברת על כל התורים המתוכננים (scheduled) שתאריכם לפני
-- התאריך שהתקבל, ומשנה את הסטטוס שלהם ל-cancelled.
-- אלמנטים: cursor מפורש (OPEN/FETCH/CLOSE), לולאה (LOOP),
--          DML (UPDATE), רשומה (RECORD), RAISE NOTICE
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_cancel_old_appointments(p_before_date DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    cur_appointments CURSOR FOR
        SELECT appointment_id, appointment_date
        FROM appointment
        WHERE status = 'scheduled'
          AND appointment_date < p_before_date;

    v_appointment RECORD;
    v_count INTEGER := 0;
BEGIN
    OPEN cur_appointments;
    LOOP
        FETCH cur_appointments INTO v_appointment;
        EXIT WHEN NOT FOUND;

        UPDATE appointment
        SET status = 'cancelled'
        WHERE appointment_id = v_appointment.appointment_id;

        v_count := v_count + 1;
    END LOOP;
    CLOSE cur_appointments;

    RAISE NOTICE 'בוטלו % תורים שתאריכם לפני %', v_count, p_before_date;
END;
$$;

-- הרצה לדוגמה:
-- CALL sp_cancel_old_appointments('2026-09-01');
