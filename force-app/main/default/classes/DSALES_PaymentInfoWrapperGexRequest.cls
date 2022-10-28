@RestResource(urlMapping='/insertPaymentInformationGEX/*')
global with sharing class DSALES_PaymentInfoWrapperGexRequest {
    
   
    @HttpPost
    global static DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse createPayment(){
        DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse responsePayload = new DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse();
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                try{
                    DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest pago = (DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest)JSON.deserialize(body, DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest.class);
                    responsePayload = insertPaymentGex(pago);
                }catch(Exception e){
                    responsePayload.success = false;
                    responsePayload.error_message = 'Error: ' + e.getMessage() +' Line: '+e.getLineNumber();
                }
            }
        }
        return responsePayload;
    }
    
    global static DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse insertPaymentGex(DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest payment){
        Boolean success = false;
        String message = '';
        DSALES_InformacionDePago__c info = new DSALES_InformacionDePago__c();
                try{
                    String recordTypeId = Schema.SObjectType.DSALES_InformacionDePago__c.getRecordTypeInfosByName().get('Pagos de Venta en NPV de GEX').getRecordTypeId();
                    info.RecordTypeId = recordTypeId;
                    info.DSALES_Clave_Tienda__c = payment.store_key;
                    info.DSales_Tienda__c = payment.Store_id;
                    info.DSALES_TipoCompra__c = payment.product_type;
                    info.DSALES_Estatus__c = payment.status;
                    info.DSALES_Factura__c = payment.bill;
                    info.DSALES_Caja__c = payment.cashier_box;
                    info.DSALES_Vendedor__c = payment.vendor_id;
                    info.DSALES_Nombre_del_Vendedor__c = payment.vendor_name;
                    info.DSALES_ExpEn__c = payment.exp_en;
                    info.DSALES_Cliente__c = payment.client_id;
                    info.DSALES_DireccionCliente__c =  payment.customer_adress;
                    info.DSALES_No_de_cliente__c = payment.customer_number;
                    info.DSALES_TelefonoCliente__c = payment.telephone;
                    info.DSALES_Celular_del_Cliente__c = payment.movilPhone;
                    info.DSALES_ProductoAdquirido__c = payment.asset_id;
                    info.DSALES_Precio__c = payment.price;
                    info.DSALES_TotalContado__c = payment.cash_total;
                    info.DSALES_CreditoIVA__c = payment.credit_VAT;
                    info.DSALES_Saldodineroelec__c = payment.electronic_money;
                    info.DSALES_dineroelectronico__c = payment.paymentElectronic_money;
                    info.DSALES_Pagoefectivo__c = payment.cash_payment;
                    info.DSALES_Cambio__c =  payment.change;
                    info.DSALES_Ganodineroelec__c = payment.wonElectronic_money;
                    info.DSALES_GEXPagada__c = payment.GEX_paid;
                    info.DSALES_Certificado__c = payment.certified_id;
                    info.DSALES_Oportunidad__c = payment.opportunity_id;
                    info.DSALES_PrecioSinIVA__c = payment.price_noVAT;
                    info.DSALES_PrecioDesIVA__c = payment.price_DiscountVAT;
                    info.DSALES_PrecioDesSinIVA__c = payment.price_DiscountNoVAT;
                    
                    insert info;
                    success = true;
                    message = 'Exito al registrar informacion de pago';
                }catch(Exception e){
                    success = false;
                    message = 'Error Pago: ' + e.getMessage() +' Line: '+e.getLineNumber();

        }
        DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse responsePayload = new DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.paymentInfo_id = info.Id;
        
        return responsePayload;
    }
}