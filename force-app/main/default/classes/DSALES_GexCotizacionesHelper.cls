public class DSALES_GexCotizacionesHelper {
    //SG Template
    private static final String TEMPLETE_NAME = 'Envi_de_cotizaci_n_1660589806562';
    //GEX
    private static final String GEX_Template = 'DSALES_Cotizacion';             // Namrata added
    
    
    private static final String DIRECCION_CORREO = 'atencion@coppel.com';  
    
    @Future(callout=true)
    public static void envioCotizacionGex(String jsonString, String quoteOld){
        try{
            System.debug('>>> response ' + jsonString);
            List<Quote> sObjectList = (List<Quote>) JSON.deserialize(jsonString, List<Quote>.class);
            Map<Id,Quote> mapQuote= (Map<Id,Quote>) JSON.deserialize(quoteOld, Map<Id,Quote>.class);
            Map<String, Account> mapAccount = new Map<String, Account>();
            
            for(Quote item: sObjectList){
                mapAccount.put(item.AccountId, new Account());
                
                
                
            }
            for(Account item: [Select Id,Name,PersonContactId, PersonEmail from Account where Id in : mapAccount.keySet()]){
                mapAccount.put(item.Id, item);
            }
            EmailTemplate templete = [Select Id, HtmlValue, Subject, DeveloperName from EmailTemplate Where DeveloperName = :TEMPLETE_NAME];
            system.debug('Template name------->' +templete.DeveloperName);
            EmailTemplate templeteGEX = [Select Id, HtmlValue, Subject, DeveloperName from EmailTemplate Where DeveloperName = :GEX_Template];     // Namrata added
            system.debug('Template name------->'  +templeteGEX.DeveloperName);
            OrgWideEmailAddress owa = [Select Id,Address From OrgWideEmailAddress Where Address = :DIRECCION_CORREO LIMIT 1];
            
            List<Messaging.SingleEmailMessage> MessageList = new List<Messaging.SingleEmailMessage>();
            
            for(Quote item: sObjectList){
                if(item.DSALES_Enviarcotizacion__c==true && mapQuote.get(item.Id).DSALES_Enviarcotizacion__c==false)
                {
                    
                    system.debug('Entró');
                    String correo = item.DSALES_Contado__c ? item.DSALES_EmailNew__c : item.Email ;
                    Account acc = mapAccount.get(item.AccountId); 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new string[] {correo});
                    system.debug('Email: '+correo);
                    //  Namrata changes start
                    RECORDTYPE motos= [SELECT Id, Name FROM RECORDTYPE WHERE Id=:item.RecordTypeId ];
                    if(motos.Name=='Venta de Seguro de Motos'){          
                        mail.setHtmlBody(templete.HtmlValue);
                        mail.setSubject(templete.Subject);
                    }
                    else if(motos.Name=='Venta de Garantía Extendida'){
                        mail.setHtmlBody(templeteGEX.HtmlValue);
                        mail.setSubject(templeteGEX.Subject);
                    }  
                    //Namrata changes end
                    mail.setOrgWideEmailAddressId(owa.Id);
                    
                    Blob b = generarPFD(item.Id); 
                    
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setContentType('application/pdf');
                    efa.setInline(False);
                    efa.setFileName('Cotización.pdf');
                    efa.setBody(b);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                    MessageList.add(mail); 
                }
                else
                {
                    system.debug('NO Entró');
                }
            }
            if(MessageList.Size()!=0)
                Messaging.sendEmail(MessageList, false);
            System.debug('Correo enviado');
        }catch(Exception ex){
            System.debug('Error: '+ex.getMessage() + ', Línea: '+ex.getLineNumber());
        }
    }
    
    public static Blob generarPFD(Id quoteId){
        PageReference pdf = Page.Cotizacion; 
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