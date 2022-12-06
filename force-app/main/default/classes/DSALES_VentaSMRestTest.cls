@istest
public with sharing class DSALES_VentaSMRestTest {
   @testSetup
    static void SetUp(){
        String tipoProducto = 'Producto';
        String message = '';
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Seguro de Moto').getRecordTypeId();
        
        DSALES_Familia__c family = new DSALES_Familia__c();
        family.Name = 'test';
        insert family;
        
        DSALES_Categoria__c category = new DSALES_Categoria__c();
        category.Name = 'test';
        insert category;
        
        DSALES_Clase__c classs = new DSALES_Clase__c();
        classs.Name = 'test';
        insert classs;
        
        Product2 prodRc = new Product2(Name ='RC Seguro de Moto',IsActive=true, StockKeepingUnit='0000',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto');
		insert prodRc;
        
        Product2 prodAmp = new Product2(Name ='AMP Seguro de Moto',IsActive=true, StockKeepingUnit='123444',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
		insert prodAmp;
        
        Product2 prodM = new Product2(Name ='Moto',IsActive=true, StockKeepingUnit='121212',DSales_Tipo_de_Producto__c='Producto',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
		insert prodM;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = prodRc.Id;
        standardPrice.UnitPrice = 0;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        PricebookEntry standardPriceGEX = new PricebookEntry();
        standardPriceGEX.Pricebook2Id = pricebookId;
        standardPriceGEX.Product2Id = prodAmp.Id;
        standardPriceGEX.UnitPrice = 0;
        standardPriceGEX.IsActive = true;
        insert standardPriceGEX;
        
        PricebookEntry standardPriceMoto = new PricebookEntry();
        standardPriceMoto.Pricebook2Id = pricebookId;
        standardPriceMoto.Product2Id = prodM.Id;
        standardPriceMoto.UnitPrice = 0;
        standardPriceMoto.IsActive = true;
        insert standardPriceMoto;
        
        Pricebook2 customPB = new Pricebook2();
        customPB.Name='Standard Price Book';
        customPB.isActive=true;
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry();
        customPrice.Pricebook2Id = customPB.Id;
        customPrice.Product2Id = prodRc.Id;
        customPrice.UnitPrice = 0;
        customPrice.IsActive = true;
        insert customPrice;
        
        PricebookEntry customPriceGEX = new PricebookEntry();
        customPriceGEX.Pricebook2Id = customPB.Id;
        customPriceGEX.Product2Id = prodAmp.Id;
        customPriceGEx.UnitPrice = 0;
        customPriceGEX.IsActive = true;
        insert customPriceGEX;
        
        PricebookEntry customPriceMoto = new PricebookEntry();
        customPriceMoto.Pricebook2Id = customPB.Id;
        customPriceMoto.Product2Id = prodM.Id;
        customPriceMoto.UnitPrice = 0;
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

        Opportunity opp = new Opportunity(Name='TestOpportunity', AccountId=accContado.Id, CloseDate=Date.Today(), StageName='Nuevo', Pricebook2Id=customPB.Id,RecordTypeId=recordTypeId);
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
    }
    
    @isTest
    public static void ventaTest(){
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        Quote cot =[SELECT Id,OpportunityId,Opportunity.Name FROM Quote WHERE Name ='test' LIMIT 1];
        //String body ='{"quoteId":"'+cot.Id+'","pagos":{"total":0,"tipoProducto":"Servicio","telephone":"4447891999","sku":"12345","salesman_name":"Nelson Varela","quoteid":"","payment_method":"Efectivo","opportunity_name":"Venta","moto_noInsurance":false,"moto_delivered":false,"ListadePagos":[{"total":0,"producto":"moto"},{"total":0,"producto":"seguro"}],"external_moto":false,"customer_adress":"av independencia 12345","cashier_box":"1","bill":"1000223","article_description":"Seguro Plus de Moto","AccountId":""},"cliente":{"zip_code":"12346","town_code":"Mexico","telephone":"1234567890","suffix":"","suburb_code":"Calle prueba 123","state_code":"CDMX","middle_name":"","marital_status":null,"last_name":"Martinez","gender":"F","first_name":"Sayra","email":"prueba@sf.co","contact_now":false,"contact_method":"Email","client_number":"12345","city_code":"Ciudad de México","birthdate":"1992-08-02"},"activos":{"use":"test","store":"123","status":"Activo","service":"test","serial_number":"test","payment_info":"","partner":"Prueba","motorcycle_delivered":false,"motor_number":"test","model":"test","license_plate":"test","key_vehicle":"test","key_amis":"test","invoice_value":1234.0,"external_motorcycle":true,"description":"test","client_number":"12345","brand":"test","asset_name":"test"}}';
        String body='{"quoteId":"'+cot.Id+'","pagos":{"total":0,"tipoProducto":"Servicio","telephone":"4447891999","sku":"","salesman_name":"Nelson Varela","quoteid":"","payment_method":"Efectivo","opportunity_name":"Venta","moto_noInsurance":false,"moto_delivered":false,"ListadePagos":[{"total":0,"producto":"moto"},{"total":0,"producto":"seguro"}],"external_moto":false,"customer_adress":"av independencia 12345","cashier_box":"1","bill":"1000223","article_description":"Seguro Plus de Moto","AccountId":""},"cliente":{"client_number":"2022","first_name":"Sayra","last_name":"Martinez","telephone":"1234567890","email":"prueba@sf.co","contact_method":"Email","gender":"F","marital_status":"S","birthdate":"1992-08-02","state_code":"CDJZ","city_code":"Ciudad Juarez","town_code":"Mexico","suburb_code":"63 Avenida Paseo de la Reforma","zip_code":"06030"},"activos":{"use":"test","store":"123","status":"Activo","service":"test","serial_number":"test","payment_info":"","partner":"Prueba","motorcycle_delivered":false,"motor_number":"test","model":"test","license_plate":"test","key_vehicle":"test","key_amis":"test","invoice_value":1234.0,"external_motorcycle":true,"description":"test","brand":"test","asset_name":"test"}}';
        request.requestURI='/apexrest/ventaSM'; 
        request.httpMethod='POST'; 
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_VentaSM.VentaSMRequest venta =(DSALES_VentaSM.VentaSMRequest)JSON.deserialize (body,DSALES_VentaSM.VentaSMRequest.class);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponsePolizaTest());
        DSALES_VentaSMRest.createVenta();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;

    }
    

}