public class DSALES_GetDocumentBody {
    public static String blodBody(String idSiniestro, String archivo) {
        String query = 'SELECT Id, ContentDocument.title, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =\''+idSiniestro+'\' and ContentDocument.title =\''+archivo+'\' LIMIT 1';
        ContentDocumentLink idvar = DataBase.query(query);
        ContentVersion v = [SELECT ContentDocumentId, VersionData FROM ContentVersion where ContentDocumentId =:idvar.ContentDocumentId];
        String documento = EncodingUtil.base64Encode(v.VersionData);
        return documento;
        
    }
}