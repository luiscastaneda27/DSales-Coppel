public class DSALES_ValidarClienteHelper {
    
   
    //quote has Client´s email & name
    
    public static void recepcionProductos(List<DSALES_CertificadoWrapper.CertificadoRequest>certificado, String quoteId)
    {
        if(certificado == null){
            List<QuoteLineItem>quoteLineMap= [SELECT id FROM QuoteLineItem WHERE QuoteId=:quoteId and Product2.DSales_Tipo_de_Producto__c='Servicio'];
            DELETE quoteLineMap;
            return; 
        } 
            Map<String,QuoteLineItem>quoteLineMap= new map<String,QuoteLineItem>();
            for(QuoteLineItem qt:[SELECT DSALES_SKU__c,Vigencia_meses__c,id FROM QuoteLineItem WHERE QuoteId=:quoteId and Product2.DSales_Tipo_de_Producto__c='Servicio'])
            {
                quoteLineMap.put(qt.DSALES_SKU__c + qt.Vigencia_meses__c,qt);
            }
            Integer meses;
            for(DSALES_CertificadoWrapper.CertificadoRequest certi: certificado)
            {
                meses=Integer.valueOf(certi.warranty_duration);
                if(quoteLineMap.containskey(certi.sku+meses))
                {
                    quoteLineMap.remove(certi.sku+meses);
                }
            }
            DELETE quoteLineMap.values();
            
        }
    
    public static void deleteTangibles(List<DSALES_AssetWrapper.AssetRequest> listAssets, String quoteId){
        Map<String,QuoteLineItem> quoteLineMapTang = new Map<String,QuoteLineItem>();
        for(QuoteLineItem qtTang:[SELECT DSALES_SKU__c,id FROM QuoteLineItem WHERE QuoteId=:quoteId and Product2.DSales_Tipo_de_Producto__c='Producto']){
            quoteLineMapTang.put(qtTang.DSALES_SKU__c,qtTang);
        }
        for(DSALES_AssetWrapper.AssetRequest assets :listAssets){
            if(quoteLineMapTang.containsKey(assets.sku)){
                quoteLineMapTang.remove(assets.sku);
            }
        }
        DELETE quoteLineMapTang.values();
    }
    
    /*public static void deleteTangibles(List<DSALES_AssetWrapper.AssetRequest>listAssets, String quoteId)
    {
        
        Map<String,QuoteLineItem>quoteLineMapTan= new map<String,QuoteLineItem>();
        for(QuoteLineItem qt:[SELECT DSALES_SKU__c,Vigencia_meses__c,id FROM QuoteLineItem WHERE QuoteId=:quoteId and Product2.DSales_Tipo_de_Producto__c='Producto'])
        {
            quoteLineMapTan.put(qt.DSALES_SKU__c + qt.Vigencia_meses__c,qt);
        }
     
    	Integer meses;
        for(DSALES_CertificadoWrapper.CertificadoRequest certi: certificado)
        {
            meses=Integer.valueOf(certi.warranty_duration);
            if(quoteLineMap.containskey(certi.sku+meses))
            {
                quoteLineMap.remove(certi.sku+meses);
            }
             
        }
        DELETE quoteLineMap.values();
       
    }*/
    /*
    public static String ValidarCliente(String quoteId)
    {
        String clienteId;
        Integer contadora=0;
        String email,name,accountNumber,telephone,Product2Id;
        //quoteId='0Q08J000000D4U2SAK';
        
        
        try{
            
            
            Quote coti = [Select id, DSALES_EmailNew__c, OpportunityId,Name FROM Quote WHERE Id=:quoteId];
            Opportunity oppor=[SELECT AccountId FROM Opportunity WHERE Id=:coti.OpportunityId LIMIT 1];
            system.debug('Su account Id es: '+oppor.AccountId);
            email=coti.DSALES_EmailNew__c;
            name=coti.Name;
            
            //if the client doesn´t exist, then create it.
            
            Account nameAccount=[SELECT Name FROM Account WHERE ID=:oppor.AccountId LIMIT 1];
            system.debug('Su account Id es: '+nameAccount.Name);
            //   if(pago.DSALES_Cliente__r.Name.Contains('90001'))
            
            if(nameAccount.Name.Contains(DSALES_Utility.NUMERO_CLIENTE_GENERICO))
            {
                
                List<Account> acc = [SELECT Id FROM Account WHERE Name=:Name OR PersonEmail=:email  LIMIT 1];

 
                if(acc.size()==0)
                {
                    RecordType record= [SELECT id FROM RECORDTYPE WHERE Name='Cuenta personal'];
                    Account cliente = new Account(RecordTypeId=''+record.Id,FirstName=Name,LastName=Name,PersonEmail=email,PersonMobilePhone=telephone);
                    insert cliente;
                    oppor.AccountId=cliente.Id;
                    clienteId=cliente.Id;
                    upsert oppor;
                    //Step 2
                    
                    system.debug('Si pasó, y el Id del nuevo cliente es: ' +cliente.Id);
                }
                else
                {
                    system.debug('Ya existe un cliente con el siguiente id: '+ acc[contadora].Id);
                    clienteId=acc[contadora].Id;
                    contadora++;
                    
                }
            }
            else
            {
                clienteId=oppor.AccountId;
            }
            
        }
        catch(Exception e)
        {
            system.debug('No pasó ');
            String message= e.getMessage() + ' '+e.getLineNumber() + ' '+e.getCause();
            System.debug(message);
        }
        
        return clienteId;
        
    }
    */
    //comparing QuoteLineItem products with Asset object 
   /* 
    public static void insertProduct(List<DSALES_AssetWrapper.AssetRequest> lstAsset, String accountId, String quoteId){
        List<QuoteLineItem> quotitem1 =  [SELECT Id, QuoteId, Product2Id, DSales_SKU_Producto__c FROM QuoteLineItem where QuoteId=:quoteId AND DSALES_ListaArticulo__c= 'Producto'];
        List<QuoteLineItem> lstItem1 = new  List<QuoteLineItem>();
        for(DSALES_AssetWrapper.AssetRequest ass: lstAsset ){
            for(QuoteLineItem item:quotitem1){
                if(item.DSales_SKU_Producto__c!= ass.sku){
                    ass.account_id=accountId;
                    QuoteLineItem cot = new QuoteLineItem();
                    cot.DSales_SKU_Producto__c= ass.sku;
                    cot.Vigencia_meses__c = ass.months;
                    lstItem1.add(cot);
                }
                
            } 
        }
        
        upsert lstItem1;
        System.debug('updated list of QuoteLineItem is------->' +lstItem1);
    }
    // Comparing QuoteLineItem service with Certificado object
    
    public static void insertService(List<DSALES_CertificadoWrapper.CertificadoRequest> lstcert, String quoteId, String accountId){
        List<QuoteLineItem> quotitem =  [SELECT Id, QuoteId, Product2Id, DSales_SKU_Producto__c FROM QuoteLineItem where QuoteId=:quoteId AND DSALES_ListaArticulo__c= 'Servicio'];
        List<QuoteLineItem> lstItem = new  List<QuoteLineItem>();
        List<QuoteLineItem> lstItem1 = new  List<QuoteLineItem>();
        
        for(DSALES_CertificadoWrapper.CertificadoRequest certificate: lstcert ){
            string monthsValidity= string.valueOf(certificate.warranty_duration);            
            for(QuoteLineItem item:quotitem){
                if(item.DSales_SKU_Producto__c== certificate.sku &&  item.Vigencia_meses__c!= monthsValidity){
                    lstItem1.add(item);
                } 
                else if(quotitem.size()== 0 || quotitem == null){
                    QuoteLineItem cot = new QuoteLineItem();
                    cot.DSales_SKU_Producto__c= certificate.sku;
                    cot.Vigencia_meses__c = monthsValidity;
                    lstItem.add(cot);
                }
            }
            
        }
        upsert lstItem;
        Delete lstItem1;
        System.debug('Updated list of QuoteLineItem is------->' +lstItem);        
        System.debug('Deleted list of QuoteLineItem is------->' +lstItem1);
        
        
    }  
    
*/    
}