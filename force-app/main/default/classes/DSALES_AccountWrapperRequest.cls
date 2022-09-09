@RestResource(urlMapping='/insertAccount/*')
global with sharing class DSALES_AccountWrapperRequest {
    
    @HttpPost
    global static DSALES_AccountWrapper.AccountResponse createAccount(){ 
        Boolean success = false;
        String message = '';
        Account accountRecord = new Account();
        
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                try{
                    DSALES_AccountWrapper.AccountRequest cliente = (DSALES_AccountWrapper.AccountRequest)JSON.deserialize(body, DSALES_AccountWrapper.AccountRequest.class);
                    accountRecord.AccountNumber = cliente.client_number;
                    accountRecord.CP_WalletCustomerNumber__c = Decimal.valueOf(cliente.client_number);
                    accountRecord.FirstName = cliente.first_name;
                    accountRecord.MiddleName = cliente.middle_name;
                    accountRecord.LastName = cliente.last_name;
                    accountRecord.Suffix = cliente.suffix;
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
                    //accountRecord.DSALES_DeseaserContactado__c = cliente.contact_now;
                    
                    insert accountRecord;
                    
                    success = true;
                    message = 'Account successfully saved';
                    
                    
                }catch(Exception e){
                    success = false;
                    message = 'Error: ' + e.getMessage();
                }
            }
        }
        DSALES_AccountWrapper.AccountResponse responsePayload = new DSALES_AccountWrapper.AccountResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.account_id = accountRecord.id;
        
        return responsePayload;
        
    }	     
}