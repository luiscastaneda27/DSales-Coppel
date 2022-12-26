global class DSALES_QuoteGexWrapper {
    global class QuoteGexRequest{
        global String id_tienda {get; set;}
        global String numero_de_cliente {get;set;}
        global String nombre {get; set;}
        global String apellido_paterno {get;set;}
        global String apellido_materno {get;set;}
        global String correo_electronico {get;set;}
        global String id_factura {get;set;}
        global List<Product> productos {get;set;}
 }
	global class Product {
		global String sku_de_tangible {get;set;}
		global Double cantidad_productos_tangibles {get;set;}
        global String articulo {get; set;}
        global String modelo {get; set;}
        global String marca {get; set;}
        global Double precio_tangible {get; set;}
    }
    global class QuoteGexResponse{
        global String	sku_de_tangible	{get;set;}
        global String	sku_de_precio	{get;set;}
        global String	sku_de_servicio	{get;set;}
        global String	nombre_intangible	{get;set;}
        global double	precio	{get;set;}
        global double	costo_total	{get;set;}
        global String 	meses_cobertura {get;set;}
        
    }
    global class respuestaNPV{        
        global Boolean 	success {get;set;}
        global String	id_cotizacion	{get;set;}
        global String	id_oportunidad	{get;set;}
        global String 	codigo_error {get;set;}
        global String 	mensaje_error {get;set;}
        global List<QuoteGexResponse> respuesta {get;set;}
    }
    
}