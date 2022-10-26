@isTest
global class DSALES_MockHttpResponseSiniestroTest implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //request.setEndpoint('https://67d6fa81-6ca4-4bdd-bdb3-7855323d5ed9.mock.pstmn.io');
        response.setBody('{"ok": "true","response": "true","msg": "Actualización de Siniestro correcta","siniestro": { "uid": "1234567idwsd9221sqa","NumeroSiniestro": "04220504541"}}');
        response.setStatusCode(200);
        System.assertEquals('PUT', request.getMethod());
        return response;
    }
}