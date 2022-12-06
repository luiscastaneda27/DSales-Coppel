public class DSALES_EndorsementWrapper {
    public class documento {
        public string IdDocumento{ get; set; }
        public string TipoDocumento{ get; set; }
        public string Documento{ get; set; }   
    }
    
    public class dato {
        public string IdDato {get; set;}
        public string TipoDato {get; set;}
        public string Valor {get; set;}
        
    }
    
    public class endorsementRequest {
        public string uid{ get; set; }
        public String TipoEndoso { get; set; }
        public String NumeroPoliza { get; set; }
        public Date FechaEndoso { get; set; }
        public String Estatus { get; set; }
        public documento Documentos { get; set; } 
        public dato Datos { get; set; } 
        public string salesforceid { get; set; } 
    }
    
    public class Endoso{
        public string uid{ get; set; }
    }
    public class endorsementResponse{
        public String ok { get; set; }
   		public string response { get; set; }
   		public string msg { get; set; }
   		public Endoso endoso { get; set; } 
    }
    public class getResponse {
        public string uid { get; set; } 
        public string TipoEndoso { get; set; }
        public string NumeroPoliza { get; set; }
        public String FechaEndoso { get; set; }
        public String FechaAplicacionEndoso { get; set; }
        public string Estatus { get; set; }
        public string ComentarioEstatus { get; set; }
        public List<documento> Documentos { get; set;}
        public List<dato> Datos { get; set;} 
        public string salesforceid { get; set; } 
    }
    
}