public class DSALES_Endosos extends fflib_SObjectDomain {
    public DSALES_Endosos(List<DSALES_Endoso__c> sObjectList){
        Super(sObjectList);
        
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_Endosos(sObjectList);
        }
    }
    
    public override void onAfterUpdate(Map<Id, SObject> existingRecords){
        List<DSALES_Endoso__c> listEndosos = new List<DSALES_Endoso__c> ();
        List<DSALES_Endoso__c> listRecord = (List<DSALES_Endoso__c>)records;
  		for(DSALES_Endoso__c endo:listRecord){
             DSALES_Endoso__c endOld = (DSALES_Endoso__c)existingRecords.get(endo.Id);
             if(endOld.DSALES_Estatus__c!=endo.DSALES_Estatus__c  && endo.DSALES_Estatus__c=='Autorizado'){
                 DSALES_EndososHelper.actualizarDatosPoliza(endo);
                 
                 
             }
         }
         
    }
    
}