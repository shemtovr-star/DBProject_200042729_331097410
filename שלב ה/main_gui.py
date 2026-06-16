import tkinter as tk
import subprocess
import sys # נוסיף את זה כדי לדעת איפה פייתון יושב

# הנתיב המדויק ל-python.exe של הפרויקט שלך
PYTHON_PATH = sys.executable

def open_doctors_window():
    subprocess.Popen([PYTHON_PATH, "crud_doctors.py"])

def open_advanced_window():
    subprocess.Popen([PYTHON_PATH, "advanced_operations.py"])

def open_patients_window():
    subprocess.Popen([PYTHON_PATH, "crud_patients.py"])

def open_appointments_window():
    subprocess.Popen([PYTHON_PATH, "crud_appointments.py"])
# --- הגדרת החלון הראשי ---
root = tk.Tk()
root.title("MediFlow & Build - מערכת ניהול משולבת")
root.geometry("500x400")
root.configure(bg="#f0f4f8")

lbl_title = tk.Label(root, text="מערכת ניהול - מרפאה ובינוי", font=("Arial", 20, "bold"), bg="#f0f4f8", fg="#2c3e50")
lbl_title.pack(pady=40)

btn_style = {"font": ("Arial", 14), "bg": "#3498db", "fg": "white", "width": 25, "pady": 8}

# כפתור שמפעיל את המסך שיצרנו בצעד הקודם
btn_doctors = tk.Button(root, text="ניהול רופאים (CRUD)", command=open_doctors_window, **btn_style)
btn_doctors.pack(pady=10)

# כפתור שמפעיל את המסך החדש שיצרנו הרגע
btn_reports = tk.Button(root, text="פונקציות ופרוצדורות (שלב ד')", command=open_advanced_window, **btn_style)
btn_reports.pack(pady=10)

btn_patients = tk.Button(root, text="ניהול מטופלים (CRUD)", command=open_patients_window, **btn_style)
btn_patients.pack(pady=10)

btn_apps = tk.Button(root, text="ניהול תורים (CRUD)", command=open_appointments_window, **btn_style)
btn_apps.pack(pady=10)

btn_exit = tk.Button(root, text="יציאה", command=root.quit, font=("Arial", 14), bg="#e74c3c", fg="white", width=25, pady=8)
btn_exit.pack(pady=30)



root.mainloop()