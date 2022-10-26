public with sharing class DSALES_GetPolicyPDF {

    public static final String NOMBRE_SERVICIO = 'DSALES_GetPolicyPDF';
    public static void sendPdf(InsurancePolicy poliza){
        DSALES_InformacionDePago__c pago=[SELECT Id,DSALES_Motoentregada__c,DSALES_Motoexterna__c FROM DSALES_InformacionDePago__c WHERE DSALES_Poliza__c=:poliza.Id];
        poliza.DSALES_PDF_poliza__c=service(poliza);
        if(pago.DSALES_Motoexterna__c==true && pago.DSALES_Motoentregada__c==false){
            if(DSALES_IPServiceToNPV.service(poliza)==true){
                System.debug('Envío de url a NPV');
                poliza.DSALES_Polizaenviada__c=true;
            }
            else{
                System.debug('No se realizó el envio');
            }
        }
        if(pago.DSALES_Motoentregada__c==true && pago.DSALES_Motoexterna__c==false){
            if(DSALES_IPServiceToEXE.service(poliza)==true){
             	System.debug('Envío de url a .EXE');
           		poliza.DSALES_Polizaenviada__c=true;   
            }
            else{
                System.debug('No se realizó el envio a .EXE');
            }
            
        }
        
    }
    public static String  service(InsurancePolicy poliza){
        String pdf=null;
        String body = obtenerCampos(poliza);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('responseGet: '+ response.getbody());
        DSALES_GetPolicyPdfWrapper.responseWrapper respuesta = (DSALES_GetPolicyPdfWrapper.responseWrapper)JSON.deserialize(response.getbody(),DSALES_GetPolicyPdfWrapper.responseWrapper.class);
        if(respuesta.code == 200 || respuesta.code == 201 ){
            if(respuesta.success == true){
                pdf=respuesta.data.policy_url;
                System.debug('url pdf: '+pdf);
                
            }
            
        }
        else{
            List<DSALES_GetPolicyPdfWrapper.Errors> errores = respuesta.data.errors;
            System.debug('error'+ errores);
        }
        return pdf;
    }

    public static String obtenerCampos(InsurancePolicy poliza){
        DSALES_GetPolicyPdfWrapper.requestWrapper req= new DSALES_GetPolicyPdfWrapper.requestWrapper();
        req.tracking_id=poliza.DSALES_Numeroseguimiento__c;
        req.business=poliza.DSALES_Negocio__c;
        req.insurance=poliza.DSALES_Aseguradora__c;
        req.Poliza=poliza.Name;
        String str = JSON.serialize(poliza);
        return str;
    }

}