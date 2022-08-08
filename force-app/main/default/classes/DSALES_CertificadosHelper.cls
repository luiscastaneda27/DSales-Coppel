public class DSALES_CertificadosHelper {
    
    
    private static final String TEMPLETE_NAME = 'DSALES_CertificadoGEX';  
    private static final String DIRECCION_CORREO = 'atencion@coppel.com';  
    
    @Future(callout=true)
    public static void envioCertificado(String jsonString){
        try{
            List<DSALES_Certificado__c> sObjectList = (List<DSALES_Certificado__c>) JSON.deserialize(jsonString, List<DSALES_Certificado__c>.class);
            Map<String, Account> mapAccount = new Map<String, Account>();
            for(DSALES_Certificado__c item: sObjectList){
                mapAccount.put(item.DSALES_Cliente__c, new Account());
            }
            for(Account item: [Select Id,Name,PersonContactId, PersonEmail from Account where Id in : mapAccount.keySet()]){
                mapAccount.put(item.Id, item);
            }
            EmailTemplate templete = [Select Id, HtmlValue, Subject from EmailTemplate Where DeveloperName = :TEMPLETE_NAME];
            OrgWideEmailAddress owa = [Select Id,Address From OrgWideEmailAddress Where Address = :DIRECCION_CORREO LIMIT 1];
            List<Messaging.SingleEmailMessage> MessageList = new List<Messaging.SingleEmailMessage>();
            for(DSALES_Certificado__c item: sObjectList){
                
                Account acc = mapAccount.get(item.DSALES_Cliente__c);
                item.DSALES_enviado__c = true;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new string[] {item.DSALES_E_mail__c});
                mail.setTemplateId(templete.Id);
                mail.setTargetObjectId(acc.PersonContactId);
                mail.setOrgWideEmailAddressId(owa.Id);
                
                Blob b = generarPFD(item.Id); 
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setContentType('application/pdf');
                efa.setInline(False);
                efa.setFileName('Certificado de Garantía Extendida.pdf');
                efa.setBody(b);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                MessageList.add(mail);  
            }
            Messaging.sendEmail(MessageList, false);
            update sObjectList;
            System.debug('Correo enviado');
        }catch(Exception ex){
            System.debug('Error: '+ex.getMessage() + ', Línea: '+ex.getLineNumber());
        }
    }
    
    public static Blob generarPFD(Id certificadoId){
        PageReference pdf = Page.DSALES_CertificadoPDF; 
        pdf.setRedirect(False);
        pdf.getParameters().put('certificadoId',certificadoId);
        Blob b; 
        if(!test.isRunningTest())
            b = pdf.getContent();
        else
            b = blob.valueOF('Test');
        return b;
    }
    
}