public class EjemploEtapa21 {
    public static void main (String [ ] args) {
        Pueblo p=new Pueblo("Villanueva");
        p.setPrecioTransporte(20);
        Cliente c=new Cliente("Juan Lopez",p);
        c.setDireccion("C/ Quijote 3");
       	c.imprimeInformacion();
        
    }
}