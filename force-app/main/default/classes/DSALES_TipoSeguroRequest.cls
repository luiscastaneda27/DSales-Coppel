@RestResource(urlMapping='/tipoSeguro/*')
global with sharing class DSALES_TipoSeguroRequest {
    @HttpGet
    global static TipoSeguroResponse getTipoSeguro() {
        TipoSeguroResponse responsePayload = new TipoSeguroResponse();
        
        responsePayload.exitoso = true;

        try { 
            list<Product2> tiposDeSeguro = [SELECT Id, Name, IsActive  FROM Product2 
            where DSales_Tipo_de_Producto__c= 'Seguro' and IsActive = true];
            list<TipoSeguro> tipoListObj = new list<TipoSeguro>();

            for (Product2 mapTS : tiposDeSeguro ) {

                TipoSeguro ts = new TipoSeguro();

                ts.id = mapTS.id;
                ts.nombre = mapTS.Name;
                ts.activo = mapTS.IsActive;
                
                
                tipoListObj.add(ts);

                //responsePayload.data.add(tu);
                
            }
            responsePayload.data = tipoListObj;

            

        
        }catch(Exception e){
            responsePayload.exitoso =false;
            responsePayload.mensaje_error= DSALES_Utility.INTERNAL_ERROR_MSJ;
            responsePayload.codigo_error= DSALES_Utility.INTERNAL_ERROR_CODE; 
        }
        
        return responsePayload;

    }


        global class TipoSeguro{
            global String id {get;set;}
            global Boolean activo{get;set;}
            global String nombre{get;set;}
            
       
        }
        global class TipoSeguroResponse{ 
            global Boolean exitoso {get;set;}
            global String mensaje_error {get;set;}
            global Integer codigo_error{get;set;}
            global List<TipoSeguro> data {get;set;}
        }
        


    
}