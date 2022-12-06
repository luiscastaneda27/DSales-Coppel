public class DSALES_ControladorMatrizTiempo {
    
    
    @AuraEnabled
    public static List<ResultWrapper> getRecords(String recordId) {
        List<ResultWrapper> resultado = new List<ResultWrapper>();
        Map<String, String> mapMatrizItem = new Map<String, String>();
        List<String> listMatrizItem = new List<String>();
        DSales_Matriz_GEX__c matriz = [Select DSALES_Tiempogex__c, DSALES_EsClone__c  from DSales_Matriz_GEX__c Where Id =:recordId];
        Map<String, ResultWrapper> mapMatriz = getPicklistOptions('DSALES_Matriz_de_Cotizacion__c', 'DSALES_Tiempo_de_Garantia_Extendida_GEX__c', matriz.DSALES_Tiempogex__c);
        for(DSALES_Matriz_de_Cotizacion__c item : 
            [Select DSALES_MatrizItemClone__c  from DSALES_Matriz_de_Cotizacion__c
             where DSales_Matriz_GEX__c = :recordId and DSales_Matriz_GEX__r.DSALES_EsClone__c = false
             and DSALES_MatrizItemClone__c != null]){
                 listMatrizItem.add(item.DSALES_MatrizItemClone__c);
             }
        for(DSALES_Matriz_de_Cotizacion__c item : 
            [Select  Id, Name from DSALES_Matriz_de_Cotizacion__c
             where Id in :listMatrizItem]){
                 mapMatrizItem.put(item.Id,  item.Name);
             }
        for(DSALES_Matriz_de_Cotizacion__c item : 
            [Select DSALES_Rango_interior_GEX__c , DSALES_Rango_Superior_GEX__c, Id,
             DSALES_Tiempo_de_Garantia_Extendida_GEX__c, Name, DSALES_ID_Matriz_GEX__c,
             SALES_Precio_GEX__c, DSALES_MatrizItemClone__c  
             from DSALES_Matriz_de_Cotizacion__c
             where DSales_Matriz_GEX__c = :recordId
             order by DSALES_Rango_interior_GEX__c]){
                 ResultWrapper mat = mapMatriz.get(item.DSALES_Tiempo_de_Garantia_Extendida_GEX__c);
                 MatrizTiempo mt = new MatrizTiempo();
                 mt.codigo = item.Name;
                 mt.matrizId = item.Id;
                 mt.rangoMenor = item.DSALES_Rango_interior_GEX__c;
                 mt.rangoMayor = item.DSALES_Rango_Superior_GEX__c;
                 mt.precio = item.SALES_Precio_GEX__c;
                 mt.anio = item.DSALES_Tiempo_de_Garantia_Extendida_GEX__c;
                 mt.seleccionado = false;
                 mt.index = mat.listMatriz.size();
                 if(mapMatrizItem.containsKey(item.DSALES_MatrizItemClone__c) ){
                     mt.codigo = mapMatrizItem.get(item.DSALES_MatrizItemClone__c);
                 }
                 mat.listMatriz.add(mt);
                 mapMatriz.put(item.DSALES_Tiempo_de_Garantia_Extendida_GEX__c, mat);
             }
        for(String item: mapMatriz.keySet()){
            resultado.add(mapMatriz.get(item));
        }
        return resultado;
    }
    
     @AuraEnabled
    public static DSales_Matriz_GEX__c getClone(String recordId) {
        DSales_Matriz_GEX__c matriz = [Select DSALES_EsClone__c, DSALES_CloneMatriz__c from DSales_Matriz_GEX__c Where Id =:recordId];
        return matriz;
    }
    
    @AuraEnabled
    public static List<ResultWrapper> actualizarRegistros(String jsonString, String recordId) {
        List<ResultWrapper> resultado = (List<ResultWrapper>) Json.deserialize(jsonString, List<ResultWrapper>.class);
        List<DSALES_Matriz_de_Cotizacion__c> listMatriz = new List<DSALES_Matriz_de_Cotizacion__c>();
        for(ResultWrapper item: resultado){
            for(MatrizTiempo mt : item.listMatriz){
                DSALES_Matriz_de_Cotizacion__c matriz = new DSALES_Matriz_de_Cotizacion__c();
                matriz.Id = mt.matrizId;
                matriz.DSALES_Rango_interior_GEX__c = mt.rangoMenor;
                matriz.DSALES_Rango_Superior_GEX__c = mt.rangoMayor;
                matriz.SALES_Precio_GEX__c = mt.precio;
                matriz.DSALES_Tiempo_de_Garantia_Extendida_GEX__c = mt.anio;
                if(matriz.Id == null){
                    matriz.DSales_Matriz_GEX__c = recordId;
                }
                listMatriz.add(matriz);
            }
        }
        upsert listMatriz;
        return getRecords(recordId);
    }
    
    @AuraEnabled
    public static List<ResultWrapper> eliminarRegistros(String jsonString, String recordId) {
        List<MatrizTiempo> resultado = (List<MatrizTiempo>) Json.deserialize(jsonString, List<MatrizTiempo>.class);
        List<DSALES_Matriz_de_Cotizacion__c> listMatriz = new List<DSALES_Matriz_de_Cotizacion__c>();
        for(MatrizTiempo item: resultado){
            if(item.seleccionado && item.matrizId != null){
                listMatriz.add(new DSALES_Matriz_de_Cotizacion__c(Id = item.matrizId));
            }
        }
        delete listMatriz;
        return getRecords(recordId);
    }
    
    public static Map<String, ResultWrapper> getPicklistOptions(String objApiName, String fieldApiName, String tiempo){
        Map<String, ResultWrapper> mapMatriz = new Map<String, ResultWrapper>();
        SObjectType objectType = Schema.getGlobalDescribe().get(objApiName);
        List<Schema.PicklistEntry> ple = objectType.getDescribe()
            .fields.getMap()
            .get(fieldApiName)
            .getDescribe().getPickListValues();
        for(Schema.PicklistEntry entry : ple)  {
            ResultWrapper m = new ResultWrapper();
            m.tiempo = entry.getValue();
            m.listMatriz = new List<MatrizTiempo>();
            mapMatriz.put(entry.getValue(), m);
            if(tiempo == entry.getValue()){
                return mapMatriz;   
            }
        }
        return mapMatriz;
    }
    
    
    public class ResultWrapper{
        @AuraEnabled public String tiempo {get;set;}
        @AuraEnabled public List<MatrizTiempo> listMatriz {get;set;}
    }
    
    public class MatrizTiempo{
        @AuraEnabled public String matrizId {get;set;}
        @AuraEnabled public String codigo {get;set;}
        @AuraEnabled public String anio {get;set;}
        @AuraEnabled public Decimal rangoMenor {get;set;}
        @AuraEnabled public Decimal rangoMayor {get;set;}
        @AuraEnabled public Decimal precio {get;set;}
        @AuraEnabled public Integer index {get;set;}
        @AuraEnabled public Boolean seleccionado {get;set;}
    }
    
    /*public class ClaseClone{
        @AuraEnabled public Boolean esClone {get;set;}
    }*/
    
}