@isTest
global class DSALES_MockHttpResponseEndoso implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "uid": "f4sw543232adas8823sq2", "TipoEndoso": "Corrección de nombre", "NumeroPoliza": "4240072338", "FechaEndoso": "1991-02-15", "FechaAplicacionEndoso": "1991-02-15", "Estatus": "Rechazado", "ComentarioEstatus": "Aquí va el comentario que nos devuelve la Aseguradora", "salesforceid": "xxxxxxxxxxxxxx" }');
        response.setStatusCode(200);
        return response;
    }
}