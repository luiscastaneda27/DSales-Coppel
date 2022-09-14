public class DSALES_CreateDocument {
    public static ContentVersion CreaDocument(String fileBody, String fileName ) {
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.ContentDocumentId = null;
        Blob blo = EncodingUtil.base64Decode(fileBody);
        cv.VersionData = blo; // Variable del archivo tipo Blob
        cv.Title = fileName; // variable nombre del archivo tipo string
        cv.PathOnClient = fileName; // variable nombre del archivo tipo string
        return cv;
    }

    public static ContentDocumentLink Crealink(ContentVersion cv, Id siniestroId ) {
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = siniestroId; // id del caso
        cdl.ShareType = 'V';
        return cdl;
    }

}