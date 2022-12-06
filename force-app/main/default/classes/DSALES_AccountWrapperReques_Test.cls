@isTest 
public class DSALES_AccountWrapperReques_Test{
    
     @isTest static void CreateRecordTest(){
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        String body = '{"client_number": "","first_name": "prueba Rojas","last_name": "Lopez prueba","telephone": "555 666 7779","email": "rosita55@gmail.com","contact_method": "Email","gender": "F","state_code": "Veracruz","city_code": "Xalapa","town_code": "Mexico","suburb_code": "Calle verazcruz 23","zip_code": "91000"}';
		
        req.requestURI = '/apexrest/insertAccount';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;
         
        DSALES_AccountWrapper.AccountRequest cliente = (DSALES_AccountWrapper.AccountRequest)JSON.deserialize(body, DSALES_AccountWrapper.AccountRequest.class);

        Test.startTest();
		DSALES_AccountWrapperRequest.createAccount();
		Test.stopTest();

        RestContext.request = req;
        RestContext.response= res;
    }
}