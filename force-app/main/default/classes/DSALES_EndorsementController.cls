public with sharing class DSALES_EndorsementController {
    public static final String NOMBRE_SERVICIO = 'DSALES_CrearEndoso';
    public static final String NOMBRE_SERVICIO_GET = 'DSALES_ConsultarEndoso';
    @AuraEnabled
    public static Boolean crearEndoso(String idEndoso){
        Boolean consulta = false;
        String query = 'SELECT Id, DSALES_uid__c, DSALES_Tipodeendoso__c, DSALES_Poliza__r.Name, DSALES_Fechadecreacin__c,';
        query+='DSALES_MotivoDevolucion__c, DSALES_MotivoRechazo__c, DSALES_SolucionDevolucion__c,';
        query += 'DSALES_Estatus__c, DSALES_Tipodedocumento__c, DSALES_Tipodedato__c,DSALES_Valor__c FROM DSALES_Endoso__c WHERE Id = \'' + idEndoso +'\'';       
        
        DSALES_Endoso__c obj = DataBase.query(query);
        String body = obterCampos(obj);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        String method ='POST';
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('body de la consulta : '+ body);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
            DSALES_EndorsementWrapper.endorsementResponse respuesta = (DSALES_EndorsementWrapper.endorsementResponse) JSON.deserialize(response.getbody(), DSALES_EndorsementWrapper.endorsementResponse.class);
            if(respuesta.ok == 'true'){
                obj.DSALES_Estatus__c = 'En tramite';
                obj.DSALES_uid__c = respuesta.endoso.uid;
                update obj;
                consulta = true;
            }
        }
        return consulta;
    }

    public static string obterCampos(DSALES_Endoso__c obj){
        DSALES_EndorsementWrapper.endorsementRequest objpost= new DSALES_EndorsementWrapper.endorsementRequest();
        
        objpost.uid = obj.DSALES_uid__c;
        objpost.TipoEndoso = obj.DSALES_Tipodeendoso__c;
        objpost.NumeroPoliza = obj.DSALES_Poliza__r.Name;
        objpost.FechaEndoso = obj.DSALES_Fechadecreacin__c;
        objpost.Estatus = obj.DSALES_Estatus__c;
        objpost.salesforceid = obj.Id;
       
        objpost.Documentos = new DSALES_EndorsementWrapper.documento();
        //objpost.Documentos.IdDocumento = ;
        objpost.Documentos.TipoDocumento = obj.DSALES_Tipodedocumento__c;
        objpost.Documentos.Documento = obj.DSALES_Tipodedocumento__c;
        
        
        objpost.Datos = new DSALES_EndorsementWrapper.dato();
        //objpost.Datos.IdDato =;
        objpost.Datos.TipoDato = obj.DSALES_Tipodedato__c;
        objpost.Datos.Valor = obj.DSALES_Valor__c;
        
        String str = JSON.serialize(objpost);
        return str;
    }
    
    public static String ConsultarEndoso(String uid){      
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO_GET);
        endpoint+= '/' + uid;
        System.debug('Llamaa a::::: '+endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            system.debug('Codigo de Estatus regresado: ' + response.getStatusCode());
            return response.getBody();
        }else{
            System.debug(response.getBody());
            return null;
                
        }
       
    }

    @AuraEnabled
    public static Integer validarDoc(String  idObject){
        List<ContentDocumentLink > docs=[SELECT ContentDocumentId,ContentDocument.title,Id,LinkedEntityId,ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:idObject];
        return docs.size();
    }

}