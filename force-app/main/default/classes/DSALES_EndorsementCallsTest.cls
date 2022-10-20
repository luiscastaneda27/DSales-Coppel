@isTest
public class DSALES_EndorsementCallsTest {
    
    
    @testSetup
    static void testSetup(){
        String accountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account acc = new Account();
        acc.firstName='JUansaos';
        acc.lastName='Japellido';
        acc.PersonEmail= 'asa@as.co';
        acc.Phone = '93617359';
        insert acc;
        
        InsurancePolicy poli = new InsurancePolicy();
        poli.Name = 'DFGGSD';
        poli.NameInsuredId=acc.Id;
        poli.DSALES_CorreoElectronico__c='nuevo@gma.com';
        insert poli;
        
        DSALES_Endoso__c endoso = new DSALES_Endoso__c();
        String recordTypeId = Schema.SObjectType.DSALES_Endoso__c.getRecordTypeInfosByName().get('Registro de endoso completo').getRecordTypeId();
        endoso.RecordTypeId = recordTypeId;
        endoso.DSALES_Cliente__c = acc.Id;
        endoso.DSALES_Folio__c = '323232';
        endoso.DSALES_Poliza__c = poli.Id;
        endoso.DSALES_uid__c = 'iszxxzxaxa';
        endoso.DSALES_Estatus__c = 'En tramite';
        endoso.DSALES_Tipodedocumento__c='Identificación oficial';
        endoso.DSALES_Tipodeendoso__c='Cambio de titular';
        endoso.DSALES_Tipodedato__c='RFC';
        endoso.DSALES_Valor__c='DFERR';
        endoso.DSALES_CorreoElectronico__c='sds@fs.com';
        insert endoso;      
    }
    
	@isTest static void testCallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseEndoso());
        DSALES_EndorsementCalls.updateEndoso();        
        Test.stopTest();                     
    }

}