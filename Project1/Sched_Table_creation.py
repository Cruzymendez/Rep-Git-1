import sqlite3
from datetime import datetime, timedelta
import numpy as np

# Crear o conectar a la base de datos SQLite
connection = sqlite3.connect("data2025.sqlite")
cursor = connection.cursor()

# Crear la tabla CALENDARIO
cursor.execute("""
CREATE TABLE IF NOT EXISTS CALENDARIO (
    Dia_year TEXT,
    Dia_semana TEXT,
    Lectivo TEXT,
    Modo_trabajo TEXT,
    Personas_T1 TEXT,
    Personas_T2 TEXT,
    Personas_T3 TEXT,
    Personas_vacaciones TEXT,
    Personas_baja TEXT,
    Personas_teletrabajo TEXT,
    Personas_teletrabajo_tarde TEXT
)
""")

# Crear la tabla MODO_TRABAJO
cursor.execute("""
CREATE TABLE IF NOT EXISTS MODO_TRABAJO (
    TIPO_T TEXT,
    T1_H1 TEXT,
    T1_H2 TEXT,
    T2_H1 TEXT,
    T2_H2 TEXT,
    T3_H1 TEXT,
    T3_H2 TEXT
)
""")

# Crear la tabla EMPLEADOS
cursor.execute("""
CREATE TABLE IF NOT EXISTS EMPLEADOS (
    NOMBRE TEXT,
    TIPO_HORARIO TEXT,
    FORMACION TEXT,
    CONCILIACION TEXT,
    D_TELETRABAJO TEXT,
    ND_CAMPAIGN INTEGER,
    ND_T1 INTEGER,
    ND_T2 INTEGER,
    ND_T3 INTEGER,
    ND_VAC INTEGER,
    ND_BAJA INTEGER
)
""")

# Crear la tabla RECUENTO
cursor.execute("""
CREATE TABLE IF NOT EXISTS RECUENTO (
    NOMBRE TEXT,
    MNT_M INTEGER,
    DEV_MNT_M INTEGER,
    MNT_T INTEGER,
    DEV_MNT_T INTEGER,
    CI_M INTEGER,
    DEV_CI_M INTEGER,
    CI_T INTEGER,
    DEV_CI_T INTEGER,
    CE_M INTEGER,
    DEV_CE_M INTEGER,
    CE_T INTEGER,
    DEV_CE_T INTEGER,
    TOTAL_M INTEGER,
    DEV_TOTAL_M INTEGER,
    TOTAL_T INTEGER,
    DEV_TOTAL_T INTEGER
)
""")

# Insertar los datos en la tabla RECUENTO
recuento_data = [
    ("OSCAR", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("Marta", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("J_David", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("ENRIQUE", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("IRENE", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("PAULA", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("FABIO", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    ("J_MARIA", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
]

cursor.executemany("""
INSERT INTO RECUENTO VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
""", recuento_data)


# Generar los datos de la tabla CALENDARIO
start_date = datetime(2025, 1, 1)
end_date = datetime(2025, 12, 31)
date_generated = [start_date + timedelta(days=x) for x in range((end_date - start_date).days + 1)]

castilla_y_leon_festivos = ["01/01/2025", "06/01/2025", "20/03/2025", "01/05/2025", "15/08/2025", "12/10/2025", "01/11/2025", "06/12/2025", "08/12/2025", "25/12/2025"]

def es_lectivo(fecha):
    dia_semana = fecha.weekday()  # Lunes es 0, Domingo es 6
    fecha_str = fecha.strftime("%d/%m/%Y")
    if dia_semana >= 5 or fecha_str in castilla_y_leon_festivos:
        return "No"
    return "Si"

calendario_data = [
    (
        fecha.strftime("%d/%m/%Y"),
        fecha.strftime("%A"),
        es_lectivo(fecha),
        "Mantenimiento" if es_lectivo(fecha) == "Si" else None,
        "", "", "", "", "", "", ""
    )
    for fecha in date_generated
]

cursor.executemany("""
INSERT INTO CALENDARIO VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
""", calendario_data)

# Insertar los datos en la tabla MODO_TRABAJO
modo_trabajo_data = [
    ("MANTENIMIENTO", "8:00", "15:00", None, None, None, None),
    ("CI", "8:00", "14:30", "14:00", "17:30", None, None),
    ("CE", "8:00", "14:30", "14:00", "18:30", None, None)
]

cursor.executemany("""
INSERT INTO MODO_TRABAJO VALUES (?, ?, ?, ?, ?, ?, ?)
""", modo_trabajo_data)

# Insertar los datos en la tabla EMPLEADOS
empleados_data = [
    ("OSCAR", "M", "Completa", None, "Martes,Miércoles", 0, 0, 0, 0, 0, 0),
    ("Marta", "M/T", "Completa", None, "Lunes,Jueves", 0, 0, 0, 0, 0, 0),
    ("J_David", "M/T", "Completa", None, None, 0, 0, 0, 0, 0, 0),
    ("ENRIQUE", "M/T", "Completa", "IRENE", "Martes", 0, 0, 0, 0, 0, 0),
    ("IRENE", "RP", "Completa", "ENRIQUE", "Jueves", 0, 0, 0, 0, 0, 0),
    ("PAULA", "M/T", "Media", None, None, 0, 0, 0, 0, 0, 0),
    ("FABIO", "M/T", "Media", None, "Lunes", 0, 0, 0, 0, 0, 0),
    ("J_MARIA", "M/T", "Formacion", None, None, 0, 0, 0, 0, 0, 0)
]

cursor.executemany("""
INSERT INTO EMPLEADOS VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
""", empleados_data)

# Guardar y cerrar la conexión
connection.commit()
connection.close()

print("Base de datos SQLite creada y datos insertados correctamente.")
