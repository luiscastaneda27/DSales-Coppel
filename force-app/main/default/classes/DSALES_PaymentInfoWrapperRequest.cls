@RestResource(urlMapping='/insertPaymentInformationSM/*')
global with sharing class DSALES_PaymentInfoWrapperRequest {
    
    @HttpPost
    global static DSALES_PaymentInfoWrapper.PaymentResponse createPayment(){
        DSALES_PaymentInfoWrapper.PaymentResponse responsePayload = new DSALES_PaymentInfoWrapper.PaymentResponse();
        if(RestContext.request != null){
            try{
                String body = System.RestContext.request.requestBody.toString();
                if(String.isNotBlank(body)){
                    DSALES_PaymentInfoWrapper.PaymentRequest pago = (DSALES_PaymentInfoWrapper.PaymentRequest)JSON.deserialize(body, DSALES_PaymentInfoWrapper.PaymentRequest.class);
                    responsePayload = insertPagos(pago);
                }          
            }catch(Exception e){
                responsePayload.success = false;
                responsePayload.error_message = 'Error: ' + e.getMessage() +' '+e.getLineNumber();              
            }
        }
        return responsePayload;
    }
    public static Id creaInfoPago(DSALES_PaymentInfoWrapper.PaymentRequest pago, Quote cotizacion, String sku, String article_description){
        Opportunity EsGenerico = [Select Id, SyncedQuoteId, AccountId, Account.Name from Opportunity where Id =:cotizacion.OpportunityId];
        DSALES_InformacionDePago__c info = new DSALES_InformacionDePago__c();
        String recordTypeId = Schema.SObjectType.DSALES_InformacionDePago__c.getRecordTypeInfosByName().get('Pagos de Venta en NPV de SM').getRecordTypeId();
        info.DSALES_Oportunidad__c = cotizacion.OpportunityId;
        info.RecordTypeId = recordTypeId;
        info.DSALES_Cliente__c = EsGenerico.AccountId;
        info.DSALES_Estatus__c = 'Acreditado';
        info.DSALES_Fecha__c = date.today();
        info.DSALES_FormaDePago__c = pago.payment_method;
        info.DSALES_Factura__c = pago.bill;
        info.DSALES_DireccionCliente__c = pago.customer_adress;
        info.DSALES_SKU__c = sku;
        info.DSALES_Montototal__c = pago.total;
        info.DSALES_DescripcionArticulo__c = article_description;
        info.DSALES_Celular_del_Cliente__c = pago.telephone;
        info.DSALES_Nombre_del_Vendedor__c = pago.salesman_name;
        info.DSALES_Caja__c = pago.cashier_box;
        info.DSALES_Motoentregada__c = pago.moto_delivered;
        info.DSALES_Motoexterna__c = pago.external_moto;
        info.DSALES_Motosinseguro__c = pago.moto_noInsurance;
        info.DSALES_TipoCompra__c = pago.tipoProducto;
        insert info;
        return info.Id;
    }
    
    public static DSALES_PaymentInfoWrapper.PaymentResponse insertPagos(DSALES_PaymentInfoWrapper.PaymentRequest pago){
        Boolean success = false;
        String message = '';
        String consulta='no ha entrado en nada';
        List<Id> listaPagos = new List<Id>();
        try{
            Quote cotizacion = [Select id, Name,DSales_ID_Tienda__c, DSales_Tienda__c, ExpirationDate, RecordTypeId, DSALES_Fechadecreacionpresupuesto__c, Lista_negra__c, Motivo_de_lista_negra__c, Phone,
                                DSALES_Fechadenacimiento__c, DSALES_Cdigodeestado__c, DSALES_Cdigodemunicipio__c, DSALES_Suburbcode__c, DSALES_Cdigopostal__c, DSALES_IDdelvehculo__c, DSALES_Opcindepago__c,
                                DSALES_Cobertura__c, DSales_Vendedor__c, DSALES_Gnero__c, DSALES_Fechadecomienzodepliza__c,Email, TotalPrice, IsSyncing, OpportunityId from Quote where Id =:pago.quoteid];
            Opportunity EsGenerico = [Select Id, SyncedQuoteId, AccountId, Account.Name from Opportunity where Id =:cotizacion.OpportunityId];
            Opportunity nueva = new Opportunity();
            Id TomarIdOportunidad = EsGenerico.Id;
            if(EsGenerico.Account.Name == '90001 -'){
                EsGenerico.AccountId = pago.AccountId;
                update EsGenerico;
            }
            Double totalSeguro = 0;
            Double totalMoto = 0;
            Double total = 0;
            
            for(DSALES_PaymentInfoWrapper.pago item: pago.ListadePagos){
                if(item.producto == 'moto'){
                    totalMoto += item.total;
                    
                }
                if(item.producto == 'seguro'){
                    totalSeguro += item.total;
                }                      
            }
            total = totalMoto + totalSeguro;
            
            if(total == cotizacion.TotalPrice){
                consulta = 'Compro los dos';
                List<QuoteLineItem> partidas = [Select DSALES_SKU__c,DSALES_NombreProducto__c,PricebookEntryId, Product2Id, Quantity, DSALES_Fechadeinicio__c, DSALES_Fechadetermino__c, DSALES_Primaneta__c, UnitPrice, DSALES_Derechosdepliza__c, DSALES_Gastosdeoperacindelrecibo__c, DSALES_Impuestos__c, TotalPrice from QuoteLineItem where QuoteId =:cotizacion.Id];
                for(QuoteLineItem objeto: partidas){
                    pago.total = objeto.UnitPrice;
                    Id aux = creaInfoPago(pago, cotizacion, objeto.DSALES_SKU__c, objeto.DSALES_NombreProducto__c); 
                    listaPagos.add(aux);
                }
                EsGenerico.StageName = 'Cerrada ganada';
                EsGenerico.SyncedQuoteId = cotizacion.Id; 
                update EsGenerico;
            }
            else{
                List<QuoteLineItem> eliminarItem = [Select DSALES_SKU__c,DSALES_NombreProducto__c,PricebookEntryId, Product2Id, Quantity, DSALES_Fechadeinicio__c, DSALES_Fechadetermino__c, DSALES_Primaneta__c, UnitPrice, DSALES_Derechosdepliza__c, DSALES_Gastosdeoperacindelrecibo__c, DSALES_Impuestos__c, TotalPrice from QuoteLineItem where QuoteId =:cotizacion.Id];
                
                for(QuoteLineItem objeto: eliminarItem){
                    if(objeto.TotalPrice == totalMoto){
                        pago.total = totalMoto;
                        Id aux = creaInfoPago(pago, cotizacion, objeto.DSALES_SKU__c, objeto.DSALES_NombreProducto__c);
                        listaPagos.add(aux);
                        consulta = 'pago moto';
                    }
                    if(objeto.TotalPrice == totalSeguro){
                        pago.total = totalSeguro;
                        Id aux = creaInfoPago(pago, cotizacion, objeto.DSALES_SKU__c, objeto.DSALES_NombreProducto__c);
                        listaPagos.add(aux);
                        EsGenerico.SyncedQuoteId = cotizacion.Id;
                        EsGenerico.StageName = 'Cerrada ganada';
                        update EsGenerico;
                        consulta = 'pago seguro';                                
                    }
                }               
            }
            success = true;
            message = 'Exito al registrar informacion de pago '+consulta;
            
        }catch(Exception e){
            success = false;
            message = 'Error: ' + e.getMessage() +' '+e.getLineNumber()+', consulta: '+consulta;              
        }
        DSALES_PaymentInfoWrapper.PaymentResponse responsePayload = new DSALES_PaymentInfoWrapper.PaymentResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.paymentInfo_ids = listaPagos;
        return responsePayload;
    }
}