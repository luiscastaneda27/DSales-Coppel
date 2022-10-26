public without sharing class DSALES_InsurancePolicyHandler extends fflib_SObjectDomain {
	public DSALES_InsurancePolicyHandler(List<InsurancePolicy> sObjectList){
        Super(sObjectList);
        
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_InsurancePolicyHandler(sObjectList);
        }
    }

    public override void onAfterInsert() {
		DSALES_UpdateInfoPago.updateInfoPagoPoliza(records);
        
       	
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        DSALES_UpdateInfoPago.updateStatus(existingRecords, records);
        DSALES_UpdateInfoPago.updatefieldOfAsset(existingRecords, records);
       
    }
}