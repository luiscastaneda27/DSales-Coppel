public class DSALES_EmissionWrapper {
    
  public class EmissionRequest{
      public	String	name	{get;set;}
      public	String	email	{get;set;}
      public	String	phone	{get;set;}
      public	String	gender	{get;set;}
      public	Date	birthday	{get;set;}
      public	String	zip_code	{get;set;}
      public	String	vehicle_type	{get;set;}
      public	String	vehicle_model	{get;set;}
      public	String	promotion_code	{get;set;}
  }
  public class Semestral {
      public double pt { get; set; }
      public double iva { get; set; }
      public Integer recibos { get; set; }
      public Integer fin { get; set; }
      public double rec_ini { get; set; }
      public double rec_sub { get; set; }
      
  }
  public class Mensual {
      public double pt { get; set; }
      public double iva { get; set; }
      public Integer recibos { get; set; }
      public Integer fin { get; set; }
      public double rec_ini { get; set; }
      public double rec_sub { get; set; }
      
  }
  public class Trimestral {
      public double pt { get; set; }
      public double iva { get; set; }
      public Integer recibos { get; set; }
      public Integer fin { get; set; }
      public double rec_ini { get; set; }
      public double rec_sub { get; set; }
      
  }
  public class Formas_pago {
      public Semestral semestral { get; set; } 
      public Mensual mensual { get; set; } 
      public Trimestral trimestral { get; set; } 
      
  }
  public class Coberturas {
      public String val { get; set; }
      public String descr { get; set; }
      public String ded { get; set; }
      public Integer ico { get; set; }
      public String valDesc { get; set; }
      public double pri { get; set; }
      public Integer cob { get; set; }
      public String dedDesc { get; set; }
      public Integer coberturaId { get; set; }
      
  }
  public class ABA {
      public String descripcion { get; set; }
      public String clave { get; set; }
      public double pt { get; set; }
      public String color_aseg { get; set; }
      public String logo_gde_aseg { get; set; }
      public Integer recargo { get; set; }
      public String forpag { get; set; }
      public Integer cot_id { get; set; }
      public Integer der { get; set; }
      public Integer pd { get; set; }
      public double iva { get; set; }
      public String logo_ch_aseg { get; set; }
      public Formas_pago formas_pago { get; set; } 
      public List<Coberturas> coberturas { get; set; }
      public double pn { get; set; }
      
  }
  public class Insurance_companies {
      public ABA ABA { get; set; } 
      
  }
  public class Data {
      public Integer id { get; set; }
      public String name { get; set; }
      public String email { get; set; }
      public String phone { get; set; }
      public String gender { get; set; }
      public String birthday { get; set; }
      public String zip_code { get; set; }
      public String vehicle_type { get; set; }
      public String vehicle_model { get; set; }
      public String promotion_code { get; set; }
      public List<Insurance_companies> insurance_companies { get; set; }
      
  }
  public class EmissionResponse {
      public Boolean status { get; set; }
      public Integer code { get; set; }
      public Data data { get; set; } 
      
  }
  
}