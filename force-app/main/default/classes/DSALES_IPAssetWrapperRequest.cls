@RestResource(urlMapping='/insertIPAsset/*')
global with sharing class DSALES_IPAssetWrapperRequest {
    @HttpPost
    global static DSALES_IPAssetWrapper.IPAssetResponse createIPAsset()
    {
        DSALES_IPAssetWrapper.IPAssetResponse policyAssetRes= new DSALES_IPAssetWrapper.IPAssetResponse();
        if(RestContext.request != null){
            String Body = System.RestContext.request.requestBody.toString();

            
            if(String.isNotBlank(Body)){
                try{
                    DSALES_IPAssetWrapper.IPAssetRequest policyAsset = (DSALES_IPAssetWrapper.IPAssetRequest)JSON.deserialize(body, DSALES_IPAssetWrapper.IPAssetRequest.class);
                    policyAssetRes= insertIPAsset(policyAsset);

                    
                }catch(Exception.JSONException e)
                {
                    policyAssetRes.success = false;
                    policyAssetRes.error_message = DSALES_Utility.BAD_REQUEST_MSJ;
                    policyAssetRes.error_code=String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                    
                }
                catch(Exception e){
                    policyAssetRes.success = false;
                    policyAssetRes.error_message = DSALES_Utility.INTERNAL_ERROR_MSJ;
                    policyAssetRes.error_code=String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    
                    
                }
            }
        }

        return policyAssetRes;
       
    }	 
    
    
    global static DSALES_IPAssetWrapper.IPAssetResponse insertIPAsset(DSALES_IPAssetWrapper.IPAssetRequest policyAsset)
    {
        Boolean success=false;
        String message='';
        String code='';

        InsurancePolicyAsset IPassetRecord  = new InsurancePolicyAsset();



        try {
            Account cliente =[SELECT Id,Name FROM ACCOUNT WHERE Id=:policyAsset.client_id LIMIT 1];
            DSALES_InformacionDePago__c pago=[SELECT Id,DSALES_Poliza__c, DSALES_Motoexterna__c,DSALES_Motosinseguro__c FROM DSALES_InformacionDePago__c WHERE id=:policyAsset.payment_info];
            if(pago.DSALES_Motosinseguro__c == false) {
                IPassetRecord.DSALES_InformacionPago__c=pago.Id;
                IPassetRecord.DSALES_Account__c=cliente.Id;
                IPassetRecord.DSALES_Tienda__c=policyAsset.store;
                IPassetRecord.DSALES_Colaborador__c=policyAsset.partner;
                IPassetRecord.DSALES_Motoexterna__c=policyAsset.external_motorcycle; 
                IPassetRecord.DSALES_Valorfactura__c=policyAsset.invoice_value;
                IPassetRecord.InsurancePolicyId=pago.DSALES_Poliza__c;
                IPassetRecord.Estatus__c=policyAsset.status;
                IPassetRecord.DSALES_ClaveAMIS__c=policyAsset.key_amis;
                IPassetRecord.DSALES_Clavevehicular__c=policyAsset.key_vehicle;
                IPassetRecord.DSALES_Descripcion__c=policyAsset.description;
                IPassetRecord.DSALES_Modelo__c=policyAsset.model;
                IPassetRecord.DSALES_Marca__c=policyAsset.brand;
                IPassetRecord.DSALES_Numeromotor__c=policyAsset.motor_number;
                IPassetRecord.DSALES_Numeroserie__c=policyAsset.serial_number;
                IPassetRecord.DSALES_Placas__c=policyAsset.license_plate;
                IPassetRecord.DSALES_Servicio__c=policyAsset.service;
                IPassetRecord.DSALES_Uso__c  =policyAsset.use;
                IPassetRecord.AssetName=policyAsset.asset_name;
                pago.DSALES_Motoexterna__c= policyAsset.external_motorcycle;               
                
                insert IPassetRecord;
                update pago;
                
                success = true;
                message = 'IPAsset successfully saved';
            
                
            } else {
        
                success = false;
                message = 'Error: No es un pago de SM, moto sin seguro ';
                
            }

            
        } catch (Exception e) {
            success = false;
           message = DSALES_Utility.BAD_REQUEST_MSJ;
                    code=String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
        }

        DSALES_IPAssetWrapper.IPAssetResponse responsePayload = new DSALES_IPAssetWrapper.IPAssetResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.Asset_id = IPAssetRecord.id;
        
        return responsePayload;

        

    }
    

}