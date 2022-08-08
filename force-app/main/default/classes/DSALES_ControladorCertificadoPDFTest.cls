@istest
public class DSALES_ControladorCertificadoPDFTest {
    public DSALES_Certificado__c certi = new DSALES_Certificado__c();
    @testSetup
    static void testSetup(){
        Account ac= new Account(Name='DannyTest');  
        insert ac;
        Asset asset= new Asset(Name='DannyTest-b',AccountId=ac.Id);
        insert asset;
        DSALES_Certificado__c certi = new DSALES_Certificado__c(DSALES_ProductoAdquirido__c=asset.id);
        insert certi;
        DSALES_Generador__C genera= new DSALES_Generador__c(Name='Certificado PDF',DSALES_Plantilla__c='Hey');
        insert genera;
    }
    @isTest static void DSALES_ControladorCertificadoPDF()
    {
        DSALES_Certificado__c certificado= [SELECT id FROM DSALES_Certificado__c];
        PageReference pageRef = Page.DSALES_CertificadoPDF;
        Test.setCurrentPage(pageRef);
        // put the certificado id as a parameter
        ApexPages.currentPage().getParameters().put('certificadoId',certificado.Id);
        // Call your apex method here and you will get code coverage
        DSALES_ControladorCertificadoPDF d = new DSALES_ControladorCertificadoPDF();
        
    }
    
}