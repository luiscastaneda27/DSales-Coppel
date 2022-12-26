@isTest
private  class DSALES_TipoSeguroRequestTest {

    @isTest static void testDSALES_TipoSeguro() {
        // Set up a test request
        Id recordId = getTestTSId();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://coppelmx--pisysdev2.sandbox.my.salesforce.com/services/apexrest/tipoSeguro/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        DSALES_TipoSeguroRequest.getTipoSeguro();
        
    }
    private static Id getTestTSId(){
        Product2 tipoSeguro = new Product2 (Name = 'TestTipoSeguro',IsActive= true, DSales_Tipo_de_Producto__c= 'Seguro');
        Insert tiposeguro;
        
        return tipoSeguro.Id;
    }

}