public class DSALES_Utility {
    
    
    public static String getEndpoint(String nombreURL){
        try{
            DSALES_RutaIntegracion__mdt ruta = DSALES_RutaIntegracion__mdt.getInstance(nombreURL); 
            return ruta.DSALES_Endpoint__c;
        }catch(Exception ex){
            return null;
        }
    }

}