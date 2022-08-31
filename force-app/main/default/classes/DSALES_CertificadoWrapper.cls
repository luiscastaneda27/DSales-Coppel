public class DSALES_CertificadoWrapper {
    
    public class CertificadoRequest{
        public String first_name{get;set;}
        public String middle_name{get;set;}
        public String last_name{get;set;}
        public String suffix {get;set;}
        public String client_number{get;set;}
        public String birthdate {get;set;}
        public	String	store_id	{get;set;}
        public	String	coppel_box_number	{get;set;}
        public	Integer	salesman_id	{get;set;}
        public	String	salesman_name	{get;set;}
        public	String	client_fullname	{get;set;}
        public	String	client_address	{get;set;}
        public	String	client_email	{get;set;}
        public	String	client_telephone	{get;set;}
        public	String	client_cellphone	{get;set;}
        public	Integer	sku	{get;set;}
        public	String	model_product	{get;set;}
        public	String	brand_product	{get;set;}
        public	String	serial_number	{get;set;}
        public	String	description_product	{get;set;}
        public	Double	product_price	{get;set;}
        public	Date	purchase_product_date	{get;set;}
        public	Integer	warranty_duration	{get;set;}
        public	Date	purchase_warranty_date	{get;set;}
        public	Date	extended_warranty_effective_date	{get;set;}
        public	Double	cost_warranty	{get;set;}
        public	Date	extended_warranty_end_date	{get;set;}
        
    }
    
    public class CertificadoResponse{
        public Boolean success {get;set;}
        public String error_message {get;set;}
        public String certificado_id {get;set;}
    }
    
}