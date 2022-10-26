@isTest
global class DSALES_MockHttpResponsePolizaTest implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        if(request.getEndpoint().endsWith('/polizaNueva')){
            
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"code": 201,"success": true,"data": {"payment_data": {"data": { "emission_id": "Xn9I9HUyu3uZVnXPkkd3","tracking_id": "92f9db42-a675-46cd-b772-5f5afc775040","policy_number": "044240108109000000","insured_data": {"policy": "044240108109000000","start_date": "2022-09-20","end_date": "2023-09-20","emission_date": "2022-09-20","vehicle_summ": "2825.13"},"value_resume": {"net_premium": "2825.13","total_premium": "3393.21","right": "100.05","tax": "468.03"}}}}}');
            response.setStatusCode(200);
            System.assertEquals('POST', request.getMethod());
            return response;
        }
        if(request.getEndpoint().endsWith('/getPdf')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "code": 201,"success": true, "data": { "policy_url": "https://storage.googleapis.com/inter-connect-prod.appspot.com/policies/111154194.pdf?GoogleAccessId=inter-connect-prod%40appspot.gserviceaccount.com&Expires=16447039200&Signature=bxjm1ftSKcO7DfzqhcXALXFYCIbOELkL3zndIXs380P2lPdKRau0IQEmy8leuKlU%2BagkB0crzJIjCEc5mAUFUdj%2BlinSFtD5Dcwc9faOlopjs%2BGqxvFht%2BJaL1Ob7zWLkUJ2J%2F04dttAhnoW759CFE5aLv1iiOoEt6nocnqHk7Z0jAagM194N6LPj0N9Xk36j%2BjUarlYBVVVkddUKbZnLxp7HsOhPz3HEYXt1iBXzDBczvBwrOW%2BKlGoNJzaQNdTn6kxu%2FXy8L9tG4uOrWyRdjUeeTp3V9D5CExAkM85bvsgrGEzxHN4T2ARsVK104Bi1y6rgWhUKUwXuaMtfNWr3Q%3D%3D"}}');
            response.setStatusCode(200);
            System.assertEquals('POST', request.getMethod());
            return response;
        }
        if(request.getEndpoint().endsWith('/actualizarSiniestro')){
            response.setHeader('Content-Type', 'application/json');
            //request.setEndpoint('https://67d6fa81-6ca4-4bdd-bdb3-7855323d5ed9.mock.pstmn.io');
            response.setBody('{"ok": "true","response": "true","msg": "Actualización de Siniestro correcta","siniestro": { "uid": "1234567idwsd9221sqa","NumeroSiniestro": "04220504541"}}');
            response.setStatusCode(200);
            System.assertEquals('PUT', request.getMethod());
            return response;
            
        }
        if(request.getEndpoint().endsWith('/sendPdf')){
            response.setHeader('Content-Type', 'application/json');
            //request.setEndpoint('https://67d6fa81-6ca4-4bdd-bdb3-7855323d5ed9.mock.pstmn.io');
            response.setBody('{"code": 201,"success": true,"message": "registro de url de pdf correcto"}');
            response.setStatusCode(200);
            System.assertEquals('POST', request.getMethod());
            return response;
        }
        else{
            return null;
        }
            
        
        
       
    }
}