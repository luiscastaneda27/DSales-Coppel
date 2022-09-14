public class DSALES_SiniestroController {
    public static final String NOMBRE_SERVICIO = 'DSALES_ConsultarSiniestro'; 
    public static final String NOMBRE_SERVICIO2 = 'DSALES_ActualizaSiniestro';
    public static final String NOMBRE_SERVICIO3 = 'DSALES_EnviarSiniestro';
    @AuraEnabled
    public static String Siniestro(String idSiniestro){
        String cuerpo='no hizo consulta';
        String query = 'SELECT Id, Name, DSALES_SiniestroUid__c,DSALES_Reporte__c,IncidentSiteStreet,IncidentSiteState,IncidentSiteCountry, ClaimType, CreatedDate, DSALES_Nombre_conductor__c, DSALES_Causa__c, DSALES_Descripcion__c, DSALES_Ano__c, DSALES_Marca__c, DSALES_Serie__c, InitiationDate, FinalizedDate, Cliente__r.Name, P_liza__r.Name, ClaimReason, DSALES_Estatus__c FROM Claim WHERE Id = \'' + idSiniestro +'\'';       
        Claim obj = DataBase.query(query);
        if(obj.DSALES_Estatus__c != 'Nuevo'){
            cuerpo = actualizaSiniestro(obj);
        }
        else{
            cuerpo = crearSiniestro(obj);
        }  
        return cuerpo;  

    }
    public static String crearSiniestro(Claim obj){
        //String query = 'SELECT Id, Name, DSALES_SiniestroUid__c,DSALES_Reporte__c,IncidentSiteStreet,IncidentSiteState,IncidentSiteCountry, ClaimType, CreatedDate, DSALES_Nombre_conductor__c, DSALES_Causa__c, DSALES_Descripcion__c, DSALES_Ano__c, DSALES_Marca__c, DSALES_Serie__c, InitiationDate, FinalizedDate, Cliente__r.Name, P_liza__r.Name, ClaimReason, DSALES_Estatus__c FROM Claim WHERE Id = \'' + idSiniestro +'\'';       
        //Claim obj = DataBase.query(query);
        String body = obterCampos(obj);
        System.debug('Campos se envian: '+ body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO3);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
            DSALES_SiniestroWrapper.siniestroPostResponse respuesta = (DSALES_SiniestroWrapper.siniestroPostResponse) JSON.deserialize(response.getbody(), DSALES_SiniestroWrapper.siniestroPostResponse.class);
            if(respuesta.ok == 'true'){
                obj.DSALES_Estatus__c = 'En trámite';
                obj.DSALES_SiniestroUid__c = respuesta.siniestro.uid;
                obj.Name = respuesta.siniestro.NumeroSiniestro;
                update obj;
            }
            return response.getBody();      
        }else{
            System.debug('___Fallo____: comuncacion: ' + response.getBody());
            return null;
        }       
    }

    public static String obterCampos(Claim obj){
        DSALES_SiniestroWrapper.siniestroCallPost objpost= new DSALES_SiniestroWrapper.siniestroCallPost();   
        objpost.uid = null;
        objpost.Reporte = String.valueOf(obj.DSALES_Reporte__c);
        objpost.NumeroSiniestro = null;
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
        if(obj.DSALES_Estatus__c =='Nuevo'){
            objpost.Estatus='Abierto';
        }
        objpost.salesforceid  = obj.Id;
        String str = JSON.serialize(objpost);
        return str;
    }

    public static String consultarSiniestro(String uid){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        endpoint+= '/' + uid;
        request.setEndpoint(endpoint);
        system.debug('End point al llamdo:::===== '+endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            system.debug('Codigo de Estatus regresado: ' + response.getStatusCode());
            return response.getBody();
        }else{
            system.debug('Codigo diferen a 200,201');
            System.debug(response.getBody());
            return null;       
        }
    }
    public static String actualizaSiniestro(Claim obj){
        //String query = 'SELECT Id, Name ,DSALES_SiniestroUid__c, DSALES_Reporte__c,IncidentSiteStreet,IncidentSiteState,IncidentSiteCountry, ClaimType, CreatedDate, DSALES_Nombre_conductor__c, DSALES_Causa__c, DSALES_Descripcion__c, DSALES_Ano__c, DSALES_Marca__c, DSALES_Serie__c, InitiationDate, FinalizedDate, Cliente__r.Name, P_liza__r.Name, ClaimReason, DSALES_Estatus__c FROM Claim WHERE Id = \'' + idSiniestro +'\'';       
        //Claim obj = DataBase.query(query);
        String body = obterCamposPut(obj);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO2);
        request.setEndpoint(endpoint);
        request.setMethod('PUT');
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('Campos otenidos: ' +  body);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
            DSALES_SiniestroWrapper.siniestroPostResponse respuesta = (DSALES_SiniestroWrapper.siniestroPostResponse) JSON.deserialize(response.getbody(), DSALES_SiniestroWrapper.siniestroPostResponse.class);
            if(respuesta.ok == 'true'){
                obj.DSALES_SiniestroUid__c = respuesta.siniestro.uid;
                obj.Name = respuesta.siniestro.NumeroSiniestro;
                update obj;
            }
            return response.getBody();      
        }else{
            System.debug('Fallo no es codigo 200 o 201 ' + response.getBody());
            return null;
        }       
    }

    public static String obterCamposPut(Claim obj){
        DSALES_SiniestroWrapper.SiniestroPut objpost= new DSALES_SiniestroWrapper.SiniestroPut();   
        objpost.uid = obj.DSALES_SiniestroUid__c;
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
        objpost.DocumentosVehiculo.Factura = DSALES_GetDocumentBody.blodBody(obj.Id, 'Factura');
        objpost.DocumentosVehiculo.ContanciaBajaPlacas = DSALES_GetDocumentBody.blodBody(obj.Id, 'ContanciaBajaPlacas');
        objpost.DocumentosVehiculo.ComprobantesTenencia = new list<DSALES_SiniestroWrapper.comprobantesTenencia>();
        DSALES_SiniestroWrapper.comprobantesTenencia aux = new DSALES_SiniestroWrapper.comprobantesTenencia();
        aux.Descripcion = DSALES_GetDocumentBody.blodBody(obj.Id, 'Descripcion');
        aux.Comprobante = DSALES_GetDocumentBody.blodBody(obj.Id, 'Comprobante');
        aux.IdComprobante = DSALES_GetDocumentBody.blodBody(obj.Id, 'IdComprobante');
        objpost.DocumentosVehiculo.ComprobantesTenencia.add(aux);

        objpost.DocumentosVehiculo.CarpetaMP = DSALES_GetDocumentBody.blodBody(obj.Id, 'CarpetaMP');
        objpost.DocumentosVehiculo.AcreditacionMP = DSALES_GetDocumentBody.blodBody(obj.Id, 'AcreditacionMP');
        objpost.DocumentosVehiculo.OficioLiberacionRobo = DSALES_GetDocumentBody.blodBody(obj.Id, 'OficioLiberacionRobo');

        objpost.DocumentosAsegurado = new DSALES_SiniestroWrapper.documentosAsegurado();
        objpost.DocumentosAsegurado.IdentificacionFrontal = DSALES_GetDocumentBody.blodBody(obj.Id, 'IdentificacionFrontal');
        objpost.DocumentosAsegurado.IdentificacionReverso = DSALES_GetDocumentBody.blodBody(obj.Id, 'IdentificacionReverso');
        objpost.DocumentosAsegurado.ComprobanteDomicilio = DSALES_GetDocumentBody.blodBody(obj.Id, 'ComprobanteDomicilio');
        objpost.DocumentosAsegurado.CURP = DSALES_GetDocumentBody.blodBody(obj.Id, 'CURP');
        objpost.DocumentosAsegurado.EncabezadoCuentaBancaria = DSALES_GetDocumentBody.blodBody(obj.Id, 'EncabezadoCuentaBancaria');
        objpost.DocumentosAsegurado.PoderNotarial = DSALES_GetDocumentBody.blodBody(obj.Id, 'PoderNotarial');
        objpost.DocumentosAsegurado.EncabezadoCuentaBancaria = DSALES_GetDocumentBody.blodBody(obj.Id, 'EncabezadoCuentaBancaria');
        objpost.DocumentosAsegurado.ConstanciaSituacionFiscal = DSALES_GetDocumentBody.blodBody(obj.Id, 'ConstanciaSituacionFiscal');

        objpost.DocumentosAseguradora = new DSALES_SiniestroWrapper.documentosAseguradora();
        objpost.DocumentosAseguradora.CartaConsentimientoCFDI = DSALES_GetDocumentBody.blodBody(obj.Id, 'CartaConsentimientoCFDI');
        objpost.DocumentosAseguradora.FormatoCompraVenta = DSALES_GetDocumentBody.blodBody(obj.Id, 'FormatoCompraVenta');
        objpost.DocumentosAseguradora.FormatoFiniquito = DSALES_GetDocumentBody.blodBody(obj.Id, 'FormatoFiniquito');
        
        objpost.salesforceid  = obj.Id;
        String str = JSON.serialize(objpost);
        return str;
    }

}