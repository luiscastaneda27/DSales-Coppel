@isTest 
public class DSALES_QuoteGexWrapperRequestTest{
    
   @testSetup
    static void SetUp(){
        String tipoProducto = 'Servicio';
        String message = '';
        String regions = 'Todas las regiones';
        String originalMat = 'Matriz Original';
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
        
        Product2 prodGEX = new Product2(Name ='testGEX', StockKeepingUnit='123444',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Servicio',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
		insert prodGEX;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = prod.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        PricebookEntry standardPriceGEX = new PricebookEntry();
        standardPriceGEX.Pricebook2Id = pricebookId;
        standardPriceGEX.Product2Id = prodGEX.Id;
        standardPriceGEX.UnitPrice = 1000;
        standardPriceGEX.IsActive = true;
        insert standardPriceGEX;
        
        Pricebook2 customPB = new Pricebook2();
        customPB.Name='Standard Price Book';
        customPB.isActive=true;
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry();
        customPrice.Pricebook2Id = customPB.Id;
        customPrice.Product2Id = prod.Id;
        customPrice.UnitPrice = 1200;
        customPrice.IsActive = true;
        insert customPrice;
        
        PricebookEntry customPriceGEX = new PricebookEntry();
        customPriceGEX.Pricebook2Id = customPB.Id;
        customPriceGEX.Product2Id = prodGEX.Id;
        customPriceGEx.UnitPrice = 2000;
        customPriceGEX.IsActive = true;
        insert customPriceGEX;
        
        DSales_Asignacion_de_Productos__c asig = new DSales_Asignacion_de_Productos__c();
        asig.Name = 'test';
        asig.DSales_Servicio_Seguro__c =prod.Id;
        asig.DSales_Producto__c = prodGEX.Id;
        asig.DSALES_Activo__c = true;
        insert asig;
        
        DSales_Matriz_GEX__c mat = new DSales_Matriz_GEX__c();
        mat.Name= 'test';
        mat.DSALES_Activo__c= true;
        mat.DSALES_Region__c ='Hermosillo';
        mat.DSALES_Tiempogex__c = '1 año';
        insert mat;
        
        DSALES_Matriz_de_Cotizacion__c matItem = new DSALES_Matriz_de_Cotizacion__c();
        matItem.DSales_Matriz_GEX__c = mat.Id;
        matItem.SALES_Precio_GEX__c = 3500;
        matItem.DSALES_Rango_interior_GEX__c=7000;
        matItem.DSALES_Rango_Superior_GEX__c = 8500;
        matItem.DSALES_Tiempo_de_Garantia_Extendida_GEX__c = '1 año';
        
        matItem.DSales_Matriz_GEX__c = mat.Id;
        matItem.SALES_Precio_GEX__c = 4500;
        matItem.DSALES_Rango_interior_GEX__c=7000;
        matItem.DSALES_Rango_Superior_GEX__c = 8500;
        matItem.DSALES_Tiempo_de_Garantia_Extendida_GEX__c = '2 años';
        insert matItem;
        
        Account acc = new Account();
        acc.Name='test';
        acc.CP_WalletCustomerNumber__c=45654;
        acc.DSALES_ClienteCoppel__c='90001';
        insert acc;
        
        Account accContado = new Account();
        accContado.FirstName = 'Daniela';
        accContado.LastName = 'Gallegos';
        accContado.PersonEmail = 'danigallegos@deloittemx.com';
        accContado.PersonBirthdate = date.today();
        accContado.Suffix = 'test';
        insert accContado;
        
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
        
        Asset proAdquirido = new Asset();
        proAdquirido.Name = 'test';
        proAdquirido.DSALES_TipoProducto__c = 'Producto';
        proAdquirido.AccountId = acc.id;
        proAdquirido.DSALES_ClaseBuscar__c = classs.Id;
        insert proAdquirido;
        
        DSALES_InformacionDePago__c info = new DSALES_InformacionDePago__c();
        info.DSALES_Factura__c = 'FAC001';
        info.DSALES_Oportunidad__c = opp.Id;
        info.DSALES_Cliente__c = acc.Id;
        info.DSALES_Clave_Tienda__c = 'T-7798';
        info.DSALES_ProductoAdquirido__c = proAdquirido.Id;
        insert info;
    }
    
    @isTest 
    static void CreateQuoteRecordTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String body = '{"vendor_id": "1234567","vendedor_name": "Pedro Juarez","type_service": "Servicio","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "Refrigerador Whirpool","brand": "Whirpool","model": "Refri","tangible_price": "7600"}],"method_payment": "Contado","suffix": "Rodriguez","last_name": "Gallegos","middle_name": "","first_name": "Daniela","Estimated_delivery_date": "2022-10-10","email": "danigallegos@deloittemx.com","division": "3","client_number": "","Address_Store": "Paseo de los virreyes"}}';
        req.requestURI = '/apexrest/insertQuoteGex';
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
        String body2 = '{"vendor_id": "1234567","vendedor_name": "Pedro Juarez","type_service": "Servicio","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "Refrigerador Whirpool","brand": "Whirpool","model": "Refri","tangible_price": "7600"}],"method_payment": "Contado","suffix": "Rodriguez","last_name": "Gallegos","middle_name": "","first_name": "Daniela","Estimated_delivery_date": "2022-10-10","email": "danigallegos@deloittemx.com","division": "3","client_number": "45654","Address_Store": "Paseo de los virreyes"}';
        req2.requestURI = '/apexrest/insertQuoteGex';
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
        String body3 = '{"vendor_id": "1234567","vendedor_name": "Pedro Juarez","type_service": "Servicio","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "Refrigerador Whirpool","brand": "Whirpool","model": "Refri","tangible_price": "7600"}],"method_payment": "Contado","suffix": "Rodriguez","last_name": "Gallegos","middle_name": "","first_name": "Daniela","Estimated_delivery_date": "2022-10-10","email": "danigallegos@deloittemx.com","division": "3","client_number": "90001","Address_Store": "Paseo de los virreyes"}';
        req3.requestURI = '/apexrest/insertQuoteGex';
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
    
    @isTest 
    static void CreateQuoteRecordTest4(){
        RestRequest req4 = new RestRequest();
        RestResponse res4 = new RestResponse();
        String body4 = '{"vendor_id": "1234567","vendedor_name": "Pedro Juarez","type_service": "Servicio","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "Refrigerador Whirpool","brand": "Whirpool","model": "Refri","tangible_price": "7600"}],"method_payment": "Contado","suffix": "Rodriguez","last_name": "Gallegos","middle_name": "","first_name": "Daniela","Estimated_delivery_date": "2022-10-10","email": "danigallegos@deloittemx.com","division": "3","client_number": "45555555555","Address_Store": "Paseo de los virreyes"}';
        req4.requestURI = '/apexrest/insertQuoteGex';
        req4.httpMethod = 'POST';
        RestContext.request = req4;
        req4.requestBody = Blob.valueof(body4);
        RestContext.response = res4;
        DSALES_QuoteGexWrapper.QuoteGexRequest data4 = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body4, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
        Test.startTest();
        DSALES_QuoteGexWrapperRequest.createQuote();
        Test.stopTest();
        RestContext.request = req4;
        RestContext.response= res4;
    }
    
    @isTest 
    static void CreateQuoteRecordTest5(){
        RestRequest req5 = new RestRequest();
        RestResponse res5 = new RestResponse();
        String body5 = '{"vendor_id": "1234567","vendedor_name": "Pedro Juarez","type_service": "Servicio","store_id": "CPPL-UGARTE","Service_product_quantity": 2,"region": "Hermosillo","productList": [{"sku": "0000","Quantity_tangible_products": 1.0,"article": "Refrigerador Whirpool","brand": "Whirpool","model": "Refri","tangible_price": "7600"}],"method_payment": "Contado","suffix": "Rodriguez","last_name": "Gallegos","middle_name": "","first_name": "Daniela","Estimated_delivery_date": "2022-10-10","email": "danigallegos@deloittemx.com","division": "3","client_number": "45555555555","bill":"FAC001","Address_Store": "Paseo de los virreyes"}';
        req5.requestURI = '/apexrest/insertQuoteGex';
        req5.httpMethod = 'POST';
        RestContext.request = req5;
        req5.requestBody = Blob.valueof(body5);
        RestContext.response = res5;
        DSALES_QuoteGexWrapper.QuoteGexRequest data5 = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body5, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
        Test.startTest();
        DSALES_QuoteGexWrapperRequest.createQuote();
        Test.stopTest();
        RestContext.request = req5;
        RestContext.response= res5;
    }
}