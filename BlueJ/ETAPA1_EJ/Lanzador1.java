public class Lanzador1{
    //static: no se puede modificar en tiempo de ejecución.
    // el lanzador siempre tiene que comenzar con este método main.
    public static void main(String args[]){
        // Este programa crea objetos y ejecuta sus metodos.
        // Creo un pueblo
        Pueblo p1 = new Pueblo();
        // Print el contenido.
        // p1.imprimeInformacion();
        // Modifico sus variables
        p1.setNombre("Ledesma");
        p1.setPrecioTransporte(20);
        p1.imprimeInformacion();
        
        // Creo otro pueblo
        Pueblo p2 = new Pueblo();
        //p2.imprimeInformacion();
        p2.setNombre("Calzada de Valdunciel");
        p2.setPrecioTransporte(15);
        p2.imprimeInformacion();
    }
}

