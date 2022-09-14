@isTest
public class DSALES_SiniestroCallsTest  {
    
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
        tempo.DSALES_SiniestroUid__c = 'iszxxzxaxa';
        tempo.DSALES_Estatus__c = 'En trámite';
        tempo.ClaimType ='Robo total';
        tempo.ClaimReason='sdsvs';       
        insert tempo;
        
        Claim tempo2 = new Claim();
        tempo2.Name='covertura';
        tempo2.PolicyNumberId = poli.Id;
        tempo2.P_liza__c = poli.Id;
        tempo2.DSALES_SiniestroUid__c = 'iszxxzxaxab';
        tempo2.DSALES_Estatus__c = 'Nuevo';
        tempo2.ClaimType ='Robo total';
        tempo2.ClaimReason='sdsvs';       
        insert tempo2;
        
        List<ContentVersion> documentos = new list<ContentVersion>(); 
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','Factura'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'ContanciaBajaPlacas'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'Descripcion'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'Comprobante'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'IdComprobante'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'CarpetaMP'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'AcreditacionMP'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd', 'OficioLiberacionRobo'));

        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','IdentificacionFrontal'));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','IdentificacionReverso' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','ComprobanteDomicilio' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','CURP' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','PoderNotarial' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','EncabezadoCuentaBancaria' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','ConstanciaSituacionFiscal' ));

        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','CartaConsentimientoCFDI' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','CartaConsentimientoCFDI' ));
        documentos.add(DSALES_CreateDocument.CreaDocument('sdsd','FormatoFiniquito' ));
        
        insert documentos;
        List<Id> siniestriIds = new list<Id>();
        siniestriIds.add(tempo.Id);
        List<ContentDocumentLink> links = new list<ContentDocumentLink>();
        for(Integer j=0; j<1; j++){
            for(Integer k=j*18; k<18*j+18; k++){
                links.add(DSALES_CreateDocument.Crealink(documentos[k], siniestriIds[j]));
            }
        }
        insert links;         
    }
    
    @isTest 
    static void testCallout(){
        Claim siniestro = [SELECT Id, DSALES_SiniestroUid__c FROM Claim WHERE DSALES_SiniestroUid__c = 'iszxxzxaxa'];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestro(3));
        DSALES_SiniestroCalls.updateSiniestro();
        
		Test.stopTest();
    }
 

}