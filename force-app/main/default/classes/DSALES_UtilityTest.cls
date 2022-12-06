@isTest
public class DSALES_UtilityTest {
    
    @isTest
    static void getEndpoint(){
        for(DSALES_RutaIntegracion__mdt item: [Select Developername from DSALES_RutaIntegracion__mdt limit 1]){
            DSALES_Utility.getEndpoint(item.Developername);
        }
        try{
            DSALES_Utility.getEndpoint(null);
        }catch(Exception ex){
            System.assertNotEquals(ex, null);
        }
    }

}