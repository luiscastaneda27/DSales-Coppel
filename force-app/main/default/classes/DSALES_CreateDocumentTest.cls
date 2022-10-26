@isTest
public class DSALES_CreateDocumentTest {
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
        
        String query = 'SELECT Id, Name, DSALES_SiniestroUid__c,DSALES_Reporte__c,IncidentSiteStreet,IncidentSiteState,IncidentSiteCountry, ClaimType, CreatedDate, DSALES_Nombre_conductor__c, DSALES_Causa__c, DSALES_Descripcion__c, DSALES_Ano__c, DSALES_Marca__c, DSALES_Serie__c, InitiationDate, FinalizedDate, Cliente__r.Name, P_liza__r.Name, ClaimReason, DSALES_Estatus__c FROM Claim WHERE Id = \'';
        Claim tempo = new Claim();
        tempo.Name='covertura';
        tempo.PolicyNumberId = poli.Id;
        tempo.P_liza__c = poli.Id;
        tempo.DSALES_SiniestroUid__c = 'iszxxzxaxa';
        tempo.DSALES_Estatus__c = 'Nuevo';
        tempo.ClaimType ='Robo total';
        tempo.ClaimReason='sdsvs';  
        insert tempo;
    }
    
    @isTest static void testCrearDocumento() {
        Claim siniestro = [SELECT Id, DSALES_SiniestroUid__c FROM Claim WHERE DSALES_SiniestroUid__c = 'iszxxzxaxa'];
		ContentVersion dc = DSALES_CreateDocument.CreaDocument('sdsfsfsf', 'Prueba.pdf');
        insert dc;
        
        DSALES_CreateDocument.Crealink(dc, siniestro.Id);
		      
    }

}