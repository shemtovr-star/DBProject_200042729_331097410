-- Views.sql

-- ==========================================
-- View 1: נקודת המבט של הקליניקה המקורית (מערכת א')
-- היסטוריית טיפולים: משלב מידע על מטופלים, ביקורים והרופא המטפל
-- ==========================================
CREATE OR REPLACE VIEW v_patient_visits_history AS
SELECT 
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    v.visit_date,
    v.diagnosis,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name
FROM Patient p
JOIN Visit v ON p.patient_id = v.patient_id
JOIN Doctor d ON v.doctor_id = d.doctor_id;

-- שאילתא 1 על המבט הראשון: שליפת היסטוריית טיפולים
SELECT * FROM v_patient_visits_history LIMIT 5;

-- שאילתא 2 על המבט הראשון: ספירת ביקורים לכל רופא
SELECT doctor_last_name, COUNT(*) as total_visits
FROM v_patient_visits_history
GROUP BY doctor_last_name LIMIT 5;


-- ==========================================
-- View 2: נקודת המבט של מחלקת הבינוי (מערכת b)
-- מעקב פרויקטים: מידע על הפרויקטים, המוסדות ואבני הדרך
-- ==========================================
CREATE OR REPLACE VIEW v_project_progress AS
SELECT 
    proj.project_id,
    proj.project_name,
    inst.name AS institution_name,
    proj.target_end_date,
    m.milestone_status
FROM project proj
JOIN medical_institution inst ON proj.institution_id = inst.institution_id
LEFT JOIN milestone m ON proj.project_id = m.project_id;

-- שאילתא 1 על המבט השני: פרויקטים עתידיים
SELECT project_name, institution_name, target_end_date 
FROM v_project_progress 
ORDER BY target_end_date ASC LIMIT 5;

-- שאילתא 2 על המבט השני: כמות אבני דרך לפי סטטוס
SELECT milestone_status, COUNT(*) as amount
FROM v_project_progress
WHERE milestone_status IS NOT NULL
GROUP BY milestone_status LIMIT 5;


-- ==========================================
-- View 3: אינטגרציה - נקודת המבט המשולבת!
-- מיפוי רופאים ומחלקות לפי מוסדות רפואיים פיזיים
-- ==========================================
CREATE OR REPLACE VIEW v_institution_clinical_staff AS
SELECT 
    inst.institution_id,
    inst.name AS institution_name,
    dept.department_id,
    dept.name AS department_name,
    doc.first_name AS doctor_fname,
    doc.last_name AS doctor_lname
FROM medical_institution inst
JOIN Department dept ON inst.institution_id = dept.institution_id
JOIN Doctor doc ON dept.department_id = doc.department_id;

-- שאילתא 1 on המבט המשולב: סיכום כמות רופאים לכל מוסד
SELECT institution_name, COUNT(doctor_lname) AS total_doctors
FROM v_institution_clinical_staff
GROUP BY institution_name LIMIT 5;

-- שאילתא 2 on המבט המשולב: מיפוי מחלקות ורופאים במוסדות
SELECT institution_name, department_name, doctor_lname
FROM v_institution_clinical_staff 
ORDER BY institution_name LIMIT 5;