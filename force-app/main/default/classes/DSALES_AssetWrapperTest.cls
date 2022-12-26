@isTest
global with sharing class DSALES_AssetWrapperTest {
    @testSetup
    static void SetUp(){
        DSALES_Categoria__c categoria = new DSALES_Categoria__c(Name='LÍNEA BLANCA');
        insert categoria;
        DSALES_SubCategoria__c subcategoria = new DSALES_SubCategoria__c(Name='ARTICULOS VIANA LINEA BLANCA');
        insert subcategoria;
        DSALES_Familia__c familia = new DSALES_Familia__c(Name='TEST FAMILIA');
        insert familia;
        DSALES_Clase__c clase = new DSALES_Clase__c(Name='01 • AMPLIFICADORES CAR AUDIO');
        insert clase;
        Account ac= new Account(Name='DannyTest',CP_WalletCustomerNumber__c=123456);  
        insert ac;
        
    }
    
    @isTest static void CreateRecordTest()
    {
        Account acc=[SELECT CP_WalletCustomerNumber__c FROM ACCOUNT WHERE NAME='DannyTest' LIMIT 1];
        Contact con = new Contact(lastname= 'Test1', AccountId= acc.Id, Email= 'johndoeus@salesforce.com');
        insert con;
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        String body = '{"name":"Prueba DannyTest", "account_id":"'+acc.Id+'", "contact_id":"'+con.Id+'", "client_number":"123456", "product_type":"Producto","service_type ":"Garantía Extendida","category":"LÍNEA BLANCA","subcategory" :"ARTICULOS VIANA LINEA BLANCA","class_type" :"01 • AMPLIFICADORES CAR AUDIO","family" :"TEST FAMILIA","status" :"Cancelado","region" :"1 • HERMOSILLO","division" :"1","sku" :"DannyTest","warranty_duration" :"12","serial_number" :"DannyTest","purchase_date" :"2022-09-06","quantity":"1","price" :"12"}';
        request.requestURI='/apexrest/insertAsset'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_AssetWrapper.AssetRequest assetRecord =  (DSALES_AssetWrapper.AssetRequest)JSON.deserialize (body,DSALES_AssetWrapper.AssetRequest.class);       
        assetRecord.numero_cliente=String.ValueOf(acc.CP_WalletCustomerNumber__c);
        Test.startTest();
        DSALES_AssetWrapperRequest.createAsset();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
    @isTest static void CreateRecordTest1()
    {          
        Account acc=[SELECT Id, Name, CP_WalletCustomerNumber__c FROM ACCOUNT WHERE NAME='DannyTest' LIMIT 1];  
        Contact con = new Contact(lastname= 'Test', AccountId= acc.Id, Email= 'johndoeus@salesforce.com');
        insert con;
        
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        String body = '{"nombre":"Prueba DannyTest","id_cuenta":"'+acc.Id+'", "id_contacto":"'+con.Id+'", "numero_cliente":"1234567", "tipo_producto":"Servicio","tipo_servicio ":"Garantía Extendida","categoria":"LÍNEA BLANCA","subcategoria" :"ARTICULOS VIANA LINEA BLANCA","clase" :"01 • AMPLIFICADORES CAR AUDIO","familia" :"TEST FAMILIA","estado" :"Adquirido","sku" :"658019","duracion_garantia" :"12","numero_serie" :"658019","fecha_compra" :"2022-09-07","cantidad":"1","marca" :"Samsung", "modelo": "2010","descripcion":"Muy cómodo"}';
        request.requestURI='/apexrest/insertAsset'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_AssetWrapper.AssetRequest assetRecord =  (DSALES_AssetWrapper.AssetRequest)JSON.deserialize (body,DSALES_AssetWrapper.AssetRequest.class);
        assetRecord.numero_cliente=String.ValueOf(acc.CP_WalletCustomerNumber__c);
        Test.startTest();
        DSALES_AssetWrapperRequest.createAsset();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
    
}