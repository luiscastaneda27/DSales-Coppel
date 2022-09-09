@isTest
public class DSALES_EndorsementController_Test {
    
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
        
        DSALES_Endoso__c tempo = new DSALES_Endoso__c();
        tempo.DSALES_Poliza__c = poli.Id;
        tempo.DSALES_uid__c = 'iszxxzxaxa';
        tempo.DSALES_Estatus__c = 'En tramite';
        tempo.DSALES_Tipodedocumento__c='Identificación oficial';
        tempo.DSALES_Tipodeendoso__c='Cambio de titular';
        tempo.DSALES_Tipodedato__c='RFC';
        tempo.DSALES_Valor__c='DFERR';
        insert tempo;      
    }
    
	@isTest static void testCallout() {
        DSALES_Endoso__c endoso = [SELECT Id, DSALES_uid__c FROM DSALES_Endoso__c WHERE DSALES_uid__c = 'iszxxzxaxa'];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseEndoso()); 
        Boolean bol = DSALES_EndorsementController.crearEndoso(endoso.Id);
        String res = DSALES_EndorsementController.ConsultarEndoso(endoso.DSALES_uid__c);        
       	//HttpResponse response = DSALES_EndorsementCallout.makePost();
        //String fake = response.getBody();
        Test.stopTest();                     
    }    
}