public class DSALES_EndorsementCalls {
    public static void updateEndoso(){
        string query = 'SELECT Id, DSALES_NuevaPoliza__c,DSALES_Poliza__r.Name,DSALES_Folio__c, DSALES_SolucionDevolucion__c, DSALES_uid__c, DSALES_Estatus__c, DSALES_Valor__c, DSALES_MotivoDevolucion__c,DSALES_MotivoRechazo__c, DSALES_Poliza__c FROM DSALES_Endoso__c WHERE DSALES_Estatus__c = \'En tramite\'';
        List<DSALES_Endoso__c> consulta = DataBase.query(query);
        List<DSALES_Endoso__c> updateEndoso = new list<DSALES_Endoso__c>();
        List<InsurancePolicy> updatepoli = new list<InsurancePolicy>();
        List<Id> siniestriIds = new list<Id>();
        List<ContentVersion> documentos = new list<ContentVersion>(); 
        List<ContentDocumentLink> links = new list<ContentDocumentLink>(); 
        for(Integer i = 0; i < consulta.size(); i++){
            String body = DSALES_EndorsementController.ConsultarEndoso(consulta[i].DSALES_uid__c);
            if(body!= null){
                System.debug(body);
                DSALES_EndorsementWrapper.getResponse obj = (DSALES_EndorsementWrapper.getResponse)JSON.deserialize(body, DSALES_EndorsementWrapper.getResponse.class);
                if(consulta[i].DSALES_Estatus__c!=obj.Estatus){
                    consulta[i].DSALES_Estatus__c = obj.Estatus;
                    if(obj.Estatus== 'Autorizado'){
                        consulta[i].DSALES_NuevaPoliza__c = obj.NumeroPoliza;
                    }
                    if(obj.Estatus== 'Requerimiento de información'){
                        consulta[i].DSALES_MotivoDevolucion__c = obj.ComentarioEstatus;
                        consulta[i].DSALES_SolucionDevolucion__c = obj.ComentarioEstatus; 
                        documentos.add(DSALES_CreateDocument.CreaDocument(obj.Documentos[0].Documento,'Documento'));
                        siniestriIds.add(consulta[i].Id);
                    }
                    /*if(consulta[i].DSALES_Estatus__c == 'Autorizado'){
                        consulta[i].DSALES_NuevaPoliza__c = obj.NumeroPoliza;
                    }else{
                        if(consulta[i].DSALES_Estatus__c == 'Requerimiento de Información'){
                            consulta[i].DSALES_MotivoDevolucion__c = obj.ComentarioEstatus;
                            consulta[i].DSALES_SolucionDevolucion__c = obj.ComentarioEstatus;
                            documentos.add(DSALES_CreateDocument.CreaDocument(obj.Documentos[0].Documento,'Documento'));
                            siniestriIds.add(consulta[i].Id);
                        }
                    }*/
                    if(obj.Estatus== 'Rechazado'){
                        String poli = consulta[i].DSALES_Poliza__r.Name;
                        consulta[i].DSALES_MotivoRechazo__c = obj.ComentarioEstatus; 
                        InsurancePolicy updateEstatu = [SELECT Name, DSALES_Estatusdepliza__c FROM InsurancePolicy WHERE Name=:poli LIMIT 1];
                        updateEstatu.DSALES_Estatusdepliza__c = 'Cancelada';
                        updatepoli.add(updateEstatu);
                    }
                    
                }
            }
            else{
                System.debug('DSALES_EndorsementController.ConsultarEndoso Devuelve null');
            }          
        }
        update consulta;
        update updatepoli;
        insert documentos;
        for(Integer j=0; j<siniestriIds.size(); j++){
                links.add(DSALES_CreateDocument.Crealink(documentos[j], siniestriIds[j]));
                System.debug('Inserta Documentos correcto: ' + DSALES_CreateDocument.Crealink(documentos[j], siniestriIds[j]));
        }
        insert links;
     

    }

}