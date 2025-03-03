public class Lanzador1{
    //static: no se puede modificar en tiempo de ejecución.
    // el lanzador siempre tiene que comenzar con este método main.
    public static void main(String args[]){
        // Este programa crea objetos y ejecuta sus metodos.
        // Creo una profesión
        Profesion p1 = new Profesion();
        // Print el contenido.
        p1.imprimeInformacion();
        // Modifico sus variables
        p1.setNombre("Electricista");
        p1.setSueldo(2000);
        p1.imprimeInformacion();
        
        // Otra profesion
        Profesion p2 = new Profesion();
        p2.imprimeInformacion();
        p2.setNombre("Ingeniero");
        p2.setSueldo(1200);
        p2.imprimeInformacion();
    }
}

