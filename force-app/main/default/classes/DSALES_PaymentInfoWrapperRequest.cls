@RestResource(urlMapping='/insertPaymentInformation/*')
global with sharing class DSALES_PaymentInfoWrapperRequest {
    
    @HttpPost
    global static DSALES_PaymentInfoWrapper.PaymentResponse createPayment(){
        Boolean success = false;
        String message = '';
        DSALES_InformacionDePago__c info = new DSALES_InformacionDePago__c();

         if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
             
             if(String.isNotBlank(body)){
                try{
                    DSALES_PaymentInfoWrapper.PaymentRequest pago = (DSALES_PaymentInfoWrapper.PaymentRequest)JSON.deserialize(body, DSALES_PaymentInfoWrapper.PaymentRequest.class);

                    String recordTypeId = Schema.SObjectType.DSALES_InformacionDePago__c.getRecordTypeInfosByName().get('Pagos de Venta en NPV de SM').getRecordTypeId();
                    Opportunity oportunidad = [Select id,AccountId,Account.Name from Opportunity where Name=: pago.opportunity_name];

                    info.DSALES_Oportunidad__c = oportunidad.Id;
                    info.DSALES_Cliente__c = oportunidad.AccountId;
                    info.Name = 'Pago -'+' '+oportunidad.Account.Name+' '+date.today().year()+'-'+date.today().month()+'-'+date.today().day();
                    info.DSALES_Estatus__c = 'Acreditado';
                    info.DSALES_Fecha__c = date.today();
                    info.DSALES_FormaDePago__c = pago.payment_method;
                    info.DSALES_Factura__c = pago.bill;
                    info.DSALES_DireccionCliente__c = pago.customer_adress;
                    info.DSALES_SKU__c = pago.sku;
                    info.DSALES_Montototal__c = pago.total;
                    info.DSALES_DescripcionArticulo__c = pago.article_description;
                    info.DSALES_Celular_del_Cliente__c = pago.telephone;
                    info.DSALES_Nombre_del_Vendedor__c = pago.salesman_name;
                    infO.DSALES_Caja__c = pago.cashier_box;
                    info.RecordTypeId=recordTypeId;
                    insert info;

					success = true;
        			message = 'Exito al registrar informacion de pago';
                    
                }catch(Exception e){
                    success = false;
                    message = 'Error: ' + e.getMessage();
             	}
             }
         }
    	DSALES_PaymentInfoWrapper.PaymentResponse responsePayload = new DSALES_PaymentInfoWrapper.PaymentResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.paymentInfo_id = info.Id;
        return responsePayload;
    }
    	
		
}