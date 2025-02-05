# -*- coding: utf-8 -*-
"""
Created on Wed Feb  5 11:42:49 2025
Este archivo lee la tabla calendario de la bbdd y actualiza los registros corresondientes
a las peronas que hayan tenido turnos, bajas, vacaciones etc entre los días inicio y fin
@author: cruzy
"""

import sqlite3
import sys
import numpy as np
from datetime import datetime, timedelta

def actualizar_desviaciones(conexion):
    cursor = conexion.cursor()
    cursor.execute("SELECT MNT_M FROM RECUENTO")
    valores = [fila[0] for fila in cursor.fetchall()]
    media = np.mean(valores)
    desviaciones = [valor - media for valor in valores]

    # Actualizar la columna DEV_MNT_M en la tabla RECUENTO
    cursor.execute("SELECT NOMBRE FROM RECUENTO")
    empleados = [fila[0] for fila in cursor.fetchall()]
    for empleado, desviacion in zip(empleados, desviaciones):
        cursor.execute("UPDATE RECUENTO SET DEV_MNT_M = ? WHERE NOMBRE = ?", (desviacion, empleado))
    conexion.commit()

def actualizar_base_datos(conexion):
    # Conectar a la base de datos SQLite
    cursor = conexion.cursor()
    
    # fechas iniciales:
    fecha_objetivo_inicio = "01/01/2025"
    fecha_objetivo_fin = "01/03/2025"
    
       # Convertir la fecha de "dd/mm/yyyy" a datetime.date
    fecha_inicio = datetime.strptime(fecha_objetivo_inicio, "%d/%m/%Y").date()
    fecha_fin = datetime.strptime(fecha_objetivo_fin, "%d/%m/%Y").date()
    
    # Poner a 0 los valores en RECUENTO y EMPLEADOS
    cursor.execute("UPDATE RECUENTO SET MNT_M = 0, DEV_MNT_M = 0")
    cursor.execute("UPDATE EMPLEADOS SET ND_T1 = 0, ND_VAC = 0, ND_BAJA = 0")
    conexion.commit()
    
    # Iterar sobre el rango de fechas
    fecha_actual = fecha_inicio
    while fecha_actual <= fecha_fin:
        fecha_str = fecha_actual.strftime("%d/%m/%Y")  # Convertir fecha a string para consulta SQL
        cursor.execute("SELECT * FROM CALENDARIO WHERE Dia_year = ?", (fecha_str,))
        datos_calendario = cursor.fetchone()
        print(datos_calendario)
        
        if datos_calendario:
            columnas = [desc[0] for desc in cursor.description]
            datos_dict = dict(zip(columnas, datos_calendario))

            # Actualizar ND_VAC en EMPLEADOS
            if datos_dict["Personas_vacaciones"]:
                for empleado in datos_dict["Personas_vacaciones"].split(","):
                    cursor.execute("UPDATE EMPLEADOS SET ND_VAC = ND_VAC + 1 WHERE NOMBRE = ?", (empleado.strip(),))
            
            # Actualizar ND_BAJA en EMPLEADOS
            if datos_dict["Personas_baja"]:
                for empleado in datos_dict["Personas_baja"].split(","):
                    cursor.execute("UPDATE EMPLEADOS SET ND_BAJA = ND_BAJA + 1 WHERE NOMBRE = ?", (empleado.strip(),))
            
            # Actualizar ND_T1 en EMPLEADOS
            if datos_dict["Personas_T1"]:
                for empleado in datos_dict["Personas_T1"].split(","):
                    cursor.execute("UPDATE EMPLEADOS SET ND_T1 = ND_T1 + 1 WHERE NOMBRE = ?", (empleado.strip(),))
            
            # Actualizar MNT_M en RECUENTO
            if datos_dict["Personas_T1"]:
                for empleado in datos_dict["Personas_T1"].split(","):
                    cursor.execute("UPDATE RECUENTO SET MNT_M = MNT_M + 1 WHERE NOMBRE = ?", (empleado.strip(),))
            
        fecha_actual += timedelta(days=1)
    
    conexion.commit()
    

# Conectar a la base de datos y ejecutar el algoritmo
def main():
    try:
        conexion = sqlite3.connect("data2025.sqlite")
        actualizar_base_datos(conexion)
        actualizar_desviaciones(conexion)
    except sqlite3.Error as e:
        print(f"Error al ejecutar el algoritmo: {e}")
    finally:
        if conexion:
            conexion.close()

if __name__ == "__main__":
    main()