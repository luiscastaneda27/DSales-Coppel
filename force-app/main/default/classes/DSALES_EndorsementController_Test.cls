@isTest
public class DSALES_EndorsementController_Test {
    
    @testSetup
    static void testSetup(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Administrador SM'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
        insert u;
        //System.runAs(u){
        String accountRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        String recordTypeIdOpp=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seguro_de_Moto').getRecordTypeId();
  		String recordTypeIdQuote=Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('DSALES_VentaSM').getRecordTypeId();

            Account acc = new Account();
             acc.firstName='JUansaos';
             acc.lastName='Japellido';
             acc.PersonEmail= 'asa@as.co';
             acc.Phone = '93617359';
             insert acc;
            
             Opportunity op= new Opportunity();
            op.recordTypeId=recordTypeIdOpp;
            op.AccountId=acc.Id;
            op.Name='Sayra Oppty';
            op.StageName='Nuevo';
            op.CloseDate=Date.today()+2;
            op.DSALES_Nombredelsolicitante__c='Keira Martinez';
            insert op;
        

            Quote cot= new Quote();
            cot.recordTypeId=recordTypeIdQuote;
            cot.Name='Sayra Martinez';
            cot.DSALES_Fechadenacimiento__c=Date.parse('11/01/1990');
            cot.Email='prib@23.mx';
            cot.OpportunityId=op.Id;
            cot.DSALES_Cobertura__c='PLUS';
            cot.DSALES_Opcindepago__c='Mensual';
            cot.DSALES_Gnero__c='Femenino';
            cot.Phone='5631234567';
            cot.DSALES_Cdigodeestado__c='1';
            cot.DSALES_Cdigodemunicipio__c='2';
            cot.DSALES_Cdigopostal__c='3';
            cot.DSALES_Suburbcode__c=34;
            insert cot;
        
             InsurancePolicy poli = new InsurancePolicy();
             poli.Name = 'DFGGSD';
             poli.NameInsuredId=acc.Id;
             poli.DSALES_CorreoElectronico__c='nuevo@gma.com';
            poli.SourceOpportunityId=op.Id;
            poli.SourceQuoteId=cot.Id;
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
        //}     
    }
    
	@isTest static void testCallout() {
        User u =[SELECT Id FROM User WHERE LastName='Testing' ];
       // System.runAs(u){
            DSALES_Endoso__c endoso = [SELECT Id, DSALES_uid__c FROM DSALES_Endoso__c WHERE DSALES_uid__c = 'iszxxzxaxa'];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseEndoso()); 
            Boolean bol = DSALES_EndorsementController.crearEndoso(endoso.Id);
            String res = DSALES_EndorsementController.ConsultarEndoso(endoso.DSALES_uid__c);
            Integer val=DSALES_EndorsementController.validarDoc(endoso.Id);     
            //HttpResponse response = DSALES_EndorsementCallout.makePost();
            //String fake = response.getBody();
            Test.stopTest(); 
        //}
    }    
}