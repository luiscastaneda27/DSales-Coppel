public with sharing class DSALES_InsurancePolicyAssets {
    public static void agregarDatosDeActivo(List<InsurancePolicyAsset> activos){
        for(InsurancePolicyAsset i:activos){
            DSALES_CreateInsurancePolicy.agregarDatosDeActivo(i.Id);
        }
    }
    public static void cancelarPoliza(Map<Id,SObject> existingRecords, List<SObject> records){
        List<InsurancePolicyAsset> listRecord = (List<InsurancePolicyAsset>)records;
        for(InsurancePolicyAsset a:listRecord){
            InsurancePolicyAsset assetOld = (InsurancePolicyAsset)existingRecords.get(a.Id);
            if(assetOld.Estatus__c!=a.Estatus__c){
                if(a.Estatus__c=='Devuelto' ||a.Estatus__c=='Cancelado'){
                    DSALES_CreateInsurancePolicy.cancelarPoliza(a.Id);
                }
                
            }
            
        }
     }
}