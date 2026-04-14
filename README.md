# מיני פרויקט בסיסי נתונים — קליניקה רפואית

## שער
**מגישים:** Roy Shem Tov (200042729) | Ori Winograd (331097410)
**שם המערכת:** MediFlow — מערכת ניהול קליניקה רפואית
**תאריך הגשה:** 13/04/2026

---

## תוכן עניינים
1. מבוא
2. מסכי המערכת
3. תרשים ERD
4. תרשים DSD
5. החלטות עיצוב
6. שיטות הכנסת נתונים
7. גיבוי ושחזור

---

## 1. מבוא

מערכת MediFlow היא מערכת ניהול קליניקה רפואית המאפשרת ניהול מטופלים, תורים, רופאים ורשומות רפואיות.

**הנתונים הנשמרים במערכת:**
- פרטי מטופלים (שם, תאריך לידה, טלפון, כתובת, ביטוח)
- פרטי רופאים ואחיות (שם, התמחות, מחלקה)
- ניהול תורים (תאריך, שעה, סטטוס)
- ביקורים ואבחנות רפואיות
- מרשמים ותרופות
- בדיקות רפואיות ותוצאותיהן

**הפונקציונאליות העיקרית:**
- קביעת תורים ומעקב אחר סטטוסם
- תיעוד ביקורים ואבחנות
- ניהול מרשמים ותרופות
- צפייה בתוצאות בדיקות
- ניהול ביטוחי מטופלים

---

## 2. מסכי המערכת

המסכים נוצרו בעזרת Google AI Studio.
**לינק לאפליקציה:** https://aistudio.google.com/prompts/190_XYT5-ZDsGzGkIizTEiP0bFTndEfuW

### מסך 1 — ניהול מטופלים
![מסך מטופלים](screenshots/screen1.png)

### מסך 2 — ניהול תורים
![מסך תורים](screenshots/screen2.png)

### מסך 3 — רופאים ומחלקות
![מסך רופאים](screenshots/screen3.png)

### מסך 4 — רשומות רפואיות
![מסך רשומות](screenshots/screen4.png)

---

## 3. תרשים ERD
![ERD](screenshots/ERD.png)

---

## 4. תרשים DSD
![DSD](screenshots/DSD.png)

---

## 5. החלטות עיצוב

- **10 ישויות** — Patient, Doctor, Nurse, Department, Appointment, Visit, Medication, Prescription, MedicalTest, InsurancePolicy
- **שדות DATE משמעותיים** — birth_date, appointment_date, visit_date, test_date, expiry_date, start_date
- **נרמול 3NF** — כל מידע נשמר פעם אחת בלבד בטבלה המתאימה
- **אילוצים** — CHECK על status בטבלת Appointment, NOT NULL על שדות חובה, UNIQUE על email

---

## 6. שיטות הכנסת נתונים

### שיטה 1 — INSERT ידני
הוכנסו נתונים ידנית לטבלאות Department ו-Medication.
![INSERT ידני](screenshots/insert_manual.png)

### שיטה 2 — סקריפט Python
נכתב סקריפט Python שייצר 20,000 רשומות לטבלאות Patient ו-Appointment.
![Python Script](screenshots/insert_python.png)

### שיטה 3 — Mockaroo
הוכנסו נתונים דרך האתר mockaroo.com לטבלאות Nurse, Visit, Prescription, MedicalTest, InsurancePolicy.
![Mockaroo](screenshots/insert_mockaroo.png)

---

## 7. גיבוי ושחזור

בוצע גיבוי של בסיס הנתונים דרך pgAdmin.
שם קובץ הגיבוי: `backup_13_04_2026.backup`
![גיבוי](screenshots/backup.png)
![שחזור](screenshots/restore.png)