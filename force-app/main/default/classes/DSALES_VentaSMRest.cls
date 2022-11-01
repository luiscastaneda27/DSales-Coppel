@RestResource(urlMapping='/ventaSM/*')
global class DSALES_VentaSMRest {
	@HttpPost
    global static DSALES_VentaSM.VentaSMResponse createVenta() {
        Boolean success=false;
        String message='';
        String values='';
        DSALES_VentaSM.VentaSMResponse ventaSM= new DSALES_VentaSM.VentaSMResponse();
        
        if(RestContext.request != null){

            String Body = System.RestContext.request.requestBody.toString();
            message='El body es: '+success;
            
            if(String.isNotBlank(Body)){
                try{
                    DSALES_VentaSM.VentaSMRequest venta = (DSALES_VentaSM.VentaSMRequest)JSON.deserialize(body, DSALES_VentaSM.VentaSMRequest.class);
                    System.debug('venta'+venta);
                    DSALES_AccountWrapper.AccountResponse cliente = DSALES_AccountWrapperRequest.upsertAccount(venta.cliente);
                    System.debug('cliente: '+ cliente);
                    values=json.serialize(cliente);
                    venta.pagos.AccountId=cliente.account_id;
                    venta.pagos.quoteid=venta.quoteId;
                    System.debug('venta pagos:'+venta.pagos);

                    DSALES_PaymentInfoWrapper.PaymentResponse resp= DSALES_PaymentInfoWrapperRequest.insertPagos(venta.pagos);
                    System.debug('pagos: '+resp);
					System.debug('activo:'+venta.activos);
                    for(Id ids:resp.paymentInfo_ids){
                        insertIPAsset(venta.activos,ids,cliente.account_id);
                        
                    }
                    
                    
                    
                    success=true;
                    message='Sale created correctly. '+'QuoteID: '+venta.quoteId + 'ClientId: '+cliente.account_id+'Payment list: ' +venta.pagos + ' IPAsset list: '+venta.activos;
                    


                }catch(Exception ex){
                    message=ex.getMessage() + ' '+ ex.getLineNumber();
                    success=false;
                }
            }    

        }
        ventaSM.message=message + values;
		return ventaSM;
    }


    
    public static void insertIPAsset(DSALES_IPAssetWrapper.IPAssetRequest asset, String pagoId, String clientId){
        System.debug('Asset: '+asset);
        System.debug('cliente id: '+ clientId);
        System.debug('pago id: '+pagoId);
        Account clientNumber =[ SELECT Id, CP_WalletCustomerNumber__c FROM Account WHERE ID= :clientId];
        DSALES_InformacionDePago__c pago=[SELECT Id,DSALES_SKU__c FROM DSALES_InformacionDePago__c WHERE Id=:pagoId];
        //for(DSALES_IPAssetWrapper.IPAssetRequest asset:AssetInformation){
        asset.client_number=String.valueof(clientNumber.CP_WalletCustomerNumber__c);
        asset.payment_info = pagoId;
        if(pago.DSALES_SKU__c!=null){
            DSALES_IPAssetWrapperRequestActivo.insertActivo(asset);//moto entregada
            
        }
        else{
            DSALES_IPAssetWrapperRequest.insertIPAsset(asset);//moto externa
        }
            
        //}   
    }



}