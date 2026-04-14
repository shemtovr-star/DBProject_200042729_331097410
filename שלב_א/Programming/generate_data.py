import random
from datetime import date, timedelta

# ייצור נתונים ל-Patient
first_names = ['James','John','Robert','Michael','William','David','Joseph','Charles','Thomas','Daniel',
               'Mary','Patricia','Jennifer','Linda','Barbara','Elizabeth','Susan','Jessica','Sarah','Karen']
last_names = ['Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Wilson','Taylor',
              'Anderson','Thomas','Jackson','White','Harris','Martin','Thompson','Robinson','Clark','Lewis']

def random_date(start_year, end_year):
    start = date(start_year, 1, 1)
    end = date(end_year, 12, 31)
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

# כתיבה לקובץ
with open('insertPatients.sql', 'w') as f:
    for i in range(1, 20001):
        first = random.choice(first_names)
        last = random.choice(last_names)
        birth = random_date(1950, 2005)
        phone = f'05{random.randint(10000000, 99999999)}'
        email = f'patient{i}@email.com'
        address = f'{random.randint(1,200)} Main St, City {random.randint(1,50)}'
        f.write(f"INSERT INTO Patient (first_name, last_name, birth_date, phone, email, address) "
                f"VALUES ('{first}', '{last}', '{birth}', '{phone}', '{email}', '{address}');\n")

print("Patient - Done! 20,000 records")

# כתיבה לקובץ Appointment
statuses = ['scheduled', 'completed', 'cancelled']
times = ['08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '14:00', '14:30', '15:00']

with open('insertAppointments.sql', 'w') as f:
    for i in range(1, 20001):
        appt_date = random_date(2023, 2026)
        appt_time = random.choice(times)
        status = random.choice(statuses)
        patient_id = random.randint(1, 20000)
        doctor_id = random.randint(1, 100)
        f.write(f"INSERT INTO Appointment (appointment_date, appointment_time, status, patient_id, doctor_id) "
                f"VALUES ('{appt_date}', '{appt_time}', '{status}', {patient_id}, {doctor_id});\n")

print("Appointment - Done! 20,000 records")