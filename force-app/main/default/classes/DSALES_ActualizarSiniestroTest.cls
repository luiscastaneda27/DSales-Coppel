@isTest
public class DSALES_ActualizarSiniestroTest {
	@testSetup
    public static void makeData(){
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponsePolizaTest());
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
       	String recordTypeIdOpp=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seguro_de_Moto').getRecordTypeId();
       	String recordTypeIdQuote=Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('DSALES_VentaSM').getRecordTypeId();
        String recordTypeIdPago=Schema.SObjectType.DSALES_InformacionDePago__c.getRecordTypeInfosByDeveloperName().get('DSALES_PagosdeVentaenNPVSM_c').getRecordTypeId();

        Account cuenta = new Account();
        cuenta.RecordTypeId=recordTypeId;
        cuenta.firstName='Sayra';
        cuenta.lastName='Martinez';
        cuenta.PersonEmail= 'prub@invalid.com';
        cuenta.Phone = '93617359';
        cuenta.PersonBirthdate=Date.parse('10/01/1997');
        insert cuenta;
        Opportunity op= new Opportunity();
        op.recordTypeId=recordTypeIdOpp;
        op.AccountId=cuenta.Id;
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
        cot.DSALES_Aseguradora__c='Qualitas';
        cot.DSALES_Negocio__c='Coppel';
        insert cot;
        Asset producto= new Asset(Name='Nelson',AccountId=cuenta.id);
        insert producto;
       
        Test.enableChangeDataCapture();
        DSALES_InformacionDePago__c pago =new DSALES_InformacionDePago__c();
        pago.recordTypeId=recordTypeIdPago;
        pago.DSALES_Nombre_del_cliente__c=cuenta.Id;
        pago.DSALES_Oportunidad__c=op.Id;
        pago.DSALES_FormaDePago__c='Efectivo';
        pago.DSALES_Factura__c='1';
        pago.DSALES_SKU__c='1';
        //pago.DSALES_ProductoAdquirido__c=producto.Id;
        //pago.DSALES_Motoexterna__c=true;
        pago.DSALES_Cliente__c=cuenta.Id;
        insert pago;
        Test.getEventBus().deliver();
        DSALES_InformacionDePago__c p=[SELECT Id, DSALES_Poliza__c,DSALES_Motoentregada__c,DSALES_Motoexterna__c,DSALES_SKU__c FROM DSALES_InformacionDePago__c LIMIT 1];
        System.debug('poliza en pago:'+p.DSALES_Poliza__c);
       /* InsurancePolicy poliza=new InsurancePolicy();
        poliza.NameInsuredId=cuenta.Id;
        poliza.DSALES_Estatusdepliza__c='En trámite';
        poliza.Name='Test';
        poliza.DSALES_CorreoElectronico__c=cuenta.PersonEmail;
        insert poliza;*/
        
        
        Test.enableChangeDataCapture();
        InsurancePolicyAsset activo = new InsurancePolicyAsset();
        activo.AssetName='Test';
        activo.DSALES_Account__c=cuenta.Id;
        activo.InsurancePolicyId=p.DSALES_Poliza__c;
        activo.DSALES_InformacionPago__c=p.Id;
        activo.DSALES_Clavevehicular__c='Test';
        activo.DSALES_Modelo__c='Test';
        activo.DSALES_Numeroserie__c='Test';
        activo.DSALES_Numeromotor__c='Test';
        activo.DSALES_Descripcion__c='Test';
        activo.DSALES_Servicio__c='Test';
        activo.DSALES_Placas__c='Test';
        activo.DSALES_Marca__c='Test';
        activo.DSALES_Uso__c='Test';
        activo.DSALES_ClaveAMIS__c='Test';
        //activo.DSALES_Motoexterna__c=true;
        activo.Estatus__c='Activo';
        activo.DSALES_Valorfactura__c=10000;
        insert activo;
       Test.enableChangeDataCapture();
        Claim sin = new Claim();
        sin.Name='Prueba Actualizar';
        sin.P_liza__c=p.DSALES_Poliza__c;
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
         
         Test.enableChangeDataCapture();      
        ClaimPaymentSummary pagos = new ClaimPaymentSummary();
        pagos.Name='Pago prueba';
        pagos.ClaimId=sin.Id;
        pagos.PaymentAmount=20000;
        pagos.DSALES_Tipopago__c='Pago a cuenta Coppel';
        insert pagos;
        
        
        
    }
    
    @isTest
    public static void actualizarSiniestro(){
        
        Test.startTest();
       	
		Test.getEventBus().deliver();
        Claim sin=[SELECT Id,P_liza__c,DSALES_Estatus__c FROM Claim LIMIT 1];
        System.debug('estatus despues de pago:'+sin.DSALES_Estatus__c);
        InsurancePolicy pol=[SELECT Id,DSALES_Estatusdepliza__c FROM InsurancePolicy  LIMIT 1];
        System.debug('estatus de póliza despues de pago:'+pol.DSALES_Estatusdepliza__c);
        
        Test.stopTest(); 
        
    }
}