public class EjemploEtapa23 {
    public static void main (String [ ] args) {
	Pueblo p=new Pueblo("Villanueva");
	p.setPrecioTransporte(20);
	Cliente c1=new Cliente("Juan Lopez",p);
	c1.setDireccion("C/ Quijote 3");
	Cliente c2=new Cliente("Luis Ramirez",p);
	c2.setDireccion("C/ Dulcinea 9");
	Pedido.setPrecioPorBolsa(7);
	Pedido.setPrecioPorKilo(0.75);
	Pedido pe1=new Pedido(c1);
	pe1.setCantidad(100);
	pe1.setBolsasAstillas(2);
	AlmacenLenya g=new AlmacenLenya();
	g.anyadirPueblo(p);
	g.anyadirCliente(c1);
	g.anyadirCliente(c2);
	g.anyadirLenya(1000);
	g.anyadirPedido(pe1);
	g.anotarServido("Juan Lopez");
	g.anotarServido("Luis Ramirez");
        
    }
}
