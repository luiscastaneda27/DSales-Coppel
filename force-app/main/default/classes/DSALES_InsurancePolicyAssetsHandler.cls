public with sharing class DSALES_InsurancePolicyAssetsHandler extends fflib_SObjectDomain {
    public DSALES_InsurancePolicyAssetsHandler(List<InsurancePolicyAsset> sObjectList){
        Super(sObjectList);
        
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_InsurancePolicyAssetsHandler(sObjectList);
        }
    }
    
    public override void onAfterInsert() {
        DSALES_InsurancePolicyAssets.agregarDatosDeActivo(records);
        //DSALES_InsurancePolicyAssets.enviarIntegracion(records);
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        
        DSALES_InsurancePolicyAssets.cancelarPoliza(existingRecords,records);
        
        
    }
    
}