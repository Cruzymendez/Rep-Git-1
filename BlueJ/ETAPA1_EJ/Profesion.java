

public class Profesion
{
    // instance variables - replace the example below with your own
    // Atributos. Denifen a la clase. Normalmente son sustantivos. Los atributos básicos son string, int, double y float
    private String nombre; //encapsulación: poner el atributo private.
    private double sueldo;
    
    // Metodos
    
    // Constructor
    /**
     * Constructor for objects of class Profesion
     */
    public Profesion(){
        // initialise instance variables
        nombre = "Ninguna";
        sueldo = 1200;
    }

    // Setters y Getters
    // Setters: métodos que te permiten poner un valor a los atributos.
    // Getters: métodos que te permiten recuperar valores de los atributos.
    // Setters: público, llamado setNombre y que no devuelve nada.
    public void setNombre(String s){
        nombre = s;
    }
    // no hay problema en que nombre y sueldo tengan la misma variable s porque Java tiene un recolector de basur.
    public void setSueldo(double s){
        sueldo = s;
    }
    // Getters
    public String getNombre(){
        return nombre;
    }
    public double getSueldo(){
        return sueldo;
    } 
    // Metodos normales
    // System.out.println : ve al sistema e imprime por su salida...
    public void imprimeInformacion(){
        System.out.println("Profesion: " +nombre+" Sueldo "+sueldo);
    }
}
