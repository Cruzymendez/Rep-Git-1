
/**
 * Write a description of class Persona here.
 * 
 * @author (Cruz) 
 * @version (9/3/2025)
 */
public class Persona
{
    // Atributos
    private String nombre;
    private int edad;
    private Profesion profesion; // tiene un atributo profesion del tipo Profesion
    
    // Metodos
    // Constructor
    Persona(String n,Profesion p){
        nombre=n;
        profesion=p;
        edad=18;
    }
    
    // Setters
    public void setNombre(String s){
        nombre=s;
    }
    public void setEdad(int e){
        edad=e;
    }
    public void setProfesion(Profesion p){
        profesion=p;
    }
    // Getters
    public String getNombre(){
        return nombre;
    }
    public int getEdad(){
        return edad;
    }
    public Profesion getProfesion(){
        return profesion;
    }
    // Metodos normales
    public void imprimeInformacion(){
       System.out.println("Nombre: "+nombre);
       System.out.println("edad: "+edad);
       profesion.imprimeInformacion();
    }
}
