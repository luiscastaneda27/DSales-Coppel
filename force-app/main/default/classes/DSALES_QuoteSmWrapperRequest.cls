@RestResource(urlMapping='/insertQuoteSM/*')
global class DSALES_QuoteSmWrapperRequest {
    public static final String NOMBRE_SERVICIO = 'DSALES_QuoteSM';
    public static final String coberturaRc = 'RC'; 
    public static final String coberturaPlus = 'PLUS'; 
    @HttpPost
    global static DSALES_QuoteSmWrapper.RespuestaParaNpv createQuoteSM(){
        String numeroCliente = DSALES_Utility.NUMERO_CLIENTE_GENERICO;
        String message = '';
        Account client = new Account();
        Opportunity oppor = new Opportunity();
        Quote cotiza = new Quote();
        DSALES_QuoteSmWrapper.QuoteSmRequest data = new DSALES_QuoteSmWrapper.QuoteSmRequest();
        DSALES_QuoteSmWrapper.respuestaDelProveedor respuestaDeProveedor = new DSALES_QuoteSmWrapper.respuestaDelProveedor();
        DSALES_QuoteSmWrapper.respuestaDelProveedor respuestaDeProveedor2 = new DSALES_QuoteSmWrapper.respuestaDelProveedor();
        DSALES_ListaNegraWrapper.responseListaNegra respuestaListaNegra = new DSALES_ListaNegraWrapper.responseListaNegra();
        Boolean listaNegra = false;
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            if(String.isNotBlank(body)){
                String rc = 'RC Seguro de Moto';
                String amp = 'AMP Seguro de Moto';
                try{
                    data = (DSALES_QuoteSmWrapper.QuoteSmRequest)JSON.deserialize(body, DSALES_QuoteSmWrapper.QuoteSmRequest.class);
                    String nombreCompleto=data.first_name;
                    if(data.middle_name!=null){
                        nombreCompleto += ' ' +data.middle_name;  
                      }
                      nombreCompleto += ' ' +data.last_name; 
                      if(data.suffix!=null){
                        nombreCompleto += ' ' +data.suffix;  
                      } 
                    String rfc = DSALES_ConsultaListaNegra.getRFC(data.first_name, data.middle_name, data.last_name, data.suffix, data.contact_birth_date);
                    respuestaListaNegra = DSALES_ConsultaListaNegra.callWebService(rfc, nombreCompleto);
                    System.debug('respuesta de la lista negra:  '+respuestaListaNegra);
                    if(respuestaListaNegra.estatus =='true'){
                        listaNegra = true;
                        message = 'Esta en la Lista negra';
                    }
                }catch(Exception e){
                    message = 'Error Lista Negra: ' + e.getMessage() +' '+e.getLineNumber();
                }
                try{
                    DSALES_QuoteSmWrapper.QuotePostProvedor datosEnviar = new DSALES_QuoteSmWrapper.QuotePostProvedor();
                    datosEnviar.business = Label.DSALES_business;
                    datosEnviar.insurance = Label.DSALES_NombreAseguradora; //sales-fijo
                    datosEnviar.contact_name = data.first_name + data.last_name;//combinacion
                    datosEnviar.contact_method = Label.DSALES_ContactMethod;//sales-fijo
                    datosEnviar.contact_phone = data.contact_phone;
                    datosEnviar.contact_email = data.contact_email;
                    datosEnviar.contact_gender = data.contact_gender;
                    datosEnviar.contact_birth_date = data.contact_birth_date.format();
                    datosEnviar.contact_state_code = data.contact_state_code;
                    datosEnviar.contact_township_code = data.contact_township_code;
                    datosEnviar.contact_suburb_code = data.contact_suburb_code;
                    datosEnviar.contact_zip_code = data.contact_zip_code;
                    datosEnviar.contact_now = true;//fijo-sales
                    datosEnviar.vehicle_id = data.vehicle_id;
                    datosEnviar.vehicle_service = Label.DSALES_vehicleService;//fijo-sales
                    datosEnviar.vehicle_use = Label.DSALES_vehicleUse;//fijo-sales
                    datosEnviar.vehicle_type=Label.DSALES_vehicleType;//fijo-sales
                    datosEnviar.payment_option = data.payment_option;
                    datosEnviar.packagge = coberturaRc;
                    datosEnviar.promotion_code='No definido';//fijo
                    datosEnviar.associate_id='No definido';//fijo
                    date aux = date.today();
                    aux = date.newInstance(aux.year(), aux.month(), aux.day());
                    datosEnviar.quote_date = aux.format(); //cotiza.DSALES_Fechadecreacionpresupuesto__c.format();//fecha creacion-sales
                    datosEnviar.start_at = data.start_at.format();
                    if(!listaNegra){
                        respuestaDeProveedor = crearQuoteSm(datosEnviar);
                        datosEnviar.packagge = coberturaPlus;
                        respuestaDeProveedor2 = crearQuoteSm(datosEnviar);
                    }
        
                }catch(Exception e){
                    message = 'Error: ' + e.getMessage() +' '+e.getLineNumber();
                }
                try{
                    //data = (DSALES_QuoteSmWrapper.QuoteSmRequest)JSON.deserialize(body, DSALES_QuoteSmWrapper.QuoteSmRequest.class);
                    Account UniversalAccount = [Select Id from Account WHERE DSALES_ClienteCoppel__c = :numeroCliente LIMIT 1];
                    Tienda__c tienda = [Select Id from Tienda__c WHERE DSales_TiendaID__c =: data.store_id LIMIT 1];
                    Id ClienteId=null; 
                    if(data.client_number == null || data.client_number=='' ||data.client_number==numeroCliente ){
                        List<Account> resul = [Select Id, FirstName, MiddleName, LastName, Fecha_de_Nacimiento__c, Phone, PersonEmail from Account WHERE FirstName=:data.first_name AND MiddleName=:data.middle_name AND LastName=:data.last_name];
                        if(resul.size() == 1){
                            ClienteId = resul[0].Id;
                            oppor = creaOportunidad(data, ClienteId, resul[0].FirstName, resul[0].MiddleName, resul[0].LastName,tienda);
                            cotiza = crearCotizacion(data, oppor.Id, resul[0].FirstName,  resul[0].MiddleName, resul[0].LastName, tienda,listaNegra, respuestaDeProveedor, rc, coberturaRc);
                            cotiza = crearCotizacion(data, oppor.Id, resul[0].FirstName,  resul[0].MiddleName, resul[0].LastName, tienda,listaNegra, respuestaDeProveedor2, amp, coberturaPlus);
                        }
                        else{
                            Boolean SinCoincidenciaCuenta = true;
                            if(resul.size() > 1){                
                                for(Account CuentaSimilare: resul){
                                    if(CuentaSimilare.PersonEmail == data.contact_email || CuentaSimilare.Phone == data.contact_phone){
                                        ClienteId = CuentaSimilare.Id;
                                        SinCoincidenciaCuenta = false;
                                        oppor = creaOportunidad(data, ClienteId, data.first_name, data.middle_name, data.last_name, tienda);
                                        cotiza = crearCotizacion(data, oppor.Id, data.first_name, data.middle_name, data.last_name, tienda,listaNegra, respuestaDeProveedor, rc, coberturaRc);
                                        cotiza = crearCotizacion(data, oppor.Id, data.first_name, data.middle_name, data.last_name, tienda,listaNegra, respuestaDeProveedor2, amp, coberturaPlus);
                                        break;
                                    }
                                }                         
                            }
                            if(resul.size() == 0 || SinCoincidenciaCuenta==true){
                                ClienteId = UniversalAccount.Id; 
                                oppor = creaOportunidad(data, ClienteId, data.first_name, data.middle_name, data.last_name, tienda);
                                cotiza = crearCotizacion(data, oppor.Id, data.first_name, data.middle_name, data.last_name, tienda,listaNegra, respuestaDeProveedor, rc, coberturaRc);
                                cotiza = crearCotizacion(data, oppor.Id, data.first_name, data.middle_name, data.last_name, tienda,listaNegra, respuestaDeProveedor2, amp,coberturaPlus);
                            }
                        }     
                    }else{
                            List<Account> result = [Select Id,FirstName,MiddleName,LastName from Account WHERE CP_WalletCustomerNumber__c =:Decimal.valueOf(data.client_number)];
                            if(result.size() == 0){
                                client = creaCliente(data);
                                ClienteId = client.Id;
                                oppor = creaOportunidad(data, ClienteId, data.first_name, data.middle_name, data.last_name,tienda);
                                cotiza = crearCotizacion(data, oppor.Id, client.FirstName,  client.MiddleName, client.LastName, tienda,listaNegra, respuestaDeProveedor, rc, coberturaRc);
                                cotiza = crearCotizacion(data, oppor.Id, client.FirstName,  client.MiddleName, client.LastName, tienda,listaNegra, respuestaDeProveedor2, amp, coberturaPlus);
                            }else{
                                ClienteId = result[0].Id;
                                oppor = creaOportunidad(data, ClienteId, result[0].FirstName, result[0].MiddleName, result[0].LastName,tienda);
                                cotiza = crearCotizacion(data, oppor.Id, result[0].FirstName,  result[0].MiddleName, result[0].LastName, tienda,listaNegra, respuestaDeProveedor, rc, coberturaRc);
                                cotiza = crearCotizacion(data, oppor.Id, result[0].FirstName,  result[0].MiddleName, result[0].LastName, tienda,listaNegra, respuestaDeProveedor2, amp, coberturaPlus);
                            }       
                    }
                    //llma a inter cotizar
                }catch(Exception e){
                    message = 'Error: ' + e.getMessage() +' '+e.getLineNumber();
                }
            }
        }
        //llama a inter con datos
        
        
        DSALES_QuoteSmWrapper.RespuestaParaNpv response = new DSALES_QuoteSmWrapper.RespuestaParaNpv();
        response.quoteId = 'test';
        response.message =  message;
        response.Cliente = 'Cliente: '+client.Id;
        response.oppor = 'Oport: '+oppor.Id;
        response.cotiza = 'mensaje: '+ data.contact_email;
        response.rc = new DSALES_QuoteSmWrapper.Receipt();
        response.amp = new DSALES_QuoteSmWrapper.Receipt();
        if(!listaNegra && (respuestaListaNegra!= null) && (respuestaDeProveedor!= null) && (respuestaDeProveedor2!= null)){
            System.debug('Respuesta Proveedor____: ' + respuestaDeProveedor.data.receipts[0]);
            response.rc = respuestaDeProveedor.data.receipts[0];
            response.amp = respuestaDeProveedor2.data.receipts[0];
        }
        return response;
    }

    public static DSALES_QuoteSmWrapper.respuestaDelProveedor crearQuoteSm(DSALES_QuoteSmWrapper.QuotePostProvedor obj){
        String body = JSON.serialize(obj);
        System.debug('Campos se envian: '+ body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
            DSALES_QuoteSmWrapper.respuestaDelProveedor respuesta = (DSALES_QuoteSmWrapper.respuestaDelProveedor) JSON.deserialize(response.getbody(), DSALES_QuoteSmWrapper.respuestaDelProveedor.class);
            return respuesta;     
        }else{
            System.debug('___Fallo____: comuncacion: ' + response.getBody());
            return null;
        }       
    }

    public static Account creaCliente (DSALES_QuoteSmWrapper.QuoteSmRequest data){
        Account cliente = new Account();
        cliente.CP_WalletCustomerNumber__c = Decimal.valueOf(data.client_number);
        cliente.FirstName = data.first_name;
        cliente.MiddleName = data.middle_name;
        cliente.LastName = data.last_name;
        cliente.Suffix = data.suffix;
        cliente.PersonBirthdate = data.contact_birth_date;
        cliente.PersonEmail = data.contact_email;
        cliente.AccountNumber = data.client_number;
        cliente.PersonMobilePhone = data.contact_phone;
        insert cliente;
        return cliente;
    }

    public static Opportunity creaOportunidad (DSALES_QuoteSmWrapper.QuoteSmRequest data, Id clienteId, String FirstName,String MiddleName, String LastName,Tienda__c tienda){
        Opportunity oppor = new Opportunity();
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Seguro de Moto').getRecordTypeId();
        Pricebook2 precioLista = [SELECT id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
        oppor.AccountId = clienteId;
        oppor.Name = FirstName;
        if(MiddleName != null ){
            oppor.Name+=' ' +MiddleName+' '+LastName;
        }else{
            oppor.Name+=' '+LastName;
        }
        if(data.suffix != null ){
            oppor.Name+=' ' +data.suffix;
        }
        oppor.CloseDate = date.today()+30;
        oppor.StageName = 'Nuevo';
        oppor.RecordTypeId = recordTypeId;
        oppor.DSALES_Tiend__c = tienda.Id;
        oppor.Pricebook2Id = precioLista.Id;
        insert oppor;
        return oppor;
    }

    public static Quote crearCotizacion (DSALES_QuoteSmWrapper.QuoteSmRequest data, Id oportunidadId, String FirstName,String MiddleName, String LastName, Tienda__c tienda, Boolean listaNegra, DSALES_QuoteSmWrapper.respuestaDelProveedor res, String packagge, String cobertura){
        Quote cotiza = new Quote();
        String recordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Venta de Seguro de Motos').getRecordTypeId();
        cotiza.Name = FirstName;
        if(MiddleName != null ){
            cotiza.Name+=' ' +MiddleName+' '+LastName;
        }else{
            cotiza.Name+=' '+LastName;
        }
        if(data.suffix != null ){
            cotiza.Name+=' ' +data.suffix;
        }
        cotiza.OpportunityId = oportunidadId;
        //cotiza.DSALES_FormadePago__c = data.method_payment;
        cotiza.DSales_ID_Tienda__c = data.store_id;
        cotiza.DSales_Tienda__c = tienda.Id;
        cotiza.ExpirationDate = date.today()+7;
        cotiza.RecordTypeId = recordTypeId;
        date aux = date.today();
        cotiza.DSALES_Fechadecreacionpresupuesto__c = date.newInstance(aux.year(), aux.month(), aux.day());
        cotiza.Lista_negra__c = listaNegra;
        cotiza.Motivo_de_lista_negra__c= 'Sin Definir';
        cotiza.Phone = data.contact_phone;
        cotiza.DSALES_Fechadenacimiento__c = data.contact_birth_date;
        cotiza.DSALES_Cdigodeestado__c = data.contact_state_code;
        cotiza.DSALES_Cdigodemunicipio__c = data.contact_township_code;
        cotiza.DSALES_Suburbcode__c = decimal.valueOf(data.contact_suburb_code);
        cotiza.DSALES_Cdigopostal__c = data.contact_zip_code;
        cotiza.DSALES_IDdelvehculo__c = data.vehicle_id;
        cotiza.DSALES_Opcindepago__c = data.payment_option;
        cotiza.DSALES_Cobertura__c = cobertura;
        cotiza.DSales_Vendedor__c = data.vendedor;
        cotiza.DSALES_Gnero__c = data.contact_gender;
        cotiza.DSALES_Fechadecomienzodepliza__c = data.start_at;
        cotiza.Email = data.contact_email;
        insert cotiza;

        List<QuoteLineItem> listaItem= new List<QuoteLineItem>();
        if(!listaNegra){
            if(data.productList[0].sku != null && data.productList[0].sku!=''){
                Product2 productoMoto = [SELECT Id, Name, StockKeepingUnit, DSALES_Seguro__c, DSales_Articulo__c FROM Product2 WHERE StockKeepingUnit=:data.productList[0].sku LIMIT 1];
                PricebookEntry precioM = [SELECT Id, Name, UnitPrice, Product2Id FROM PricebookEntry WHERE Product2Id =:productoMoto.Id LIMIT 1];
                QuoteLineItem partidaM = new QuoteLineItem();
                partidaM.QuoteId = cotiza.Id;
                partidaM.PricebookEntryId = precioM.Id;
                partidaM.Product2Id = precioM.Product2Id;
                partidaM.Quantity = 1;
                partidaM.UnitPrice = precioM.UnitPrice;
                listaItem.add(partidaM);
            }
            Product2 producto = [SELECT Id, Name, StockKeepingUnit, DSALES_Seguro__c, DSales_Articulo__c FROM Product2 WHERE Name=:packagge LIMIT 1];
            PricebookEntry precio = [SELECT Id, Name, UnitPrice, Product2Id FROM PricebookEntry WHERE Product2Id =:producto.Id LIMIT 1];
            QuoteLineItem partida = new QuoteLineItem();
            partida.QuoteId = cotiza.Id;
            partida.PricebookEntryId = precio.Id;
            partida.Product2Id = precio.Product2Id;
            partida.Quantity = 1;
            partida.UnitPrice = precio.UnitPrice;
            partida.DSALES_Fechadeinicio__c = Date.valueOf(res.data.receipts[0].start_date);
            partida.DSALES_Fechadetermino__c = Date.valueOF(res.data.receipts[0].end_date);
            partida.DSALES_Primaneta__c = decimal.valueOf(res.data.receipts[0].net_premium);
            partida.UnitPrice = decimal.valueOf(res.data.receipts[0].total_premium);
            partida.DSALES_Derechosdepliza__c = decimal.valueOf(res.data.receipts[0].right);
            partida.DSALES_Gastosdeoperacindelrecibo__c = decimal.valueOf(res.data.receipts[0].recharge);
            partida.DSALES_Impuestos__c = decimal.valueOf(res.data.receipts[0].tax);
            
            listaItem.add(partida);
            insert listaItem;
        }
        
        return cotiza;
    }
}