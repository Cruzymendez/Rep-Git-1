
/**
 * CLASE PUEBLO
 * 
 * @author (Cruz) 
 * @version (7_3_2025)
 */

public class Pueblo
{
    // Atributos
    private String nombre; //Nombre del pueblo.
    private double precioTransporte;
    
    // Metodos
    // Constructor
    /**
     * Constructor for objects of class Pueblo
     */
    public Pueblo(String s){
        // initialise instance variables
        nombre = s;
        precioTransporte = 10;
    }

    // Setters 
    public void setNombre(String s){
        nombre = s;
    }
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
    // System.out.println : Imprime por la salida del sistema
    public void imprimeInformacion(){
        System.out.println("Población: " +nombre+"\nPrecio del transporte: "+precioTransporte+" euros");
    }
}