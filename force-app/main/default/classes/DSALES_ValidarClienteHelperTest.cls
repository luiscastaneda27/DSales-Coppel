@isTest
global with sharing class DSALES_ValidarClienteHelperTest {
    @testSetup
    static void SetUp()
    { 
        String pb2Id=Test.getStandardPricebookId();
        Product2 pr = new Product2(Name='Producto de Prueba',DSales_Tipo_de_Producto__c='Producto');
		insert pr;
        Account ac= new Account(Name='DannyTest',CP_WalletCustomerNumber__c=123456);  
        insert ac;
        Contact con = new Contact(lastname= 'Test', AccountId= ac.Id, Email= 'johndoeus@salesforce.com');
        insert con;
        Asset ass = new Asset(Name='Test',AccountId= ac.Id,ContactId=con.Id);
        insert ass;
        Opportunity op = New Opportunity();
        op.Name='Danny';
        op.StageName='Open';
        op.CloseDate=Date.today();
        insert op;
        Quote qt = New Quote();
        qt.OpportunityId=op.Id;
        qt.Name='Danny';
        qt.Pricebook2Id=pb2Id;
        insert qt;
        //PriceBookEntry
        PricebookEntry pb = New PricebookEntry();
        pb.Product2Id = pr.Id;
        pb.PriceBook2Id =pb2Id;//Test.getStandardPricebookId();
        pb.UseStandardPrice = false;
        pb.UnitPrice=200;
        //pb.UnitPrice=35;//when we use standarprice book =true thenunit price is readonly field
        pb.isActive=true;
       	insert pb; 
         QuoteLineItem quote= new QuoteLineItem(QuoteId=qt.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=pr.id,Vigencia_meses__c='12');
        insert quote;
    }
    @isTest static void CertificadoValor()
    {
        Quote qt = [SELECT id FROM Quote WHERE Name='Danny' LIMIT 1];
        Account acc=[SELECT CP_WalletCustomerNumber__c FROM ACCOUNT WHERE NAME='DannyTest' LIMIT 1];
        contact c= [SELECT Id, FirstName, LastName, AccountId from Contact];
        Asset ast =[select Id, Name, AccountId from Asset];
        
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        String body = '{"asset_id":"'+ast.Id+'", "account_id":"'+acc.Id+'", "client_number":"123456","store_id": "1234","coppel_box_number": "1234","salesman_id": "1234","client_address": "Montreal 169 Paseo Montejo","client_email": "dsanmiguel@deloittemx.com","client_telephone": "8130912906","client_cellphone": "812091342","sku": "ABCDS12","model_product": "Italika","brand_product": "Samsung","serial_number": "90001","description_product": "Muy bueno","product_price": "900","purchase_product_date": "2022-09-06","warranty_duration": "12","cost_warranty": "900","purchase_warranty_date": "2022-09-06","extended_warranty_end_date": "2022-09-06","extended_warranty_effective_date": "2022-09-06"}';
        request.requestURI='/apexrest/insertCertificado'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
       DSALES_CertificadoWrapper.CertificadoRequest certificado =  (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize (body,DSALES_CertificadoWrapper.CertificadoRequest.class);
      List <DSALES_CertificadoWrapper.CertificadoRequest> certificados = new List<DSALES_CertificadoWrapper.CertificadoRequest>();
        certificados.add(certificado);
       certificado.client_number=String.ValueOf(acc.CP_WalletCustomerNumber__c);
        String qtId=qt.Id;
         
        Contact con = [SELECT Id FROM Contact WHERE EMAIL='johndoeus@salesforce.com'];
        RestRequest request2=new RestRequest();
        RestResponse response2 = new RestResponse();
        String body2 = '{"name":"Prueba DannyTest", "account_id":"'+acc.Id+'", "contact_id":"'+con.Id+'", "client_number":"123456", "product_type":"Producto","service_type ":"Garantía Extendida","category":"LÍNEA BLANCA","subcategory" :"ARTICULOS VIANA LINEA BLANCA","class_type" :"01 • AMPLIFICADORES CAR AUDIO","family" :"TEST FAMILIA","status" :"Cancelado","region" :"1 • HERMOSILLO","division" :"1","sku" :"DannyTest","warranty_duration" :"12","serial_number" :"DannyTest","purchase_date" :"2022-09-06","quantity":"1","price" :"12"}';
        request2.requestURI='/apexrest/insertAsset'; 
        request2.httpMethod='POST';
        RestContext.request=request2;
        request2.requestBody=Blob.valueOf(body2);
        RestContext.response=response2;
        DSALES_AssetWrapper.AssetRequest assetRecord =  (DSALES_AssetWrapper.AssetRequest)JSON.deserialize (body2,DSALES_AssetWrapper.AssetRequest.class);       
        List<DSALES_AssetWrapper.AssetRequest> assets= new List<DSALES_AssetWrapper.AssetRequest>();
        assets.add(assetRecord);
        assetRecord.client_number=String.ValueOf(acc.CP_WalletCustomerNumber__c);
        Test.startTest();
        DSALES_ValidarClienteHelper.recepcionProductos(certificados,qtId);
        DSALES_ValidarClienteHelper.deleteTangibles(assets, qtId);
        Test.stopTest();
    }
    @isTest static void CertificadoNull()
    {
        Quote qt = [SELECT id FROM Quote WHERE Name='Danny' LIMIT 1];
        List <DSALES_CertificadoWrapper.CertificadoRequest> certificados = new List<DSALES_CertificadoWrapper.CertificadoRequest>();
        String qtId=qt.Id;
        Test.startTest();
        DSALES_ValidarClienteHelper.recepcionProductos(null,qtId);
        Test.stopTest();
    }
    
    
}