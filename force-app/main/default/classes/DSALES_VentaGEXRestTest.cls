@isTest
public with sharing class DSALES_VentaGEXRestTest {
    
    @testSetup
    static void SetUp(){
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Garantía Extendida').getRecordTypeId();
        String recordTypeQuoteId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Venta de Garantía Extendida').getRecordTypeId();
       
         Product2 prod2 = new Product2();
        prod2.Name='Testing Test2';
        prod2.StockKeepingUnit='1234689011111';
        prod2.DSales_Tipo_de_Producto__c='Servicio';
        insert prod2;
		
		Product2 produ = new Product2(); 
        produ.Name='test tangible';
        produ.StockKeepingUnit='123468911';
        produ.DSales_Tipo_de_Producto__c='Producto';
        insert produ;
        
        Account acc = new Account();
        acc.FirstName ='test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.PersonBirthdate = date.today();
        insert acc;
        
        Tienda__c t = new Tienda__c();
        t.DSales_TiendaID__c =  'CPPL-UGARTE';
        insert t;
        
        Opportunity oppor = new Opportunity();
        oppor.AccountId = acc.Id;
        oppor.Name = acc.Name+' '+'GEX';
        oppor.CloseDate = date.today()+30;
        oppor.StageName = 	'Nuevo';
        oppor.RecordTypeId = recordTypeId;
        oppor.DSALES_Tienda__c = t.Id;
        insert oppor;
        
        Quote cotiza = new Quote();
        cotiza.Name = acc.Name+' '+'GEX';
        cotiza.OpportunityId = oppor.Id;
        cotiza.RecordTypeId =recordTypeQuoteId;
        cotiza.DSales_Tienda__c = t.Id;
        cotiza.DSALES_Region__c = 'HERMOSILLO';
        cotiza.DSales_Division__c= '4';
        cotiza.ExpirationDate = date.today()+14;
        insert cotiza;
    }
    
    @isTest 
    static void CreateSaleTest(){
        Quote cotiza=[SELECT id FROM Quote LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String body = '{"cliente":{"first_name": "Emmanuel","last_name": "Gonzalez","telephone": "5578939271","email": "egonzalezlopez@deloittemx.com","contact_method": "Email","gender": "M","marital_status" : "S","birthdate": "1992-08-02","state_code": "CDMX","city_code": "Ciudad de México","town_code": "Mexico","suburb_code": "Calle prueba 123","zip_code": "54800"},"quoteid":"'+cotiza.Id+'","listAssets":[{"name":"Horno", "product_type":"x","service_type ":"Garantía Extendida","category":"Línea Blanca","subcategory" :"ARTICULOS VIANA LINEA BLANCA","class_type" :"Estufas, parrillas y hornos","family" :"Horno","status" :"Cancelado","sku" :"123468911","warranty_duration" :"12","serial_number" :"DannyTest","purchase_date" :"2022-09-06","quantity":"1"}],"certificado":[{"store_id": "1234","coppel_box_number": "1234","salesman_id": "1234","client_address": "Montreal 169 Paseo Montejo","client_email": "dsanmiguel@deloittemx.com","client_telephone": "8130912906","client_cellphone": "812091342","sku": "1234689011111","model_product": "Horno","brand_product": "Samsung","serial_number": "90001","description_product": "Muy bueno","product_price": "900","purchase_product_date": "2022-09-06","warranty_duration": "12","cost_warranty": "1035","purchase_warranty_date": "2022-09-06","extended_warranty_end_date": "2022-09-06","extended_warranty_effective_date": "2022-09-06","salesman_name": "Carlos Castaño","ticket":"12345","sales_date":"2022-09-06","sku_tangible":"123468901"}],"paymentInformation":[{"store_key": "CPPL-UGARTE","product_type": "Producto","status": "Acreditado","bill": "0001","cashier_box": "2","vendor_id": "1234","vendor_name": "Ramon Villanueva","exp_en": "test","customer_adress": "calle de prueba 123","customer_number": "100110","telephone": "555 555 6666","movilPhone": "123 456 7890","price": 500,"cash_total": 500,"credit_VAT": 0,"electronic_money": 10,"paymentElectronic_money": 0,"cash_payment": 200,"change": 0,"wonElectronic_money": 1,"GEX_paid": false,"price_noVAT": 200,"price_DiscountVAT": 200,"price_DiscountNoVAT": 200,"sku": "123468901"}]}}';
        req.requestURI = '/apexrest/ventaGex';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;
        DSALES_VentaGEX.VentaGexRequest venta = (DSALES_VentaGEX.VentaGexRequest)JSON.deserialize(body, DSALES_VentaGEX.VentaGexRequest.class);
        Test.startTest();
        DSALES_VentaGEXRest.createVenta();
        Test.stopTest();
        RestContext.request = req;
        RestContext.response= res;
    }
     static void CreateSaleTestWrong(){
        RestRequest req2= new RestRequest(); 
        RestResponse res2= new RestResponse();
        String body2 = '{"":stupurc: "Carl55 6666","movilPhone": "123 456 7890","price": 500,"cash_total": 500,"credit_VAT": 0,"electronic_money": 10,"paymentElectronic_money": 0,"cash_payment": 200,"change": 0,"wonElectronic_money": 1,"GEX_paid": false,"price_noVAT": 200,"price_DiscountVAT": 200,"price_DiscountNoVAT": 200,"sku": "123468901"}]}}';
        req2.httpMethod = 'POST';
        RestContext.request = req2;
        req2.requestBody = Blob.valueof(body2);
        RestContext.response = res2;
        DSALES_VentaGEX.VentaGexRequest venta2 = (DSALES_VentaGEX.VentaGexRequest)JSON.deserialize(body2, DSALES_VentaGEX.VentaGexRequest.class);
        Test.startTest();
        DSALES_VentaGEXRest.createVenta();
        Test.stopTest();
        RestContext.request = req2;
        RestContext.response= res2;
    }
    
}