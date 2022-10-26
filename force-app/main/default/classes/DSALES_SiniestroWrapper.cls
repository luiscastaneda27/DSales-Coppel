public class DSALES_SiniestroWrapper {

    public class siniestroCallPost { 
        public String uid { get; set;}
        public String Reporte { get; set;}
        public String NumeroSiniestro { get; set;}
        public String TipoSiniestro { get; set;}
        public String FechaSiniestro { get; set;}
        public String NombreConductor { get; set;}
        public String Causa { get; set;}

        public vehiculo Vehiculo { get; set;}
        public poliza Poliza { get; set;}

        public String ComoOcurrio { get; set;}
        public String Ubicacion { get; set;}
        public String Municipio { get; set;}
        public String Estado { get; set;}
        public String Estatus { get; set;}
        public String salesforceid { get; set;}
    }

    public class vehiculo{
        public String Descripcion { get; set;}
        public String Anio { get; set;}
        public String Placa { get; set;}
        public String Serie { get; set;}
    }

    public class poliza{
        public String NumeroPoliza { get; set;}
        public String Inciso { get; set;}
        public String FechaInicioVigencia { get; set;}
        public String FechaFinVigencia { get; set;}
        public String NombreAsegurado { get; set;}
    }

    public class siniestroPostResponse{
        public String ok { get; set;}
        public String response { get; set;}
        public String msg { get; set;}
        public siniestro siniestro { get; set;}
        
    }

    public class siniestro{
        public String uid { get; set;}
        public String NumeroSiniestro { get; set;}
    }

    public class SiniestroPut{
        public String uid { get; set;}
        public String Reporte { get; set;}
        public String NumeroSiniestro { get; set;}
        public String TipoSiniestro { get; set;}
        public String FechaSiniestro { get; set;}
        public String NombreConductor { get; set;}
        public String Causa { get; set;}

        public vehiculo Vehiculo { get; set;}
        public poliza Poliza { get; set;}

        public String ComoOcurrio { get; set;}
        public String Ubicacion { get; set;}
        public String Municipio { get; set;}
        public String Estado { get; set;}
        public String Estatus { get; set;}
        
        public documentosVehiculo DocumentosVehiculo { get; set;}
        public documentosAsegurado DocumentosAsegurado { get; set;}
        public documentosAseguradora DocumentosAseguradora { get; set;}

        public String salesforceid { get; set;}       
    }

    public class documentosVehiculo{
        public String Factura { get; set;}  
        public String ContanciaBajaPlacas { get; set;}  
        public List<comprobantesTenencia> ComprobantesTenencia { get; set;} 
        public String CarpetaMP { get; set;} 
        public String AcreditacionMP { get; set;} 
        public String OficioLiberacionRobo { get; set;} 

    }
    public class documentosAsegurado{
        public String IdentificacionFrontal { get; set;} 
        public String IdentificacionReverso { get; set;} 
        public String ComprobanteDomicilio { get; set;} 
        public String CURP { get; set;} 
        public String PoderNotarial { get; set;} 
        public String EncabezadoCuentaBancaria { get; set;} 
        public String ConstanciaSituacionFiscal { get; set;} 
        
    }

    public class documentosAseguradora{
        public String CartaConsentimientoCFDI { get; set;} 
        public String FormatoCompraVenta { get; set;} 
        public String FormatoFiniquito { get; set;} 
        
    }
    
    public class comprobantesTenencia{
        public String Descripcion { get; set;} 
        public String Comprobante { get; set;} 
        public String IdComprobante { get; set;} 
        
    }

    public class SiniestroGet{
        public String uid { get; set;}
        public String Reporte { get; set;}
        public String NumeroSiniestro { get; set;}
        public String TipoSiniestro { get; set;}
        public String FechaSiniestro { get; set;}
        public String NombreConductor { get; set;}
        public String Causa { get; set;}

        public vehiculo Vehiculo { get; set;}
        public poliza Poliza { get; set;}

        public String ComoOcurrio { get; set;}
        public String Ubicacion { get; set;}
        public String Municipio { get; set;}
        public String Estado { get; set;}
        public String Estatus { get; set;}
        
        public documentosVehiculo DocumentosVehiculo { get; set;}
        public documentosAsegurado DocumentosAsegurado { get; set;}
        public documentosAseguradora DocumentosAseguradora { get; set;}

        public String salesforceid { get; set;}       
    }

}