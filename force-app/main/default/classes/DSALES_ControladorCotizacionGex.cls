public class DSALES_ControladorCotizacionGex {
    
    
    public  String html{get;set;}
    public  String email{get;set;}
    public String cliente{get;set;}
    public String tienda {get;set;}
    private static final String NOMBRE_OBJETO = 'Quote';
    private static final String NOMBRE_OBJETO2 = 'QuoteLineItem'; 
    private static final String NOMBRE_PLANTILLA = 'Cotizacion Gex';
    private static final String NOMBRE_Seguro='Cotizacion SG';
    private static final String NOMBRE_DATE = 'DATE';
    private static final String NOMBRE_DOUBLE = 'DOUBLE';
        private static final String myfilename = 'Cotizacion';
    
    public DSALES_ControladorCotizacionGex(){
        //Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=hey');
        String recordId = ApexPages.currentPage().getParameters().get('quoteId');
        Quote recordCoti=[SELECT Id, RecordTypeId FROM Quote Where Id=:recordId];
        RECORDTYPE motos= [SELECT Id, Name FROM RECORDTYPE WHERE Id=:recordCoti.RecordTypeId ];
        //html = [Select Id, HtmlValue, Subject from EmailTemplate Where DeveloperName = :NOMBRE_PLANTILLA].HtmlValue;
        If(motos.name=='Venta de Garantía Extendida')
        {
        html = [select Id, DSALES_Plantilla__c  from DSALES_Generador__c Where Name = :NOMBRE_PLANTILLA LIMIT 1].DSALES_Plantilla__c; 
            replaceHtml(NOMBRE_PLANTILLA,recordId);
        }
        else if(motos.name=='Venta de Seguro de Motos')
        {
             html = [select Id, DSALES_Plantilla__c  from DSALES_Generador__c Where Name = :NOMBRE_Seguro LIMIT 1].DSALES_Plantilla__c;
            replaceHtml(NOMBRE_Seguro,recordId);
        }
        
      
         }
    
    
    private static Map<String, String> getField(String ObjName){
        Map<String, String> mapCampos = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(ObjName).getDescribe().fields.getMap();
        for(Schema.SObjectField Sfield : fieldMap.Values()){
            schema.describefieldresult Field = sfield.getDescribe();
            mapCampos.put(Field.getName(), String.valueOf(Field.getType())); 
        }
        return mapCampos;
    }
    
   
    
    public void replaceHtml(String templateName,Id recordId){ 
        Quote cotizacion=[SELECT  DSALES_EmailNew__c,Name,Id,DSales_Tienda__c FROM Quote WHERE ID=:recordId];
        email=[SELECT  DSALES_EmailNew__c,Name,Id,DSales_Direccion_de_la_tienda__c FROM Quote WHERE ID=:recordId].DSALES_EmailNew__c;
       // cliente=[SELECT Name FROM Account WHERE Id=:cliente].Name;
        List<Tienda__c> tienda = new List<Tienda__c>();
           //tienda=[SELECT DSALES_Direccin__c FROM Tienda__c WHERE Id=:String.ValueOf(cotizacion.DSales_Tienda__c) Limit 1].DSALES_Direccin__c;
           tienda=[SELECT DSALES_Direccin__c FROM Tienda__c WHERE Id=:cotizacion.DSales_Tienda__c Limit 1];
        for(Tienda__c t: tienda)
        {
            if(tienda!=null)
                html=html.replace('Tienda__c', t.DSALES_Direccin__c);
            else
            {
                html=html.replace('Tienda__c', '');
            }
        }
           
        
        
        if(email!=null)
        {
            html=html.replace('DSALES_CorreoSeleccionado__c', email);  
        }
       
        
        
        Map<String, String> mapCampos = getField(NOMBRE_OBJETO);
        Map<String, String> mapCamposQuoteLineItem = getField(NOMBRE_OBJETO2);
        String query = 'Select ';
        String query2 = 'Select ';
        for(String item: mapCampos.keySet()){
            query += item+',';
        }
        for(String item2: mapCamposQuoteLineItem.keySet()){
            query2 += item2+',';
        }
        query = query.substring(0, query.length() -1);
        query += ' From Quote Where Id = :recordId';
        query2 = query2.substring(0, query2.length() -1);
        query2 += ' From QuoteLineItem Where QuoteId = :recordId';
        
        Quote coti = DataBase.query(query);
        html = html.replace('coti.', '');
        Integer contadora=0;
        QuoteLineItem[] cotiLine = DataBase.query(query2);
        html = html.replace('Quote.', '');
        for(String item: mapCampos.keySet()){
           
            if(html.contains(item)){
              String replace = '';
                if(coti.get(item)!= null){
                    if(mapCampos.get(item) == NOMBRE_DATE){
                        replace = String.valueOf(Date.valueOf(coti.get(item)).format());
                    }else if (mapCampos.get(item) == NOMBRE_DOUBLE ){
                        replace = String.valueOf(Decimal.valueOf( String.valueOf(coti.get(item)) ).format());
                    }else{
                        replace = String.valueOf(coti.get(item));
                    }
                }
                html = html.replace(item, replace);
                 contadora++;
                
            
            }
           
        }
        Integer count=0;
        Double total=0;
        Double total12=0;
        Double total24=0;
        System.debug('html: '+html);
        
        String formato='<tr>';
        formato+='<td colspan="1" rowspan="1">DSALES_NombreProducto__c</td>';
			 formato+='<td colspan="1" rowspan="1">QuoteLineItem.Quantity</td>';
			 formato+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
			 formato+='<td colspan="1" rowspan="1">QuoteLineItem.DSALES_Fechadecompra__c</td>';
			 formato+='<td colspan="1" rowspan="1">QuoteLineItem.DSALES_PrecioTotal</td>';        
        formato+='</tr>';
        
        String formato2='<tr>';
        formato2+='<td colspan="1" rowspan="1">DSALES_NombreProducto__c</td>';
        formato2+='<td colspan="1" rowspan="1">DSALES_SKU__c</td>';
        formato2+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formato2+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formato2+='<td colspan="1" rowspan="1">8000</td>';
        formato2+='</tr>';
        
        
        String tdTotal='<tr>';
        tdTotal+='<td colspan="1" rowspan="1" >Total</td>';
        tdTotal+='<td colspan="1" rowspan="1">&nbsp;</td>';
        tdTotal+='<td colspan="1" rowspan="1">&nbsp;</td>';
        tdTotal+='<td colspan="1" rowspan="1">16000</td>';
        tdTotal+='<td colspan="1" rowspan="1">8000</td>';
        tdTotal+='</tr>';
        
        
        String formatoSG='<tr>';
        formatoSG+='<td colspan="1" rowspan="1">DSALES_NombreProducto__c</td>';
        formatoSG+='<td colspan="1" rowspan="1">QuoteLineItem.Quantity</td>';
        formatoSG+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formatoSG+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formatoSG+='</tr>';
        
        String formatoSG1='<tr>';
        formatoSG1+='<td colspan="1" rowspan="1">DSALES_NombreProducto__c</td>';
        formatoSG1+='<td colspan="1" rowspan="1">Vigencia_meses__c</td>';
        formatoSG1+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formatoSG1+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formatoSG1+='</tr>';
        
        
        String tdTotalRem='';
        String tabla='';
        String tabla2='';
        String tabla3='';
        String tabla4='';
        double price=0;
        double tdPrice=0;
        double sgPrice=0;
        String formattedDate1='';
        double discount=0;
        
        for(QuoteLineItem quote: cotiLine)
        {
            Product2 producto = [SELECT DSales_Tipo_de_Producto__c FROM Product2 WHERE ID=:quote.Product2Id ];
            String sku='';
            String skuArray='';
            if(String.isBlank(quote.DSALES_SKU__c))
                sku='';
            else
                sku=quote.DSALES_SKU__c;
            String formattedDate='';
            
            
            if(producto.DSales_Tipo_de_Producto__c=='Producto')
             {
            skuArray+=sku;
            
            tabla+='<tr>';
            tabla+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>' +quote.DSALES_NombreProducto__c+ '<br/>'+'<span style="color:#838383">'+'SKU: '+ sku+'</span>'+'</td>';
            tabla+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>' +quote.Quantity+'<br/>'+ '</td>';
            tabla+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>' +'$ '+quote.UnitPrice+'<br/>'+ '</td>';
            price=quote.UnitPrice;
            if(quote.DSALES_Fechadecompra__c!=null){
                formattedDate=quote.DSALES_Fechadecompra__c.format();
                tabla+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+formattedDate+'</td>';
                tabla+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>' +'$ '+quote.totalPrice+  '<br/>' +'</td>';
            }
              else
                 {
                      tabla+='<td colspan="1" rowspan="1 "style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+'________'+'</td>';
                tabla+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>' +'$ '+quote.totalPrice+  '<br/>'+'</td>';
                 }
            if(String.valueOf(quote.DSALES_Fechadecompra__c)==null)
                total+=quote.TotalPrice;
            tabla+='</tr>';
            tabla+='<tr>';
            tabla+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla+='</tr>';
            
             }	 
            
            
            if(producto.DSales_Tipo_de_Producto__c=='Servicio'){
            
            
            tabla2+='<tr>';
            tabla2+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+  '<br/>' +quote.DSALES_NombreProducto__c+  '<br/>' +'</td>';
            
            tabla2+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+  '<br/>'+sku+ '<br/>'+'</td>';
            sku=sku.replace('-GEX', '');
            if(skuArray==sku)
            {
                tabla2+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>'+'$ '+price+ '<br/>'+'</td>';
            }
            else
            {
                tabla2+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>'+'$ '+price+ '<br/>'+'</td>';
            }
            
            if(quote.Vigencia_meses__c=='12')
            {
                tabla2+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>'+'$ '+quote.TotalPrice+ '<br/>'+'</td>';
                total12+=quote.TotalPrice;
                tabla2+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+'________'+ '</td>';  
                tabla4+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>'+'$ '+quote.TotalPrice+ '<br/>'+'</td>';
            }
            else if (quote.Vigencia_meses__c=='24')
            {
                tabla2+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+'________'+'</td>';
                tabla2+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>'+ '$ '+quote.TotalPrice+ '<br/>'+'</td>';  
                total24+=quote.TotalPrice;
                tabla4+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+ '<br/>'+'$ '+quote.TotalPrice+ '<br/>'+'</td>';
            }
            else 
            {
                tabla2+='<td colspan="1" rowspan="1" style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+'________'+'</td>';
                tabla2+='<td colspan="1" rowspan="1"style="font-size:15px;font-family: Arial, Helvetica, sans-serif;text-align:center;">'+'________'+'</td>'; 
            }
            tabla2+='</tr>';
             //tabla2+='</tr>';
            tabla2+='<tr>';
            tabla2+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla2+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla2+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla2+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla2+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla2+='</tr>';
            
            }
            if(templateName==NOMBRE_Seguro){
                
                 if(producto.DSales_Tipo_de_Producto__c=='Producto')
             {
              if(String.valueOf(discount)!=null)
                  discount=quote.Discount;
                 tabla3+='<tr>';
                tabla3+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+ '<br/>' +quote.DSALES_NombreProducto__c+ '<br/>'+'<span style="color:#838383">'+'SKU: '+ sku+'</span>'+'</td>';
                tabla3+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+quote.Quantity+'</td>';
                tabla3+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+quote.UnitPrice+'</td>';
                tabla3+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+quote.TotalPrice+'</td>';
                tabla3+='</tr>';
           // tabla3+='<td style="color:#00a9e0 ; "><strong>_______________________________</strong></td>';
           // tabla3+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
            //tabla3+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
           // tabla3+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
           // tabla3+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
          tabla3+='<tr>';
            tabla3+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla3+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla3+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla3+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla3+='<td style="border-bottom:1px solid #00a9e0;"height="10"></td>';
            tabla3+='</tr>';
                
                //formattedDate1+=quote.DSales_Fecha_de_entrega_estimada__c.format();
                
                
                tdPrice+= quote.TotalPrice;
             }
                 if(producto.DSales_Tipo_de_Producto__c=='Seguro')
             {
                
                tabla4+='<tr>';
                tabla4+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+'<br/>'+quote.DSALES_NombreProducto__c+'<br/>'+'</td>';
                tabla4+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+'<br/>'+quote.Vigencia_meses__c+'<br/>'+'</td>';
                tabla4+='<td colspan="1" rowspan="1" style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+'<br/>'+quote.UnitPrice+'<br/>'+'</td>';
                tabla4+='<td colspan="1" rowspan="1"style="text-align:center;font-size:15px;font-family: Arial, Helvetica, sans-serif;">'+'<br/>'+quote.UnitPrice+'<br/>'+'</td>';
                tabla4+='</tr>';
            tabla4+='<tr>';
            tabla4+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla4+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla4+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla4+='<td style="border-bottom:1px solid #00a9e0;"height="12"></td>';
            tabla4+='</tr>';
                 sgPrice+=quote.ListPrice;
             }
            //tabla4+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
            //tabla4+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
            //tabla4+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
           // tabla4+='<td style="color:#00a9e0 ;"><strong>_______________________________</strong></td>';
           }
           
        }
        
	
        
        html=html.replace('<th','<th style="border-top: 1px solid #00a9e0;border-bottom:1px solid #00a9e0;text-align:center;font-family: Arial, Helvetica, sans-serif;font-size:15px;" height="23"');
         //html=html.replace('<td', '<td style="border-bottom:1px solid #333; border-left:1px solid #333; border-right:1px solid #333;"');
        //html=html.replace('<td ', '<td style="border-top: 1px solid #00a9e0;border-bottom:1px solid #00a9e0;border-left:1px solid #00a9e0;border-right:1px solid #00a9e0;"');
        // html=html.replace('<th style="border-top: 1px solid #00a9e0;border-bottom:1px solid #00a9e0;>Producto</th>', 'style=border-left:1px solid #00a9e0;>Producto');
         if(templateName==NOMBRE_PLANTILLA){
            //htmL=html.replace('YYY',)
             html=html.replace(formato, tabla);
            html=html.replace(formato2,tabla2);
            html=html.replace('null', 'fdsfsfsdf');
            html=html.replace('XX',' '+String.valueOf(total));
            html=html.replace('total12',String.valueOf(total12+total));
            html=html.replace('total24',String.valueOf(total24+total));
             //html=html.replace(sku, sku2);
            }
      if(templateName==NOMBRE_Seguro){
          //html=html.replace('null', '');
            html=html.replace(formatoSG, tabla3); 
            html=html.replace(formatoSG1, tabla4);
            html=html.replace('Date',+string.valueOf(formattedDate1));
            html= html.replace('XXX',+string.valueOf(tdPrice));
          html= html.replace('AAAA',+string.valueOf(sgPrice));
          html=html.replace('ZZZ', +string.valueOf(sgPrice+tdPrice));
          if(discount>0)
              html=html.replace('YYY',string.valueOf(tdPrice-(tdPrice*discount)/100));
          else
              html=html.replace('YYY',string.valueOf(tdPrice));
      }
        html=html.replace('null', '________');
        system.debug('Discount: '+discount);
        system.debug('Price: '+tdPrice);
        system.debug('Total: '+total);
        system.debug('Tabla: '+tabla); 

    }    
}