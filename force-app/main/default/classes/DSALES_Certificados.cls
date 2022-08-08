public class DSALES_Certificados extends fflib_SObjectDomain{

    public DSALES_Certificados(List<DSALES_Certificado__c> sObjectList){
        Super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_Certificados(sObjectList);
        }
    }
    
    public override void onAfterInsert() {
        DSALES_CertificadosHelper.envioCertificado(JSON.serialize(records));
    }
}