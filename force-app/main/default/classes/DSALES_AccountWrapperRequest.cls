@RestResource(urlMapping='/insertAccount/*')
global with sharing class DSALES_AccountWrapperRequest {
    
    @HttpPost
    global static DSALES_AccountWrapper.AccountResponse createAccount(){ 
        Boolean success = false;
        String message = '';
        Account accountRecord = new Account();
        DSALES_AccountWrapper.AccountResponse responsePayload = new DSALES_AccountWrapper.AccountResponse();
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                try{
                    DSALES_AccountWrapper.AccountRequest cliente = (DSALES_AccountWrapper.AccountRequest)JSON.deserialize(body, DSALES_AccountWrapper.AccountRequest.class);
                    responsePayload = upsertAccount(cliente);
                }catch(JSONException e){
                    responsePayload.success = false;
                    responsePayload.error_code = String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                    responsePayload.error_message = DSALES_Utility.BAD_REQUEST_MSJ;
                }catch(Exception e){
                    responsePayload.success = false;
                    responsePayload.error_code = String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    responsePayload.error_message = DSALES_Utility.INTERNAL_ERROR_MSJ;
                }
            }
        }
        return responsePayload;
        
    }
    
    
    global static  DSALES_AccountWrapper.AccountResponse upsertAccount (DSALES_AccountWrapper.AccountRequest cliente){
        Boolean success = false;
        String message = '';
        String code = '';
        Account accountRecord = new Account();
        try{
            String nombre = cliente.first_name + ' '+ cliente.last_name;
            if(cliente.first_name.contains(' ')){
                List<String> nombres = cliente.first_name.split(' ');
                for(Integer i=0; i<nombres.size(); i++){
                    if(i==0){
                        cliente.first_name=nombres[0];
                    }else{
                        cliente.middle_name = nombres[i]+' ';
                    }
                }
                cliente.middle_name=cliente.middle_name.subString(0,cliente.middle_name.length()-1);
            }
            if(cliente.last_name.contains(' ')){
                List<String> apellidos = cliente.last_name.split(' ');
                for(Integer i=0; i<apellidos.size(); i++){
                    if(i==0){
                        cliente.last_name=apellidos[0];
                    }else{
                        cliente.suffix = apellidos[i]+' ';
                    }
                }
                cliente.suffix=cliente.suffix.subString(0,cliente.suffix.length()-1);
            }
            if(cliente.client_number == null || cliente.client_number ==''){
                for(Account item : [Select id from Account Where FirstName=:cliente.first_name and LastName=:cliente.last_name and PersonEmail= :cliente.email]){
                    accountRecord.Id = item.Id;
                }
            }else{
                for(Account item : [Select id from Account Where CP_WalletCustomerNumber__c =: Decimal.valueOf(cliente.client_number)]){
                    accountRecord.Id = item.Id;
                    accountRecord.CP_WalletCustomerNumber__c = Decimal.valueOf(cliente.client_number);
                }
            }
            accountRecord.FirstName = cliente.first_name;
            accountRecord.MiddleName = cliente.middle_name;
            accountRecord.LastName = cliente.last_name;
            accountRecord.Suffix = cliente.suffix;
            accountRecord.CP_MaritalStatus__pc = cliente.marital_status;
            accountRecord.PersonMobilePhone = cliente.telephone;
            accountRecord.PersonEmail = cliente.email;
            accountRecord.DSALES_Metodocontacto__pc = cliente.contact_method;
            accountRecord.CP_Gender__pc = cliente.gender;
            accountRecord.PersonBirthdate = cliente.birthdate;
            accountRecord.BillingState = cliente.state_code;
            accountRecord.BillingCity = cliente.city_code;
            accountRecord.BillingCountry = cliente.town_code;
            accountRecord.BillingStreet = cliente.suburb_code;
            accountRecord.BillingPostalCode = cliente.zip_code;
            
            upsert accountRecord;
            
            success = true;
            message = '';
            code = '';
            
        }catch(Exception e){
            success = false;
            message = DSALES_Utility.INTERNAL_ERROR_MSJ;
            code = String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
        }
        
        
        DSALES_AccountWrapper.AccountResponse responsePayload = new DSALES_AccountWrapper.AccountResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.error_code = code;
        responsePayload.account_id = accountRecord.id;
        
        return responsePayload;
    }
}