global class DSALES_CertificadoWrapper {
    
    global class CertificadoRequest{
        global String sku_tangible {get;set;}
        global String id_cuenta {get;set;} 
        global String id_producto_adquirido{get;set;}
        global String ticket {get;set;}
        global String numero_cliente {get;set;}
        global	String	clave_tienda	{get;set;}
        global  String  id_tienda {get;set;}
        global	String	numero_caja_coppel	{get;set;}
        global	String	id_vendedor	{get;set;}
        global	String	nombre_vendedor	{get;set;}
        global	String	nombre_completo_cliente	{get;set;}
        global	String	direccion_cliente	{get;set;}
        global	String	email_cliente	{get;set;}
        global	String	telefono_cliente	{get;set;}
        global	String	celular_cliente	{get;set;}
        global	String	sku	{get;set;}
        global	String	modelo_tangible	{get;set;}
        global	String	marca_tangible	{get;set;}
        global	String	numero_serie	{get;set;}
        global	String	descripcion_tangible	{get;set;}
        global	Double	precio_tangible	{get;set;}
        global	Date	fecha_compra_tangible	{get;set;}
        global	Double	garantia_coppel_tangible	{get;set;}
        global	Date	fecha_compra_garantia	{get;set;}
        global  Date 	fecha_venta {get;set;}
        global	Date	fecha_inicio_garantia_extendida	{get;set;}
        global	Double	costo_garantia	{get;set;}
        global	Date	fecha_fin_garantia_extendida	{get;set;}
        
    }
    
    global class CertificadoResponse{
        global Boolean exito {get;set;}
        global String codigo_error {get;set;}
        global String mensaje_error {get;set;}
        global String id_certificado {get;set;}
    }
    
}