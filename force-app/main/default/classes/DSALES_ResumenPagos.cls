public class DSALES_ResumenPagos extends fflib_SObjectDomain {
    public DSALES_ResumenPagos(List<ClaimPaymentSummary> sObjectList){
        Super(sObjectList);
        
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_ResumenPagos(sObjectList);
        }
    }
        
    
    public override void onAfterInsert() {
        List<ClaimPaymentSummary> listRecord = (List<ClaimPaymentSummary>)records;
        List<ClaimPaymentSummary> listPagos = new List<ClaimPaymentSummary>();
        for(ClaimPaymentSummary pago:listRecord){ 
            if(pago.DSALES_Tipopago__c=='Pago a Cliente' || pago.DSALES_Tipopago__c=='Pago a cuenta Coppel'){
                System.debug('entró a la condición del handler');  
                listPagos.add(pago);
            }
        }
        if(listPagos.size()>0){
        	DSALES_SiniestrosHelper.actualizarDatos(JSON.serialize(listPagos));
        }
   }

}