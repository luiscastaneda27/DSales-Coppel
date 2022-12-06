@RestResource(urlMapping='/ventaGex/*')
global class DSALES_VentaGEXRest {
     
    @HttpPost
    global static DSALES_VentaGEX.VentaGexResponse createVenta() {
        List<String> assetsId = new List<String>();
         List<String> paymentIds= new List<String>();
         List<String> certifiedIds= new List <String>();
        Boolean success=false;
        String message='';
        String code='';
       
    
       
        DSALES_VentaGEX.VentaGexResponse ventaGEX= new DSALES_VentaGEX.VentaGexResponse();
        
        if(RestContext.request != null){
            String Body = System.RestContext.request.requestBody.toString();
            if(String.isNotBlank(Body)){
                try{
                    DSALES_VentaGEX.VentaGexRequest venta = (DSALES_VentaGEX.VentaGexRequest)JSON.deserialize(body, DSALES_VentaGEX.VentaGexRequest.class);
                    DSALES_AccountWrapper.AccountResponse cliente = DSALES_AccountWrapperRequest.upsertAccount(venta.cliente);
                    validarCliente(venta.quoteId, cliente.account_id);
                    Map<String, String> mapAssets = insertAssets(venta.listAssets, cliente.account_id); 
                     for (String assetId : mapAssets.values())
                     {
                         assetsId.add(assetId);
                     }
                    if(venta.certificado!=null){
                        Map<String, String> mapCertifieds = insertCertified(venta.certificado, cliente.account_id, mapAssets);
                        for(String certificadoId: mapCertifieds.values())
                        {
                            certifiedIds.add(certificadoId);
                        }
                        for(DSALES_CertificadoWrapper.CertificadoRequest cert : venta.certificado){
                            for(DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest payInfo : venta.paymentInformation){
                                if(cert.sku_tangible == payInfo.sku){
                                    payInfo.certified_id = mapCertifieds.get(cert.sku);
                                }
                            }
                        }
                    }
                  paymentIds=insertPaymentInfo(venta.paymentInformation, cliente.account_id, mapAssets, venta.quoteId);
                    DSALES_ValidarClienteHelper.recepcionProductos(venta.certificado, venta.quoteid);
                    DSALES_ValidarClienteHelper.deleteTangibles(venta.listAssets, venta.quoteId);
                    
                    success=true;
                    message='';
                }catch(JSONException e){
                    success = false;
                    message = DSALES_Utility.BAD_REQUEST_MSJ;
                    code = String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                }catch(Exception ex){
                    success = false;
                    message = DSALES_Utility.INTERNAL_ERROR_MSJ;
                    code = String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                }
            }
        }
       
        ventaGEX.success = success;
        ventaGEX.error_message=message;
        ventaGEX.error_code=code;
        ventaGEX.assets_id=assetsId;
        ventaGEX.certifieds_id=certifiedIds;
        ventaGEX.payments_id=paymentIds;
        //ventaGEX.assets_id=responsePayloadAsset;
        return ventaGEX;
    }
    
    
    
    public static Boolean validarCliente(String quoteId, String accountId){
        Quote cotizacion = [SELECT Id,AccountId,OpportunityId,Opportunity.AccountId FROM Quote WHERE Id= :quoteId];
        cotizacion.DSALES_Enviarcotizacion__c = true;

        Opportunity oportunidad = new Opportunity();
        oportunidad.AccountId = accountId;
        oportunidad.SyncedQuoteId=quoteId;
        oportunidad.Id = cotizacion.OpportunityId;
        
        try{
            update cotizacion;
            update oportunidad;
            return true;
        }catch(Exception e){
            return false;
        }
        
        
    }
    
    public static Map<String, String> insertAssets(List<DSALES_AssetWrapper.AssetRequest> listAssets, String accountId){
        Map<String, String> mapAssets = new Map<String, String>();
        List<String> listSKU = new List<String>();
        List<String> idsAssets = new List<String>();
        for(DSALES_AssetWrapper.AssetRequest sku: listAssets){
            listSKU.add(sku.sku);
        }
        for(Product2 t: [Select StockKeepingUnit from Product2 where StockKeepingUnit in :listSKU and DSales_Tipo_de_Producto__c='Producto']){
            for(DSALES_AssetWrapper.AssetRequest producto: listAssets){
                if(t.StockKeepingUnit == producto.sku){
                    producto.account_id=accountId;
                    DSALES_AssetWrapper.AssetResponse responsePayloadAsset = DSALES_AssetWrapperRequest.insertAssets(producto);
                    mapAssets.put(t.StockKeepingUnit, responsePayloadAsset.asset_id);
                    idsAssets.add(responsePayloadAsset.asset_id);
                   
                }
            }
        }
        return mapAssets;
    }
    
    public static Map<String, String> insertCertified(List<DSALES_CertificadoWrapper.CertificadoRequest> certificado, String accountId, Map<String, String> mapAssets){
        Map<String, String> mapCertifieds = new Map<String, String>();
        List<String> listSKUCertifieds = new List<String>();
        for(DSALES_CertificadoWrapper.CertificadoRequest sku: certificado){
            listSKUCertifieds.add(sku.sku);
        }
        for(Product2 t: [Select StockKeepingUnit from Product2 where StockKeepingUnit in :listSKUCertifieds and DSales_Tipo_de_Producto__c='Servicio']){
            for(DSALES_CertificadoWrapper.CertificadoRequest productoGex: certificado){
                if(t.StockKeepingUnit == productoGex.sku){
                    productoGex.account_id =accountId;
                    productoGex.asset_id = mapAssets.get(productoGex.sku_tangible);
                    system.debug('Asset al que va: '+productoGex.asset_id);
                    DSALES_CertificadoWrapper.CertificadoResponse responsePayloadCertifieds = DSALES_CertificadoWrapperRequest.insertCertificado(productoGex);
                    mapCertifieds.put(t.StockKeepingUnit, responsePayloadCertifieds.certificado_id);
                }
            }
        }
        return mapCertifieds;
    }
    
    public static List<String> insertPaymentInfo(List<DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest> paymentInformation, String accountId, Map<String, String> assetsId, String quoteId){
        Map<String, String> mapStores = new Map<String, String>();
        List<String> listStores = new List<String>();
        List<String> ids= new List<String>();
        
        Quote cotizacion = [SELECT OpportunityId FROM Quote WHERE Id= :quoteId];
        for(DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest stores: paymentInformation){
            listStores.add(stores.store_key);
        }
        for(Tienda__c store: [select id,DSales_TiendaID__c from Tienda__c where DSales_TiendaID__c in :listStores]){
            mapStores.put(store.DSales_TiendaID__c, store.Id);
        }
        for(DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest pagos : paymentInformation){
            pagos.store_id = mapStores.get(pagos.store_key);
            pagos.client_id = accountId;
            pagos.asset_id =  assetsId.get(pagos.sku);
            pagos.opportunity_id = cotizacion.OpportunityId;
            
            DSALES_PaymentInfoWrapperGEX.PaymentGEXResponse responsePaymInfo = DSALES_PaymentInfoWrapperGexRequest.insertPaymentGex(pagos);
          ids.add(responsePaymInfo.paymentInfo_id);
            
            
        }
        return ids;
    }
}