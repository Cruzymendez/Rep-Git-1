
/**
 * CLASE PUEBLO
 * 
 * @author (Cruz) 
 * @version (7_3_2025)
 */

public class Pueblo
{
    // instance variables - replace the example below with your own
    // Atributos. Denifen a la clase. Normalmente son sustantivos. Los atributos básicos son string, int, double y float
    private String nombre; //Nombre del pueblo.
    private double precioTransporte;
    
    // Metodos
    
    // Constructor
    /**
     * Constructor for objects of class Pueblo
     */
    public Pueblo(){
        // initialise instance variables
        nombre = "Ninguna";
        precioTransporte = 10;
    }

    // Setters 
    public void setNombre(String s){
        nombre = s;
    }
    // no hay problema en que nombre y sueldo tengan la misma variable s porque Java tiene un recolector de basur.
    public void setPrecioTransporte(double s){
        precioTransporte = s;
    }
    // Getters
    public String getNombre(){
        return nombre;
    }
    public double getPrecioTransporte(){
        return precioTransporte;
    } 
    // Metodos normales
    // System.out.println : ve al sistema e imprime por su salida...
    public void imprimeInformacion(){
        System.out.println("Población: " +nombre+"\nPrecio del transporte: "+precioTransporte+" euros");
    }
}