@isTest 
public class DSALES_QuoteGexWrapperRequestTest{
    
   @testSetup
    static void SetUp(){
        String tipoProducto = 'Servicio';
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
        
        Product2 prod = new Product2(Name ='test', StockKeepingUnit='0000',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto');
		insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Standard Price Book', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Account acc = new Account();
        acc.Name='test';
        acc.CP_WalletCustomerNumber__c=45654;
        acc.DSALES_ClienteCoppel__c='90001';
        insert acc;
        
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
        presupuesto.Product2Id = prod.Id;
        presupuesto.Quantity = 1.0;
        presupuesto.UnitPrice = customPrice.UnitPrice;
        presupuesto.DSALES_ListaArticulo__c = 'Producto';
        insert presupuesto;
    }
    
    @isTest 
    static void CreateQuoteRecordTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String body = '{"type_service": "Servicio","suffix": "credito","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "GEX test","brand": " test","model": "gx1","product_type":"Producto"}],"middle_name": "gonzalez","method_payment": "Credito","last_name": "lopez","first_name": "Emmanuel","Estimated_delivery_date": "2022-10-10","email": "clientenuevoLuis@gmail.com","division": "3","client_number": "45654","Address_Store": "calle 123 sur"}';
        req.requestURI = '/apexrest/insertQuote';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;
        DSALES_QuoteGexWrapper.QuoteGexRequest data = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
        Test.startTest();
        DSALES_QuoteGexWrapperRequest.createQuote();
        Test.stopTest();
        RestContext.request = req;
        RestContext.response= res;
    }
    
    @isTest 
    static void CreateQuoteRecordTest2(){
        RestRequest req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        String body2 = '{"type_service": "Servicio","suffix": "credito","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "GEX test","brand": "Garantia extendida test","model": "gx1","product_type":"Producto"}],"middle_name": "gonzalez","method_payment": "Credito","last_name": "lopez","first_name": "Emmanuel","Estimated_delivery_date": "2022-10-10","email": "clientenuevoLuis@gmail.com","division": "3","client_number": "111111","Address_Store": "calle 123 sur"}';
        req2.requestURI = '/apexrest/insertQuote';
        req2.httpMethod = 'POST';
        RestContext.request = req2;
        req2.requestBody = Blob.valueof(body2);
        RestContext.response = res2;
        DSALES_QuoteGexWrapper.QuoteGexRequest data2 = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body2, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
        Test.startTest();
        DSALES_QuoteGexWrapperRequest.createQuote();
        Test.stopTest();
        RestContext.request = req2;
        RestContext.response= res2;
    }
    
    @isTest 
    static void CreateQuoteRecordTest3(){
        RestRequest req3 = new RestRequest();
        RestResponse res3 = new RestResponse();
        String body3 = '{"type_service": "Servicio","suffix": "credito","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "GEX test","brand": "Garantia extendida test","model": "gx1","product_type":"Producto"}],"middle_name": "gonzalez","method_payment": "Credito","last_name": "lopez","first_name": "Emmanuel","Estimated_delivery_date": "2022-10-10","email": "clientenuevoLuis@gmail.com","division": "3","client_number": "90001","Address_Store": "calle 123 sur"}';
        req3.requestURI = '/apexrest/insertQuote';
        req3.httpMethod = 'POST';
        RestContext.request = req3;
        req3.requestBody = Blob.valueof(body3);
        RestContext.response = res3;
        DSALES_QuoteGexWrapper.QuoteGexRequest data3 = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body3, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
        Test.startTest();
        DSALES_QuoteGexWrapperRequest.createQuote();
        Test.stopTest();
        RestContext.request = req3;
        RestContext.response= res3;
    }
}