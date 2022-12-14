@RestResource(urlMapping='/ventaSM/*')
global class DSALES_VentaSMRest {
	@HttpPost
    global static DSALES_VentaSM.VentaSMResponse createVenta() {
        String client_id='';
        List<String> paymentIds= new List<String>();
        List<String> assetsId = new List<String>();
        Boolean success=false;
        String error_message='';
        Integer code;
        DSALES_VentaSM.VentaSMResponse ventaSM= new DSALES_VentaSM.VentaSMResponse();
        
        if(RestContext.request != null){

            String Body = System.RestContext.request.requestBody.toString();
           
            
            if(String.isNotBlank(Body)){
                try{
                    
                    DSALES_VentaSM.VentaSMRequest venta = (DSALES_VentaSM.VentaSMRequest)JSON.deserialize(body, DSALES_VentaSM.VentaSMRequest.class);
                    System.debug('venta'+venta);
                    DSALES_AccountWrapper.AccountResponse cliente = DSALES_AccountWrapperRequest.upsertAccount(venta.cliente);
                    client_id=cliente.account_id;
                    System.debug('cliente: '+ cliente);
                    //values=json.serialize(cliente);
                    venta.pagos.AccountId=cliente.account_id;
                    venta.pagos.quoteid=venta.quoteId;
                    System.debug('venta pagos:'+venta.pagos);

                    DSALES_PaymentInfoWrapper.PaymentResponse resp= DSALES_PaymentInfoWrapperRequest.insertPagos(venta.pagos);
                    System.debug('pagos: '+resp);
					System.debug('activo:'+venta.activos);
                    
                    for(Id ids:resp.paymentInfo_ids){
                        String temp=insertIPAsset(venta.activos,ids,cliente.account_id);
                        paymentIds.add(ids);
                        assetsId.add(temp);
                    }
                    success=true;
                }catch(Exception.JSONException je ){
                    success =false;
                    error_message=DSALES_Utility.BAD_REQUEST_MSJ;
                    code=DSALES_Utility.BAD_REQUEST_CODE;
                }catch(Exception ex){
                    error_message=DSALES_Utility.INTERNAL_ERROR_MSJ;
                    success=false;
                    code=DSALES_Utility.INTERNAL_ERROR_CODE;
                }
            }    

        }
        ventaSM.success=success;
        ventaSM.error_code=code;
        ventaSM.error_message=error_message;
        ventaSM.client_id=client_id;
        ventaSM.payments_id=paymentIds;
        ventaSM.assets_id=assetsId;
       
        
		return ventaSM;
    }


    
    public static String insertIPAsset(DSALES_IPAssetWrapper.IPAssetRequest asset, String pagoId, String clientId){
        System.debug('Asset: '+asset);
        System.debug('cliente id: '+ clientId);
        System.debug('pago id: '+pagoId);
        String assetId='';
        DSALES_IPAssetWrapper.IPAssetResponse response = new DSALES_IPAssetWrapper.IPAssetResponse();
        Account clientNumber =[ SELECT Id, CP_WalletCustomerNumber__c FROM Account WHERE ID= :clientId];
        DSALES_InformacionDePago__c pago=[SELECT Id,DSALES_SKU__c FROM DSALES_InformacionDePago__c WHERE Id=:pagoId];
        //for(DSALES_IPAssetWrapper.IPAssetRequest asset:AssetInformation){
       // asset.client_number=String.valueof(clientNumber.CP_WalletCustomerNumber__c);
       //asset.client_id=clientNumber.Id;
        asset.payment_info = pagoId;
        if(pago.DSALES_SKU__c!=null){
            response= DSALES_IPAssetWrapperRequestActivo.insertActivo(asset);//moto entregada
           
        }
        else{
            response=DSALES_IPAssetWrapperRequest.insertIPAsset(asset);//moto externa
        }
            
        return response.asset_id;
    }



}