public with sharing class DSALES_EndososHelper {
    public static final String NOMBRE_SERVICIO = 'DSALES_ObtenerPoliza';
    
    public static void actualizarDatosPoliza(String jsonString){
        List<DSALES_Endoso__c> listEndosos = (List<DSALES_Endoso__c>) JSON.deserialize(jsonString, List<DSALES_Endoso__c>.class);
        List<String> polizasId = new List<String>();
         List<String> endososId = new List<String>();
        for(DSALES_Endoso__c endo:listEndosos){ 
            polizasId.add(endo.DSALES_Poliza__c);
            endososId.add(endo.Id);
       	}
        
        //el estado de la póliza anterior se actualiza a endosada.
        List<InsurancePolicy> listToUpdate = [SELECT Id,ChangeSubtype,DSALES_Estatusdepliza__c,DSALES_Activodeplizadeseguro__c FROM InsurancePolicy WHERE Id IN:polizasId]; 
       	if(listToUpdate.size()>0){
            for(InsurancePolicy p: listToUpdate){
                p.ChangeSubtype='Endosada';
                p.DSALES_Estatusdepliza__c='Cancelada';
                //p.DSALES_Activodeplizadeseguro__c=null;
            }
        }
        crearNuevaPoliza(endososId);
        update listToUpdate;
    }
    @future(callout=true)
    public static void crearNuevaPoliza(List<String> listEndosos){
        //se hace la petición a inter de los datos para la nueva poliza
        String query ='SELECT Id,DSALES_NuevaPoliza__c,DSALES_Cliente__c,DSALES_Poliza__r.DSALES_CorreoElectronico__c,DSALES_Poliza__r.DSALES_Activodeplizadeseguro__c,DSALES_Poliza__r.NameInsuredId,DSALES_Poliza__r.SourceQuoteId,DSALES_Poliza__r.SourceOpportunityId FROM DSALES_Endoso__c WHERE Id IN:listEndosos';
        
        List<DSALES_Endoso__c> objList = DataBase.query(query);
        List<InsurancePolicy> listToInsert = new List<InsurancePolicy>();
        for(DSALES_Endoso__c e: objList){
            String body = obtenerCampos(e);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
            
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            
            request.setBody(body);
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                responsePoliza respuesta = (responsePoliza)JSON.deserialize(response.getbody(),responsePoliza.class);
                if(respuesta.success == true){
                    System.debug('respuesta url: '+ respuesta.data);
                    System.debug('url pdf'+respuesta.data.policy_url);
                    InsurancePolicy polizaNueva = new InsurancePolicy();
                    polizaNueva.DSALES_PDFpoliza__c=respuesta.data.policy_url;
                    polizaNueva.PolicyName=respuesta.data.policy_name;
                    polizaNueva.NameInsuredId=e.DSALES_Poliza__r.NameInsuredId;
                   	polizaNueva.DSALES_Estatusdepliza__c=respuesta.data.policy_status;
                    polizaNueva.Name=respuesta.data.policy_number;
                    polizaNueva.EffectiveDate=Datetime.valueOf(respuesta.data.policy_effectivedate);
                    polizaNueva.ExpirationDate=Datetime.valueOf(respuesta.data.policy_expirationdate);
                    System.debug('datetime:'+polizaNueva.ExpirationDate);
                    Decimal primaNeta =Decimal.valueOf(!String.isEmpty(respuesta.data.policy_netpremium) ? respuesta.data.policy_netpremium : '0');
                    polizaNueva.DSALES_Prima_Neta__c=primaNeta;
                    Decimal primaTotal =Decimal.valueOf(!String.isEmpty(respuesta.data.policy_totalpremium) ? respuesta.data.policy_totalpremium : '0');
                    polizaNueva.DSALES_Prima_total__c=primaTotal;
                    Decimal gastosExp =Decimal.valueOf(!String.isEmpty(respuesta.data.policy_shippingcosts) ? respuesta.data.policy_shippingcosts : '0');
                    polizaNueva.DSALES_Gastos_expedicion__c=gastosExp;
                    polizaNueva.DSALES_IVA__c=Decimal.valueOf(!String.isEmpty(respuesta.data.policy_iva) ? respuesta.data.policy_iva : '0');
                    //polizaNueva.ChangeSubtype=respuesta.data.policy_type;
                    polizaNueva.DSALES_CorreoElectronico__c=e.DSALES_Poliza__r.DSALES_CorreoElectronico__c;
                    polizaNueva.DSALES_Activodeplizadeseguro__c=e.DSALES_Poliza__r.DSALES_Activodeplizadeseguro__c;
                    polizaNueva.SourceQuoteId=e.DSALES_Poliza__r.SourceQuoteId;
                    polizaNueva.SourceOpportunityId=e.DSALES_Poliza__r.SourceOpportunityId;
                   	listToInsert.add(polizaNueva);
                }
                
            }
            
        }
         
        insert listToInsert;
         
    }
    
   /* public static void obtenerNuevaPoliza(List<InsurancePolicy> polisasNuevas,List<InsurancePolicy> polizasAnterior){
        List<String> ids = new List<String>();
        for(InsurancePolicy p:polisasNuevas){
            ids.add(p.Id);
        }
        List<String> listIds = new List<String>();
        for(InsurancePolicy p:polizasAnterior){
            listIds.add(p.DSALES_Activodeplizadeseguro__c);
        }
        List<InsurancePolicyAsset> listaActivos =[SELECT Id,InsurancePolicyId FROM InsurancePolicyAsset WHERE Id IN:listIds];
        for(InsurancePolicyAsset ac:listaActivos){
            for(String p:ids){
                ac.InsurancePolicyId=p;
            }
            
        }
        update listaActivos;
        
       
    }*/
    public static String obtenerCampos(DSALES_Endoso__c obj){
        polizaRequest objPost= new polizaRequest();
        objPost.Poliza=obj.DSALES_NuevaPoliza__c;
        objPost.insurance='zurich'; //se obtienen cuando se genera la autenticacion
        objPost.tracking_id='92f9db42-a675-46cd-b772-5f5afc775040';//se obtienen cuando se genera la autenticacion
        String str = JSON.serialize(objPost);
        return str;
        
    }
    
    //wrapper de campos para enviar a inter
    public class polizaRequest{
        public String Poliza {get; set;}
        public String insurance {get; set;}
        public String tracking_id {get; set;}
    }
    //respuesta de inter
    public class responsePoliza{
        public Integer code {get; set;}
        public Boolean success {get; set;}
        public datosPoliza data {get;set;}
    }
    //datos de la nueva poliza a mapear
    public class datosPoliza{
        public String policy_url {get;set;}
        public String policy_status {get;set;}
        public String policy_name {get;set;}
        public String policy_number {get;set;}
        public String policy_effectivedate {get;set;}
        public String policy_expirationdate {get;set;}
        public String policy_netpremium {get;set;}
        public String policy_totalpremium {get; set;}
        public String policy_shippingcosts {get;set;}
        public String policy_iva {get;set;}
        //public String policy_type {get;set;}
        
        
    }
}