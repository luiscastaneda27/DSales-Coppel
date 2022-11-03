@isTest
global with sharing class DSALES_SiniestroResumenPagosTest {

    @TestSetup
    static void SetUp(){
         

        Claim siniestro = new Claim(Name='SNT',ClaimType='Perdida Total',ClaimReason='Choque unilateral');
        insert siniestro;
        
		//Test.enableChangeDataCapture();       
        ClaimPaymentSummary resumenPago = new ClaimPaymentSummary(Name='Prueba del Test', ClaimId=siniestro.id, PaymentAmount=45678);
        insert resumenPago;
        
    }
    @isTest static void CreateRecordTest()
    {
        
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        Claim siniestro = [SELECT Id FROM  Claim  LIMIT 1];
        String body='{"claimpayment_info":"'+siniestro.Id+'","payment_amount":"45900","claimpayment_name":"Prueba funcional","payment_type":"Pago a cliente","payment_date": "2022-10-11"}';
        request.requestURI='/apexrest/insertClaimPaymentSummary'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_SiniestroRPWrapper.SiniestroRPRequest SiniestroRP = (DSALES_SiniestroRPWrapper.SiniestroRPRequest)JSON.deserialize(body, DSALES_SiniestroRPWrapper.SiniestroRPRequest.class);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponsePolizaTest());
        DSALES_SiniestroResumenPagos.createSiniestroRP();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
    @isTest static void CreateRecordTestWrong()
    {
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        Claim siniestro = [SELECT Id FROM  Claim  LIMIT 1];
        String body='{"claimpayment_info":"'+siniestro.Id+'","payment_amount":"45900","claimpayment_name":"Prueba funcional","payment_type":"Pago a cliente","payment_date": "2022-09-06"}';
        request.requestURI='/apexrest/insertClaimPaymentSummary/'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_SiniestroRPWrapper.SiniestroRPRequest SiniestroRP = (DSALES_SiniestroRPWrapper.SiniestroRPRequest)JSON.deserialize(body, DSALES_SiniestroRPWrapper.SiniestroRPRequest.class);
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponsePolizaTest());
        DSALES_SiniestroResumenPagos.createSiniestroRP();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
    }
    
}