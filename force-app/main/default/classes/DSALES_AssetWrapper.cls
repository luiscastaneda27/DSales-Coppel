global class DSALES_AssetWrapper {
    global class AssetRequest{
         global String primer_nombre {get; set;}
        global String apellido {get;set;}
        global String email {get;set;}
        global String nombre{get;set;}
        global String numero_cliente{get;set;}
        global String id_cuenta {get;set;}
        global String id_contacto{get;set;}
        global String tipo_producto {get;set;}
        global String tipo_seguro {get;set;}
        global String tipo_servicio {get;set;}
        global String categoria {get;set;}
        global String subcategoria {get;set;}
        global String clase {get;set;}
        global String familia {get;set;}
        //picklist values for Status: Adquirido,Cancelado,Devuelto 
        global String estado {get;set;}
        global String meses{get;set;}
        global String sku {get;set;}
        global String duracion_garantia {get;set;}
        global String numero_serie {get;set;}
        global Date fecha_compra {get;set;}
        global Integer cantidad{get;set;}
        global String marca{get;set;}
        global String modelo{get;set;}
            global String descripcion{get;set;}    
        
   
    }
    global class AssetResponse{
        global Boolean exito {get;set;}
        global String mensaje_error {get;set;}
        global String codigo_error{get;set;}
        global String id_asset {get;set;}
    }
}