import tkinter as tk
from tkinter import ttk, messagebox
import pg8000.native

def get_db_connection():
    return pg8000.native.Connection(
        host="localhost", database="clinic_db", user="postgres", password="1234"
    )

root = tk.Tk()
root.title("ניהול תורים - CRUD")
root.geometry("900x600")
root.configure(bg="#f0f4f8")

# --- עמודות הטבלה (עם שמות ולא רק ID) ---
columns = ("app_id", "patient_name", "doctor_name", "date", "status")
tree = ttk.Treeview(root, columns=columns, show="headings", height=8)
tree.heading("app_id", text="תור ID")
tree.heading("patient_name", text="מטופל")
tree.heading("doctor_name", text="רופא")
tree.heading("date", text="תאריך")
tree.heading("status", text="סטטוס")
tree.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

# --- שדות קלט ---
form_frame = tk.Frame(root, bg="#f0f4f8")
form_frame.pack(pady=10)

tk.Label(form_frame, text="תור ID:", bg="#f0f4f8").grid(row=0, column=0); ent_id = tk.Entry(form_frame, width=10); ent_id.grid(row=0, column=1)
tk.Label(form_frame, text="מטופל ID:", bg="#f0f4f8").grid(row=0, column=2); ent_pid = tk.Entry(form_frame, width=10); ent_pid.grid(row=0, column=3)
tk.Label(form_frame, text="רופא ID:", bg="#f0f4f8").grid(row=0, column=4); ent_did = tk.Entry(form_frame, width=10); ent_did.grid(row=0, column=5)
tk.Label(form_frame, text="תאריך (YYYY-MM-DD):", bg="#f0f4f8").grid(row=1, column=0); ent_date = tk.Entry(form_frame, width=15); ent_date.grid(row=1, column=1)
tk.Label(form_frame, text="סטטוס:", bg="#f0f4f8").grid(row=1, column=2); ent_stat = tk.Entry(form_frame, width=15); ent_stat.grid(row=1, column=3)

# --- פונקציות ---
def load_data():
    for row in tree.get_children(): tree.delete(row)
    conn = get_db_connection()
    query = """
    SELECT a.appointment_id, p.first_name || ' ' || p.last_name, d.first_name || ' ' || d.last_name, a.appointment_date, a.status
    FROM appointment a
    JOIN patient p ON a.patient_id = p.patient_id
    JOIN doctor d ON a.doctor_id = d.doctor_id
    ORDER BY a.appointment_date;
    """
    for r in conn.run(query):
        tree.insert("", tk.END, values=r)
    conn.close()

def execute_update():
    try:
        conn = get_db_connection()
        conn.run("UPDATE appointment SET patient_id=:p, doctor_id=:d, appointment_date=:dt, status=:s WHERE appointment_id=:id",
                 p=int(ent_pid.get()), d=int(ent_did.get()), dt=ent_date.get(), s=ent_stat.get(), id=int(ent_id.get()))
        conn.close(); load_data(); messagebox.showinfo("עדכון", "התור עודכן")
    except Exception as e:
        messagebox.showerror("שגיאה", str(e))

# --- כפתורים ---
btn_frame = tk.Frame(root, bg="#f0f4f8"); btn_frame.pack(pady=20)
tk.Button(btn_frame, text="טען נתונים", command=load_data).grid(row=0, column=0)
tk.Button(btn_frame, text="שמור עדכון", command=execute_update).grid(row=0, column=1)

load_data()
root.mainloop()