public with sharing class DSALES_SiniestrosHelper {
    public static final String NOMBRE_SERVICIO = 'DSALES_ActualizarEstadoSiniestro';
    
    @future(callout=true)
    public static void actualizarDatos(String jsonString){//recibo datos de pago
        List<ClaimPaymentSummary> listPagos = (List<ClaimPaymentSummary>) JSON.deserialize(jsonString, List<ClaimPaymentSummary>.class);
        List<String> siniestrosId = new List<String>();
        List<String> polizasId = new List<String>();
        for(ClaimPaymentSummary pagos:listPagos){ 
            siniestrosId.add(pagos.ClaimId);
            polizasId.add(pagos.Claim.PolicyNumberId);
       	}
         
        //se actualiza el siniestro a Pagado
       	String query = 'SELECT Id, Name,PolicyNumberId,P_liza__c, DSALES_SiniestroUid__c,DSALES_Reporte__c,IncidentSiteStreet,IncidentSiteState,IncidentSiteCountry, ClaimType, CreatedDate, DSALES_Nombre_conductor__c, DSALES_Causa__c, DSALES_Descripcion__c, DSALES_Ano__c, DSALES_Marca__c, DSALES_Serie__c, InitiationDate, FinalizedDate, Cliente__r.Name, P_liza__r.Name, ClaimReason, DSALES_Estatus__c FROM Claim WHERE Id IN:siniestrosId';       
        List<Claim> objList = DataBase.query(query);
        List<String> sss= new List<String>();
        for(Claim c:objList){
            sss.add(c.PolicyNumberId);
        }
        List<InsurancePolicy> listToUpdatePoliza = [SELECT Id,ChangeSubtype,DSALES_Estatusdepliza__c,DSALES_Activodeplizadeseguro__c FROM InsurancePolicy WHERE Id IN:sss]; 
       	System.debug('listToUpdatePoliza size:'+listToUpdatePoliza.size());
        if(listToUpdatePoliza.size()>0){ 
            for(InsurancePolicy p: listToUpdatePoliza){
                p.ChangeSubtype='Siniestrada';
                p.DSALES_Estatusdepliza__c='Cancelada';
                //p.DSALES_Activodeplizadeseguro__c=null;
                System.debug('se asignaron los datos');
            }
        }
        
        List<Claim> listToUpdate = new List<Claim>();
        if(objList.size()>0){
        	for(Claim s:objList){
                String body = obterCamposPut(s);
                System.debug('obtenerCamposPut:'+body);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
                request.setEndpoint(endpoint);
                request.setMethod('PUT');
                request.setBody(body);
                HttpResponse response = http.send(request);
                System.debug('Campos otenidos: ' +  body);
                System.debug('code:'+response.getStatusCode());
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                    System.debug('se cumple el estatus');
                    DSALES_SiniestroWrapper.siniestroPostResponse respuesta = (DSALES_SiniestroWrapper.siniestroPostResponse) JSON.deserialize(response.getbody(), DSALES_SiniestroWrapper.siniestroPostResponse.class);
                    if(respuesta.ok == 'true'){
                        s.DSALES_SiniestroUid__c = respuesta.siniestro.uid;
                        s.Name = respuesta.siniestro.NumeroSiniestro;
                        s.DSALES_Estatus__c='Pagado';
                        System.debug('se asignan estado a siniestro');
                        System.debug('estado de siniestro:'+s.DSALES_Estatus__c);
                            listToUpdate.add(s);
                        //update s;
                    }
                          
                }else{
                    System.debug('Fallo no es codigo 200 o 201 ' + response.getBody());
                    
                }       
            }
        }
       	
        update listToUpdatePoliza;
        update listToUpdate;
    }
    
    public static List<String> getDocumentos(Claim obj){
        List<ContentDocumentLink> documentos =[SELECT ContentDocumentId,ContentDocument.title,Id,LinkedEntityId,ShareType 
                                               FROM ContentDocumentLink WHERE LinkedEntityId =:obj.Id];
        System.debug('size document:'+documentos.size());
        List<String> listName = new List<String>();
        for(ContentDocumentLink doc:documentos){
            System.debug('nombre:'+doc.ContentDocument.title);
            listName.add(doc.ContentDocument.title);
        }
        return listName;
    }
    
    //mandar campos a inter
    public static String obterCamposPut(Claim obj){
        
        DSALES_SiniestroWrapper.SiniestroPut objpost= new DSALES_SiniestroWrapper.SiniestroPut();   
        objpost.uid =obj.DSALES_SiniestroUid__c;
        objpost.Reporte = String.valueOf(obj.DSALES_Reporte__c);
        objpost.NumeroSiniestro = obj.Name;
        objpost.TipoSiniestro = obj.ClaimType;
        objpost.FechaSiniestro = String.ValueofGmt(obj.CreatedDate);
        objpost.NombreConductor = obj.DSALES_Nombre_conductor__c;
        objpost.Causa = obj.DSALES_Causa__c;
       
        objpost.Vehiculo = new DSALES_SiniestroWrapper.vehiculo();
        objpost.Vehiculo.Descripcion = obj.DSALES_Descripcion__c;
        objpost.Vehiculo.Anio = obj.DSALES_Ano__c;
        objpost.Vehiculo.Placa = obj.DSALES_Marca__c;
        objpost.Vehiculo.Serie = obj.DSALES_Serie__c;
        
        objpost.Poliza = new DSALES_SiniestroWrapper.poliza();
        objpost.Poliza.NumeroPoliza = obj.P_liza__r.Name;
        objpost.Poliza.Inciso = '001';
        objpost.Poliza.FechaInicioVigencia = String.ValueofGmt(obj.InitiationDate);
        objpost.Poliza.FechaFinVigencia = String.ValueofGmt(obj.FinalizedDate);
        objpost.Poliza.NombreAsegurado = obj.Cliente__r.Name;
        
        objpost.ComoOcurrio = obj.ClaimReason;
        objpost.Ubicacion  = obj.IncidentSiteStreet;
        objpost.Municipio  = obj.IncidentSiteCountry;
        objpost.Estado  = obj.IncidentSiteState;
        objpost.Estatus  = obj.DSALES_Estatus__c;
        objpost.DocumentosVehiculo = new DSALES_SiniestroWrapper.documentosVehiculo();
        objpost.DocumentosVehiculo.ComprobantesTenencia = new list<DSALES_SiniestroWrapper.comprobantesTenencia>();
        objpost.DocumentosAsegurado = new DSALES_SiniestroWrapper.documentosAsegurado();
        objpost.DocumentosAseguradora = new DSALES_SiniestroWrapper.documentosAseguradora();
       	objpost.DocumentosVehiculo.Factura=getDocument(obj.Id,'Factura');
        objpost.DocumentosVehiculo.ContanciaBajaPlacas=getDocument(obj.Id,'ContanciaBajaPlacas');
        for(DSALES_SiniestroWrapper.comprobantesTenencia comp:objpost.DocumentosVehiculo.ComprobantesTenencia){
            System.debug('entra al for de tenencia'); 
            comp.Descripcion=getDocument(obj.Id,'Descripcion');
            comp.Comprobante=getDocument(obj.Id,'Comprobante');
          	comp.IdComprobante=getDocument(obj.Id,'IdComprobante');
        }
        objpost.DocumentosVehiculo.CarpetaMP=getDocument(obj.Id,'CarpetaMP');
        objpost.DocumentosVehiculo.AcreditacionMP =getDocument(obj.Id,'AcreditacionMP');
        objpost.DocumentosVehiculo.OficioLiberacionRobo=getDocument(obj.Id,'OficioLiberacionRobo');
        objpost.DocumentosAsegurado.IdentificacionFrontal =getDocument(obj.Id,'IdentificacionFrontal');
        objpost.DocumentosAsegurado.IdentificacionReverso=getDocument(obj.Id,'IdentificacionReverso');
        objpost.DocumentosAsegurado.ComprobanteDomicilio=getDocument(obj.Id,'ComprobanteDomicilio');
        objpost.DocumentosAsegurado.CURP=getDocument(obj.Id,'CURP');
        System.debug('curp:'+objpost.DocumentosAsegurado.CURP);
        objpost.DocumentosAsegurado.EncabezadoCuentaBancaria=getDocument(obj.Id,'EncabezadoCuentaBancaria');
		objpost.DocumentosAsegurado.PoderNotarial=getDocument(obj.Id,'PoderNotarial');
        objpost.DocumentosAsegurado.ConstanciaSituacionFiscal=getDocument(obj.Id,'ConstanciaSituacionFiscal');
        objpost.DocumentosAseguradora.CartaConsentimientoCFDI=getDocument(obj.Id,'CartaConsentimientoCFDI');
		objpost.DocumentosAseguradora.FormatoCompraVenta=getDocument(obj.Id,'FormatoCompraVenta');
        objpost.DocumentosAseguradora.FormatoFiniquito=getDocument(obj.Id,'FormatoFiniquito');
        System.debug('formato finiquito:'+objpost.DocumentosAseguradora.FormatoFiniquito);
        objpost.salesforceid  = obj.Id;
        String str = JSON.serialize(objpost);
        return str;
    }
    public static String getDocument(String idSiniestro, String archivo) {
        String query = 'SELECT ContentDocumentId,ContentDocument.title,ContentDocument.FileType,Id,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:idSiniestro AND ContentDocument.title =:archivo' ;
        List<ContentDocumentLink> docList = DataBase.query(query);
        String documento=null;
        if(docList.size()>0){
            for(ContentDocumentLink d:docList){
                ContentVersion contVersion = [SELECT ContentDocumentId, VersionData FROM ContentVersion where ContentDocumentId =:d.ContentDocumentId];
                documento = EncodingUtil.base64Encode(contVersion.VersionData);
        	}
			
        }
              
        return documento;
    }

}