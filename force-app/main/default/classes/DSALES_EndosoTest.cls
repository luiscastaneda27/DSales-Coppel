@isTest
public class DSALES_EndosoTest {
	 @testSetup
    public static void makeData(){
        Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponsePolizaTest());
    	String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
       	String recordTypeIdOpp=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seguro_de_Moto').getRecordTypeId();
       	String recordTypeIdQuote=Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('DSALES_VentaSM').getRecordTypeId();
        
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
        
        Test.enableChangeDataCapture();
        DSALES_InformacionDePago__c pago =new DSALES_InformacionDePago__c();
        //pago.Name='Pago 1';
        pago.DSALES_Nombre_del_cliente__c=cuenta.Id;
        pago.DSALES_Oportunidad__c=op.Id;
        pago.DSALES_FormaDePago__c='Efectivo';
        pago.DSALES_Factura__c='1';
        pago.DSALES_SKU__c='1';
        //pago.DSALES_Motoexterna__c=true;
        pago.DSALES_Cliente__c=cuenta.Id;
        insert pago;
        
        InsurancePolicy poliza=new InsurancePolicy();
        poliza.NameInsuredId=cuenta.Id;
        poliza.DSALES_Estatusdepliza__c='En trámite';
        poliza.Name='Test';
        poliza.DSALES_CorreoElectronico__c=cuenta.PersonEmail;
        insert poliza;
        
        
        
        DSALES_Endoso__c endoso = new 	DSALES_Endoso__c();
        endoso.DSALES_Poliza__c=poliza.Id;
        endoso.DSALES_Tipodeendoso__c='Corrección de nombre';
        endoso.DSALES_Tipodedato__c='Color';
        endoso.DSALES_Valor__c='esto es una prueba';
        endoso.DSALES_Estatus__c='Nuevo';
        endoso.DSALES_CorreoElectronico__c='pruebastest@invalid.com';
        endoso.DSALES_NuevaPoliza__c='111154194';
        endoso.DSALES_Tipodedocumento__c='Identificación oficial';
        insert endoso;
        
        Test.enableChangeDataCapture();
        //DSALES_Endoso__c endoso =[SELECT Id,DSALES_Estatus__c FROM DSALES_Endoso__c LIMIT 1];
        endoso.DSALES_Estatus__c='Autorizado';
        update endoso;
        
        
       
        
    }
    @isTest
    public static void nuevaPoliza(){
       	Test.startTest();
       	Test.getEventBus().deliver();
        DSALES_Endoso__c endo=[SELECT Id, DSALES_Estatus__c FROM DSALES_Endoso__c LIMIT 1];
        System.debug('endoso'+endo.DSALES_Estatus__c);
        InsurancePolicy pol=[SELECT Id,DSALES_Estatusdepliza__c,Status,DSALES_Activodeplizadeseguro__c FROM InsurancePolicy LIMIT 1 ];
        System.debug('poliza activo: '+ pol.DSALES_Activodeplizadeseguro__c);
        
        Test.stopTest();
        
    }
    
    
}