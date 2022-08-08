public class DSALES_MatrizCotizacion {    
    public static String clonarMatriz(Id recordId){       
        List<String> listaCampo = Clonar_Matriz.getField('DSales_Matriz_GEX__c');
        String query = 'Select ';
        for(Integer i = 0; i < listaCampo.size(); i++){
            query += listaCampo[i]+',';  
        }
        
        query = query.substring(0, query.length()-1);
        query += ' From DSales_Matriz_GEX__c WHERE Id =: recordId'; 
        DSales_Matriz_GEX__c matrizClone = Database.query(query);
        matrizClone.Id = matrizClone.DSALES_CloneMatriz__c;
        matrizClone.DSALES_EsClone__c = false;
        matrizClone.DSALES_CloneMatriz__c = recordId;
        update matrizClone;
        clonarMatrizItem(matrizClone.Id,recordId);
        return matrizClone.Id;
        
    }
    
    public static void clonarMatrizItem(Id originalId, Id recordId){       
        List<String> listaCampo = Clonar_Matriz.getField('DSALES_Matriz_de_Cotizacion__c');
        String query = 'Select ';
        for(Integer i = 0; i < listaCampo.size(); i++){
            query += listaCampo[i]+',';  
        }
        
        query = query.substring(0, query.length()-1);
        DSales_Matriz_GEX__c ds = new DSales_Matriz_GEX__c();
        
        query += ' From DSALES_Matriz_de_Cotizacion__c WHERE DSales_Matriz_GEX__c =: recordId'; 
        List <DSALES_Matriz_de_Cotizacion__c> listMatrizItem = Database.query(query);
        for(DSALES_Matriz_de_Cotizacion__c matrizItem:listMatrizItem )	{
            matrizItem.DSALES_MatrizItemClone__c=matrizItem.Id;
            matrizItem.Id=null;
            matrizItem.DSales_Matriz_GEX__c=originalId;
        }
        Database.upsert(listMatrizItem,DSALES_Matriz_de_Cotizacion__c.DSALES_MatrizItemClone__c) ;  
        compararEliminados(originalId,recordId);
    }
    
    public static void compararEliminados(Id original, Id clone){
        //Los que se eliminaron en el clon, borrarlos en la original.
        ///si está en la original y no en el cln, se borran
        Map<String,DSALES_Matriz_de_Cotizacion__c> mapOriginal= new Map<String,DSALES_Matriz_de_Cotizacion__c>();
        Map<String,DSALES_Matriz_de_Cotizacion__c> mapClone= new Map<String,DSALES_Matriz_de_Cotizacion__c>();
        List<DSALES_Matriz_de_Cotizacion__c> listaARemover = new List<DSALES_Matriz_de_Cotizacion__c>();
        for(DSALES_Matriz_de_Cotizacion__c item:[SELECT id,DSALES_MatrizItemClone__c From DSALES_Matriz_de_Cotizacion__c WHERE DSales_Matriz_GEX__c =: original]){
            mapOriginal.put(item.DSALES_MatrizItemClone__c,item);
        }
        
        for(DSALES_Matriz_de_Cotizacion__c item:[SELECT id,DSales_Matriz_GEX__c From DSALES_Matriz_de_Cotizacion__c WHERE DSales_Matriz_GEX__c =: clone]){
            mapClone.put(item.Id,item);
        }
        for( String item:mapOriginal.keySet()){
            if(!mapClone.containsKey(item)){
                listaARemover.add(mapOriginal.get(item));
            }      
        }
        delete  listaARemover;
    }
    
}