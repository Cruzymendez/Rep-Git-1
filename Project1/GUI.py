# -*- coding: utf-8 -*-
"""
Created on Tue Feb 11 09:22:46 2025

@author: cmendez
"""

import sqlite3
import tkinter as tk
from tkinter import ttk


def actualizar_datos_calendario():
    """Actualiza la base de datos con los valores ingresados en los campos inferiores."""
    dia_seleccionado = combo_dia_year.get()
    nuevo_t1 = entry_personas_t1.get()
    nuevo_vacaciones = entry_personas_vacaciones.get()
    nuevo_baja = entry_personas_baja.get()
    nuevo_teletrabajo = entry_personas_teletrabajo.get()
    
    conexion = sqlite3.connect("data2025.sqlite")
    cursor = conexion.cursor()
    cursor.execute('''UPDATE CALENDARIO SET Personas_T1 = ?, Personas_vacaciones = ?, 
                      Personas_baja = ?, Personas_teletrabajo = ? WHERE Dia_year = ?''', 
                   (nuevo_t1, nuevo_vacaciones, nuevo_baja, nuevo_teletrabajo, dia_seleccionado))
    conexion.commit()
    conexion.close()
    cargar_datos_calendario()

def cargar_dias_year():
    """Carga los valores únicos de Dia_year en el desplegable."""
    conexion = sqlite3.connect("data2025.sqlite")
    cursor = conexion.cursor()
    cursor.execute("SELECT DISTINCT Dia_year FROM CALENDARIO")
    dias = [row[0] for row in cursor.fetchall()]
    conexion.close()
    return dias

def actualizar_campos(event):
    """Actualiza los valores en las casillas inferiores basándose en el Dia_year seleccionado."""
    dia_seleccionado = combo_dia_year.get()
    conexion = sqlite3.connect("data2025.sqlite")
    cursor = conexion.cursor()
    cursor.execute('''SELECT Personas_T1, Personas_vacaciones, Personas_baja, Personas_teletrabajo 
                      FROM CALENDARIO WHERE Dia_year = ?''', (dia_seleccionado,))
    resultado = cursor.fetchone()
    conexion.close()
    
    if resultado:
        entry_personas_t1.delete(0, tk.END)
        entry_personas_t1.insert(0, resultado[0])
        entry_personas_vacaciones.delete(0, tk.END)
        entry_personas_vacaciones.insert(0, resultado[1])
        entry_personas_baja.delete(0, tk.END)
        entry_personas_baja.insert(0, resultado[2])
        entry_personas_teletrabajo.delete(0, tk.END)
        entry_personas_teletrabajo.insert(0, resultado[3])

def cargar_datos_calendario():
    """Carga los datos de la tabla CALENDARIO en el Treeview."""
    conexion = sqlite3.connect("data2025.sqlite")
    cursor = conexion.cursor()
    
    consulta = '''
    SELECT Dia_year, Dia_semana, Lectivo, Modo_trabajo, Personas_T1, 
           Personas_vacaciones, Personas_baja, Personas_medico, 
           Personas_teletrabajo, Personas_teletrabajo_tarde
    FROM CALENDARIO'''
    cursor.execute(consulta)
    registros = cursor.fetchall()
    
    for fila in tree_calendario.get_children():
        tree_calendario.delete(fila)
    
    for registro in registros:
        tree_calendario.insert("", "end", values=registro)
    
    conexion.close()

def cargar_datos_empleados():
    """Carga los datos de la tabla EMPLEADOS en el Treeview."""
    conexion = sqlite3.connect("data2025.sqlite")
    cursor = conexion.cursor()
    
    consulta = '''
    SELECT Nombre, Tipo_horario, Formacion, D_teletrabajo, ND_T1, ND_VAC, ND_BAJA
    FROM EMPLEADOS'''
    cursor.execute(consulta)
    registros = cursor.fetchall()
    
    for fila in tree_empleados.get_children():
        tree_empleados.delete(fila)
    
    for registro in registros:
        tree_empleados.insert("", "end", values=registro)
    
    conexion.close()

def cargar_datos_recuento():
    """Carga los datos de la tabla RECUENTO en el Treeview."""
    conexion = sqlite3.connect("data2025.sqlite")
    cursor = conexion.cursor()
    
    consulta = '''
    SELECT Nombre, MNT_M, DEV_MNT_M
    FROM RECUENTO'''
    cursor.execute(consulta)
    registros = cursor.fetchall()
    
    for fila in tree_recuento.get_children():
        tree_recuento.delete(fila)
    
    for registro in registros:
        tree_recuento.insert("", "end", values=registro)
    
    conexion.close()

# Crear la ventana principal
root = tk.Tk()
root.title("Gestión de Recursos Humanos")
root.geometry("900x600")

# Crear un Notebook (Pestañas)
notebook = ttk.Notebook(root)
notebook.pack(fill="both", expand=True)

# Crear los Frames para cada pestaña
frame_empleados = ttk.Frame(notebook)
frame_modo_trabajo = ttk.Frame(notebook)
frame_calendario = ttk.Frame(notebook)
frame_recuento = ttk.Frame(notebook)

notebook.add(frame_empleados, text="EMPLEADOS")
notebook.add(frame_modo_trabajo, text="MODO DE TRABAJO")
notebook.add(frame_calendario, text="CALENDARIO")
notebook.add(frame_recuento, text="RECUENTO")

# --- PESTAÑA CALENDARIO ---
frame_calendario_superior = ttk.Frame(frame_calendario)
frame_calendario_superior.pack(fill="both", expand=True)

columnas_calendario = ("Dia_year", "Dia_semana", "Lectivo", "Modo_trabajo", "Personas_T1", 
            "Personas_vacaciones", "Personas_baja", "Personas_medico", 
            "Personas_teletrabajo", "Personas_teletrabajo_tarde")

tree_calendario = ttk.Treeview(frame_calendario_superior, columns=columnas_calendario, show="headings")

for col in columnas_calendario:
    tree_calendario.heading(col, text=col)
    tree_calendario.column(col, anchor="center")

tree_calendario.pack(fill="both", expand=True)

boton_cargar_calendario = ttk.Button(frame_calendario_superior, text="Cargar Datos", command=cargar_datos_calendario)
boton_cargar_calendario.pack(pady=5)

frame_calendario_inferior = ttk.Frame(frame_calendario)
frame_calendario_inferior.pack(fill="x", padx=10, pady=10)

# Desplegable para seleccionar Dia_year
combo_dia_year = ttk.Combobox(frame_calendario_inferior, state="readonly")
combo_dia_year.pack()
combo_dia_year['values'] = cargar_dias_year()
combo_dia_year.bind("<<ComboboxSelected>>", actualizar_campos)

# Campos de entrada para modificar datos
entry_personas_t1 = ttk.Entry(frame_calendario_inferior)
entry_personas_vacaciones = ttk.Entry(frame_calendario_inferior)
entry_personas_baja = ttk.Entry(frame_calendario_inferior)
entry_personas_teletrabajo = ttk.Entry(frame_calendario_inferior)

# Etiquetas y disposición de los campos
ttk.Label(frame_calendario_inferior, text="Personas_T1").pack()
entry_personas_t1.pack()
ttk.Label(frame_calendario_inferior, text="Personas_vacaciones").pack()
entry_personas_vacaciones.pack()
ttk.Label(frame_calendario_inferior, text="Personas_baja").pack()
entry_personas_baja.pack()
ttk.Label(frame_calendario_inferior, text="Personas_teletrabajo").pack()
entry_personas_teletrabajo.pack()

# Botón para actualizar datos
ttk.Button(frame_calendario_inferior, text="Actualizar Datos", command=actualizar_datos_calendario).pack(pady=5)

# --- PESTAÑA RECUENTO ---
frame_recuento_superior = ttk.Frame(frame_recuento)
frame_recuento_superior.pack(fill="both", expand=True)
columnas_recuento = ("Nombre", "MNT_M", "DEV_MNT_M")

tree_recuento = ttk.Treeview(frame_recuento, columns=columnas_recuento, show="headings")

for col in columnas_recuento:
    tree_recuento.heading(col, text=col)
    tree_recuento.column(col, anchor="center")

tree_recuento.pack(fill="both", expand=True)

frame_recuento_inferior = ttk.Frame(frame_recuento)
frame_recuento_inferior.pack(fill="x", padx=10, pady=10)
# Botón para actualizar datos # de momento no hace nada, lo mismo que el superior de cargar.
boton_actualizar_recuento = ttk.Button(frame_recuento_inferior, text="Actualizar Datos", command=cargar_datos_recuento)
boton_actualizar_recuento.pack(pady=10)

boton_cargar_recuento = ttk.Button(frame_recuento_inferior, text="Cargar Datos", command=cargar_datos_recuento)
boton_cargar_recuento.pack(pady=10)

# --- PESTAÑA EMPLEADOS ---
columnas_empleados = ("Nombre", "Tipo_horario", "Formacion", "D_teletrabajo", "ND_T1", "ND_VAC", "ND_BAJA")  

tree_empleados = ttk.Treeview(frame_empleados, columns=columnas_empleados, show="headings")

for col in columnas_empleados:
    tree_empleados.heading(col, text=col)
    tree_empleados.column(col, anchor="center")

tree_empleados.pack(fill="both", expand=True)

boton_cargar_empleados = ttk.Button(frame_empleados, text="Cargar Datos", command=cargar_datos_empleados)
boton_cargar_empleados.pack(pady=10)

root.mainloop()
