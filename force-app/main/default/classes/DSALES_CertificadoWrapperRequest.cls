@RestResource(urlMapping='/insertCertificado/*')
global with sharing class DSALES_CertificadoWrapperRequest {
    @HttpPost
    global static DSALES_CertificadoWrapper.CertificadoResponse createCertificado(String idCliente){
        
        Boolean success = false;
        String message = '';
        DSALES_Certificado__c certificadoRecord = new DSALES_Certificado__c();
        
        if(RestContext.request != null){
            String Body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(Body)){
                try{
                    DSALES_CertificadoWrapper.CertificadoRequest certificado = (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize(body, DSALES_CertificadoWrapper.CertificadoRequest.class);
                    //certificadoRecord.DSALES_Cliente__c. 
                    Account cliente =[SELECT Id FROM ACCOUNT WHERE CP_WalletCustomerNumber__c=:Double.valueOf(certificado.client_number) LIMIT 1];                    certificadoRecord.DSALES_ProductoAdquirido__c=certificado.id_Asset;
                    certificadoRecord.DSALES_Cliente__c=cliente.Id;
                    certificadoRecord.DSALES_Ticket__c=certificado.ticket;
                    certificadoRecord.DSALES_Tienda__c=certificado.store_id;	
                    certificadoRecord.DSALES_Caja_GEX__c=certificado.coppel_box_number;
                    certificadoRecord.DSALES_Numero_de_Vendedor__c=certificado.salesman_id;
                    certificadoRecord.DSALES_Nombre_Vendedor__c=certificado.salesman_name;	
                    certificadoRecord.DSALES_Domicilio_del_Client_e__c=certificado.client_address;
                    certificadoRecord.DSALES_Email__c=certificado.client_email;
                    certificadoRecord.DSALES_No_de_Telefono__c=certificado.client_telephone;
                    certificadoRecord.DSALES_Numero_celular__c=certificado.client_cellphone;
                    certificadoRecord.DSALES_SKU__c=certificado.sku;	
                    certificadoRecord.DSALES_Modelo__c=certificado.model_product;	
                    certificadoRecord.DSALES_Marca__c=certificado.brand_product;	
                    certificadoRecord.DSALES_Numero_serie__c=certificado.serial_number;	
                    certificadoRecord.DSALES_DescripcionDelArtculo__c=certificado.description_product;
                    certificadoRecord.DSALES_Precio_del_Articulo__c=certificado.product_price;
                    certificadoRecord.DSALES_Fecha_de_compra_GEX__c=certificado.purchase_product_date;
                    certificadoRecord.DSALES_Duracion_de_GEX__c=certificado.warranty_duration;	
                    certificadoRecord.DSALES_Fecha_de_compra_GEX__c=certificado.purchase_warranty_date;	
                    certificadoRecord.DSALES_Fecha_Inicio_de_Vigencia__c=certificado.extended_warranty_effective_date;
                    certificadoRecord.DSALES_Costo_de_Garantia_Extendida__c=certificado.cost_warranty;
                    certificadoRecord.DSALES_Fecha_Fin_Vigencia__c=certificado.extended_warranty_end_date;
                    certificadoRecord.DSALES_Fecha_de_venta_del_articulo__c=certificado.sales_date;
                    insert certificadoRecord;
                    
                    success = true;
                    message = 'Certificado successfully saved';
                    
                    
                }catch(Exception e){
                    success = false;
                    message = 'Error: ' + e.getMessage() +' Line: '+e.getLineNumber();
                    
                }
            }
        }
        DSALES_CertificadoWrapper.CertificadoResponse responsePayload = new DSALES_CertificadoWrapper.CertificadoResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.certificado_id = certificadoRecord.id;
        
        return responsePayload;
        
    }	     
    
}