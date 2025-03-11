import java.util.Scanner;

public class InterfazEtapa1 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("--- Creación de un Pueblo ---");
        System.out.print("Ingrese el nombre del pueblo: ");
        String nombrePueblo = scanner.nextLine();
        
        System.out.print("Ingrese el coste de transporte: ");
        double precioTransporte = scanner.nextDouble();
        
        // Crear instancia de Pueblo
        Pueblo pueblo = new Pueblo(nombrePueblo);
        pueblo.setPrecioTransporte(precioTransporte);
        
        // Mostrar información del pueblo
        System.out.println("\nInformación del pueblo creado:");
        pueblo.imprimeInformacion();
        
        scanner.close();
    }
}