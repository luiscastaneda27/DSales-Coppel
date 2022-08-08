@isTest
public class DSALES_ControladorMatrizTiempo_Test {

    @testSetup
    static void testSetup(){
        DSales_Matriz_GEX__c matriz = new DSales_Matriz_GEX__c();
        matriz.Name = 'Temporal';
        matriz.DSALES_Tiempogex__c='1 año';
        insert matriz;   
    }
    
    @isTest
    static void DSALES_ControladorMatrizTiempo(){
        DSales_Matriz_GEX__c matriz = [Select Id from DSales_Matriz_GEX__c];
        DSALES_ControladorMatrizTiempo.getClone(matriz.Id);
        List<DSALES_ControladorMatrizTiempo.ResultWrapper> listMatrix =  DSALES_ControladorMatrizTiempo.getRecords(matriz.Id);
        
        DSALES_ControladorMatrizTiempo.MatrizTiempo mt = new DSALES_ControladorMatrizTiempo.MatrizTiempo();
        mt.anio = listMatrix[0].tiempo;
        listMatrix[0].listMatriz.add(mt);
        listMatrix[0].listMatriz.add(mt);
        listMatrix = DSALES_ControladorMatrizTiempo.actualizarRegistros(Json.serialize(listMatrix), matriz.Id);
        listMatrix[0].listMatriz[0].seleccionado = true;
        listMatrix = DSALES_ControladorMatrizTiempo.eliminarRegistros(Json.serialize(listMatrix[0].listMatriz), matriz.Id);
        System.assertEquals(listMatrix[0].listMatriz.size(), 1);
    }
}