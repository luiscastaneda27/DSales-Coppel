public without sharing class DSALES_UpdateInfoPago {
    public static void updateInfoPagoPoliza(List<InsurancePolicy> poliza){
        for(InsurancePolicy p:poliza){
                DSALES_CreateInsurancePolicy.updateInfoPago(p);
        }
    }
    
    public static void updatefieldOfAsset(Map<Id,SObject> existingRecords,List<InsurancePolicy> records){
    	List<InsurancePolicy> listRecord = (List<InsurancePolicy>)records;
        for(InsurancePolicy p:listRecord){
            InsurancePolicy policyOld = (InsurancePolicy)existingRecords.get(p.Id);
            if(policyOld.DSALES_Activodeplizadeseguro__c!= p.DSALES_Activodeplizadeseguro__c){
                DSALES_CreateInsurancePolicy.agregarDatosDeActivo(p.DSALES_Activodeplizadeseguro__c);
            }
        }
        
    }
    public static void updateStatus(Map<Id,SObject> existingRecords,List<InsurancePolicy> records){
        List<InsurancePolicy> listRecord = (List<InsurancePolicy>)records;
        for(InsurancePolicy p :listRecord){
            InsurancePolicy policyOld = (InsurancePolicy)existingRecords.get(p.Id);
            if(policyOld.ExpirationDate!=p.ExpirationDate && policyOld.DSALES_Estatusdepliza__c!='Cancelada'){
                DSALES_CreateInsurancePolicy.cambiarEstatus(p.Id);
            }
        }  
       
    }
    

    
    
}