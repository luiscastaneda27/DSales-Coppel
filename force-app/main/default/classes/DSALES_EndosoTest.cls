@isTest
public class DSALES_EndosoTest {
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
        
        
       
        
    }
    @isTest
    public static void nuevaPoliza(){
        DSALES_Endoso__c endoso =[SELECT Id,DSALES_Estatus__c FROM DSALES_Endoso__c LIMIT 1];
        endoso.DSALES_Estatus__c='Autorizado';
        update endoso;
        Test.startTest();
       	Test.setMock(HttpCalloutMock.class, new DSALES_MockHttpResponsePolizaTest());
		Test.getEventBus().deliver();
        DSALES_Endoso__c endo=[SELECT Id, DSALES_Estatus__c FROM DSALES_Endoso__c LIMIT 1];
        System.debug('endoso'+endo.DSALES_Estatus__c);
        InsurancePolicy pol=[SELECT Id,DSALES_Estatusdepliza__c,Status,DSALES_Activodeplizadeseguro__c FROM InsurancePolicy LIMIT 1 ];
        System.debug('poliza activo: '+ pol.DSALES_Activodeplizadeseguro__c);
        
        Test.stopTest();
        
    }
    
    
}