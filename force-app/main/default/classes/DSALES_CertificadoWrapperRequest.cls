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
                    responsePayload.exito = false;
                    responsePayload.mensaje_error = DSALES_Utility.BAD_REQUEST_MSJ;
                    responsePayload.codigo_error=String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                    
                }
                 catch(Exception e){
                    responsePayload.exito = false;
                    responsePayload.mensaje_error = DSALES_Utility.INTERNAL_ERROR_MSJ;
                    responsePayload.codigo_error=String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    
                    
                }
            }
        }
        
        return responsePayload;
        
    }
    @HttpPut
     global static DSALES_CertificadoWrapper.CertificadoResponse  putCertificado(String name, String estado, Boolean asset){
        name=name.toUpperCase();
         String message='';
        String certId='';
        Boolean success=false;
        String code='';
         
         if(estado.containsIgnoreCase('dev') ||estado.containsIgnoreCase('can'))
         { 
         try{
              DSALES_Certificado__c certi= [SELECT Name,Id, DSALES_ProductoAdquirido__c FROM DSALES_Certificado__c WHERE Name=:name ];
             
         if(estado.containsIgnoreCase('dev'))
         {
             estado='Devuelto';
         }
         else if (estado.containsIgnoreCase('can'))
         {
             estado='Cancelado';
         }
     
           
      	DSALES_Certificado__c certificado= new DSALES_Certificado__c(
         Id=certi.id,
         DSALES_Estatus__c=estado
         );
         upsert certificado;
             certId=certificado.id;
             success=true;
             message='Certificado actualizado:';
           
           if(asset && certi.DSALES_ProductoAdquirido__c!=null)
           {
               Asset prod = [SELECT Status FROM Asset Where id=:certi.DSALES_ProductoAdquirido__c]; 
               prod.Status=estado;      
               Update prod;
               message+= ' y Producto Adquirido actualizado, con Id: '+prod.Id;
           }
             
         }
          catch(Exception.JSONException e)
                {
                   message=DSALES_Utility.BAD_REQUEST_MSJ;
                   code=String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                    success=false;       
                }
         catch(Exception e)
         {
              message=DSALES_Utility.INTERNAL_ERROR_MSJ + ' '+ e.GetMessage() ;
             
                   code=String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    success=false;       
         }
         }
         else
         {
              message=DSALES_Utility.INTERNAL_ERROR_MSJ;
                   code=String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    success=false;    
         }
          DSALES_CertificadoWrapper.CertificadoResponse responsePayload = new DSALES_CertificadoWrapper.CertificadoResponse();
        responsePayload.exito = success;
        responsePayload.mensaje_error = message;
        responsePayload.codigo_error=code;
        responsePayload.id_certificado =certId;
         return responsePayload;
     
     }
    
    
    global static DSALES_CertificadoWrapper.CertificadoResponse insertCertificado(DSALES_CertificadoWrapper.CertificadoRequest certificado){
        DSALES_Certificado__c certificadoRecord = new DSALES_Certificado__c();
        Boolean success = false;
        String message = '';
        String code='';
        try{
            if(certificado.numero_cliente!=null)
               {
                   Account cliente =[SELECT Id FROM ACCOUNT WHERE CP_WalletCustomerNumber__c=:Double.valueOf(certificado.numero_cliente) LIMIT 1]; 
                    certificadoRecord.DSALES_Cliente__c=cliente.Id;
               }
            else
            {
                 certificadoRecord.DSALES_Cliente__c=certificado.id_cuenta;
            }
                 
            certificadoRecord.DSALES_ProductoAdquirido__c=certificado.id_producto_adquirido;
           
            certificadoRecord.DSALES_Ticket__c=certificado.ticket;
            certificadoRecord.DSALES_Tienda__c=certificado.clave_tienda;
             certificadoRecord.DSALES_TiendaId__c=certificado.id_tienda;
            certificadoRecord.DSALES_Caja_GEX__c=certificado.numero_caja_coppel;
            certificadoRecord.DSALES_Numero_de_Vendedor__c=certificado.id_vendedor;
            certificadoRecord.DSALES_Nombre_Vendedor__c=certificado.nombre_vendedor;	
            certificadoRecord.DSALES_Domicilio_del_Client_e__c=certificado.direccion_cliente;
            certificadoRecord.DSALES_Email__c=certificado.email_cliente;
            certificadoRecord.DSALES_No_de_Telefono__c=certificado.telefono_cliente;
            certificadoRecord.DSALES_Numero_celular__c=certificado.celular_cliente;
            certificadoRecord.DSALES_SKU__c=certificado.sku;	
            certificadoRecord.DSALES_Modelo__c=certificado.modelo_tangible;	
            certificadoRecord.DSALES_Marca__c=certificado.marca_tangible;	
            certificadoRecord.DSALES_Numero_serie__c=certificado.numero_serie;	
            certificadoRecord.DSALES_DescripcionDelArtculo__c=certificado.descripcion_tangible;
            certificadoRecord.DSALES_Precio_del_Articulo__c=certificado.precio_tangible;
            certificadoRecord.DSALES_Fecha_de_compra_GEX__c=certificado.fecha_compra_tangible;
            certificadoRecord.DSALES_Duracion_de_GEX__c=certificado.garantia_coppel_tangible;	
            certificadoRecord.DSALES_Fecha_de_compra_GEX__c=certificado.fecha_compra_garantia;	
            certificadoRecord.DSALES_Fecha_Inicio_de_Vigencia__c=certificado.fecha_inicio_garantia_extendida;
            certificadoRecord.DSALES_Costo_de_Garantia_Extendida__c=certificado.costo_garantia;
            certificadoRecord.DSALES_Fecha_Fin_Vigencia__c=certificado.fecha_fin_garantia_extendida;
            certificadoRecord.DSALES_Fecha_de_venta_del_articulo__c=certificado.fecha_venta;
            
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
        responsePayload.exito = success;
        responsePayload.mensaje_error = message;
        responsePayload.codigo_error=code;
        responsePayload.id_certificado = certificadoRecord.id;
        
        return responsePayload;
    }
    
}