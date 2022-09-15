public class DSALES_ResumenPagos  {
/*extends fflib_SObjectDomain {
    public DSALES_ResumenPagos(List<ClaimPaymentSummary> sObjectList){
        Super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<ClaimPaymentSummary> sObjectList){
            return new DSALES_ResumenPagos(sObjectList);
        }
    }*/
    
    
    public static void onAfterInsert(Map<Id, ClaimPaymentSummary> newMap) {
        List<ClaimPaymentSummary> listPagos = new List<ClaimPaymentSummary>();
        for(ClaimPaymentSummary pago:newMap.Values()){ 
            if(newMap.get(pago.Id).DSALES_Tipopago__c=='Pago a Cliente' || newMap.get(pago.Id).DSALES_Tipopago__c=='Pago a cuenta Coppel'){
                System.debug('entró a la condición del handler');  
                listPagos.add(newMap.get(pago.Id));
            }
        }
        if(listPagos.size()>0){
        	DSALES_SiniestrosHelper.actualizarDatos(JSON.serialize(listPagos));
        }
   }

}