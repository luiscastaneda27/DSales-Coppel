public with sharing class DSALES_NuevaPoliza {
    public static final String NOMBRE_SERVICIO = 'DSALES_createPoliza';
    @future(callout=true)
    public static void invokeService(String idPoliza){
        String datos='SELECT Id,DSALES_Genero__c,DSALES_Codigopostal__c,DSALES_Codigoestado__c,DSALES_CorreoElectronico__c,DSALES_Activodeplizadeseguro__c,DSALES_Numeroseguimiento__c,SourceQuoteId,DSALES_Negocio__c,DSALES_Aseguradora__c,PlanTier,';
        String dats='DSALES_Estatusdepliza__c,Name,EffectiveDate,ExpirationDate,DSALES_Prima_Neta__c,DSALES_Prima_total__c,DSALES_Gastos_expedicion__c,DSALES_IVA__c,SourceOpportunityId,TotalSumInsured,DSALES_IDemision__c,DSALES_Servicio__c,DSALES_Uso__c,';
        String dat='DSALES_Telefono__c,DSALES_Codigomunicipio__c,DSALES_Codigocolonia__c,DSALES_Fechanacimiento__c,DSALES_Numeroserie__c,DSALES_Placas__c,DSALES_Modelo__c,NameInsuredId,DSALES_RFC__c,Fecha_de_emisi_n__c,CreatedDate,DSALES_Opcionpago__c,DSALES_Tipovehiculo__c,';
        String query =datos+ dats + dat + 'DSALES_PDF_poliza__c,DSALES_Polizaenviada__c FROM InsurancePolicy WHERE Id =:idPoliza';
        System.debug('Poliza:'+query);
        InsurancePolicy poliza = DataBase.query(query);
        if(service(poliza)!=null){
            System.debug('se actualiza la póliza');
            DSALES_GetPolicyPDF.sendPdf(poliza);
            update poliza;
        }else{
            System.debug('No se actualizarón los datos de la póliza');
        }
    
        
        
        
    }
    
    
    public static InsurancePolicy service(InsurancePolicy poliza){
        String body = obtenerCampos(poliza);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('responseGet: '+ response.getbody());
        System.debug('Estatus despues de enviar datos: '+ poliza.DSALES_Estatusdepliza__c);
        DSALES_PolizaWrapper.Application respuesta = (DSALES_PolizaWrapper.Application)JSON.deserialize(response.getbody(),DSALES_PolizaWrapper.Application.class);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
            if(respuesta.success == true){
                poliza.DSALES_IDemision__c=respuesta.data.payment_data.data.emission_id;
                poliza.DSALES_Numeroseguimiento__c=respuesta.data.payment_data.data.tracking_id;
                System.debug('Name data:'+respuesta.data.payment_data.data.policy_number);
                poliza.Name=respuesta.data.payment_data.data.policy_number;
                poliza.PolicyName =respuesta.data.payment_data.data.insured_data.policy;
                System.debug('Name:'+ poliza.Name);
                System.debug('Num:'+poliza.PolicyName);
                String fechaIni=respuesta.data.payment_data.data.insured_data.start_date;
                System.debug('fechaIni'+fechaIni);
                Date fInicio= date.valueOf(fechaIni);
                System.debug('fInicio'+fInicio);
                poliza.EffectiveDate = Datetime.newInstance(fInicio.year(),fInicio.month(),fInicio.day());
                String fechaFin=respuesta.data.payment_data.data.insured_data.end_date;
                System.debug('fechaFin'+fechaFin);
                Date endDate= date.valueOf(fechaFin);
                System.debug('endDate'+endDate);
                poliza.ExpirationDate=Datetime.newInstance(endDate.year(),endDate.month(),endDate.day());
                poliza.Fecha_de_emisi_n__c=Date.valueOf(respuesta.data.payment_data.data.insured_data.emission_date);
                System.debug('Fecha_de_emisi_n__c'+poliza.Fecha_de_emisi_n__c);
                poliza.TotalSumInsured =Decimal.valueOf(!String.isEmpty(respuesta.data.payment_data.data.insured_data.vehicle_summ) ? respuesta.data.payment_data.data.insured_data.vehicle_summ : '0');
                poliza.DSALES_Prima_Neta__c=Decimal.valueOf(!String.isEmpty(respuesta.data.payment_data.data.value_resume.net_premium) ? respuesta.data.payment_data.data.value_resume.net_premium  : '0');
                poliza.DSALES_Prima_total__c=Decimal.valueOf(!String.isEmpty(respuesta.data.payment_data.data.value_resume.total_premium) ? respuesta.data.payment_data.data.value_resume.total_premium : '0');
                poliza.DSALES_Gastos_expedicion__c=Decimal.valueOf(!String.isEmpty(respuesta.data.payment_data.data.value_resume.right) ? respuesta.data.payment_data.data.value_resume.right : '0');
                poliza.DSALES_IVA__c=Decimal.valueOf(!String.isEmpty(respuesta.data.payment_data.data.value_resume.tax) ? respuesta.data.payment_data.data.value_resume.tax : '0') ;
                poliza.DSALES_Estatusdepliza__c='Vigente';
                System.debug('Estatus despues de recibir respuesta: '+ poliza.DSALES_Estatusdepliza__c);
                //update poliza;
                System.debug('poliza Name:'+poliza.Name);
                String str = JSON.serialize(poliza);
        		
                
            }
            return poliza;
        }else{
            List<DSALES_PolizaWrapper.Errors> errores = respuesta.data.errors;
            System.debug('size: '+ errores.size());
            System.System.debug('error: '+errores[0].service.message);
            return null;

        }
    }


    public static String obtenerCampos(InsurancePolicy obj){
        Account cli =[SELECT Id, FirstName,LastName,Suffix,Fecha_de_Nacimiento__c FROM Account WHERE Id=:obj.NameInsuredId];
        DSALES_PolizaWrapper.polizaRequest objPost= new DSALES_PolizaWrapper.polizaRequest();
        objPost.tracking_id =obj.DSALES_Numeroseguimiento__c;
        objPost.quote_id=obj.SourceQuoteId;
        objPost.business=obj.DSALES_Negocio__c;
        objPost.insurance=obj.DSALES_Aseguradora__c;
        objPost.package_id=obj.PlanTier;
        objPost.payment_plan=obj.PlanTier;
        objPost.payment_option =obj.DSALES_Opcionpago__c;
        objPost.vehicle_id=obj.DSALES_Activodeplizadeseguro__c;
        objPost.vehicle_service=obj.DSALES_Servicio__c;
        objPost.vehicle_use=obj.DSALES_Uso__c;
        objPost.vehicle_vin=obj.DSALES_Numeroserie__c;
        objPost.vehicle_plate=obj.DSALES_Placas__c;
        objPost.vehicle_model=obj.DSALES_Modelo__c;
        objPost.contractor_first_name=cli.FirstName;
        objPost.contractor_lastname=cli.LastName;
        objPost.contractor_second_lastname=cli.Suffix;
        objPost.contractor_rfc=obj.DSALES_RFC__c;
        objPost.contractor_email=obj.DSALES_CorreoElectronico__c;
        objPost.emision_date=String.valueOf( obj.Fecha_de_emisi_n__c);
        objPost.start_at=String.valueOf(obj.CreatedDate);

        String str = JSON.serialize(objPost);
        return str;
        
    }
}