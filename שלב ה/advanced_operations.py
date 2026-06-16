import tkinter as tk
from tkinter import messagebox
import pg8000.native

def get_db_connection():
    return pg8000.native.Connection(
        host="localhost",
        database="clinic_db",
        user="postgres",
        password="1234"
    )

# --- פונקציות להפעלת התוכניות מתוך בסיס הנתונים ---
def run_fn_inst():
    val = ent_inst.get()
    if not val: return
    try:
        conn = get_db_connection()
        res = conn.run("SELECT * FROM fn_institution_summary(:id)", id=int(val))
        conn.close()
        if res:
            text = f"שם המוסד: {res[0][0]}\nכמות מחלקות: {res[0][1]}\nכמות רופאים: {res[0][2]}"
            messagebox.showinfo("סיכום מוסד רפואי", text)
    except Exception as e:
        messagebox.showerror("שגיאה", str(e))

def run_fn_patient():
    val = ent_pat.get()
    if not val: return
    try:
        conn = get_db_connection()
        res = conn.run("SELECT fn_patient_summary(:id)", id=int(val))
        conn.close()
        if res:
            messagebox.showinfo("סיכום מטופל", res[0][0])
    except Exception as e:
        messagebox.showerror("שגיאה", str(e))

def run_sp_cancel():
    val = ent_date.get()
    if not val: return
    try:
        conn = get_db_connection()
        conn.run("CALL sp_cancel_old_appointments(:d)", d=val)
        conn.close()
        messagebox.showinfo("הצלחה", f"פרוצדורת ביטול תורים (לפני התאריך {val}) הופעלה בהצלחה בבסיס הנתונים!")
    except Exception as e:
        messagebox.showerror("שגיאה", str(e))

def run_sp_transfer():
    f_dep = ent_from.get()
    t_dep = ent_to.get()
    if not f_dep or not t_dep: return
    try:
        conn = get_db_connection()
        conn.run("CALL sp_transfer_doctors(:f, :t)", f=int(f_dep), t=int(t_dep))
        conn.close()
        messagebox.showinfo("הצלחה", f"הפרוצדורה הופעלה: הרופאים הועברו בהצלחה ממחלקה {f_dep} למחלקה {t_dep}!")
    except Exception as e:
        messagebox.showerror("שגיאה", str(e))

# --- עיצוב המסך ---
root = tk.Tk()
root.title("פעולות מתקדמות - שלב ד'")
root.geometry("650x400")
root.configure(bg="#f0f4f8")

tk.Label(root, text="הפעלת לוגיקה עסקית (פונקציות ופרוצדורות)", font=("Arial", 16, "bold"), bg="#f0f4f8").pack(pady=20)

frame = tk.Frame(root, bg="#f0f4f8")
frame.pack(pady=10)

# פונקציה 1
tk.Label(frame, text="ID מוסד רפואי:", bg="#f0f4f8").grid(row=0, column=0, pady=10, sticky="e")
ent_inst = tk.Entry(frame, width=10)
ent_inst.grid(row=0, column=1, padx=10)
tk.Button(frame, text="הפעל פונקציית סיכום מוסד", command=run_fn_inst, bg="#3498db", fg="white", width=25).grid(row=0, column=2)

# פונקציה 2
tk.Label(frame, text="ID מטופל:", bg="#f0f4f8").grid(row=1, column=0, pady=10, sticky="e")
ent_pat = tk.Entry(frame, width=10)
ent_pat.grid(row=1, column=1, padx=10)
tk.Button(frame, text="הפעל פונקציית סיכום מטופל", command=run_fn_patient, bg="#3498db", fg="white", width=25).grid(row=1, column=2)

# פרוצדורה 1
tk.Label(frame, text="תאריך (YYYY-MM-DD):", bg="#f0f4f8").grid(row=2, column=0, pady=10, sticky="e")
ent_date = tk.Entry(frame, width=15)
ent_date.grid(row=2, column=1, padx=10)
tk.Button(frame, text="בטל תורים ישנים (פרוצדורה)", command=run_sp_cancel, bg="#e74c3c", fg="white", width=25).grid(row=2, column=2)

# פרוצדורה 2
tk.Label(frame, text="ממחלקה (ID):", bg="#f0f4f8").grid(row=3, column=0, pady=10, sticky="e")
ent_from = tk.Entry(frame, width=5)
ent_from.grid(row=3, column=1, sticky="w", padx=5)
tk.Label(frame, text="למחלקה:", bg="#f0f4f8").grid(row=3, column=1, sticky="e", padx=5)
ent_to = tk.Entry(frame, width=5)
ent_to.grid(row=3, column=2, sticky="w", padx=5)
tk.Button(frame, text="העבר רופאים (פרוצדורה)", command=run_sp_transfer, bg="#2ecc71", fg="white", width=25).grid(row=3, column=3, padx=10)

root.mainloop()