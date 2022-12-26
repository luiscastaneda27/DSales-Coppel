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
        accContado.FirstName = 'Emmanuel';
        accContado.LastName = 'Gonzalez';
        accContado.PersonEmail = 'egl@deloittemx.com';
        accContado.PersonBirthdate = date.today();
        accContado.Suffix = 'Lopez';
        insert accContado;
        
        Opportunity opp = new Opportunity(Name='TestOpportunity', AccountId=acc.Id, CloseDate=Date.Today(), StageName='Nuevo', Pricebook2Id=customPB.Id,RecordTypeId=recordTypeId);
        insert opp;
        
        Tienda__c t = new Tienda__c();
        t.DSales_TiendaID__c =  '21';
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
        String body = '{  "id_tienda": "21", "productos": [{"sku_de_tangible": "0000", "cantidad_productos_tangibles": 1.0, "articulo": "Estufa", "marca": "Whirlpool", "modelo": "WFR5000D", "precio_tangible": "4650" } ], "apellido_materno": "Lopez", "apellido_paterno": "Gonzalez", "nombre": "Emmanuel", "correo_electronico": "egl@deloittemx.com", "numero_de_cliente": "", "id_factura": null, "id_oportunidad": null }';
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
        String body2 = '{ "id_tienda": "21", "productos": [ { "sku_de_tangible": "0000", "cantidad_productos_tangibles": 1.0, "articulo": "Estufa", "marca": "Whirlpool", "modelo": "WFR5000D", "precio_tangible": "4650" } ], "apellido_materno": "Test", "apellido_paterno": "Tes", "nombre": "Test", "correo_electronico": "danigallegos@deloittemx.com", "numero_de_cliente": "45654", "id_factura": null, "id_oportunidad": null }';
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
        String body3 = '{ "id_tienda": "21", "productos": [ { "sku_de_tangible": "0000", "cantidad_productos_tangibles": 1.0, "articulo": "Estufa", "marca": "Whirlpool", "modelo": "WFR5000D", "precio_tangible": "4650" } ], "apellido_materno": "Test", "apellido_paterno": "Tes", "nombre": "Test", "correo_electronico": "danigallegos@deloittemx.com", "numero_de_cliente": "90001", "id_factura": null, "id_oportunidad": null }';
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
        String body4 = '{ "id_tienda": "21", "productos": [ { "sku_de_tangible": "0000", "cantidad_productos_tangibles": 1.0, "articulo": "Estufa", "marca": "Whirlpool", "modelo": "WFR5000D", "precio_tangible": "4650" } ], "apellido_materno": "Test2", "apellido_paterno": "Test2", "nombre": "Test2", "correo_electronico": "test@deloittemx.com", "numero_de_cliente": "8765765875", "id_factura": null, "id_oportunidad": null }';
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
        String body5 = '{ "id_tienda": "21", "productos": [ { "sku_de_tangible": "0000", "cantidad_productos_tangibles": 1.0, "articulo": "Estufa", "marca": "Whirlpool", "modelo": "WFR5000D", "precio_tangible": "4650" } ], "apellido_materno": "Test", "apellido_paterno": "Tes", "nombre": "Test", "correo_electronico": "danigallegos@deloittemx.com", "numero_de_cliente": "444444", "id_factura": "FAC001", "id_oportunidad": null }';
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