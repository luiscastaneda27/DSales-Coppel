@isTest
public class DSALES_PaymentInfoWrapperTest {
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
        
        Product2 prodRc = new Product2(Name ='RC Seguro de Moto', StockKeepingUnit='0000',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto');
		insert prodRc;
        
        Product2 prodAmp = new Product2(Name ='AMP Seguro de Moto', StockKeepingUnit='123444',DSALES_Familia__c=family.Id,DSALES_Categoria__c=category.Id,DSALES_Clase__c=classs.Id,DSales_Tipo_de_Producto__c='Producto',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
		insert prodAmp;
        
        Product2 prodM = new Product2(Name ='Moto', StockKeepingUnit='121212',DSales_Tipo_de_Producto__c='Producto',DSales_Aplicaporcentajecobro__c=true, DSales_PorcentajeCobro__c=40);
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
       	static void CreatePaymentRecordTest(){ 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    	Quote cotizacion = [Select id, Name, OpportunityId from Quote where Name ='test'];
       
        String body = '{"quoteid":"';
            body+=cotizacion.Id + '","AccountId":"0018J00000BruvyQAB","opportunity_name":"Prueba info pago","payment_method":"Efectivo","bill":"factura 01","customer_adress":"av independencia 12345","sku":"661235","total":"4450.00","article_description":"Motocicleta honda 200","telephone":"444 789 1999","salesman_name":"Antonio Pedro","cashier_box":"1","moto_delivered":false,"external_moto":false,"moto_noInsurance":false,"tipoProducto":"Servicio","ListadePagos":[{"producto":"seguro","total":0},{"producto":"moto","total":0}]}';
        
        req.requestURI = '/apexrest/insertPaymentInformationSM';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;
         
        DSALES_PaymentInfoWrapper.PaymentRequest pago = (DSALES_PaymentInfoWrapper.PaymentRequest)JSON.deserialize(body, DSALES_PaymentInfoWrapper.PaymentRequest.class);

        Test.startTest();
		DSALES_PaymentInfoWrapper.PaymentResponse responsePayload = new DSALES_PaymentInfoWrapper.PaymentResponse();
        responsePayload = DSALES_PaymentInfoWrapperRequest.createPayment();
		Test.stopTest();

        RestContext.request = req;
        RestContext.response= res;
    }
    
        @isTest 
       	static void CreatePaymentRecord2Test(){ 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    	Quote cotizacion = [Select id, Name, OpportunityId from Quote where Name ='test'];
       
        String body = '{"quoteid":"';
            body+=cotizacion.Id + '","AccountId":"0018J00000BruvyQAB","opportunity_name":"Prueba info pago","payment_method":"Efectivo","bill":"factura 01","customer_adress":"av independencia 12345","sku":"661235","total":"4450.00","article_description":"Motocicleta honda 200","telephone":"444 789 1999","salesman_name":"Antonio Pedro","cashier_box":"1","moto_delivered":false,"external_moto":false,"moto_noInsurance":false,"tipoProducto":"Servicio","ListadePagos":[{"producto":"seguro","total":2000},{"producto":"moto","total":1000}]}';
        
        req.requestURI = '/apexrest/insertPaymentInformationSM';
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(body);
        RestContext.response = res;
         
        DSALES_PaymentInfoWrapper.PaymentRequest pago = (DSALES_PaymentInfoWrapper.PaymentRequest)JSON.deserialize(body, DSALES_PaymentInfoWrapper.PaymentRequest.class);

        Test.startTest();
		DSALES_PaymentInfoWrapper.PaymentResponse responsePayload = new DSALES_PaymentInfoWrapper.PaymentResponse();
        responsePayload = DSALES_PaymentInfoWrapperRequest.createPayment();
		Test.stopTest();

        RestContext.request = req;
        RestContext.response= res;
    }

}