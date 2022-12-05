@istest
public class DSALES_ControladorCotizacionGexTest {
    @testSetup
    static void testSetup()   
    { 
        Id rtGex = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Venta de Garantía Extendida').getRecordTypeId();
         Id rtSg = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Venta de Seguro de Motos').getRecordTypeId();
        //Quote obj creation
        Opportunity op = new Opportunity(Name='Danny',StageName='Nuevo',CloseDate=Date.today());
        insert op;
        //QuoteLineItemCreation
       // PriceBook2 pb2 = new PriceBook2(Name='Danny');
        //Insert pb2;
        //Product
        Product2 prod = new Product2(Name = 'Laptop X26', 
            Family = 'Hardware', DSales_Tipo_de_Producto__c='Producto');
        
        insert prod;
        
         Product2 prod2 = new Product2(Name = 'Laptop X27', 
            Family = 'Hardware', DSales_Tipo_de_Producto__c='Producto');
        
        insert prod2;
        
           Product2 prod3 = new Product2(Name = 'Servicio', 
            Family = 'Hardware', DSales_Tipo_de_Producto__c='Servicio');
        
        insert prod3;
        
        String pb2Id=Test.getStandardPricebookId();
        //PriceBookEntry
        PricebookEntry pb = New PricebookEntry();
        pb.Product2Id = prod.Id;
        pb.PriceBook2Id =pb2Id;//Test.getStandardPricebookId();
        pb.UseStandardPrice = false;
        pb.UnitPrice=200;
        //pb.UnitPrice=35;//when we use standarprice book =true thenunit price is readonly field
        pb.isActive=true;
       	insert pb; 
        Quote qtGex = new Quote(name='DannyGex',OpportunityId=op.Id,PriceBook2Id=pb2Id,RecordTypeId=rtGex);
        insert qtGex;
         Quote qtSg = new Quote(name='DannySG',OpportunityId=op.Id,PriceBook2Id=pb2Id,RecordTypeId=rtSg);
        insert qtSg;
            
        
        QuoteLineItem quote= new QuoteLineItem(QuoteId=qtGex.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod.id,Vigencia_meses__c='12');
        insert quote;
        
        QuoteLineItem quote1= new QuoteLineItem(QuoteId=qtGex.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod2.id,Vigencia_meses__c='24');
        insert quote1;
        QuoteLineItem quote2= new QuoteLineItem(QuoteId=qtGex.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod3.id,Vigencia_meses__c='12');
        insert quote2;
        
        QuoteLineItem quote3= new QuoteLineItem(QuoteId=qtSg.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod.id,Vigencia_meses__c='12');
        insert quote3;
        
        QuoteLineItem quote4= new QuoteLineItem(QuoteId=qtSg.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod2.id,Vigencia_meses__c='24');
        insert quote4;
        QuoteLineItem quote5= new QuoteLineItem(QuoteId=qtSg.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod3.id,Vigencia_meses__c='12');
        insert quote5;
        
        DSALES_Generador__c gen = new DSALES_Generador__c();
        gen.Name='Cotizacion Gex';
        gen.DSALES_Plantilla__c='Cotizacion';
        
        
        insert gen;
        
         DSALES_Generador__c gen2 = new DSALES_Generador__c();
        gen2.Name='Cotizacion SG';
        gen2.DSALES_Plantilla__c='Cotizacion';
        insert gen2;
   	}
        @istest public  static void DSALES_ControladorCotizacionGex()
        {
            Test.startTest();
            List<Product2> pd=[SELECT Name,Family, DSales_Tipo_de_Producto__c FROM Product2 WHERE DSales_Tipo_de_Producto__c='Producto' LIMIT 1];
            Quote qt= [SELECT Id, DSALES_EmailCliente__c FROM QUOTE WHERE NAME='DannyGex' LIMIT 1	];
            System.debug('quote: '+qt.Id);
            List<QuoteLineItem> qline =[SELECT Id, QuoteId,UnitPrice,Quantity,PricebookEntryId,Product2Id FROM QuoteLineItem];
           
            DSALES_Generador__c gene=[SELECT Id,Name,DSALES_Plantilla__c FROM DSALES_Generador__c   WHERE Name='Cotizacion Gex' LIMIT 1];
             System.debug('generador: '+gene.Id);
            PageReference pageRef = Page.Cotizacion;
            Test.setCurrentPage(pageRef);
            // put the certificado id as a parameter
            ApexPages.currentPage().getParameters().put('quoteId',qt.Id);
            // Call your apex method here and you will get code coverage
            
            DSALES_ControladorCotizacionGex controlador = new DSALES_ControladorCotizacionGex();
            
           
            Test.stopTest();
        }
     @istest public  static void DSALES_ControladorCotizacionSG()
        {
            Test.startTest();
            List<Product2> pd=[SELECT Name,Family, DSales_Tipo_de_Producto__c FROM Product2 WHERE DSales_Tipo_de_Producto__c='Producto' LIMIT 1];
            Quote qt= [SELECT Id, DSALES_EmailCliente__c FROM QUOTE WHERE NAME='DannySg' LIMIT 1	];
            System.debug('quote: '+qt.Id);
            List<QuoteLineItem> qline =[SELECT Id, QuoteId,UnitPrice,Quantity,PricebookEntryId,Product2Id FROM QuoteLineItem];
           
            DSALES_Generador__c gene=[SELECT Id,Name,DSALES_Plantilla__c FROM DSALES_Generador__c WHERE Name='Cotizacion SG' LIMIT 1];
             System.debug('generador: '+gene.Id);
            PageReference pageRef = Page.Cotizacion;
            Test.setCurrentPage(pageRef);
            // put the certificado id as a parameter
            ApexPages.currentPage().getParameters().put('quoteId',qt.Id);
            // Call your apex method here and you will get code coverage
            
            DSALES_ControladorCotizacionGex controlador = new DSALES_ControladorCotizacionGex();
            
           
            Test.stopTest();
        }
  
        
}