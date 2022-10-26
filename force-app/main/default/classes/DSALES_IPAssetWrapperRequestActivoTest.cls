@isTest
global with sharing class DSALES_IPAssetWrapperRequestActivoTest {
    @testSetup
    static void SetUp(){
        Account ac= new Account(Name='NelsonTest',CP_WalletCustomerNumber__c=90229562);  
        insert ac;
        Opportunity op = new Opportunity(Name='Nelson',CloseDate=Date.today(),StageName='Nuevo');
        insert op;
         InsurancePolicy ip = new InsurancePolicy(Name='Nelson',NameInsuredId=ac.id,DSALES_CorreoElectronico__c='xnelsonvsx@hotmail.com');
        insert ip;
        /*Asset producto= new Asset(Name='Nelson',AccountId=ac.id);
        insert producto;*/
        String recordTypeIdPago=Schema.SObjectType.DSALES_InformacionDePago__c.getRecordTypeInfosByDeveloperName().get('DSALES_PagosdeVentaenNPVSM_c').getRecordTypeId();

        DSALES_InformaciondePago__c pago = new DSALES_InformaciondePago__c(DSALES_Oportunidad__c=op.id,DSALES_Cliente__c=ac.Id,DSALES_Poliza__c=ip.id,DSALES_Clave_Tienda__c='2');
        insert pago; 
    }
    @isTest static void CreateRecordTest()
    {
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        DSALES_InformaciondePago__c pago = [SELECT id,DSALES_Poliza__c, DSALES_Motoentregada__c FROM  DSALES_InformaciondePago__c  LIMIT 1];
        String body='{"payment_info":"'+pago.Id+'","store":"123","client_number":"90229562","partner":"Prueba","external_motorcycle":true, "invoice_value":"1234","status":"Activo","key_amis":"NelsonTest","key_vehicle":"NelsonTest","description":"NelsonTest","model":"NelsonTest","brand":"NelsonTest","motor_number":"NelsonTest","serial_number":"NelsonTest","license_plate":"NelsonTest","service":"NelsonTest","use":"NelsonTest","asset_name":"NelsonTest"}';
        request.requestURI='/apexrest/insertIPAssetDelivered'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_IPAssetWrapper.IPAssetRequest policyAsset =  (DSALES_IPAssetWrapper.IPAssetRequest)JSON.deserialize (body,DSALES_IPAssetWrapper.IPAssetRequest.class);
        //policyAsset.payment_info=pago.id;
        Test.startTest();
        DSALES_IPAssetWrapperRequestActivo.createIPAsset();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
   /* @isTest static void CreateRecordTestWrong()
    {
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        DSALES_InformaciondePago__c pago = [SELECT id,DSALES_Poliza__c, DSALES_Motoentregada__c FROM  DSALES_InformaciondePago__c  LIMIT 1];
        String body='{"payment_info":"dadsada","store":"123","client_number":"90229565","partner":"Prueba","external_motorcycle":true, "invoice_value":"1234","status":"Activo","key_amis":"NelsonTest","key_vehicle":"NelsonTest","description":"NelsonTest","model":"NelsonTest","brand":"NelsonTest","motor_number":"NelsonTest","serial_number":"NelsonTest","license_plate":"NelsonTest","service":"NelsonTest","use":"NelsonTest","asset_name":"NelsonTest"}';
        request.requestURI='/apexrest/insertIPAsset'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_IPAssetWrapper.IPAssetRequest policyAsset =  (DSALES_IPAssetWrapper.IPAssetRequest)JSON.deserialize (body,DSALES_IPAssetWrapper.IPAssetRequest.class);
        //policyAsset.payment_info=pago.id;
        Test.startTest();
        DSALES_IPAssetWrapperRequestActivo.createIPAsset();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
    }*/
    
}