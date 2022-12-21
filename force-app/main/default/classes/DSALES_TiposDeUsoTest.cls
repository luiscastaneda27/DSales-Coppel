@isTest
private  class DSALES_TiposDeUsoTest {

    @isTest static void testDSALES_TiposDeUso() {
        // Set up a test request
        Id recordId = getTestTUId();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://coppelmx--pisysdev2.sandbox.my.salesforce.com/services/apexrest/tiposUso/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        DSALES_TiposDeUsoRequest.getTiposDeUso();
        
    }
    private static Id getTestTUId(){
        DSALES_TipodeUso__c tipoUso = new DSALES_TipodeUso__c (Name = 'TestTipoUso',DSALES_Activo__c= true, DSALES_Descripcin__c='Hola');
        Insert tipoUso;
        
        return tipoUso.Id;
    }

}