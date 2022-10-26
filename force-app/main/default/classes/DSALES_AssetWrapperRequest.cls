@RestResource(urlMapping='/insertAsset/*')
global with sharing class DSALES_AssetWrapperRequest {
    @HttpPost
    global static DSALES_AssetWrapper.AssetResponse createAsset()
    {
        Boolean success=false;
        String message='';
        Asset assetRecord = new Asset();
        if(RestContext.request != null){
            String Body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(Body)){
                try{
                    
                    DSALES_AssetWrapper.AssetRequest product = (DSALES_AssetWrapper.AssetRequest)JSON.deserialize(body, DSALES_AssetWrapper.AssetRequest.class);
                    DSALES_Categoria__c categoria=[SELECT id FROM DSALES_categoria__c WHERE name=:product.category ];
                    DSALES_Clase__c clase=[SELECT id FROM DSALES_clase__c WHERE name=:product.class_type];
                    DSALES_familia__c familia=[SELECT id FROM DSALES_familia__c WHERE name=:product.family];
                    
                    Account cliente =[SELECT Id FROM ACCOUNT WHERE CP_WalletCustomerNumber__c=:Double.valueOf(product.client_number) LIMIT 1];
                    assetRecord.Name=product.name;
                    assetRecord.AccountId=cliente.id;
                    assetRecord.ContactId=product.contact_id;
                    assetRecord.DSALES_TipoProducto__c=product.product_type;
                    assetRecord.DSALES_TipoSeguro__c=product.insurance_type;
                    assetRecord.DSALES_TipoServicio__c=product.service_type;
                    assetRecord.DSALES_CategoriaBuscar__c=categoria.id;
                    assetRecord.DSALES_ClaseBuscar__c=clase.id;
                    assetRecord.DSALES_FamiliaBuscar__c=familia.id;
                    assetRecord.Status=product.status;
                    assetRecord.DSALES_RegionList__c=product.region;
                    assetRecord.DSALES_Division__c=product.division;
                    // assetRecord.StockKeepingUnit=product.sku;
                    assetRecord.DSALES_DuracionGEX__c=product.warranty_duration;
                    assetRecord.SerialNumber=product.serial_number;
                    assetRecord.PurchaseDate=product.purchase_date;
                    assetRecord.Quantity=product.quantity;
                    assetRecord.Price=product.price;
                    assetRecord.DSALES_Precio_con_descuento_con_IVA__c=product.price_w_discount_w_vat;
                    assetRecord.DSALES_Precio_con_descuento_sin_IVA__c=product.price_w_discount_no_vat;
                    assetRecord.DSALES_PrecioSINIVA__c=product.price_no_vat;
                        
                    
                    insert assetRecord;
                    
                    success = true;
                    message = 'Asset successfully saved';
                    
                    
                }catch(Exception e){
                    success = false;
                    message = 'Error: ' + e.getMessage() +' Line: '+e.getLineNumber();
                    
                }
            }
        }
        DSALES_AssetWrapper.AssetResponse responsePayload = new DSALES_AssetWrapper.AssetResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.Asset_id = AssetRecord.id;
        
        return responsePayload;
        
    }	     
}