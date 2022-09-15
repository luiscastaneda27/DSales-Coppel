@isTest
global class DSALES_MockHttpResponsePolizaTest implements HttpCalloutMock{
	
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //request.setEndpoint('https://67d6fa81-6ca4-4bdd-bdb3-7855323d5ed9.mock.pstmn.io');
        response.setBody('{"code": 201,"success": true,"data": { "policy_url": "pruebas.invalid/nose.pdf","policy_status": "Vigente", "policy_name": "Pruebas", "policy_number": "0000","policy_effectivedate": "2022-09-15 10:10:56", "policy_expirationdate": "2022-09-15 10:10:56","policy_netpremium": "21", "policy_totalpremium": "29","policy_shippingcosts": "19", "policy_iva": "12" }}');
        response.setStatusCode(200);
        System.assertEquals('POST', request.getMethod());
        return response;
    }
}