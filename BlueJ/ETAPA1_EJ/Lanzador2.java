public class Lanzador2{
    //static: no se puede modificar en tiempo de ejecución.
    // el lanzador siempre tiene que comenzar con este método main.
    public static void main(String args[]){
        // Este programa crea objetos y ejecuta sus metodos.
        // Creo una profesion llamando al constructor.
        Profesion p1 = new Profesion();
        // Print el contenido.
        // p1.imprimeInformacion();
        // Modifico sus variables
        p1.setNombre("Fontarero");
        p1.setSueldo(2000);
        p1.imprimeInformacion();
        
        // creo una persona
        Persona w = new Persona("Manolo",p1);
        w.imprimeInformacion();
    }
}
