# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 12:58:50 2025
Este archivo ejecuta el algoritmo greedy con los datos que haya en la tabla CALENDARIO.
OJO: el recuento no está hecho. Es decir, si se ejecuta a partir de un determinado día, hay que tener en cuenta que hay que rellenar
de momento a mano los días que ha realizado cada persona.
@author: cmendez
"""

import sqlite3
import numpy as np
from datetime import datetime, timedelta

# Función para calcular la desviación estándar de las asignaciones de mantenimiento por empleado
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

# Función para seleccionar empleados para la tarea de mantenimiento
# def seleccionar_empleados(cursor, excluidos):
#     cursor.execute("SELECT NOMBRE FROM EMPLEADOS WHERE ND_T1 = (SELECT MIN(ND_T1) FROM EMPLEADOS)")
#     posibles_empleados = [fila[0] for fila in cursor.fetchall() if fila[0] not in excluidos]
#     return posibles_empleados[:2] if len(posibles_empleados) >= 2 else posibles_empleados

def seleccionar_empleados(cursor, excluidos):
    cursor.execute("SELECT NOMBRE, ND_T1 FROM EMPLEADOS")
    empleados = sorted(cursor.fetchall(), key=lambda x: x[1])
    posibles_empleados = [emp[0] for emp in empleados if emp[0] not in excluidos]
    return posibles_empleados[:2] if len(posibles_empleados) >= 2 else posibles_empleados


# Función principal del algoritmo greedy balanceado
def algoritmo_greedy_balanceado(conexion, dia_actual):
    cursor = conexion.cursor()

    # Recorrer cada fila de la tabla CALENDARIO
    cursor.execute("SELECT Dia_year, Modo_trabajo, Personas_vacaciones, Personas_baja, Personas_medico, Personas_teletrabajo FROM CALENDARIO")
    filas = cursor.fetchall()
    fecha_actual = datetime.strptime(dia_actual, "%d/%m/%Y")

    for i, fila in enumerate(filas):
        dia_year, modo_trabajo, vacaciones, bajas, medico, teletrabajo = fila
                
        fecha_futura = datetime.strptime(dia_year, "%d/%m/%Y")
        if modo_trabajo != "Mantenimiento" or fecha_futura < fecha_actual:
            continue

        # Listar empleados excluidos para el día actual
        excluidos = set()
        if vacaciones:
            excluidos.update(vacaciones.split(","))
        if bajas:
            excluidos.update(bajas.split(","))
        if medico:
            excluidos.update(medico.split(","))
        if teletrabajo:
            excluidos.update(teletrabajo.split(","))

        # Seleccionar empleados disponibles
        empleados_seleccionados = seleccionar_empleados(cursor, excluidos)

        # Escribir los empleados seleccionados en la columna Personas_T1
        if empleados_seleccionados:
            empleados_t1 = ",".join(empleados_seleccionados)
            cursor.execute("UPDATE CALENDARIO SET Personas_T1 = ? WHERE Dia_year = ?", (empleados_t1, dia_year))
        else:
            cursor.execute("UPDATE CALENDARIO SET Personas_T1 = 'NADIE' WHERE Dia_year = ?", (dia_year,))

        # Actualizar la tabla EMPLEADOS y la tabla RECUENTO
        for empleado in empleados_seleccionados:
            cursor.execute("UPDATE EMPLEADOS SET ND_T1 = ND_T1 + 1 WHERE NOMBRE = ?", (empleado,))
            cursor.execute("UPDATE RECUENTO SET MNT_M = MNT_M + 1 WHERE NOMBRE = ?", (empleado,))

        # Actualizar las desviaciones estándar en la tabla RECUENTO
        actualizar_desviaciones(conexion)

    conexion.commit()

# Conectar a la base de datos y ejecutar el algoritmo
def main():
    try:
        conexion = sqlite3.connect("data2025.sqlite")
        dia_actual = "03/03/2025"  # Fecha actual para el algoritmo
        algoritmo_greedy_balanceado(conexion, dia_actual)
        print("El algoritmo greedy balanceado se ejecutó correctamente.")
    except sqlite3.Error as e:
        print(f"Error al ejecutar el algoritmo: {e}")
    finally:
        if conexion:
            conexion.close()

if __name__ == "__main__":
    main()
