public class DSALES_Utility {
    public static final String NUMERO_CLIENTE_GENERICO = '90001';
    
    public static String getEndpoint(String nombreURL){
        try{
            DSALES_RutaIntegracion__mdt ruta = DSALES_RutaIntegracion__mdt.getInstance(nombreURL); 
            return ruta.DSALES_Endpoint__c;
        }catch(Exception ex){
            return null;
        }
    }

}