public class EjemploEtapa22 {
    public static void main (String [ ] args) {
        Pueblo p=new Pueblo("Villanueva");
        p.setPrecioTransporte(20);
        Cliente c=new Cliente("Juan Lopez",p);
        c.setDireccion("C/ Quijote 3");
        Pedido.setPrecioPorBolsa(7);
        Pedido.setPrecioPorKilo(0.75);
        Pedido pe=new Pedido(c);
        pe.setCantidad(100);
        pe.setBolsasAstillas(2);
        pe.imprimeInformacion();        
    }
}