@isTest
public class DSALES_UpdateClienteTest {
    @testSetup
    static void testSetup(){
        String accountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account acc = new Account();
        acc.firstName='alberto';
        acc.lastName='gar';
        acc.MiddleName = 'beto';
        acc.Suffix='procopio';
        date fechaNacimiento = date.newInstance(1991, 2, 15); 
        acc.PersonBirthdate=fechaNacimiento;
        acc.PersonEmail= 'asa@as.co';
        acc.Phone = '93617359';
        insert acc;
        
        Opportunity op = new Opportunity(Name='alberto',CloseDate=Date.today(),StageName='Nuevo', AccountId=acc.Id);
        insert op;
        
        Quote cotizacion = new Quote(Name='Nueva', Motivo_de_lista_negra__c='no hay',DSALES_AdquiriopolizaSM__c=true,
                                     OpportunityId=op.Id);
        insert cotizacion; 
        
        //
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
        Asset nuev = new Asset(Name='test',AccountId=acc.Id);
        insert nuev;
        DSALES_InformacionDePago__c pago = new DSALES_InformacionDePago__c(DSALES_Oportunidad__c=op.Id,
                                                                           DSALES_Estatus__c='No Acreditado',
                                                                          DSALES_FormaDePago__c='Efectivo',
                                                                          DSALES_Factura__c='sdfsfs',
                                                                          DSALES_DescripcionArticulo__c='ada',
                                                                          DSALES_Cliente__c=acc.Id,
                                                                          DSALES_Clave_Tienda__c='daadsa'
                                                                         
                                                                          );
        insert pago;
        
        
        
        
    }
    
    @isTest 
    static void CambiaCautivoClienteTest(){
        DSALES_InformacionDePago__c Objpago = [Select Id,Name, DSALES_Estatus__c FROM DSALES_InformacionDePago__c LIMIT 1];
        Test.startTest();
        Objpago.DSALES_Estatus__c='Acreditado';
        update Objpago;
		Test.stopTest();       
    }
    
}