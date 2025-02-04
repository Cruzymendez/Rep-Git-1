# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 14:48:41 2025
Este archivo lee los datos de la tabla calendario y crea un archivo ics que puede ser importado por google calendar.
@author: cmendez
"""

import sqlite3
import sys
from datetime import datetime, timedelta
from ics import Calendar, Event

# Conexión a la base de datos SQLite3
db_path = "data2025.sqlite"
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Fecha objetivo (jueves 30 de enero de 2025)
fecha_objetivo_inicio = "03/02/2025"
fecha_objetivo_fin = "28/02/2025"

# Convertir la fecha de "dd/mm/yyyy" a datetime.date
fecha_inicio = datetime.strptime(fecha_objetivo_inicio, "%d/%m/%Y").date()
fecha_fin = datetime.strptime(fecha_objetivo_fin, "%d/%m/%Y").date()

# Crear calendario ICS
c = Calendar()

# Iterar sobre el rango de fechas
fecha_actual = fecha_inicio
while fecha_actual <= fecha_fin:
    fecha_str = fecha_actual.strftime("%d/%m/%Y")  # Convertir fecha a string para consulta SQL
    
    # Consultar la tabla CALENDARIO para obtener los datos del día
    cursor.execute("SELECT * FROM CALENDARIO WHERE Dia_year = ?", (fecha_str,))
    fila = cursor.fetchone()

    if fila:
        # Definir nombres de columnas (incluyendo "Lectivo")
        columnas = ["Dia_year", "Dia_semana","Lectivo","Modo_trabajo","Personas_T1", "Personas_T2", "Personas_T3","Personas_vacaciones", "Personas_baja", 
            "Personas_medico", "Personas_teletrabajo", "Personas_teletrabajo_tarde"]
        
        datos = dict(zip(columnas, fila))
        
        # Solo agregar eventos si "Lectivo" es "Si"
        if datos["Lectivo"] == "Si":
            titulo_evento = datos["Personas_T1"] if datos["Personas_T1"] else "Sin título"
            # Construir la descripción solo con las columnas especificadas
            columnas_descripcion = ["Modo_trabajo", "Personas_vacaciones", "Personas_baja", 
                                    "Personas_medico", "Personas_teletrabajo", "Personas_teletrabajo_tarde"]
            
            descripcion = "\n".join([f"{col}: {datos[col]}" for col in columnas_descripcion if datos[col]])

            # Crear evento
            e = Event()
            e.name = titulo_evento
            e.begin = fecha_actual  # Asigna la fecha del evento
            e.make_all_day()  # Evento de todo el día
            e.description = descripcion

            # Agregar evento al calendario
            c.events.add(e)

    # Avanzar al siguiente día
    fecha_actual += timedelta(days=1)

# Cerrar conexión a la base de datos
conn.close()

# Guardar el archivo ICS
file_name = "eventos_lectivos.ics"
with open(file_name, "w") as f:
    f.writelines(c)

print(f"Archivo ICS creado con eventos lectivos: {file_name}")
# # Consultar la tabla CALENDARIO para obtener los datos del día
# cursor.execute("SELECT * FROM CALENDARIO WHERE Dia_year = ?", (fecha_objetivo,))
# fila = cursor.fetchone()

# # Cerrar la conexión a la base de datos
# conn.close()

# if not fila:
#     print("No se encontraron datos para la fecha especificada.")
#     sys.exit()

# # Definir nombres de columnas
# columnas = ["Dia_year", "Dia_semana","Lectivo","Modo_trabajo","Personas_T1", "Personas_T2", "Personas_T3","Personas_vacaciones", "Personas_baja", 
#             "Personas_medico", "Personas_teletrabajo", "Personas_teletrabajo_tarde"]

# datos = dict(zip(columnas, fila))

# # Extraer datos para el evento
# titulo_evento = datos["Personas_T1"] if datos["Personas_T1"] else "Sin título"
# descripcion = "\n".join([f"{col}: {datos[col]}" for col in columnas[2:] if datos[col]])

# # Crear el evento en formato ICS
# c = Calendar()
# e = Event()

# # Corregir valores del evento
# e.name = titulo_evento  # <-- Asegurar que el título es el valor correcto de Personas_T1
# e.begin = fecha_dt
# e.make_all_day()  # Evento de todo el día
# e.description = descripcion

# # Agregar evento al calendario
# c.events.add(e)

# # Guardar el archivo ICS
# file_name = "evento_30_enero.ics"
# with open(file_name, "w") as f:
#     f.writelines(c)

# print(f"Archivo ICS creado correctamente: {file_name}")