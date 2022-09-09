@RestResource(urlMapping='/insertAccountCredit/*')
global with sharing class DSALES_AccountWrapperRequestCredit {
    
    @HttpPost
    global static DSALES_AccountWrapper.AccountResponse createAccount(){ 
        Boolean success = false;
        String message = '';
        Account accountRecord = new Account();
        
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                try{
                    DSALES_AccountWrapper.AccountRequest clienteCredito = (DSALES_AccountWrapper.AccountRequest)JSON.deserialize(body, DSALES_AccountWrapper.AccountRequest.class);
                    accountRecord.AccountNumber = clienteCredito.client_number;
                    accountRecord.CP_WalletCustomerNumber__c = Decimal.valueOf(clienteCredito.client_number);
                    accountRecord.FirstName = clienteCredito.first_name;
                    accountRecord.MiddleName = clienteCredito.middle_name;
                    accountRecord.LastName = clienteCredito.last_name;
                    accountRecord.Suffix = clienteCredito.suffix;
                    accountRecord.PersonMobilePhone = clienteCredito.telephone;
                    accountRecord.PersonEmail = clienteCredito.email;
                    accountRecord.DSALES_Metodocontacto__pc = clienteCredito.contact_method;
                    accountRecord.CP_Gender__pc = clienteCredito.gender;
                    accountRecord.PersonBirthdate = clienteCredito.birthdate;
                    accountRecord.BillingState = clienteCredito.state_code;
                    accountRecord.BillingCity = clienteCredito.city_code;
                    accountRecord.BillingCountry = clienteCredito.town_code;
                    accountRecord.BillingStreet = clienteCredito.suburb_code;
                    accountRecord.BillingPostalCode = clienteCredito.zip_code;
                    //accountRecord.DSALES_DeseaserContactado__c = clienteCredito.contact_now;
                    
                    //Database.query('SELECT Id FROM Account WHERE CP_WalletCustomerNumber__c =\'' +clienteCredito.client_number+ '\'')
                    list<Account> result = [Select Id from Account WHERE CP_WalletCustomerNumber__c =:Decimal.valueOf(clienteCredito.client_number)];
                    if(result.size()!= 0){
                        success = false;
                        message = 'An account already exists';
                    }else{
                        insert accountRecord;
                        success = true;
                        message = 'Account successfully saved';
                    }
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