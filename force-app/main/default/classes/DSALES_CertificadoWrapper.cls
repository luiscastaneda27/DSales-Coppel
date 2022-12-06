global class DSALES_CertificadoWrapper {
    
    global class CertificadoRequest{
        global String sku_tangible {get;set;}
        global String account_id{get;set;}
        global String asset_id{get;set;}
        global String ticket {get;set;}
        global String client_number{get;set;}
        global	String	store_id	{get;set;}
        global	String	coppel_box_number	{get;set;}
        global	String	salesman_id	{get;set;}
        global	String	salesman_name	{get;set;}
        global	String	client_fullname	{get;set;}
        global	String	client_address	{get;set;}
        global	String	client_email	{get;set;}
        global	String	client_telephone	{get;set;}
        global	String	client_cellphone	{get;set;}
        global	String	sku	{get;set;}
        global	String	model_product	{get;set;}
        global	String	brand_product	{get;set;}
        global	String	serial_number	{get;set;}
        global	String	description_product	{get;set;}
        global	Double	product_price	{get;set;}
        global	Date	purchase_product_date	{get;set;}
        global	Double	warranty_duration	{get;set;}
        global	Date	purchase_warranty_date	{get;set;}
        global  Date 	sales_date {get;set;}
        global	Date	extended_warranty_effective_date	{get;set;}
        global	Double	cost_warranty	{get;set;}
        global	Date	extended_warranty_end_date	{get;set;}
        
    }
    
    global class CertificadoResponse{
        global Boolean success {get;set;}
        global String error_code {get;set;}
        global String error_message {get;set;}
        global String certificado_id {get;set;}
    }
    
}