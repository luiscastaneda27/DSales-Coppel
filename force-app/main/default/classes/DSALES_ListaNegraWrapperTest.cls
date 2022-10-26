@isTest
public class DSALES_ListaNegraWrapperTest {
    @isTest 
    static void wrapperTestWS(){
        DSALES_ListaNegraWrapper.responseListaNegra op = new DSALES_ListaNegraWrapper.responseListaNegra();
		DSALES_ListaNegraWrapper.enviarListaNegra op2 = new DSALES_ListaNegraWrapper.enviarListaNegra(); 
        op.estatus='Autorizado';
        op.nombreContribuyente='JUan';
        op.ok='ok';
        op.rfc='ASFAA';
        op2.nombre='ok';
        op2.rfc='GFASfas';           
    }

}