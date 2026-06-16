import tkinter as tk
from tkinter import ttk, messagebox
import pg8000.native


# --- התחברות למסד הנתונים ---
def get_db_connection():
    return pg8000.native.Connection(
        host="localhost",
        database="clinic_db",
        user="postgres",
        password="1234"
    )


# --- הגדרת החלון ---
root = tk.Tk()
root.title("ניהול רופאים - CRUD")
root.geometry("850x600")
root.configure(bg="#f0f4f8")

# --- כותרת ---
tk.Label(root, text="מסך ניהול רופאים (Doctor)", font=("Arial", 16, "bold"), bg="#f0f4f8").pack(pady=10)

# ==========================================
# 1. אזור תצוגת הנתונים (READ)
# ==========================================
# הגדרת העמודות - שים לב שאנחנו מציגים את שם המחלקה במקום ה-ID (לפי דרישת המרצה)
columns = ("doctor_id", "first_name", "last_name", "specialization", "department_name")
tree = ttk.Treeview(root, columns=columns, show="headings", height=8)

tree.heading("doctor_id", text="ID רופא")
tree.heading("first_name", text="שם פרטי")
tree.heading("last_name", text="שם משפחה")
tree.heading("specialization", text="התמחות")
tree.heading("department_name", text="שם מחלקה (ולא מספר!)")

tree.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

# ==========================================
# 2. אזור הטופס (להזנת נתונים לעדכון והוספה)
# ==========================================
form_frame = tk.Frame(root, bg="#f0f4f8")
form_frame.pack(pady=10)

# שורת שדות ראשונה
tk.Label(form_frame, text="ID רופא:", bg="#f0f4f8").grid(row=0, column=0, padx=5, pady=5)
ent_id = tk.Entry(form_frame, width=10)
ent_id.grid(row=0, column=1, padx=5, pady=5)

tk.Label(form_frame, text="שם פרטי:", bg="#f0f4f8").grid(row=0, column=2, padx=5, pady=5)
ent_first = tk.Entry(form_frame, width=15)
ent_first.grid(row=0, column=3, padx=5, pady=5)

tk.Label(form_frame, text="שם משפחה:", bg="#f0f4f8").grid(row=0, column=4, padx=5, pady=5)
ent_last = tk.Entry(form_frame, width=15)
ent_last.grid(row=0, column=5, padx=5, pady=5)

# שורת שדות שנייה
tk.Label(form_frame, text="התמחות:", bg="#f0f4f8").grid(row=1, column=0, padx=5, pady=5)
ent_spec = tk.Entry(form_frame, width=15)
ent_spec.grid(row=1, column=1, columnspan=3, sticky="w", padx=5, pady=5)

tk.Label(form_frame, text="ID מחלקה (לעדכון):", bg="#f0f4f8").grid(row=1, column=4, padx=5, pady=5)
ent_dept = tk.Entry(form_frame, width=10)
ent_dept.grid(row=1, column=5, padx=5, pady=5)


# ==========================================
# 3. הלוגיקה של בסיס הנתונים (הפונקציות)
# ==========================================

def load_data():
    """קורא את הנתונים מבסיס הנתונים ומציג בטבלה"""
    # מחיקת נתונים ישנים מהמסך
    for row in tree.get_children():
        tree.delete(row)

    try:
        conn = get_db_connection()
        # השאילתה מביאה את השם של המחלקה מהטבלה השנייה כדי שלא נראה סתם מספרים
        query = """
        SELECT d.doctor_id, d.first_name, d.last_name, d.specialization, dep.name
        FROM doctor d
        LEFT JOIN department dep ON d.department_id = dep.department_id
        ORDER BY d.doctor_id;
        """
        for r in conn.run(query):
            tree.insert("", tk.END, values=r)
        conn.close()
    except Exception as e:
        messagebox.showerror("שגיאה", f"לא ניתן לטעון נתונים: {e}")


def fetch_for_update():
    """הדרישה הייעודית מהדוח: המשתמש מזין מפתח (ID) והמערכת מביאה את שאר השדות"""
    doc_id = ent_id.get()
    if not doc_id:
        messagebox.showwarning("אזהרה", "נא להזין ID רופא בשדה כדי לשלוף את הנתונים שלו.")
        return

    try:
        conn = get_db_connection()
        query = "SELECT first_name, last_name, specialization, department_id FROM doctor WHERE doctor_id = :id"
        result = conn.run(query, id=int(doc_id))
        conn.close()

        if result:
            # מילוי אוטומטי של השדות במסך
            ent_first.delete(0, tk.END);
            ent_first.insert(0, result[0][0])
            ent_last.delete(0, tk.END);
            ent_last.insert(0, result[0][1])
            ent_spec.delete(0, tk.END);
            ent_spec.insert(0, result[0][2])
            ent_dept.delete(0, tk.END);
            ent_dept.insert(0, str(result[0][3]))
            messagebox.showinfo("הצלחה", "הנתונים נשלפו. כעת תוכל לשנות אותם וללחוץ 'שמור עדכון'.")
        else:
            messagebox.showerror("שגיאה", "לא נמצא רופא עם ה-ID הזה.")
    except Exception as e:
        messagebox.showerror("שגיאה", f"שגיאה בשליפה: {e}")


def execute_update():
    """שומר את השינויים (UPDATE)"""
    try:
        conn = get_db_connection()
        query = """UPDATE doctor 
                   SET first_name = :f, last_name = :l, specialization = :s, department_id = :d 
                   WHERE doctor_id = :id"""
        conn.run(query, f=ent_first.get(), l=ent_last.get(), s=ent_spec.get(), d=int(ent_dept.get()),
                 id=int(ent_id.get()))
        conn.close()
        load_data()
        messagebox.showinfo("עודכן", "פרטי הרופא עודכנו בהצלחה!")
    except Exception as e:
        messagebox.showerror("שגיאה בעדכון", str(e))


def execute_insert():
    """הוספת רופא חדש (INSERT)"""
    try:
        conn = get_db_connection()
        query = """INSERT INTO doctor (doctor_id, first_name, last_name, specialization, department_id) 
                   VALUES (:id, :f, :l, :s, :d)"""
        conn.run(query, id=int(ent_id.get()), f=ent_first.get(), l=ent_last.get(), s=ent_spec.get(),
                 d=int(ent_dept.get()))
        conn.close()
        load_data()
        messagebox.showinfo("נוסף", "רופא חדש נוסף למערכת בהצלחה!")
    except Exception as e:
        messagebox.showerror("שגיאה בהוספה", str(e))


def execute_delete():
    """מחיקת רופא (DELETE)"""
    try:
        conn = get_db_connection()
        query = "DELETE FROM doctor WHERE doctor_id = :id"
        conn.run(query, id=int(ent_id.get()))
        conn.close()
        load_data()
        messagebox.showinfo("נמחק", "הרופא הוסר מהמערכת.")
    except Exception as e:
        messagebox.showerror("שגיאה במחיקה", str(e))


# ==========================================
# 4. כפתורי הפעולות (GUI)
# ==========================================
btn_frame = tk.Frame(root, bg="#f0f4f8")
btn_frame.pack(pady=20)

tk.Button(btn_frame, text="טען נתונים מחדש", command=load_data, bg="#3498db", fg="white", width=15).grid(row=0,
                                                                                                         column=0,
                                                                                                         padx=5)
tk.Button(btn_frame, text="הבא נתונים לעדכון", command=fetch_for_update, bg="#f39c12", fg="white", width=15).grid(row=0,
                                                                                                                  column=1,
                                                                                                                  padx=5)
tk.Button(btn_frame, text="שמור עדכון", command=execute_update, bg="#2ecc71", fg="white", width=15).grid(row=0,
                                                                                                         column=2,
                                                                                                         padx=5)
tk.Button(btn_frame, text="הוסף רופא חדש", command=execute_insert, bg="#9b59b6", fg="white", width=15).grid(row=0,
                                                                                                            column=3,
                                                                                                            padx=5)
tk.Button(btn_frame, text="מחק רופא", command=execute_delete, bg="#e74c3c", fg="white", width=15).grid(row=0, column=4,
                                                                                                       padx=5)

# טעינת הנתונים בפעם הראשונה שהחלון נפתח
load_data()

root.mainloop()