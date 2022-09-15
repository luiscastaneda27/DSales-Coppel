@isTest
public class DSALES_ActualizarSiniestroTest {
	@testSetup
    public static void makeData(){
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Test.enableChangeDataCapture();
        Account cuenta = new Account();
        cuenta.RecordTypeId=recordTypeId;
        cuenta.firstName='Prueba';
        cuenta.lastName='Test';
        cuenta.PersonEmail= 'prub@invalid.com';
        cuenta.Phone = '93617359';
        insert cuenta;
        
        InsurancePolicy poliza = new InsurancePolicy();
        poliza.NameInsuredId=cuenta.Id;
        poliza.DSALES_Tipodepersona__c='Física';
        poliza.Name='Test';
        poliza.DSALES_Estatusdepliza__c='Vigente';
        
        poliza.DSALES_CorreoElectronico__c='pruebastest@invalid.com';
        //poliza.DSALES_Activodeplizadeseguro__c=activo.Id;
        insert poliza;
        
        InsurancePolicyAsset activo = new InsurancePolicyAsset();  
        activo.AssetName='Pruebas activo';
        activo.InsurancePolicyId=poliza.Id;
        activo.DSALES_Account__c=cuenta.Id;
        insert activo;
       
        Claim sin = new Claim();
        sin.Name='Prueba Actualizar';
        sin.P_liza__c=poliza.Id;
        sin.ClaimType='Perdida Total';
        sin.ClaimReason='Pruebas';
        insert sin;
        
        List<ContentVersion> documentos = new list<ContentVersion>(); 
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','Factura'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'ContanciaBajaPlacas'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'Descripcion'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'Comprobante'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'IdComprobante'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'CarpetaMP'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'AcreditacionMP'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas', 'OficioLiberacionRobo'));

        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','IdentificacionFrontal'));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','IdentificacionReverso' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','ComprobanteDomicilio' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','CURP' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','PoderNotarial' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','EncabezadoCuentaBancaria' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','ConstanciaSituacionFiscal' ));

        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','CartaConsentimientoCFDI' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','CartaConsentimientoCFDI' ));
        documentos.add(DSALES_DocumentsToTest.CrearDocumentos('pruebas','FormatoFiniquito' ));
        
        insert documentos;
        List<ContentDocumentLink> contDoc = new list<ContentDocumentLink>();
        for(Integer i=0; i<18; i++){
                contDoc.add(DSALES_DocumentsToTest.documentLink(documentos[i], sin.Id));
            }
        
        insert contDoc; 
         
                
        
        
        
    }
    
    @isTest
    public static void actualizarSiniestro(){
        Claim sin=[SELECT Id,P_liza__c,DSALES_Estatus__c FROM Claim LIMIT 1];
        System.debug('estatus antes de pago:'+sin.DSALES_Estatus__c);
        InsurancePolicy pol=[SELECT Id,DSALES_Estatusdepliza__c FROM InsurancePolicy WHERE Id=:sin.P_liza__c LIMIT 1];
         System.debug('estatus de póliza despues de pago:'+pol.DSALES_Estatusdepliza__c);
        ClaimPaymentSummary pagos = new ClaimPaymentSummary();
        pagos.Name='Pago prueba';
        pagos.ClaimId=sin.Id;
        pagos.PaymentAmount=20000;
        pagos.DSALES_Tipopago__c='Pago a cuenta Coppel';
        insert pagos;
        
        Test.startTest();
       	Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponseSiniestroTest());
		Test.getEventBus().deliver();
        sin=[SELECT Id,P_liza__c,DSALES_Estatus__c FROM Claim LIMIT 1];
        System.debug('estatus despues de pago:'+sin.DSALES_Estatus__c);
        pol=[SELECT Id,DSALES_Estatusdepliza__c FROM InsurancePolicy WHERE Id=:sin.P_liza__c LIMIT 1];
        System.debug('estatus de póliza despues de pago:'+pol.DSALES_Estatusdepliza__c);
        
        Test.stopTest(); 
        
    }
}