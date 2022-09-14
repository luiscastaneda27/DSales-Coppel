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
            
            return response;
    }

}