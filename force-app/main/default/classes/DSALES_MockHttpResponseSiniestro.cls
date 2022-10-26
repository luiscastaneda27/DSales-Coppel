@isTest
global class DSALES_MockHttpResponseSiniestro implements HttpCalloutMock{
    Integer opc;
    global DSALES_MockHttpResponseSiniestro(Integer opcr){
        opc = opcr;
    }
    	global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            if(opc == 1){        
                response.setBody('{ "ok": "true", "response": "true", "msg": "Nuevo Siniestro insertado", "siniestro": { "uid": "aswfewefwfewfewfe", "NumeroSiniestro": "04220504541" }}');
                response.setStatusCode(200);         
            }
            if(opc == 2){        
                response.setBody('{ "ok": "true", "response": "true", "msg": "Actualización de Siniestro correcta", "siniestro": { "uid": "aswfewefwfewfewfe", "NumeroSiniestro": "04223333333" } }');
                response.setStatusCode(200);         
            }
            if(opc == 3){        
                response.setBody('{ "uid": "aswfewefwfewfewfe", "Reporte": "057486122", "NumeroSiniestro": "04220504541", "TipoSiniestro": "Robo", "FechaSiniestro": "28/07/2022 16:40:23", "NombreConductor": "José Juan Resendiz Calavera ", "Causa": "Chocó", "Vehiculo": { "Descripcion": "MOTOCICLETA VENTO WORKMAN 125 CC", "Anio": "2022", "Placa": "123HDF", "Serie": "1234DFGERS92871WD" }, "Poliza": { "NumeroPoliza": "4240072338", "Inciso": "0001", "FechaInicioVigencia": "23/03/2022", "FechaFinVigencia": "22/03/2023", "NombreAsegurado": "Graciela Guzmán Arreola" }, "ComoOcurrio": "Se cayó y chocó", "Ubicacion": "Calle Orquideas 27", "Municipio": "Tampico", "Estado": "Tamaulipas", "Estatus": "Rechazado", "DocumentosVehiculo": { "Factura": "cadena a 64 bits del documento escaneado", "ContanciaBajaPlacas": "cadena a 64 bits del documento escaneado", "ComprobantesTenencia": [ { "Descripcion": "cadena a 64 bits del documento escaneado", "Comprobante": "cadena a 64 bits del documento escaneado", "IdComprobante": "cadena a 64 bits del documento escaneado" }, { "Descripcion": "cadena a 64 bits del documento escaneado", "Comprobante": "cadena a 64 bits del documento escaneado", "IdComprobante": "cadena a 64 bits del documento escaneado" } ], "CarpetaMP": "cadena a 64 bits del documento escaneado", "AcreditacionMP": "cadena a 64 bits del documento escaneado", "OficioLiberacionRobo": "cadena a 64 bits del documento escaneado" }, "DocumentosAsegurado": { "IdentificacionFrontal": "cadena a 64 bits del documento escaneado", "IdentificacionReverso": "cadena a 64 bits del documento escaneado", "ComprobanteDomicilio": "cadena a 64 bits del documento escaneado", "CURP": "cadena a 64 bits del documento escaneado", "PoderNotarial": "cadena a 64 bits del documento escaneado", "EncabezadoCuentaBancaria": "cadena a 64 bits del documento escaneado", "ConstanciaSituacionFiscal": "cadena a 64 bits del documento escaneado" }, "DocumentosAseguradora": { "CartaConsentimientoCFDI": "cadena a 64 bits del documento escaneado", "FormatoCompraVenta": "cadena a 64 bits del documento escaneado", "FormatoFiniquito": "cadena a 64 bits del documento escaneado" }, "salesforceid": "xxxxxxxxxxxxxx" }');
                response.setStatusCode(200);         
            }
            if(opc == 4){        
                response.setBody('{ "ok": "true", "estatus": "false", "rfc": "JUCE761023", "nombreContribuyente": "Juan José Castañeda Espinoza" }');
                response.setStatusCode(200);         
            }
            if(opc == 5){        
                response.setBody('{"ok":"true","estatus":"false","rfc":"JUCE761023","nombreContribuyente":"Juan José Castañeda Espinoza"}');
                response.setStatusCode(200);         
            }
            if(opc == 6){        
                response.setBody('{"code":201,"success":true,"data":{"police_id":"0","quote_id":"0606199820","payment_options_json":[{"value":"M","label":"Mensual"}],"insurance_premium":{"right":100.05,"commission":2,"surcharge":903.21,"net_premium":10752.49,"tax":1880.92},"receipts":[{"numbere":1,"start_date":"2022-09-10","end_date":"2022-10-10","net_premium":"896.05","total_premium":"50000","right":"100.05","recharge":"75.24","tax":"171.41","commission":"17.92"},{"number":2,"start_date":"2022-10-19","end_date":"2022-11-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":3,"start_date":"2022-11-19","end_date":"2022-12-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":4,"start_date":"2022-12-19","end_date":"2023-01-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":5,"start_date":"2023-01-19","end_date":"2023-02-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":6,"start_date":"2023-02-19","end_date":"2023-03-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":7,"start_date":"2023-03-19","end_date":"2023-04-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":8,"start_date":"2023-04-19","end_date":"2023-05-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":9,"start_date":"2023-05-19","end_date":"2023-06-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":10,"start_date":"2023-06-19","end_date":"2023-07-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":11,"start_date":"2023-07-19","end_date":"2023-08-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"},{"number":12,"start_date":"2023-08-19","end_date":"2023-09-19","net_premium":"896.04","total_premium":"1126.72","right":"0","recharge":"75.27","tax":"155.41","commission":"17.92"}],"company_logo":"https://storage.googleapis.com/inter-public-cloudstorage-prod/cocheseguro/static/Qualitas.svg"}}');
                response.setStatusCode(200);         
            }
            
            return response;
    }

}