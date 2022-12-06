public class DSALES_MatrizHelper {

    public static void crearClon(List<DSales_Matriz_GEX__c> records){
        for(DSales_Matriz_GEX__c item: records){
            if(!item.DSALES_EsClone__c){
                DSALES_ClonarMatriz.clonarMatriz(item.Id);
            }
        }
    }
}