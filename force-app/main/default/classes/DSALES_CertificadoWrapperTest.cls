@isTest
global with sharing class DSALES_CertificadoWrapperTest {
   @testSetup
    static void SetUp(){
        Account ac= new Account(Name='DannyTest',CP_WalletCustomerNumber__c=123456);  
        insert ac;
    }
    @isTest static void CreateRecordTest()
    {
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        String body = '{"id_asset":"02i8J000000Ei7iQAC","client_number":"123456","store_id": "1234","coppel_box_number": "1234","salesman_id": "1234","client_address": "Montreal 169 Paseo Montejo","client_email": "dsanmiguel@deloittemx.com","client_telephone": "8130912906","client_cellphone": "812091342","sku": "ABCDS12","model_product": "Italika","brand_product": "Samsung","serial_number": "90001","description_product": "Muy bueno","product_price": "900","purchase_product_date": "2022-09-06","warranty_duration": "12","cost_warranty": "900","purchase_warranty_date": "2022-09-06","extended_warranty_end_date": "2022-09-06","extended_warranty_effective_date": "2022-09-06"}';
        request.requestURI='/apexrest/insertCertificado'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_CertificadoWrapper.CertificadoRequest certificado =  (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize (body,DSALES_CertificadoWrapper.CertificadoRequest.class);
         Account acc=[SELECT CP_WalletCustomerNumber__c FROM ACCOUNT WHERE NAME='DannyTest' LIMIT 1];
        certificado.client_number=String.ValueOf(acc.CP_WalletCustomerNumber__c);
        Test.startTest();
        DSALES_CertificadoWrapperRequest.createCertificado(acc.Id);
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
}