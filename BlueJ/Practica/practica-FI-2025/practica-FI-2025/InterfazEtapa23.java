import java.util.Scanner;

public class InterfazEtapa23 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        AlmacenLenya almacen = new AlmacenLenya();
        
        while (true) {
            System.out.println("\n--- MENÚ PRINCIPAL ---");
            System.out.println("1) Actualizar precio de la leña");
            System.out.println("2) Actualizar precio de la bolsa de astillas");
            System.out.println("3) Añadir leña al almacén");
            System.out.println("4) Añadir un pueblo");
            System.out.println("5) Actualizar el coste de transporte de un pueblo");
            System.out.println("6) Añadir un cliente");
            System.out.println("7) Crear un pedido");
            System.out.println("8) Anotar un pedido como servido");
            System.out.println("9) Salir");
            System.out.print("Seleccione una opción: ");
            
            int opcion = scanner.nextInt();
            scanner.nextLine(); // Consumir nueva línea
            
            switch (opcion) {
                case 1:
                    System.out.print("Ingrese el nuevo precio por kilo de leña: ");
                    double precioKilo = scanner.nextDouble();
                    Pedido.setPrecioPorKilo(precioKilo);
                    break;
                case 2:
                    System.out.print("Ingrese el nuevo precio por bolsa de astillas: ");
                    double precioBolsa = scanner.nextDouble();
                    Pedido.setPrecioPorBolsa(precioBolsa);
                    break;
                case 3:
                    System.out.print("Ingrese la cantidad de leña a añadir: ");
                    int cantidadLenya = scanner.nextInt();
                    almacen.anyadirLenya(cantidadLenya);
                    break;
                case 4:
                    System.out.print("Ingrese el nombre del pueblo: ");
                    String nombrePueblo = scanner.nextLine();
                    System.out.print("Ingrese el precio del transporte: ");
                    double precioTransporte = scanner.nextDouble();
                    Pueblo nuevoPueblo = new Pueblo(nombrePueblo);
                    nuevoPueblo.setPrecioTransporte(precioTransporte);
                    almacen.anyadirPueblo(nuevoPueblo);
                    break;
                case 5:
                    System.out.println("Seleccione el pueblo para actualizar transporte:");
                    for (int i = 0; i < almacen.getPueblos().size(); i++) {
                        System.out.println((i + 1) + ") " + almacen.getPueblos().get(i).getNombre());
                    }
                    int indexPueblo = scanner.nextInt() - 1;
                    System.out.print("Ingrese el nuevo precio de transporte: ");
                    double nuevoPrecio = scanner.nextDouble();
                    almacen.getPueblos().get(indexPueblo).setPrecioTransporte(nuevoPrecio);
                    break;
                case 6:
                    System.out.print("Ingrese el nombre del cliente: ");
                    String nombreCliente = scanner.nextLine();
                    System.out.print("Ingrese la dirección del cliente: ");
                    String direccionCliente = scanner.nextLine();
                    System.out.println("Seleccione el pueblo del cliente:");
                    for (int i = 0; i < almacen.getPueblos().size(); i++) {
                        System.out.println((i + 1) + ") " + almacen.getPueblos().get(i).getNombre());
                    }
                    int indexPuebloCliente = scanner.nextInt() - 1;
                    Pueblo puebloCliente = almacen.getPueblos().get(indexPuebloCliente);
                    Cliente nuevoCliente = new Cliente(nombreCliente, puebloCliente);
                    nuevoCliente.setDireccion(direccionCliente);
                    almacen.anyadirCliente(nuevoCliente);
                    break;
                case 7:
                    System.out.println("Seleccione el cliente para el pedido:");
                    for (int i = 0; i < almacen.getClientes().size(); i++) {
                        System.out.println((i + 1) + ") " + almacen.getClientes().get(i).getNombre());
                    }
                    int indexCliente = scanner.nextInt() - 1;
                    Cliente clientePedido = almacen.getClientes().get(indexCliente);
                    System.out.print("Ingrese la cantidad de leña en kilos: ");
                    int cantidadPedido = scanner.nextInt();
                    System.out.print("Ingrese el número de bolsas de astillas: ");
                    int bolsasAstillas = scanner.nextInt();
                    Pedido nuevoPedido = new Pedido(clientePedido);
                    nuevoPedido.setCantidad(cantidadPedido);
                    nuevoPedido.setBolsasAstillas(bolsasAstillas);
                    almacen.anyadirPedido(nuevoPedido);
                    break;
                case 8:
                    System.out.println("Pedidos pendientes de servir:");
                    int pendientes = 0;
                    for (int i = 0; i < almacen.getPedidos().size(); i++) {
                        Pedido p = almacen.getPedidos().get(i);
                        if (!p.isServido()) {
                            System.out.println((i + 1) + ") " + p.getCliente().getNombre());
                            pendientes++;
                        }
                    }
                    if (pendientes == 0) {
                        System.out.println("No hay pedidos pendientes de servir.");
                        break;
                    }
                    System.out.print("Seleccione el número del pedido a marcar como servido: ");
                    int indexPedido = scanner.nextInt() - 1;
                    almacen.anotarServido(almacen.getPedidos().get(indexPedido).getCliente().getNombre());
                    break;
                case 9:
                    System.out.println("Saliendo del sistema...");
                    scanner.close();
                    return;
                default:
                    System.out.println("Opción no válida, intente de nuevo.");
            }
        }
    }
}
