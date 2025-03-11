import java.util.Scanner;

public class InterfazEtapa22 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Crear una instancia de Pueblo
        System.out.print("Ingrese el nombre del pueblo: ");
        String nombrePueblo = scanner.nextLine();
        Pueblo pueblo = new Pueblo(nombrePueblo);
        
        System.out.print("Ingrese el precio del transporte: ");
        double precioTransporte = scanner.nextDouble();
        pueblo.setPrecioTransporte(precioTransporte);
        
        scanner.nextLine(); // Limpiar buffer
        
        // Crear una instancia de Cliente
        System.out.print("Ingrese el nombre del cliente: ");
        String nombreCliente = scanner.nextLine();
        Cliente cliente = new Cliente(nombreCliente, pueblo);
        
        System.out.print("Ingrese la dirección del cliente: ");
        String direccionCliente = scanner.nextLine();
        cliente.setDireccion(direccionCliente);

        // Configurar precios estáticos
        System.out.print("Ingrese el precio por kilo de leña: ");
        double precioPorKilo = scanner.nextDouble();
        Pedido.setPrecioPorKilo(precioPorKilo);
        
        System.out.print("Ingrese el precio por bolsa de astillas: ");
        double precioPorBolsa = scanner.nextDouble();
        Pedido.setPrecioPorBolsa(precioPorBolsa);
        
        // Crear una instancia de Pedido
        Pedido pedido = new Pedido(cliente);
        
        System.out.print("Ingrese la cantidad de leña en kilos: ");
        int cantidadLenia = scanner.nextInt();
        pedido.setCantidad(cantidadLenia);
        
        System.out.print("Ingrese la cantidad de bolsas de astillas: ");
        int cantidadBolsas = scanner.nextInt();
        pedido.setBolsasAstillas(cantidadBolsas);

        // Mostrar información del pedido
        System.out.println("\nResumen del pedido:");
        pedido.imprimeInformacion();
        
        scanner.close();
    }
}
