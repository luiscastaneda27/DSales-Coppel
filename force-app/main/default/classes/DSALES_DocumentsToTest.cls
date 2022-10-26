public class DSALES_DocumentsToTest {
	public static ContentVersion CrearDocumentos(String datos, String name ) {
        ContentVersion content = new ContentVersion();
        content.ContentLocation = 'S';
        content.ContentDocumentId = null;
        Blob bodyBlob = EncodingUtil.base64Decode(datos);
        content.VersionData = bodyBlob; 
        content.Title = name; 
        content.PathOnClient = name + '.pdf'; 
        content.origin = 'H';
        return content;
        
    }
    
    public static ContentDocumentLink documentLink(ContentVersion content, String idSin ) {
        ContentDocumentLink doc = new ContentDocumentLink();
        doc.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: content.Id].ContentDocumentId;
        doc.LinkedEntityId = idSin;
        doc.ShareType = 'V';
        return doc;
    }
}