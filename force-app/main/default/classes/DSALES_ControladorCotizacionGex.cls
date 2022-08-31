public class DSALES_ControladorCotizacionGex {
    
    
    public String html{get;set;}
    public String email{get;set;}
    private static final String NOMBRE_OBJETO = 'Quote';
    private static final String NOMBRE_OBJETO2 = 'QuoteLineItem'; 
    private static final String NOMBRE_PLANTILLA = 'Cotizacion Gex';
    private static final String NOMBRE_DATE = 'DATE';
    private static final String NOMBRE_DOUBLE = 'DOUBLE';
    
    public DSALES_ControladorCotizacionGex(){
        
        String recordId = ApexPages.currentPage().getParameters().get('quoteId');
        
        //html = [Select Id, HtmlValue, Subject from EmailTemplate Where DeveloperName = :NOMBRE_PLANTILLA].HtmlValue;
        //If(String.ValueOf([SELECT RecordTypeId FROM QUOTE WHERE ID=:recordId LIMIT 1])=='0128J0000008WY6QAM')
        //{
        html = [select Id, DSALES_Plantilla__c  from DSALES_Generador__c Where Name = :NOMBRE_PLANTILLA LIMIT 1].DSALES_Plantilla__c;    
        //}
        
        email=[SELECT  DSALES_EmailCliente__c,Name,Id FROM Quote WHERE ID=:recordId].DSales_EmailCliente__c;
        if(email!=null)
        {
            html=html.replace('DSALES_emailCliente__C', email);  
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
        formato+='<td colspan="1" rowspan="1">$30,299</td>';
        formato+='</tr>';
        
        String formato2='<tr>';
        formato2+='<td colspan="1" rowspan="1">DSALES_NombreProducto__c</td>';
        formato2+='<td colspan="1" rowspan="1">DSALES_SKU__c</td>';
        formato2+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formato2+='<td colspan="1" rowspan="1">QuoteLineItem.UnitPrice</td>';
        formato2+='<td colspan="1" rowspan="1">8000</td>';
        formato2+='</tr>';
        String tdTotal='<tr>';
        tdTotal+='<td colspan="1" rowspan="1">Total</td>';
        tdTotal+='<td colspan="1" rowspan="1">&nbsp;</td>';
        tdTotal+='<td colspan="1" rowspan="1">&nbsp;</td>';
        tdTotal+='<td colspan="1" rowspan="1">16000</td>';
        tdTotal+='<td colspan="1" rowspan="1">8000</td>';
        tdTotal+='</tr>';
        String tdTotalRem='';
        String tabla='';
        String tabla2='';
        double price=0;
        for(QuoteLineItem quote: cotiLine)
        {
                            
            String sku='';
            String skuArray='';
            if(String.isBlank(quote.DSALES_SKU__c))
                sku='';
            else
                sku=quote.DSALES_SKU__c;
            String formattedDate='';
            
            if(quote.DSALES_ListaArticulo__c=='Producto')
            {
                skuArray+=sku;
                tabla+='<tr>';
                tabla+='<td colspan="1" rowspan="1">'+ quote.DSALES_NombreProducto__c+ '<br/>'+'<span style="color:#838383">'+ sku+'</span>'+'</td>';
                tabla+='<td colspan="1" rowspan="1">'+quote.Quantity+'</td>';
                tabla+='<td colspan="1" rowspan="1">'+quote.UnitPrice+'</td>';
                price=quote.UnitPrice;
                if(quote.DSALES_Fechadecompra__c!=null)
                    formattedDate=quote.DSALES_Fechadecompra__c.format();
                tabla+='<td colspan="1" rowspan="1">'+formattedDate+'</td>';
                tabla+='<td colspan="1" rowspan="1">'+quote.totalPrice+'</td>';
                if(String.valueOf(quote.DSALES_Fechadecompra__c)==null)
                    total+=quote.TotalPrice;
                tabla+='</tr>';
            }	
            
            
            if(quote.DSALES_ListaArticulo__c=='GEX'){
                
                tabla2+='<tr>';
                tabla2+='<td colspan="1" rowspan="1">'+quote.DSALES_NombreProducto__c+'</td>';
                
                tabla2+='<td colspan="1" rowspan="1">'+sku+'</td>';
               sku=sku.replace('-GEX', '');
                if(skuArray==sku)
                {
                    tabla2+='<td colspan="1" rowspan="1">'+price+'</td>';
                }
                else
                {
                    tabla2+='<td colspan="1" rowspan="1">'+price+'</td>';
                }
                
                if(quote.Vigencia_meses__c=='12')
                {
                    tabla2+='<td colspan="1" rowspan="1">'+quote.listPrice+'</td>';
                    total12+=quote.ListPrice;
                    tabla2+='<td colspan="1" rowspan="1">'+'</td>';    
                }
                else if (quote.Vigencia_meses__c=='24')
                {
                    tabla2+='<td colspan="1" rowspan="1">'+'</td>';
                    tabla2+='<td colspan="1" rowspan="1">'+quote.listPrice+'</td>';  
                    total24+=quote.ListPrice;
                }
                else 
                {
                    tabla2+='<td colspan="1" rowspan="1">'+'</td>';
                    tabla2+='<td colspan="1" rowspan="1">'+'</td>'; 
                }
                tabla2+='</tr>';
                // tabla2+='<tr>';
            }
            
            
            
            
        }
       
        html=html.replace('<th','<th style="border:solid; color:#00a9e0;"');
        html=html.replace(formato, tabla);
        html=html.replace(formato2,tabla2);
        html=html.replace('null', '');
        html=html.replace('XX',' '+String.valueOf(total));
        html=html.replace('total12',String.valueOf(total12));
        html=html.replace('total24',String.valueOf(total24));
        // html=html.replace(sku, sku2);
        
        
        system.debug('Total: '+total);
        system.debug('Tabla: '+tabla);
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
    
    public static String definirCampos(QuoteLineItem quote){
        String html='';
        switch on quote.DSALES_ListaArticulo__c{
            
            when 'Producto'
            {
                
            }
            when 'GEX'
            {
                
            }
            when 'Seguro Motos'
            {
                
            }
        }
        return html;
        
    }
    
    
}