public with sharing class DSALES_IPServiceToEXE {
    public static final String NOMBRE_SERVICIO = 'DSALES_SendPdfToNVP';//DSALES_SendPdfToEXE
    public static Boolean service(InsurancePolicy poliza){
        String body = obtenerCampos(poliza);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('responseGet: '+ response.getbody());
        wrapperResponse respuesta = (wrapperResponse)JSON.deserialize(response.getbody(),wrapperResponse.class);
        if(respuesta.code == 200 || respuesta.code == 201 ){
            System.debug('Envió exitoso');
        }
        else{
            System.debug('No se realizó el envío: ');
            System.debug(respuesta.message);
        }
        return respuesta.success;
    }

    public static String obtenerCampos(InsurancePolicy poliza){
        wrapperRequest req = new wrapperRequest();
        req.policy_pdf=poliza.DSALES_PDF_poliza__c;
        String str = JSON.serialize(req);
        return str;
    }

    public class wrapperRequest{
        public String policy_pdf{get;set;}
    }

    public class wrapperResponse{
        public Integer code{get;set;}
        public Boolean success{get;set;}
        public String message{get;set;}
    }
}