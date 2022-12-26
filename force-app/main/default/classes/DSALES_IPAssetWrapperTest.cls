@isTest
global with sharing class DSALES_IPAssetWrapperTest {
    @testSetup
    static void SetUp(){
        Account ac= new Account(Name='DannyTest',CP_WalletCustomerNumber__c=90229562);  
        insert ac;
        Opportunity op = new Opportunity(Name='Danny',CloseDate=Date.today(),StageName='Nuevo');
        insert op;
         InsurancePolicy ip = new InsurancePolicy(Name='Danny',NameInsuredId=ac.id,DSALES_CorreoElectronico__c='kvothe.sanmiguel@gmail.com');
        insert ip;
        /*Asset producto= new Asset(Name='Danny',AccountId=ac.id);
        insert producto;*/
        DSALES_InformaciondePago__c pago = new DSALES_InformaciondePago__c(DSALES_Oportunidad__c=op.id,DSALES_Cliente__c=ac.Id,DSALES_Poliza__c=ip.id);
        insert pago;
    }
    @isTest static void CreateRecordTest()
    {
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        DSALES_InformaciondePago__c pago = [SELECT id,DSALES_Poliza__c FROM  DSALES_InformaciondePago__c  LIMIT 1];
        String body='{"payment_info":"'+pago.Id+'","store":"123","client_id":"0017500000GcwfMAAR","partner":"Prueba","external_motorcycle":true, "invoice_value":"1234","status":"Activo","key_amis":"DannyTest","key_vehicle":"DannyTest","description":"DannyTest","model":"DannyTest","brand":"DannyTest","motor_number":"DannyTest","serial_number":"DannyTest","license_plate":"DannyTest","service":"DannyTest","use":"DannyTest","asset_name":"DannyTest"}';
        request.requestURI='/apexrest/insertIPAsset'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_IPAssetWrapper.IPAssetRequest policyAsset =  (DSALES_IPAssetWrapper.IPAssetRequest)JSON.deserialize (body,DSALES_IPAssetWrapper.IPAssetRequest.class);
        //policyAsset.payment_info=pago.id;
        Test.startTest();
        DSALES_IPAssetWrapperRequest.createIPAsset();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
    
}