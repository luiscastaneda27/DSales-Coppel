@isTest
public class DSALES_QuoteSmWrapperRequestTest {
    @testSetup
    static void SetUp(){
        String tipoProducto = 'Producto';
        String message = '';
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Garantía Extendida').getRecordTypeId();
        
        DSALES_Familia__c family = new DSALES_Familia__c();
        family.Name = 'test';
        insert family;
        
        DSALES_Categoria__c category = new DSALES_Categoria__c();
        category.Name = 'test';
        insert category;
        
        DSALES_Clase__c classs = new DSALES_Clase__c();
        classs.Name = 'test';
        insert classs;
        
        Product2 prodRc = new Product2(Name ='RC Seguro de Moto',DSALES_vehculo__c='sadkncdcs' ,StockKeepingUnit='0000',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto');
		insert prodRc;
        
        Product2 prodAmp = new Product2(Name ='AMP Seguro de Moto',DSALES_vehculo__c='23d23d23', StockKeepingUnit='123444',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
		insert prodAmp;
        
        Product2 prodM = new Product2(Name ='Moto',DSALES_vehculo__c='lasicndsldicsid',StockKeepingUnit='1231212',DSales_Tipo_de_Producto__c='Producto',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
		insert prodM;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = prodRc.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        PricebookEntry standardPriceGEX = new PricebookEntry();
        standardPriceGEX.Pricebook2Id = pricebookId;
        standardPriceGEX.Product2Id = prodAmp.Id;
        standardPriceGEX.UnitPrice = 1000;
        standardPriceGEX.IsActive = true;
        insert standardPriceGEX;
        
        PricebookEntry standardPriceMoto = new PricebookEntry();
        standardPriceMoto.Pricebook2Id = pricebookId;
        standardPriceMoto.Product2Id = prodM.Id;
        standardPriceMoto.UnitPrice = 1000;
        standardPriceMoto.IsActive = true;
        insert standardPriceMoto;
        
        Pricebook2 customPB = new Pricebook2();
        customPB.Name='Standard Price Book';
        customPB.isActive=true;
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry();
        customPrice.Pricebook2Id = customPB.Id;
        customPrice.Product2Id = prodRc.Id;
        customPrice.UnitPrice = 1200;
        customPrice.IsActive = true;
        insert customPrice;
        
        PricebookEntry customPriceGEX = new PricebookEntry();
        customPriceGEX.Pricebook2Id = customPB.Id;
        customPriceGEX.Product2Id = prodAmp.Id;
        customPriceGEx.UnitPrice = 2000;
        customPriceGEX.IsActive = true;
        insert customPriceGEX;
        
        PricebookEntry customPriceMoto = new PricebookEntry();
        customPriceMoto.Pricebook2Id = customPB.Id;
        customPriceMoto.Product2Id = prodM.Id;
        customPriceMoto.UnitPrice = 2000;
        customPriceMoto.IsActive = true;
        insert customPriceMoto;
		
        
        
        Account acc = new Account();
        acc.Name='test';
        acc.CP_WalletCustomerNumber__c=45654;
        acc.DSALES_ClienteCoppel__c='90001';
        insert acc;
        
        Account accContado = new Account();
        accContado.FirstName = 'Daniela';
        accContado.LastName = 'Gallegos';
        accContado.Middlename = 'Ho';
        accContado.PersonEmail = 'danigallegos@deloittemx.com';
        accContado.PersonBirthdate = date.today();
        insert accContado;
        
        Account accContado2 = new Account();
        accContado2.FirstName = 'Daniela';
        accContado2.LastName = 'Gallegos';
        accContado2.Middlename = 'Ho';
        accContado2.PersonEmail = 'danigegos@deloittemx.com';
        insert accContado2;
        
        Opportunity opp = new Opportunity(Name='TestOpportunity', AccountId=acc.Id, CloseDate=Date.Today(), StageName='Nuevo', Pricebook2Id=customPB.Id,RecordTypeId=recordTypeId);
        insert opp;
        
        Tienda__c t = new Tienda__c();
        t.DSales_TiendaID__c =  'CPPL-UGARTE';
        insert t;
        
        Quote cotizacion = new Quote(OpportunityId=opp.Id,Name='test',DSales_Tienda__c=t.Id);
        insert cotizacion;

        QuoteLineItem presupuesto = new QuoteLineItem();
        presupuesto.QuoteId = cotizacion.Id;
        presupuesto.PricebookEntryId = customPrice.Id;
        presupuesto.Product2Id = prodRc.Id;
        presupuesto.Quantity = 1.0;
        presupuesto.UnitPrice = customPrice.UnitPrice;
        presupuesto.DSALES_ListaArticulo__c = 'Producto';
        insert presupuesto;
        
        DSALES_TipodeUso__c tipoUso = new DSALES_TipodeUso__c(Name='Comercial');
        insert tipoUso;
        DSALES_Tipodevehculo__c tipovehiculo = new DSALES_Tipodevehculo__c(Name='Moto');
        insert tipovehiculo;
    }
    
    @isTest 
    static void CreateQuoteCredito(){
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String body = '{"vehicle_use":"Comercial","sku":"1231212",vehicle_type":"Moto","plazo":"12","rfc":"abcd","client_number":"43535","first_name":"hpero","middle_name":"gonzalez","last_name":"lopez","suffix":"sepa","store_id":"CPPL-UGARTE","vendedor":"pedro","contact_phone":"4545454545","contact_email":"ssas@fgmaoc.com","contact_gender":"Masculino","contact_birth_date":"1990-10-02","contact_state_code":"12","contact_township_code":"212","contact_suburb_code":12,"contact_zip_code":"12","vehicle_id":"slknvsaeclskvlams","payment_option":"Mensual","packagge":"EC","start_at":"2020-10-10","productList":[{"sku":"1231212"},{"sku":"632013-GEX"}]}';
        req.requestURI = '/apexrest/insertQuoteSM';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        //RestContext.response = res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(5));
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(6));
        DSALES_QuoteSmWrapper.RespuestaParaNpv response = DSALES_QuoteSmWrapperRequest.createQuoteSM();
		Test.stopTest();
    }
    
    @isTest 
    static void CreateQuoteCredito2(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String body = '{"vehicle_use":"Comercial","sku":"1231212","vehicle_type":"Moto","plazo":"12","rfc":"abcd","client_number":"45654","first_name":"hpero","middle_name":"gonzalez","last_name":"lopez","suffix":"sepa","store_id":"CPPL-UGARTE","vendedor":"pedro","contact_phone":"4545454545","contact_email":"ssas@fgmaoc.com","contact_gender":"Masculino","contact_birth_date":"1990-10-02","contact_state_code":"12","contact_township_code":"212","contact_suburb_code":12,"contact_zip_code":"12","vehicle_id":"slknvsaeclskvlams","payment_option":"Mensual","packagge":"EC","start_at":"2020-10-10","productList":[{"sku":"121212"},{"sku":"632013-GEX"}]}';
        req.requestURI = '/apexrest/insertQuoteSM';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(5));
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(6));
        DSALES_QuoteSmWrapper.RespuestaParaNpv response = DSALES_QuoteSmWrapperRequest.createQuoteSM();
		Test.stopTest();
    }
    
    @isTest 
    static void CreateQuoteGenerico(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String body = '{"vehicle_use":"Comercial","sku":"1231212","vehicle_type":"Moto","plazo":"12","rfc":"abcd","client_number":"","first_name":"Daniela","middle_name":"Ho","last_name":"Gallegos","suffix":"","store_id":"CPPL-UGARTE","vendedor":"pedro","contact_phone":"4545454545","contact_email":"ssas@fgmaoc.com","contact_gender":"Masculino","contact_birth_date":"1990-10-02","contact_state_code":"12","contact_township_code":"212","contact_suburb_code":12,"contact_zip_code":"12","vehicle_id":"slknvsaeclskvlams","payment_option":"Mensual","packagge":"EC","start_at":"2020-10-10","productList":[{"sku":"121212121212"},{"sku":"632013-GEX"}]}';
        req.requestURI = '/apexrest/insertQuoteSM';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
		System.debug('Generico: ');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(5));
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(6));
        DSALES_QuoteSmWrapper.RespuestaParaNpv response = DSALES_QuoteSmWrapperRequest.createQuoteSM();
		Test.stopTest();
    }

}