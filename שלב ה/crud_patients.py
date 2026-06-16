import tkinter as tk
from tkinter import ttk, messagebox
import pg8000.native

def get_db_connection():
    return pg8000.native.Connection(
        host="localhost", database="clinic_db", user="postgres", password="1234"
    )

root = tk.Tk()
root.title("ניהול מטופלים - CRUD")
root.geometry("850x600")
root.configure(bg="#f0f4f8")

# --- עמודות הטבלה ---
columns = ("patient_id", "first_name", "last_name", "birth_date", "email")
tree = ttk.Treeview(root, columns=columns, show="headings", height=8)
tree.heading("patient_id", text="מטופל ID")
tree.heading("first_name", text="שם פרטי")
tree.heading("last_name", text="שם משפחה")
tree.heading("birth_date", text="תאריך לידה")
tree.heading("email", text="אימייל")
tree.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

# --- שדות קלט ---
form_frame = tk.Frame(root, bg="#f0f4f8")
form_frame.pack(pady=10)

tk.Label(form_frame, text="ID:", bg="#f0f4f8").grid(row=0, column=0); ent_id = tk.Entry(form_frame, width=10); ent_id.grid(row=0, column=1)
tk.Label(form_frame, text="שם פרטי:", bg="#f0f4f8").grid(row=0, column=2); ent_fn = tk.Entry(form_frame, width=15); ent_fn.grid(row=0, column=3)
tk.Label(form_frame, text="שם משפחה:", bg="#f0f4f8").grid(row=0, column=4); ent_ln = tk.Entry(form_frame, width=15); ent_ln.grid(row=0, column=5)
tk.Label(form_frame, text="תאריך לידה (YYYY-MM-DD):", bg="#f0f4f8").grid(row=1, column=0); ent_bd = tk.Entry(form_frame, width=15); ent_bd.grid(row=1, column=1)
tk.Label(form_frame, text="אימייל:", bg="#f0f4f8").grid(row=1, column=2); ent_em = tk.Entry(form_frame, width=20); ent_em.grid(row=1, column=3)

# --- פונקציות ---
def load_data():
    for row in tree.get_children(): tree.delete(row)
    conn = get_db_connection()
    for r in conn.run("SELECT patient_id, first_name, last_name, birth_date, email FROM patient ORDER BY patient_id"):
        tree.insert("", tk.END, values=r)
    conn.close()

def fetch_for_update():
    pid = ent_id.get()
    conn = get_db_connection()
    res = conn.run("SELECT first_name, last_name, birth_date, email FROM patient WHERE patient_id = :id", id=int(pid))
    conn.close()
    if res:
        ent_fn.delete(0, tk.END); ent_fn.insert(0, res[0][0])
        ent_ln.delete(0, tk.END); ent_ln.insert(0, res[0][1])
        ent_bd.delete(0, tk.END); ent_bd.insert(0, str(res[0][2]))
        ent_em.delete(0, tk.END); ent_em.insert(0, res[0][3])

def execute_update():
    conn = get_db_connection()
    conn.run("UPDATE patient SET first_name=:f, last_name=:l, birth_date=:b, email=:e WHERE patient_id=:id",
             f=ent_fn.get(), l=ent_ln.get(), b=ent_bd.get(), e=ent_em.get(), id=int(ent_id.get()))
    conn.close(); load_data(); messagebox.showinfo("עדכון", "המטופל עודכן")

# --- כפתורים ---
btn_frame = tk.Frame(root, bg="#f0f4f8"); btn_frame.pack(pady=20)
tk.Button(btn_frame, text="טען נתונים", command=load_data).grid(row=0, column=0)
tk.Button(btn_frame, text="הבא נתונים לעדכון", command=fetch_for_update).grid(row=0, column=1)
tk.Button(btn_frame, text="שמור עדכון", command=execute_update).grid(row=0, column=2)

load_data()
root.mainloop()