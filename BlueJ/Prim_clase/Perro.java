
public class Perro { // la clase no puede ser privada.
    // Atributos: caracteristicas
    private String nombre; //private solo puedo modificarlo en sus metodos
    public int edad;       // puedo modificarlo con métodos de clases externas.
    private double peso;   // solo se pone en los atributos, si no se pone se supone que son públicas.
    
    // los alcances son public, private y protected. Protected, todos los objetos
    // de la clase los comparten.
    
    // Metodos: acciones
    // Metodo constructor: tiene el mismo nombre que la clase y se ejecuta
    // cuando se construye un objeto nuevo. Si no lo hacemos, java lo hace
    // por nosotros e inicializa las variables a cero.
    // Vamos a crear un método constructor:
    // Cuando cree un perro, por defecto se va a llamar así y tendrá esa edad
    // y ese peso.
    Perro(){
        nombre="hospiciano";
        edad=0;
        peso=1.5;
    }
    
    public void bautiza(String n){ //los métodos se suelen poner en minúsculas.
        // lo voy a ejecutar desde fuera. void, devuelve nada.
        nombre=n;        
    }
}
