public class DSALES_InformacionDePago extends fflib_SObjectDomain{

    public DSALES_InformacionDePago(List<DSALES_InformacionDePago__c> sObjectList){
        Super(sObjectList);
        
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_InformacionDePago(sObjectList);
        }
    }

    
    public override void onAfterInsert() {
        DSALES_InformacionPagoHandler.CambiaClienteCautivo( records);
        DSALES_InformacionPagoHandler.createPolizaMExt(records);
       
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        DSALES_InformacionPagoHandler.CambiaClienteCautivo( records);
        DSALES_InformacionPagoHandler.enviarIntegracion(existingRecords, records);
        
    }
    
    
    
}