@isTest
private  class DSALES_TipoVehiculoTest {

    @isTest static void testDSALES_TipoVehiculo() {
        // Set up a test request
        Id recordId = getTestTVId();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://coppelmx--pisysdev2.sandbox.my.salesforce.com/services/apexrest/TiposVehiculo/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        DSALES_TipoVehiculoRequest.getTipoVehiculo();
        
    }
    private static Id getTestTVId(){
        DSALES_Tipodevehculo__c tipoVehiculo = new DSALES_Tipodevehculo__c (Name = 'TestTipoUso',DSALES_Activo__c= true, DSALES_Descripcin__c='Hola');
        Insert tipoVehiculo;
        
        return tipoVehiculo.Id;
    }

}