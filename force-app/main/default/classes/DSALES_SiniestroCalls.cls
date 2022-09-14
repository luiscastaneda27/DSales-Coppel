public class DSALES_SiniestroCalls {
    public static void updateSiniestro(){
        String query = 'SELECT Id, DSALES_Motivo_rechazo__c,DSALES_SiniestroUid__c,DSALES_Reporte__c,IncidentSiteStreet,IncidentSiteState,IncidentSiteCountry, ClaimType, CreatedDate, DSALES_Nombre_conductor__c, DSALES_Causa__c, DSALES_Descripcion__c, DSALES_Ano__c, DSALES_Marca__c, DSALES_Serie__c, InitiationDate, FinalizedDate, Cliente__r.Name, P_liza__r.Name, ClaimReason, DSALES_Estatus__c FROM Claim WHERE DSALES_Estatus__c = \'En trámite\'';
        List<Claim> consulta = DataBase.query(query);
        List<Claim> updateSiniestro = new list<Claim>();
        List<Id> siniestriIds = new list<Id>();
        List<ContentVersion> documentos = new list<ContentVersion>(); 
        List<ContentDocumentLink> links = new list<ContentDocumentLink>(); 
        for(Integer i = 0; i < consulta.size(); i++){
            String body = DSALES_SiniestroController.consultarSiniestro(consulta[i].DSALES_SiniestroUid__c);
            if(body!= null){
                DSALES_SiniestroWrapper.SiniestroGet obj = (DSALES_SiniestroWrapper.SiniestroGet)JSON.deserialize(body, DSALES_SiniestroWrapper.SiniestroGet.class);
                if(obj.Estatus == 'Abierto'){
                    obj.Estatus = 'En trámite';
                }
                if(obj.Estatus == 'En revisión'){
                    obj.Estatus = 'En trámite';
                }
                System.debug('::::::::::body de la consulta: '+ body);
                if(consulta[i].DSALES_Estatus__c!=obj.Estatus){
                    consulta[i].DSALES_Estatus__c = obj.Estatus;
                    if(obj.Estatus== 'Rechazado'){
                        consulta[i].DSALES_Motivo_rechazo__c = 'Pedir campo a proveedor';
                    }
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.Factura,'Factura'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.ContanciaBajaPlacas, 'ContanciaBajaPlacas'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.ComprobantesTenencia[0].Descripcion, 'Descripcion'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.ComprobantesTenencia[0].Comprobante, 'Comprobante'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.ComprobantesTenencia[0].IdComprobante, 'IdComprobante'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.CarpetaMP, 'CarpetaMP'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.AcreditacionMP, 'AcreditacionMP'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosVehiculo.OficioLiberacionRobo, 'OficioLiberacionRobo'));

                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.IdentificacionFrontal,'IdentificacionFrontal'));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.IdentificacionReverso,'IdentificacionReverso' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.ComprobanteDomicilio,'ComprobanteDomicilio' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.CURP,'CURP' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.PoderNotarial,'PoderNotarial' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.EncabezadoCuentaBancaria,'EncabezadoCuentaBancaria' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAsegurado.ConstanciaSituacionFiscal,'ConstanciaSituacionFiscal' ));

                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAseguradora.CartaConsentimientoCFDI,'CartaConsentimientoCFDI' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAseguradora.CartaConsentimientoCFDI,'CartaConsentimientoCFDI' ));
                    documentos.add(DSALES_CreateDocument.CreaDocument(obj.DocumentosAseguradora.FormatoFiniquito,'FormatoFiniquito' ));
                    siniestriIds.add(consulta[i].Id);
                    
                    //borrar depsues de prubeas
                    //consulta[i].DSALES_Estatus__c = 'En trámite';
                    
                }
            }else{
                System.debug('DSALES_EndorsementController.ConsultarEndoso Devuelve null');
            }          
        }
        update consulta;
        insert documentos;

        for(Integer j=0; j<siniestriIds.size(); j++){
            for(Integer k=j*18; k<18*j+18; k++){
                links.add(DSALES_CreateDocument.Crealink(documentos[k], siniestriIds[j]));
                System.debug('Inserta Documentos correcto: ' + DSALES_CreateDocument.Crealink(documentos[j], siniestriIds[j]));
            }
            

        }
        insert links;
    }
    
}