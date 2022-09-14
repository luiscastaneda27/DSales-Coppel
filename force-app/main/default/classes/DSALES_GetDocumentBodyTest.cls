@isTest
public class DSALES_GetDocumentBodyTest {
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
        
        Claim tempo = new Claim();
        tempo.Name='covertura';
        tempo.PolicyNumberId = poli.Id;
        tempo.P_liza__c = poli.Id;
        tempo.DSALES_SiniestroUid__c = '1';
        tempo.DSALES_Estatus__c = 'Nuevo';
        tempo.ClaimType ='Robo total';
        tempo.ClaimReason='sdsvs';       
        insert tempo;
        
        Claim tempo2 = new Claim();
        tempo2.Name='covertura';
        tempo2.PolicyNumberId = poli.Id;
        tempo2.P_liza__c = poli.Id;
        tempo2.DSALES_SiniestroUid__c = '2';
        tempo2.DSALES_Estatus__c = 'En trámite';
        tempo2.ClaimType ='Robo total';
        tempo2.ClaimReason='sdsvs';       
        insert tempo2;   
        
        ContentVersion documentos = new ContentVersion ();
        documentos.ContentLocation = 'S';
        documentos.ContentDocumentId = null;
        Blob blo = EncodingUtil.base64Decode('fileBody');
        documentos.VersionData = blo; // Variable del archivo tipo Blob
        documentos.Title = 'Archivo'; // variable nombre del archivo tipo string
        documentos.PathOnClient = 'fileName'; // variable nombre del archivo tipo string
        insert documentos;
        
        ContentVersion version = DSALES_CreateDocument.CreaDocument('Cadena64bits','nombreArchivo');
        insert version;
        
    }
    
    @isTest 
    static void CreaDocumentTest(){
        Claim siniestro = [SELECT Id, DSALES_SiniestroUid__c FROM Claim WHERE DSALES_SiniestroUid__c = '2'];
        ContentVersion version = DSALES_CreateDocument.CreaDocument('Cadena64bits','nombreArchivo');
        ContentVersion v = [SELECT ContentDocumentId, VersionData FROM ContentVersion where ContentDocument.Title ='Archivo'];
        DSALES_CreateDocument.Crealink(v, siniestro.Id);
       
        
        
    }
    

}