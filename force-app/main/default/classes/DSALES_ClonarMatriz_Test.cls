@isTest
public class DSALES_ClonarMatriz_Test {
   
    @testSetup
    static void testSetup(){
        DSales_Matriz_GEX__c temporal = new DSales_Matriz_GEX__c();
        temporal.Name = 'Temporal';
        temporal.DSALES_Tiempogex__c='1 año';
        insert temporal;
        
        DSALES_Matriz_de_Cotizacion__c item = new DSALES_Matriz_de_Cotizacion__c();
        item.DSALES_Rango_interior_GEX__c = 12;
        item.DSALES_Rango_Superior_GEX__c = 23;
        item.DSales_Matriz_GEX__c = temporal.Id;
        insert item;    
    }
    
    @isTest
    static void clonarMatriz(){
        DSales_Matriz_GEX__c tempo =[SELECT Name, Id FROM DSales_Matriz_GEX__c LIMIT 1];
        DSALES_ClonarMatriz.getClone(tempo.Id);
        String idClon = DSALES_ClonarMatriz.clonarMatriz(tempo.Id);
        DSALES_Matriz_de_Cotizacion__c item = new DSALES_Matriz_de_Cotizacion__c();
        item.DSALES_Rango_interior_GEX__c = 12;
        item.DSALES_Rango_Superior_GEX__c = 23;
        item.DSales_Matriz_GEX__c = idClon;
        insert item;
       	String idOriginal = DSALES_ClonarMatriz.actualizarMatrizOriginal(idClon);
        System.assertEquals(idOriginal, tempo.Id);
    }
}