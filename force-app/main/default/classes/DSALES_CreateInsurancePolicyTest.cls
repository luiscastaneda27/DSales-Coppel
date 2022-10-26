@isTest
public with sharing class DSALES_CreateInsurancePolicyTest {
    @TestSetup
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
        insert cot;
        
        
       
        Test.enableChangeDataCapture();
        DSALES_InformacionDePago__c pago =new DSALES_InformacionDePago__c();
        pago.RecordTypeId=recordTypeIdPago;
        pago.DSALES_Nombre_del_cliente__c=cuenta.Id;
        pago.DSALES_Oportunidad__c=op.Id;
        pago.DSALES_FormaDePago__c='Efectivo';
        pago.DSALES_Factura__c='2';
        pago.DSALES_SKU__c='1';
        pago.DSALES_Cliente__c=cuenta.Id;
        insert pago;
        
        Test.enableChangeDataCapture();
        DSALES_InformacionDePago__c pag =new DSALES_InformacionDePago__c();
        pag.RecordTypeId=recordTypeIdPago;
        pag.DSALES_Nombre_del_cliente__c=cuenta.Id;
        pag.DSALES_Oportunidad__c=op.Id;
        pag.DSALES_FormaDePago__c='Efectivo';
        pag.DSALES_Factura__c='1';
       	pag.DSALES_Cliente__c=cuenta.Id;
        insert pag;
       
        Test.getEventBus().deliver();
        List<DSALES_InformacionDePago__c> ppa=[SELECT Id, DSALES_Poliza__c,DSALES_Motoentregada__c,DSALES_Motoexterna__c,DSALES_SKU__c FROM DSALES_InformacionDePago__c];
        System.debug('pago pol:'+ppa[0].DSALES_Poliza__c);  
        System.debug('pag pol:'+ppa[1].DSALES_Poliza__c);
        System.debug('pago sku:'+ppa[0].DSALES_SKU__c);  
        System.debug('pag sku:'+ppa[1].DSALES_SKU__c);
		System.debug('pago Id:'+ppa[0].Id);  
        System.debug('pag Id:'+ppa[1].Id);
        
        
       	Test.enableChangeDataCapture();
        InsurancePolicyAsset activo = new InsurancePolicyAsset();
        activo.AssetName='Test';
        activo.DSALES_Account__c=cuenta.Id;
        activo.InsurancePolicyId=ppa[0].DSALES_Poliza__c;
        activo.DSALES_InformacionPago__c=ppa[0].Id;
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
        InsurancePolicyAsset ac = new InsurancePolicyAsset();
        ac.AssetName='Test';
        ac.DSALES_Account__c=cuenta.Id;
        ac.InsurancePolicyId=ppa[1].DSALES_Poliza__c;
        ac.DSALES_InformacionPago__c=ppa[1].Id;
        ac.DSALES_Clavevehicular__c='Test';
        ac.DSALES_Modelo__c='Test';
        ac.DSALES_Numeroserie__c='Test';
        ac.DSALES_Numeromotor__c='Test';
        ac.DSALES_Descripcion__c='Test';
        ac.DSALES_Servicio__c='Test';
        ac.DSALES_Placas__c='Test';
        ac.DSALES_Marca__c='Test';
        ac.DSALES_Uso__c='Test';
        ac.DSALES_ClaveAMIS__c='Test';
        ac.Estatus__c='Activo';
        ac.DSALES_Valorfactura__c=10000;
        ac.DSALES_Motoexterna__c=true;
        insert ac;

		ppa[0].DSALES_Motoentregada__c=true;     
        ppa[1].DSALES_Motoexterna__c=true;
        update ppa;
        Test.getEventBus().deliver();
        List<InsurancePolicyAsset> activos =[SELECT Id,Estatus__c FROM InsurancePolicyAsset ];
        activos[0].Estatus__c='Devuelto';
        activos[1].Estatus__c='Cancelado';
        update activos;
        
		
    }
    
    @isTest
    public static void datosPolizaTest(){
        Test.getEventBus().deliver();
       	List<DSALES_InformacionDePago__c> pago=[SELECT Id,DSALES_Poliza__c,DSALES_Motoexterna__c,DSALES_Motoentregada__c FROM DSALES_InformacionDePago__c ];
        List<InsurancePolicy> pol=[SELECT Id,DSALES_Activodeplizadeseguro__c,ExpirationDate,DSALES_Estatusdepliza__c,DSALES_PDF_poliza__c FROM InsurancePolicy ];
		System.debug('ext11:'+pago[0].DSALES_Motoexterna__c);
        System.debug('ext22:'+pago[1].DSALES_Motoexterna__c);
        System.debug('ent11:'+pago[0].DSALES_Motoentregada__c);
        System.debug('ent22:'+pago[1].DSALES_Motoentregada__c);
    
        Test.enableChangeDataCapture();
        pol[0].ExpirationDate=System.today();
        update pol[0];
        
        Test.startTest();
		System.debug('Poliza en test2:'+ pol);
        System.assertEquals(2,pol.size());
        Test.stopTest();
        
    }
}