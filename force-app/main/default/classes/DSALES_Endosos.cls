public class DSALES_Endosos {//extends fflib_SObjectDomain
    /*public DSALES_Endosos(List<DSALES_Endoso__c> listEndosos){
        Super(listEndosos);
        
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_Endosos(sObjectList);
        }
    }*/
    
     public static void onAfterUpdate(Map<Id, DSALES_Endoso__c> oldMap, Map<Id, DSALES_Endoso__c> newMap){
         List<DSALES_Endoso__c> listEndosos = new List<DSALES_Endoso__c> ();
         for(DSALES_Endoso__c endo:newMap.Values()){
             if(oldMap.get(endo.Id).DSALES_Estatus__c!=newMap.get(endo.Id).DSALES_Estatus__c  && newMap.get(endo.Id).DSALES_Estatus__c=='Autorizado'){
                 listEndosos.add(newMap.get(endo.Id));
             }
         }
         if(listEndosos.size() > 0){
             DSALES_EndososHelper.actualizarDatosPoliza(JSON.serialize(listEndosos));
         }
        
    }
    
}