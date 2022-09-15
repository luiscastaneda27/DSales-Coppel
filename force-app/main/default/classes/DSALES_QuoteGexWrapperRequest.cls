@RestResource(urlMapping='/insertQuote/*')
global with sharing class DSALES_QuoteGexWrapperRequest {
    
     
    @HttpPost
    global static DSALES_QuoteGexWrapper.QuoteGexResponse createQuote(){
        Boolean success = false;
        String message = '';
        String numeroCliente = '90001';
        String tipoProducto = 'Servicio';
        Account cliente = new Account();
        Opportunity oppor = new Opportunity();
        Quote cotiza = new Quote();
        List<QuoteLineItem> listaPartida = new List<QuoteLineItem>();
        List<PricebookEntry> listaPartida2 = new List<PricebookEntry>();
		PricebookEntry listaentradapre = new PricebookEntry();
        Product2 productos = new Product2(); 
        Pricebook2 listaPrecio = new Pricebook2();

        if(RestContext.request != null){
             String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                
                try{
                    Map<String, DSALES_QuoteGexWrapper.Product> mapProducts = new  Map<String, DSALES_QuoteGexWrapper.Product>();
                    DSALES_QuoteGexWrapper.QuoteGexRequest data = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
                    for (DSALES_QuoteGexWrapper.Product p : data.productList){
                        mapProducts.put(p.sku, p);
                    }
                    String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Garantía Extendida').getRecordTypeId();
                    List<Product2> produc = [SELECT Id,Name,StockKeepingUnit,DSALES_Categoria__c,DSALES_Clase__c,DSALES_Familia__c FROM Product2 WHERE StockKeepingUnit in: mapProducts.keySet()];
                    List<Pricebook2> precioLista = [SELECT id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
                    List<PricebookEntry> precioEn = [SELECT Id,UnitPrice,Name,Product2Id,Pricebook2Id,Product2.StockKeepingUnit FROM PricebookEntry WHERE Product2Id =: produc and Pricebook2Id=: precioLista];
                    List<Account> UniversalAccount = [Select Id from Account WHERE DSALES_ClienteCoppel__c = :numeroCliente];
                    List<Tienda__c> tiendas = [Select Id from Tienda__c WHERE DSales_TiendaID__c =: data.store_id];
                    
                    List<Account> result = [Select Id,FirstName,MiddleName,LastName from Account WHERE CP_WalletCustomerNumber__c =:Decimal.valueOf(data.client_number)];
                    if(Decimal.valueOf(data.client_number) != Decimal.valueOf(numeroCliente)){
                       
                        if(result.size()!= 0){
                            
                            oppor.AccountId = result[0].Id;
                            oppor.Name = 'Oportunidad -'+' '+result[0].FirstName+' '+result[0].MiddleName+' '+result[0].LastName;
                            oppor.CloseDate = date.today()+30;
                            oppor.StageName = 	'Nuevo';
                            oppor.RecordTypeId = recordTypeId;
                            oppor.DSALES_Tienda__c = data.store_name;
                            oppor.Pricebook2Id = precioLista[0].Id;
                            insert oppor;
                            
                            cotiza.Name = 'Cotizacion -'+' '+result[0].FirstName+' '+result[0].MiddleName+' '+result[0].LastName;
                            cotiza.OpportunityId = oppor.Id;
                            //cotiza.DSALES_Fechadenacimiento__c = data.birthdate;
                            cotiza.DSALES_FormadePago__c = data.method_payment;
                            //cotiza.DSALES_EmailNew__c = data.email;
                            cotiza.DSales_Vendedor__c = data.vendedor_name;
                            cotiza.DSales_ID_Tienda__c = data.store_id;
                            cotiza.DSales_Tienda__c = tiendas[0].Id;
                            cotiza.ID_Vendedor__c = data.vendor_id;
                            cotiza.DSales_Direccion_de_la_tienda__c = data.Address_Store;
                            cotiza.DSALES_Region__c = data.region;
                            cotiza.DSales_Division__c= data.division;
                            insert cotiza;
                            
                            for(PricebookEntry item : precioEn){
                            QuoteLineItem partidapre = new QuoteLineItem();
                                
                                DSALES_QuoteGexWrapper.Product p =  mapProducts.get(item.Product2.StockKeepingUnit);
                                Product2 producto = new Product2();
                                
                                for(Product2 pro: produc){
                                    if(pro.StockKeepingUnit == item.Product2.StockKeepingUnit){
                                        producto = pro; 
                                    }
                                }
                                partidapre.QuoteId = cotiza.Id;
                                partidapre.PricebookEntryId = item.Id;
                                partidapre.Product2Id = producto.Id;
                                partidapre.Quantity = p.Quantity_tangible_products;
                                partidapre.Discount = p.discount;
                                partidapre.UnitPrice = item.UnitPrice;
                                partidapre.DSales_Fecha_de_entrega_estimada__c = data.Estimated_delivery_date;
                                partidapre.DSales_Articulo__c = p.article;
                                partidapre.DSales_Marca__c = p.brand;
                                partidapre.DSales_Modelo__c = p.model;
                                partidapre.DSALES_ListaArticulo__c = p.product_type;
                                listaPartida.add(partidapre);
                            } 
                    		insert listaPartida;

                        	//message = 'ERES CLIENTE COPPEL Y SE CREO SOLO OPORTUNIDAD Y COTIZACION';
                            
                        }else{
                            cliente.CP_WalletCustomerNumber__c = Decimal.valueOf(data.client_number);
                            cliente.FirstName = data.first_name;
                            cliente.MiddleName = data.middle_name;
                            cliente.LastName = data.last_name;
                            cliente.Suffix = data.suffix;
                            cliente.PersonBirthdate = data.birthdate;
                            cliente.PersonEmail = data.email;     
                            insert cliente;
                            
                            oppor.AccountId =cliente.Id;
                            oppor.Name = 'Oportunidad -'+' '+data.first_name+' '+data.middle_name+' '+data.last_name;
                            oppor.CloseDate = date.today()+30;
                            oppor.StageName = 	'Nuevo';
                            oppor.RecordTypeId = recordTypeId;
                            oppor.DSALES_Tienda__c = data.store_name;
                            oppor.Pricebook2Id = precioLista[0].Id;
                            
                            insert oppor;
                            
                            cotiza.Name = 'Cotizacion -'+' '+data.first_name+' '+data.middle_name+' '+data.last_name;
                            cotiza.OpportunityId = oppor.Id;
                            //cotiza.DSALES_Fechadenacimiento__c = data.birthdate;
                            cotiza.DSALES_FormadePago__c = data.method_payment;
                            cotiza.DSales_Vendedor__c = data.vendedor_name;
                            cotiza.DSales_ID_Tienda__c = data.store_id;
                            cotiza.DSales_Tienda__c = tiendas[0].Id;
                            cotiza.ID_Vendedor__c = data.vendor_id;
                            cotiza.DSales_Direccion_de_la_tienda__c = data.Address_Store;
                            cotiza.DSALES_Region__c = data.region;
                            cotiza.DSales_Division__c= data.division;
                            insert cotiza;
                            

							for(PricebookEntry item : precioEn){
                            QuoteLineItem partidapre = new QuoteLineItem();
                                 DSALES_QuoteGexWrapper.Product p =  mapProducts.get(item.Product2.StockKeepingUnit);
                                Product2 producto = new Product2();
                                for(Product2 pro: produc){
                                    if(pro.StockKeepingUnit == item.Product2.StockKeepingUnit){
                                        producto = pro;
                                    }
                                }
                                partidapre.QuoteId = cotiza.Id;
                                partidapre.PricebookEntryId = item.Id;
                                partidapre.Product2Id = item.Product2Id;
                                partidapre.Quantity = p.Quantity_tangible_products;
                                partidapre.Discount = p.discount;
                                partidapre.UnitPrice = item.UnitPrice;
                                partidapre.DSales_Fecha_de_entrega_estimada__c = data.Estimated_delivery_date;
                                partidapre.DSales_Articulo__c = p.article;
                                partidapre.DSales_Marca__c = p.brand;
                                partidapre.DSales_Modelo__c = p.model;
                                partidapre.DSALES_ListaArticulo__c = p.product_type;
                                listaPartida.add(partidapre);
                            } 
                    		insert listaPartida;

                        	//message = 'AHORA YA ERES UN CLIENTE NUEVO Y SE CREO CLIENTE DE CREDITO, OPORTUNIDAD Y COTIZACION';  
                        }
                    }else{
                            oppor.AccountId = UniversalAccount[0].Id;
                            oppor.Name = '90001 -'+' '+data.first_name+' '+data.middle_name+' '+data.last_name;
                            oppor.CloseDate = date.today()+30;
                            oppor.StageName = 	'Nuevo';
                            oppor.RecordTypeId = recordTypeId;
                        	oppor.DSALES_Nombredelsolicitante__c = +data.first_name+' '+data.middle_name+' '+data.last_name;
                            oppor.DSALES_Tienda__c = data.store_name;
                            oppor.Pricebook2Id = precioLista[0].Id;
                            insert oppor;
                            
                            cotiza.Name = '90001 '+data.first_name+' '+data.middle_name+' '+data.last_name;
                            cotiza.OpportunityId = oppor.Id;
                            //cotiza.DSALES_Fechadenacimiento__c = data.birthdate;
                            cotiza.DSALES_FormadePago__c = data.method_payment;
                            cotiza.DSALES_EmailNew__c = data.email;
                            cotiza.DSales_Vendedor__c = data.vendedor_name;
                            cotiza.DSales_ID_Tienda__c = data.store_id;
                        	cotiza.DSales_Tienda__c = tiendas[0].Id;
                            cotiza.ID_Vendedor__c = data.vendor_id;
                        	cotiza.DSales_Direccion_de_la_tienda__c = data.Address_Store;
                            cotiza.DSALES_Region__c = data.region;
                            cotiza.DSales_Division__c= data.division;
                            insert cotiza;
                            
							for(PricebookEntry item : precioEn){
                            QuoteLineItem partidapre = new QuoteLineItem();
                                DSALES_QuoteGexWrapper.Product p =  mapProducts.get(item.Product2.StockKeepingUnit);
                                Product2 producto = new Product2();
                                for(Product2 pro: produc){
                                    if(pro.StockKeepingUnit == item.Product2.StockKeepingUnit){
                                        producto = pro;
                                    }
                                }
                                partidapre.QuoteId = cotiza.Id;
                                partidapre.PricebookEntryId = item.Id;
                                partidapre.Product2Id = item.Product2Id;
                                partidapre.Quantity = p.Quantity_tangible_products;
                                partidapre.Discount = p.discount;
                                partidapre.UnitPrice = item.UnitPrice;
                                partidapre.DSales_Fecha_de_entrega_estimada__c = data.Estimated_delivery_date;
                                partidapre.DSales_Articulo__c = p.article;
                                partidapre.DSales_Marca__c = p.brand;
                                partidapre.DSales_Modelo__c = p.model;
                                partidapre.DSALES_ListaArticulo__c = p.product_type;
                                listaPartida.add(partidapre);
                            } 
                    		insert listaPartida;

                        //message = 'SE CREO CLIENTE DE CONTADO, OPORTUNIDAD Y COTIZACION';
                    }
    
                }catch(Exception e){
                    message = 'Error: ' + e.getMessage() +' '+e.getLineNumber();
                }
            }
        }
        DSALES_QuoteGexWrapper.QuoteGexResponse responsePayload = new DSALES_QuoteGexWrapper.QuoteGexResponse();
        List<QuoteLineItem> ConsultaRespuesta = [Select Id,Product2.Name,ListPrice,Quantity,Quote.GrandTotal,Product2.DSales_Tipo_de_Producto__c,Product2.DSALES_Familia__r.Name,Product2.DSALES_Clase__r.Name,Product2.DSALES_Categoria__r.Name from QuoteLineItem WHERE QuoteId=: cotiza.Id ];
        
        /*Map<String,QuoteLineItem> respuesta = new  Map<String,QuoteLineItem>();
        for(QuoteLineItem i : ConsultaRespuesta){
            respuesta.put(i.Product2.Name,i);
        }*/
            
        responsePayload.quote_id= cotiza.Id;
        responsePayload.total_cost = ConsultaRespuesta[0].Quote.GrandTotal;
        responsePayload.price = ConsultaRespuesta[0].ListPrice;
        responsePayload.service_type = ConsultaRespuesta[0].Product2.DSales_Tipo_de_Producto__c;
        responsePayload.intangible_name = ConsultaRespuesta[0].Product2.Name;
        responsePayload.category = ConsultaRespuesta[0].Product2.DSALES_Categoria__r.Name;
        responsePayload.class1 = ConsultaRespuesta[0].Product2.DSALES_Clase__r.Name;
        responsePayload.family = ConsultaRespuesta[0].Product2.DSALES_Familia__r.Name;
        return responsePayload;
    }

}