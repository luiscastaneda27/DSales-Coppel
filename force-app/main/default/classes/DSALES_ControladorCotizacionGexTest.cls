@istest
public class DSALES_ControladorCotizacionGexTest {
    @testSetup
    static void testSetup()   
    { //Quote obj creation
        Opportunity op = new Opportunity(Name='Danny',StageName='Nuevo',CloseDate=Date.today());
        insert op;
        //QuoteLineItemCreation
       // PriceBook2 pb2 = new PriceBook2(Name='Danny');
        //Insert pb2;
        //Product
        Product2 prod = new Product2(Name = 'Laptop X26', 
            Family = 'Hardware');
        
        insert prod;
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
        Quote qt = new Quote(name='DannyTest',OpportunityId=op.Id,PriceBook2Id=pb2Id);
        insert qt;
            
        QuoteLineItem quote= new QuoteLineItem(QuoteId=qt.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod.id,DSALES_ListaArticulo__c='Producto');
        insert quote;
        
        QuoteLineItem quote1= new QuoteLineItem(QuoteId=qt.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod.id,DSALES_ListaArticulo__c='GEX');
        insert quote1;
        QuoteLineItem quote2= new QuoteLineItem(QuoteId=qt.Id,UnitPrice=2,Quantity=2,PricebookEntryId=pb.Id,Product2Id=prod.id,DSALES_ListaArticulo__c='Seguro Motos');
        insert quote2;
        
        DSALES_Generador__c gen = new DSALES_Generador__c();
        gen.Name='Cotizacion Gex';
        gen.DSALES_Plantilla__c='Cotizacion';
        
        insert gen;
   	}
        @istest static void DSALES_ControladorCotizacionGex()
        {
            Test.startTest();
            Quote qt= [SELECT Id, DSALES_EmailCliente__c FROM QUOTE LIMIT 1	];
            System.debug('quote: '+qt.Id);
            QuoteLineItem qline =[SELECT Id, QuoteId,UnitPrice,Quantity,PricebookEntryId,Product2Id,DSALES_ListaArticulo__c FROM QuoteLineItem LIMIT 1];
            System.debug('quoteLine: '+qline.Id);
            DSALES_Generador__c gene=[SELECT Id,Name,DSALES_Plantilla__c FROM DSALES_Generador__c LIMIT 1 ];
             System.debug('generador: '+gene.Id);
            PageReference pageRef = Page.DSALES_GexCot;
            Test.setCurrentPage(pageRef);
            // put the certificado id as a parameter
            ApexPages.currentPage().getParameters().put('quoteId',qt.Id);
            // Call your apex method here and you will get code coverage
            
            DSALES_ControladorCotizacionGex controlador = new DSALES_ControladorCotizacionGex();
            
           
            Test.stopTest();
        }
        
}