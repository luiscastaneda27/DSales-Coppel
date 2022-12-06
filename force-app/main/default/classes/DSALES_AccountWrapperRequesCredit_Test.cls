@isTest 
public class DSALES_AccountWrapperRequesCredit_Test{
    
    @isTest static void CreateCreditRecordTest(){
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String body = '{"client_number": "90001","first_name": "prueba","middle_name": "Rojas","last_name": "Lopez","suffix": "prueba contado","telephone": "555 666 7779","email": "rosita55@gmail.com","contact_method": "Email","gender": "F","state_code": "Veracruz","city_code": "Xalapa","town_code": "Mexico","suburb_code": "Calle verazcruz 23","zip_code": "91000"}';
        
        req.requestURI = '/apexrest/insertAccountCredit';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;
        
        DSALES_AccountWrapper.AccountRequest clienteCredito = (DSALES_AccountWrapper.AccountRequest)JSON.deserialize(body, DSALES_AccountWrapper.AccountRequest.class);
        
        Test.startTest();
        DSALES_AccountWrapperRequestCredit.createAccount();
        Test.stopTest();
        
        RestContext.request = req;
        RestContext.response= res;
    }
}