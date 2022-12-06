public class DSALES_Utility {
    
    public static final String NUMERO_CLIENTE_GENERICO = '90001';
    public static final String BAD_REQUEST_MSJ = 'Malformed JSON: Expected';
    public static final String INTERNAL_ERROR_MSJ = 'Internal Error';
    public static final Integer BAD_REQUEST_CODE = 400;
    public static final Integer INTERNAL_ERROR_CODE = 500;
    
    public static String getEndpoint(String nombreURL){
        try{
            DSALES_RutaIntegracion__mdt ruta = DSALES_RutaIntegracion__mdt.getInstance(nombreURL); 
            return ruta.DSALES_Endpoint__c;
        }catch(Exception ex){
            return null;
        }
    }

}