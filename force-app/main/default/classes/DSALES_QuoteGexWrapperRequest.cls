@RestResource(urlMapping='/insertQuoteGex/*')
global with sharing class DSALES_QuoteGexWrapperRequest {
    
    
    @HttpPost
    global static DSALES_QuoteGexWrapper.respuestaNPV createQuote(){
        Boolean success = false;
        String message = '';
        String code = '';
        String regions = 'Todas las regiones';
        String tipoProducto = 'Servicio';
        String originalMat = 'Matriz Original';
        Account cliente = new Account();
        Opportunity oppor = new Opportunity();
        Quote cotiza = new Quote();
        List<QuoteLineItem> listaPartida = new List<QuoteLineItem>();
        List<PricebookEntry> listaPartida2 = new List<PricebookEntry>();
        PricebookEntry listaentradapre = new PricebookEntry();
        Product2 productos = new Product2(); 
        Pricebook2 listaPrecio = new Pricebook2();
        List<DSales_Asignacion_de_Productos__c> productAsig = new List<DSales_Asignacion_de_Productos__c>();
        
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                
                try{
                    Map<String, DSALES_QuoteGexWrapper.Product> mapProducts = new  Map<String, DSALES_QuoteGexWrapper.Product>();
                    
                    DSALES_QuoteGexWrapper.QuoteGexRequest data = (DSALES_QuoteGexWrapper.QuoteGexRequest)JSON.deserialize(body, DSALES_QuoteGexWrapper.QuoteGexRequest.class);
                    
                    for(DSALES_QuoteGexWrapper.Product p : data.productos){
                        mapProducts.put(p.sku_de_tangible, p);
                    }
                    
                    String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Garantía Extendida').getRecordTypeId();
                    String recordTypeQuoteId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Venta de Garantía Extendida').getRecordTypeId();
                    
                    List<Product2> produc = [SELECT Id,Name,StockKeepingUnit,DSALES_Categoria__c,DSALES_Clase__c,DSALES_Familia__c,DSales_Aplicaporcentajecobro__c,DSales_PorcentajeCobro__c FROM Product2 WHERE StockKeepingUnit in: mapProducts.keySet()];
                    
                    productAsig = [SELECT id, Name, DSales_Servicio_Seguro__c, DSales_Producto__c,DSALES_SKU__c FROM DSales_Asignacion_de_Productos__c WHERE DSALES_SKU__c in: mapProducts.keySet()];
                    
                    List<Id> DSales_ProductoSetId = new List<Id>();
                    for(DSales_Asignacion_de_Productos__c da : productAsig){
                        DSales_ProductoSetId.add(da.DSales_Producto__c);
                    }
                    List<DSales_Matriz_GEX__c> mat = [SELECT id, Name, DSALES_Activo__c, DSALES_Region__c, DSALES_Tipo__c FROM DSales_Matriz_GEX__c WHERE DSALES_Servicio__c =: DSales_ProductoSetId and DSALES_Activo__c =true and DSALES_Tipo__c=:originalMat and DSALES_Region__c INCLUDES (:regions)];
                    List<DSALES_Matriz_de_Cotizacion__c> matPrice1Year = [SELECT id, Name,SALES_Precio_GEX__c,DSales_Matriz_GEX__c,DSALES_Rango_interior_GEX__c,DSALES_Rango_Superior_GEX__c,DSALES_Tiempo_de_Garantia_Extendida_GEX__c FROM DSALES_Matriz_de_Cotizacion__c WHERE DSales_Matriz_GEX__c =: mat ORDER BY SALES_Precio_GEX__c DESC];
                    List<Pricebook2> precioLista = [SELECT id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
                    List<PricebookEntry> precioEn = [SELECT Id,UnitPrice,Name,Product2Id,Pricebook2Id,Product2.StockKeepingUnit,Product2.DSales_PorcentajeCobro__c,Product2.DSales_Aplicaporcentajecobro__c FROM PricebookEntry WHERE Product2Id =: produc and Pricebook2Id=: precioLista];
                    List<PricebookEntry> precioEnGEX = [SELECT Id,Name,UnitPrice,Product2Id,Pricebook2Id,Product2.StockKeepingUnit,Product2.DSales_Tipo_de_Producto__c,Product2.DSales_PorcentajeCobro__c,Product2.DSales_Aplicaporcentajecobro__c FROM PricebookEntry WHERE Product2Id =: DSales_ProductoSetId and Pricebook2Id=: precioLista];
                    
                    List<Account> UniversalAccount = [Select Id from Account WHERE DSALES_ClienteCoppel__c = :DSALES_Utility.NUMERO_CLIENTE_GENERICO];
                    List<Tienda__c> tiendas = [Select Id from Tienda__c WHERE DSales_TiendaID__c =: data.id_tienda];
                    
                    if(data.id_factura != null){
                        DSALES_InformacionDePago__c newOpportunity =[Select id,DSALES_Oportunidad__c,DSALES_Oportunidad__r.Name, DSALES_Cliente__c from DSALES_InformacionDePago__c where DSALES_Factura__c= :data.id_factura LIMIT 1];
                        oppor.AccountId = newOpportunity.DSALES_Cliente__c;
                        oppor.Name = newOpportunity.DSALES_Oportunidad__r.Name+' '+'GEX';
                        oppor.CloseDate = date.today()+30;
                        oppor.StageName = 	'Nuevo';
                        oppor.RecordTypeId = recordTypeId;
                        oppor.Pricebook2Id = precioLista[0].Id;
                        oppor.DSALES_OppPrin__c = newOpportunity.DSALES_Oportunidad__c;
                        insert oppor;
                        
                        cotiza.OpportunityId = oppor.Id;
                        cotiza.Name = newOpportunity.DSALES_Oportunidad__r.Name+' '+'GEX';
                        cotiza.RecordTypeId =recordTypeQuoteId;
                        cotiza.DSales_ID_Tienda__c = data.id_tienda;
                        cotiza.DSales_Tienda__c = tiendas[0].Id;
                        cotiza.ExpirationDate = date.today()+14;
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
                        String intangibleId;
                            for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                                if(asigProduc.DSales_Servicio_Seguro__c == item.Product2Id){
                                    intangibleId = asigProduc.DSales_Producto__c;
                                }
                            }
                            for(PricebookEntry item2 : precioEnGEX){
                                if(item2.Product2Id == intangibleId){
                                    
                                    QuoteLineItem partidapreGEX = new QuoteLineItem();
                                    Double price1 =0;
                                    Double price2=0;
                                    
                                    if(item2.Product2.DSales_Aplicaporcentajecobro__c==true){
                                        price1= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                        price2= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                    }else{
                                        for(DSALES_Matriz_de_Cotizacion__c mPrice : matPrice1Year){
                                            if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='1 año'){
                                                price1 = mPrice.SALES_Precio_GEX__c;
                                            }
                                            if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='2 años'){
                                                price2 = mPrice.SALES_Precio_GEX__c;
                                            }
                                        }
                                    }
                                    partidapreGEX.QuoteId = cotiza.Id;
                                    partidapreGEX.PricebookEntryId = item2.Id;
                                    partidapreGEX.Product2Id = item2.Product2Id;
                                    partidapreGEX.Quantity = 1;
                                    partidapreGEX.UnitPrice = price1;
                                    partidapreGEX.Vigencia_meses__c = '12';
                                    partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                    partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 12M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                    listaPartida.add(partidapreGEX);
                                    
                                    partidapreGEX = new QuoteLineItem();
                                    partidapreGEX.QuoteId = cotiza.Id;
                                    partidapreGEX.PricebookEntryId = item2.Id;
                                    partidapreGEX.Product2Id = item2.Product2Id;
                                    partidapreGEX.Quantity = 1;
                                    partidapreGEX.UnitPrice = price2;
                                    partidapreGEX.Vigencia_meses__c = '24';
                                    partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                    partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 24M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                    listaPartida.add(partidapreGEX);
                                }
                            }
                        }
                        insert listaPartida;
                        success=true;
                        code = '';
                        message = '';
                        
                        DSALES_QuoteGexWrapper.respuestaNPV respuestaNpvList = new DSALES_QuoteGexWrapper.respuestaNPV();
                        respuestaNpvList.id_cotizacion = cotiza.Id;
                        respuestaNpvList.success = success;
                        respuestaNpvList.codigo_error = code;
                        respuestaNpvList.mensaje_error = message;
                        respuestaNpvList.respuesta =  new List<DSALES_QuoteGexWrapper.QuoteGexResponse>();
                        
                        List<QuoteLineItem> ConsultaRespuesta = new List<QuoteLineItem> ();
                        List<QuoteLineItem> ConsultaRespuestaGEX = new List<QuoteLineItem> ();
                        
                        for(QuoteLineItem item: [Select Id,Product2.Id,Product2.Name,ListPrice,UnitPrice,Quantity,Vigencia_meses__c,Quote.GrandTotal,Product2.DSales_Tipo_de_Producto__c,Product2.DSALES_Familia__r.Name,Product2.DSALES_Clase__r.Name,Product2.DSALES_Categoria__r.Name from QuoteLineItem WHERE QuoteId=: cotiza.Id]){
                            if(item.Product2.DSales_Tipo_de_Producto__c == 'Producto'){
                                ConsultaRespuesta.add(item);
                            }else{
                                ConsultaRespuestaGEX.add(item);
                            }
                        }
                            for(QuoteLineItem resTangible : ConsultaRespuesta){
                                List<String> listIntangible = new List<String>();
                                for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                                    if(asigProduc.DSales_Servicio_Seguro__c == resTangible.Product2Id){
                                        listIntangible.add(asigProduc.DSales_Producto__c);
                                    }
                                }
                        
                        for(QuoteLineItem resIntangible : ConsultaRespuestaGEX){
                            DSALES_QuoteGexWrapper.QuoteGexResponse responsePayload = new DSALES_QuoteGexWrapper.QuoteGexResponse();
                            responsePayload.costo_total = resIntangible.UnitPrice;
                            responsePayload.precio = resIntangible.UnitPrice;
                            responsePayload.nombre_intangible = 'GEX '+resIntangible.Vigencia_meses__c+' '+resIntangible.DSALES_SKU__c+' '+resTangible.Product2.Name;
                            responsePayload.sku_de_tangible = resTangible.DSALES_SKU__c;
                            responsePayload.sku_de_precio = 'falta ajustar';
                            responsePayload.sku_de_servicio = resIntangible.DSALES_SKU__c;
                            respuestaNpvList.respuesta.add(responsePayload);
                        }
                      }    
                    return respuestaNpvList;
                    } 
                    
                    List<Account> clienteContado = [SELECT Id,FirstName,LastName FROM Account WHERE FirstName=: data.nombre and LastName=: data.apellido_paterno and PersonEmail= :data.correo_electronico];
                    if(data.numero_de_cliente == '' || data.numero_de_cliente == null ){
                        
                        oppor.AccountId = clienteContado[0].Id;
                        oppor.Name = clienteContado[0].FirstName+' '+clienteContado[0].LastName;
                        oppor.CloseDate = date.today()+30;
                        oppor.StageName = 	'Nuevo';
                        oppor.RecordTypeId = recordTypeId;
                        oppor.Pricebook2Id = precioLista[0].Id;
                        insert oppor;
                        
                        cotiza.Name = clienteContado[0].FirstName+' '+clienteContado[0].LastName;
                        cotiza.OpportunityId = oppor.Id;
                        cotiza.RecordTypeId =recordTypeQuoteId;
                        cotiza.DSales_ID_Tienda__c = data.id_tienda;
                        cotiza.DSales_Tienda__c = tiendas[0].Id;
                        cotiza.ExpirationDate = date.today()+14;
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
                            partidapre.Quantity = p.cantidad_productos_tangibles;
                            partidapre.UnitPrice = p.precio_tangible;
                            partidapre.DSales_Articulo__c = p.articulo;
                            partidapre.DSales_Marca__c = p.marca;
                            partidapre.DSales_Modelo__c = p.modelo;
                            partidapre.DSALES_NombreProductoServicio__c  = p.articulo;
                            listaPartida.add(partidapre);
                            
                            String intangibleId;
                            for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                                if(asigProduc.DSales_Servicio_Seguro__c == item.Product2Id){
                                    intangibleId = asigProduc.DSales_Producto__c;
                                }
                            }
                            for(PricebookEntry item2 : precioEnGEX){
                                if(item2.Product2Id == intangibleId){
                                    
                                    QuoteLineItem partidapreGEX = new QuoteLineItem();
                                    Double price1 =0;
                                    Double price2=0;
                                    
                                    if(item2.Product2.DSales_Aplicaporcentajecobro__c==true){
                                        price1= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                        price2= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                    }else{
                                        for(DSALES_Matriz_de_Cotizacion__c mPrice : matPrice1Year){
                                            if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='1 año'){
                                                price1 = mPrice.SALES_Precio_GEX__c;
                                            }
                                            if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='2 años'){
                                                price2 = mPrice.SALES_Precio_GEX__c;
                                            }
                                        }
                                    }
                                    partidapreGEX.QuoteId = cotiza.Id;
                                    partidapreGEX.PricebookEntryId = item2.Id;
                                    partidapreGEX.Product2Id = item2.Product2Id;
                                    partidapreGEX.Quantity = 1;
                                    partidapreGEX.UnitPrice = price1;
                                    partidapreGEX.Vigencia_meses__c = '12';
                                    partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                    partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 12M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                    listaPartida.add(partidapreGEX);
                                    
                                    partidapreGEX = new QuoteLineItem();
                                    partidapreGEX.QuoteId = cotiza.Id;
                                    partidapreGEX.PricebookEntryId = item2.Id;
                                    partidapreGEX.Product2Id = item2.Product2Id;
                                    partidapreGEX.Quantity = 1;
                                    partidapreGEX.UnitPrice = price2;
                                    partidapreGEX.Vigencia_meses__c = '24';
                                    partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                    partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 24M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                    listaPartida.add(partidapreGEX);
                                }
                            }
                        }
                        insert listaPartida;
                        success=true;
                        code = '';
                        message = '';
                        //message = 'Entro a prueba de cliente contado';
                    }else{
                        if(data.numero_de_cliente != DSALES_Utility.NUMERO_CLIENTE_GENERICO){
                            List<Account> result = [Select Id,FirstName,MiddleName,LastName from Account WHERE CP_WalletCustomerNumber__c =:Decimal.valueOf(data.numero_de_cliente)];
                            if(result.size()!= 0){
                                oppor.AccountId = result[0].Id;
                                oppor.Name = result[0].FirstName+' '+result[0].LastName;
                                oppor.CloseDate = date.today()+30;
                                oppor.StageName = 	'Nuevo';
                                oppor.RecordTypeId = recordTypeId;
                                oppor.Pricebook2Id = precioLista[0].Id;
                                insert oppor;
                                
                                cotiza.Name = result[0].FirstName+' '+result[0].LastName;
                                cotiza.OpportunityId = oppor.Id;
                                cotiza.RecordTypeId =recordTypeQuoteId;
                                cotiza.DSales_ID_Tienda__c = data.id_tienda;
                                cotiza.DSales_Tienda__c = tiendas[0].Id;
                                cotiza.ExpirationDate = date.today()+14;
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
                                    partidapre.Quantity = p.cantidad_productos_tangibles;
                                    partidapre.UnitPrice = p.precio_tangible;
                                    partidapre.DSales_Articulo__c = p.articulo;
                                    partidapre.DSales_Marca__c = p.marca;
                                    partidapre.DSales_Modelo__c = p.modelo;
                                    partidapre.DSALES_NombreProductoServicio__c  = p.articulo;
                                    listaPartida.add(partidapre);
                                    
                                    String intangibleId;
                                    for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                                        if(asigProduc.DSales_Servicio_Seguro__c == item.Product2Id){
                                            intangibleId = asigProduc.DSales_Producto__c;
                                        }
                                    }
                                    for(PricebookEntry item2 : precioEnGEX){
                                        if(item2.Product2Id == intangibleId){        
                                            QuoteLineItem partidapreGEX = new QuoteLineItem();
                                            Double price1 =0;
                                            Double price2=0;
                                            
                                            if(item2.Product2.DSales_Aplicaporcentajecobro__c==true){
                                                price1= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                                price2= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                            }else{
                                                for(DSALES_Matriz_de_Cotizacion__c mPrice : matPrice1Year){
                                                    if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='1 año'){
                                                        price1 = mPrice.SALES_Precio_GEX__c;
                                                    }
                                                    if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='2 años'){
                                                        price2 = mPrice.SALES_Precio_GEX__c;
                                                    }
                                                }
                                            }
                                            partidapreGEX.QuoteId = cotiza.Id;
                                            partidapreGEX.PricebookEntryId = item2.Id;
                                            partidapreGEX.Product2Id = item2.Product2Id;
                                            partidapreGEX.Quantity = 1;
                                            partidapreGEX.UnitPrice = price1;
                                            partidapreGEX.Vigencia_meses__c = '12';
                                            partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                            partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 12M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                            listaPartida.add(partidapreGEX);
                                            
                                            partidapreGEX = new QuoteLineItem();
                                            partidapreGEX.QuoteId = cotiza.Id;
                                            partidapreGEX.PricebookEntryId = item2.Id;
                                            partidapreGEX.Product2Id = item2.Product2Id;
                                            partidapreGEX.Quantity = 1;
                                            partidapreGEX.UnitPrice = price2;
                                            partidapreGEX.Vigencia_meses__c = '24';
                                            partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                            partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 24M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                            listaPartida.add(partidapreGEX);
                                        }
                                    }
                                }
                                insert listaPartida;
                                success=true;
                                code = '';
                                message = '';
                                //message = 'ERES CLIENTE COPPEL Y SE CREO SOLO OPORTUNIDAD Y COTIZACION'; 
                            }else{
                                cliente.CP_WalletCustomerNumber__c = Decimal.valueOf(data.numero_de_cliente);
                                cliente.FirstName = data.nombre;
                                cliente.LastName = data.apellido_paterno;
                                cliente.Suffix =  data.apellido_materno;
                                cliente.PersonEmail = data.correo_electronico;     
                                insert cliente;
                                
                                oppor.AccountId =cliente.Id;
                                oppor.Name = data.nombre+' '+data.apellido_paterno+' '+data.apellido_materno;
                                oppor.CloseDate = date.today()+30;
                                oppor.StageName = 	'Nuevo';
                                oppor.RecordTypeId = recordTypeId;
                                oppor.Pricebook2Id = precioLista[0].Id;
                                
                                insert oppor;
                                
                                cotiza.Name = data.nombre+' '+data.apellido_paterno+' '+data.apellido_materno;
                                cotiza.OpportunityId = oppor.Id;
                                cotiza.RecordTypeId =recordTypeQuoteId;
                                cotiza.DSales_ID_Tienda__c = data.id_tienda;
                                cotiza.DSales_Tienda__c = tiendas[0].Id;
                                cotiza.ExpirationDate = date.today()+14;
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
                                    partidapre.Quantity = p.cantidad_productos_tangibles;
                                    partidapre.UnitPrice = p.precio_tangible;
                                    partidapre.DSales_Articulo__c = p.articulo;
                                    partidapre.DSales_Marca__c = p.marca;
                                    partidapre.DSales_Modelo__c = p.modelo;
                                    partidapre.DSALES_NombreProductoServicio__c  = p.articulo;
                                    listaPartida.add(partidapre);
                                    
                                    String intangibleId;
                                    for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                                        if(asigProduc.DSales_Servicio_Seguro__c == item.Product2Id){
                                            intangibleId = asigProduc.DSales_Producto__c;
                                        }
                                    }
                                    for(PricebookEntry item2 : precioEnGEX){
                                        if(item2.Product2Id == intangibleId){
                                            
                                            QuoteLineItem partidapreGEX = new QuoteLineItem();
                                            Double price1 =0;
                                            Double price2=0;
                                            
                                            if(item2.Product2.DSales_Aplicaporcentajecobro__c==true){
                                                price1= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                                price2= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                            }else{
                                                for(DSALES_Matriz_de_Cotizacion__c mPrice : matPrice1Year){
                                                    if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='1 año'){
                                                        price1 = mPrice.SALES_Precio_GEX__c;
                                                    }
                                                    if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='2 años'){
                                                        price2 = mPrice.SALES_Precio_GEX__c;
                                                    }
                                                }
                                            }
                                            partidapreGEX.QuoteId = cotiza.Id;
                                            partidapreGEX.PricebookEntryId = item2.Id;
                                            partidapreGEX.Product2Id = item2.Product2Id;
                                            partidapreGEX.Quantity = 1;
                                            partidapreGEX.UnitPrice = price1;
                                            partidapreGEX.Vigencia_meses__c = '12';
                                            partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                            partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 12M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                            listaPartida.add(partidapreGEX);
                                            
                                            partidapreGEX = new QuoteLineItem();
                                            partidapreGEX.QuoteId = cotiza.Id;
                                            partidapreGEX.PricebookEntryId = item2.Id;
                                            partidapreGEX.Product2Id = item2.Product2Id;
                                            partidapreGEX.Quantity = 1;
                                            partidapreGEX.UnitPrice = price2;
                                            partidapreGEX.Vigencia_meses__c = '24';
                                            partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                            partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 24M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                            listaPartida.add(partidapreGEX);
                                        }
                                    }
                                }
                                insert listaPartida;
                                success=true;
                                code = '';
                                message = '';
                                //message = 'AHORA YA ERES UN CLIENTE NUEVO Y SE CREO CLIENTE DE CREDITO, OPORTUNIDAD Y COTIZACION';  
                            }
                        }else{
                            oppor.AccountId = UniversalAccount[0].Id;
                            oppor.Name = data.nombre+' '+data.apellido_paterno+' '+data.apellido_materno;
                            oppor.CloseDate = date.today()+30;
                            oppor.StageName = 	'Nuevo';
                            oppor.RecordTypeId = recordTypeId;
                            oppor.DSALES_Nombredelsolicitante__c = data.nombre+' '+data.apellido_paterno+' '+data.apellido_materno;
                            oppor.Pricebook2Id = precioLista[0].Id;
                            insert oppor;
                            
                            cotiza.Name = data.nombre+' '+data.apellido_paterno+' '+data.apellido_materno;
                            cotiza.OpportunityId = oppor.Id;
                            cotiza.RecordTypeId =recordTypeQuoteId;
                            cotiza.DSALES_EmailNew__c = data.correo_electronico;
                            cotiza.DSales_ID_Tienda__c = data.id_tienda;
                            cotiza.DSales_Tienda__c = tiendas[0].Id;
                            cotiza.ExpirationDate = date.today()+14;
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
                                partidapre.Quantity = p.cantidad_productos_tangibles;
                                partidapre.UnitPrice = p.precio_tangible;
                                partidapre.DSales_Articulo__c = p.articulo;
                                partidapre.DSales_Marca__c = p.marca;
                                partidapre.DSales_Modelo__c = p.modelo;
                                partidapre.DSALES_NombreProductoServicio__c  = p.articulo;
                                listaPartida.add(partidapre);
                                
                                String intangibleId;
                                for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                                    if(asigProduc.DSales_Servicio_Seguro__c == item.Product2Id){
                                        intangibleId = asigProduc.DSales_Producto__c;
                                    }
                                }
                                for(PricebookEntry item2 : precioEnGEX){
                                    if(item2.Product2Id == intangibleId){
                                        
                                        QuoteLineItem partidapreGEX = new QuoteLineItem();
                                        Double price1 =0;
                                        Double price2=0;
                                        
                                        if(item2.Product2.DSales_Aplicaporcentajecobro__c==true){
                                            price1= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                            price2= (p.precio_tangible * item2.Product2.DSales_PorcentajeCobro__c)/100;
                                        }else{
                                            for(DSALES_Matriz_de_Cotizacion__c mPrice : matPrice1Year){
                                                if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='1 año'){
                                                    price1 = mPrice.SALES_Precio_GEX__c;
                                                }
                                                if(mPrice.DSALES_Rango_interior_GEX__c<= p.precio_tangible && mPrice.DSALES_Rango_Superior_GEX__c>= p.precio_tangible && mPrice.DSALES_Tiempo_de_Garantia_Extendida_GEX__c =='2 años'){
                                                    price2 = mPrice.SALES_Precio_GEX__c;
                                                }
                                            }
                                        }
                                        partidapreGEX.QuoteId = cotiza.Id;
                                        partidapreGEX.PricebookEntryId = item2.Id;
                                        partidapreGEX.Product2Id = item2.Product2Id;
                                        partidapreGEX.Quantity = 1;
                                        partidapreGEX.UnitPrice = price1;
                                        partidapreGEX.Vigencia_meses__c = '12';
                                        partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                        partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 12M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                        listaPartida.add(partidapreGEX);
                                        
                                        partidapreGEX = new QuoteLineItem();
                                        partidapreGEX.QuoteId = cotiza.Id;
                                        partidapreGEX.PricebookEntryId = item2.Id;
                                        partidapreGEX.Product2Id = item2.Product2Id;
                                        partidapreGEX.Quantity = 1;
                                        partidapreGEX.UnitPrice = price2;
                                        partidapreGEX.Vigencia_meses__c = '24';
                                        partidapreGEX.DSALES_ListaArticulo__c = item2.Product2.DSales_Tipo_de_Producto__c;
                                        partidapreGEX.DSALES_NombreProductoServicio__c  = 'GEX 24M'+' '+item.product2.StockKeepingUnit+' '+p.articulo;
                                        listaPartida.add(partidapreGEX);
                                    }
                                }
                            }
                            insert listaPartida;
                            success=true;
                            code = '';
                            message = '';
                            //message = 'SE CREO CLIENTE DE CONTADO, OPORTUNIDAD Y COTIZACION';
                        }
                    }
                    
                }catch(JSONException e){
                    success = false;
                    code = String.valueOf(DSALES_Utility.BAD_REQUEST_CODE);
                    message = DSALES_Utility.BAD_REQUEST_MSJ;
                }catch(Exception e){
                    success = false;
                    code = String.valueOf(DSALES_Utility.INTERNAL_ERROR_CODE);
                    message = DSALES_Utility.INTERNAL_ERROR_MSJ + ' ' +e.getMessage() + ' '+e.getLineNumber() + ' '+ e.getCause();
                }
            }
        }
        
        DSALES_QuoteGexWrapper.respuestaNPV respuestaNpvList = new DSALES_QuoteGexWrapper.respuestaNPV();
        respuestaNpvList.id_cotizacion = cotiza.Id;
        respuestaNpvList.success = success;
        respuestaNpvList.codigo_error = code;
        respuestaNpvList.mensaje_error = message;
        respuestaNpvList.respuesta =  new List<DSALES_QuoteGexWrapper.QuoteGexResponse>();
        
        List<QuoteLineItem> ConsultaRespuesta = new List<QuoteLineItem> ();
        List<QuoteLineItem> ConsultaRespuestaGEX = new List<QuoteLineItem> ();
        
        for(QuoteLineItem item: [Select Id,Product2.Id,Product2.Name,ListPrice,UnitPrice,Quantity,Vigencia_meses__c,DSALES_SKU__c,Quote.GrandTotal,Product2.DSales_Tipo_de_Producto__c,Product2.DSALES_Familia__r.Name,Product2.DSALES_Clase__r.Name,Product2.DSALES_Categoria__r.Name from QuoteLineItem WHERE QuoteId=: cotiza.Id]){
            if(item.Product2.DSales_Tipo_de_Producto__c == 'Producto'){
                ConsultaRespuesta.add(item);
            }else{
                ConsultaRespuestaGEX.add(item);
            }
        }
        if(ConsultaRespuesta.isEmpty()){
            DSALES_QuoteGexWrapper.QuoteGexResponse responsePayloadError = new DSALES_QuoteGexWrapper.QuoteGexResponse();
            responsePayloadError.nombre_intangible = null;
            responsePayloadError.precio = null;
            responsePayloadError.costo_total = null;
            responsePayloadError.sku_de_tangible = null;
            responsePayloadError.sku_de_precio = null;
            responsePayloadError.sku_de_servicio = null;
            respuestaNpvList.success = false;
            respuestaNpvList.codigo_error = code;
            respuestaNpvList.mensaje_error = message;
            respuestaNpvList.respuesta.add(responsePayloadError);
            return respuestaNpvList;
        }else{
            for(QuoteLineItem resTangible : ConsultaRespuesta){
                List<String> listIntangible = new List<String>();
                for(DSales_Asignacion_de_Productos__c asigProduc: productAsig){
                    if(asigProduc.DSales_Servicio_Seguro__c == resTangible.Product2Id){
                        listIntangible.add(asigProduc.DSales_Producto__c);
                    }
                }
                for(QuoteLineItem resIntangible : ConsultaRespuestaGEX){
                    if(listIntangible.contains(resIntangible.Product2Id)){
                        DSALES_QuoteGexWrapper.QuoteGexResponse responsePayload = new DSALES_QuoteGexWrapper.QuoteGexResponse();
                        responsePayload.costo_total = resIntangible.UnitPrice + resTangible.UnitPrice;
                        responsePayload.precio = resIntangible.UnitPrice;
                        responsePayload.nombre_intangible = 'GEX '+resIntangible.Vigencia_meses__c+'M'+' '+resTangible.DSALES_SKU__c+' '+resTangible.Product2.Name;
                        responsePayload.sku_de_tangible = resTangible.DSALES_SKU__c;
                        responsePayload.sku_de_precio = 'por definir';
                        responsePayload.sku_de_servicio = resIntangible.DSALES_SKU__c;
                        responsePayload.meses_cobertura = resIntangible.Vigencia_meses__c;
                        respuestaNpvList.respuesta.add(responsePayload);
                    }
                }
            }
        }
        return respuestaNpvList;
    }
    
}