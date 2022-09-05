public class DSALES_GexCotizacionesHelper {
    private static final String TEMPLETE_NAME = 'DSALES_Cotizacion';  
    private static final String DIRECCION_CORREO = 'atencion@coppel.com';  
    
    @Future(callout=true)
    public static void envioCotizacionGex(String jsonString){
        try{
            System.debug('>>> response ' + jsonString);
            List<Quote> sObjectList = (List<Quote>) JSON.deserialize(jsonString, List<Quote>.class);
            Map<String, Account> mapAccount = new Map<String, Account>();
            for(Quote item: sObjectList){
                mapAccount.put(item.AccountId, new Account());
            }
            for(Account item: [Select Id,Name,PersonContactId, PersonEmail from Account where Id in : mapAccount.keySet()]){
                mapAccount.put(item.Id, item);
            }
            EmailTemplate templete = [Select Id, HtmlValue, Subject from EmailTemplate Where DeveloperName = :TEMPLETE_NAME];
            OrgWideEmailAddress owa = [Select Id,Address From OrgWideEmailAddress Where Address = :DIRECCION_CORREO LIMIT 1];
            List<Messaging.SingleEmailMessage> MessageList = new List<Messaging.SingleEmailMessage>();
            
            for(Quote item: sObjectList){     
                Account acc = mapAccount.get(item.AccountId); 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new string[] {item.DSALES_EmailCliente__c});
                system.debug('Email: '+item.DSALES_EmailCliente__c);
                mail.setHtmlBody(templete.HtmlValue);
                mail.setSubject(templete.Subject);
                mail.setOrgWideEmailAddressId(owa.Id);
                
                Blob b = generarPFD(item.Id); 
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setContentType('application/pdf');
                efa.setInline(False);
                efa.setFileName('CotizacionGEX.pdf');
                efa.setBody(b);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                MessageList.add(mail);  
            }
            Messaging.sendEmail(MessageList, false);
            System.debug('Correo enviado');
        }catch(Exception ex){
            System.debug('Error: '+ex.getMessage() + ', Línea: '+ex.getLineNumber());
        }
    }
    
    public static Blob generarPFD(Id quoteId){
        PageReference pdf = Page.DSALES_GexCot; 
        pdf.setRedirect(False);
        pdf.getParameters().put('quoteID',quoteId);
        Blob b; 
        if(!test.isRunningTest())
            b = pdf.getContent();
        else
            b = blob.valueOF('Test');
        return b;
    }
    
}