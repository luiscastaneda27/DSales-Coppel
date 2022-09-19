@isTest
public class DSALES_ConsultaListaNegraTest {
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
        
        
        Quote cotizacion = new Quote(Name='Nueva', Motivo_de_lista_negra__c='no hay',DSALES_AdquiriopolizaSM__c=true, OpportunityId=op.Id);
        insert cotizacion; 
        
        
    }
    
    @isTest 
    static void testListaNegra(){
        Quote cotizacion = [Select Id, Name FROM Quote WHERE Name = 'Nueva' LIMIT 1];
        System.debug('Name = '+cotizacion.Name);
        String NOMBRE_SERVICIO = 'DSALES_ListaNegra';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(4)); 
        DSALES_ConsultaListaNegra.listaNegra(cotizacion.Id);
		Test.stopTest();       
    }

}