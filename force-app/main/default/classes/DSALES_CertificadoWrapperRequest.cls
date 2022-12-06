@RestResource(urlMapping='/insertCertificado/*')
global with sharing class DSALES_CertificadoWrapperRequest {
    @HttpPost
    global static DSALES_CertificadoWrapper.CertificadoResponse createCertificado(){
        
        DSALES_CertificadoWrapper.CertificadoResponse responsePayload = new DSALES_CertificadoWrapper.CertificadoResponse();
        if(RestContext.request != null){
            String Body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(Body)){
                try{
                    DSALES_CertificadoWrapper.CertificadoRequest certificado = (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize(body, DSALES_CertificadoWrapper.CertificadoRequest.class);
                    responsePayload = insertCertificado(certificado);
                }
                
                catch(Exception.JSONException e)
                {
                    responsePayload.success = false;
                    responsePayload.error_message = DSALES_Utility.BAD_REQUEST_MSJ;
                    responsePayload.error_code=String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                    
                }
                 catch(Exception e){
                    responsePayload.success = false;
                    responsePayload.error_message = DSALES_Utility.INTERNAL_ERROR_MSJ;
                    responsePayload.error_code=String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    
                    
                }
            }
        }
        
        return responsePayload;
        
    }
    
    global static DSALES_CertificadoWrapper.CertificadoResponse insertCertificado(DSALES_CertificadoWrapper.CertificadoRequest certificado){
        DSALES_Certificado__c certificadoRecord = new DSALES_Certificado__c();
        Boolean success = false;
        String message = '';
        String code='';
        try{
            if(certificado.client_number!=null)
               {
                   Account cliente =[SELECT Id FROM ACCOUNT WHERE CP_WalletCustomerNumber__c=:Double.valueOf(certificado.client_number) LIMIT 1]; 
                    certificadoRecord.DSALES_Cliente__c=cliente.Id;
               }
            else
            {
                 certificadoRecord.DSALES_Cliente__c=certificado.account_id;
            }
                 
            certificadoRecord.DSALES_ProductoAdquirido__c=certificado.asset_id;
           
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
            message = '';
            system.debug('message' +message);
            
        } catch(Exception e){
                    success = false;
                    message = DSALES_Utility.INTERNAL_ERROR_MSJ;
                    code=String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    
                    
                }
        
        DSALES_CertificadoWrapper.CertificadoResponse responsePayload = new DSALES_CertificadoWrapper.CertificadoResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.error_code=code;
        responsePayload.certificado_id = certificadoRecord.id;
        
        return responsePayload;
    }
    
}