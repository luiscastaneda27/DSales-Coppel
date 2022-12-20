@RestResource(urlMapping='/TiposVehiculo/*')
global with sharing class DSALES_TipoVehiculoRequest {
    @HttpGet
    global static TipoVehiculoResponse getTipoVehiculo() {
        TipoVehiculoResponse responsePayload = new TipoVehiculoResponse();
        
        responsePayload.exitoso = true;

        try { 
            list<DSALES_Tipodevehculo__c> tiposDeVehiculo = [SELECT Id,Name, DSALES_Activo__c, DSALES_Descripcin__c
                                                  FROM DSALES_Tipodevehculo__c WHERE DSALES_Activo__c= true];
            System.debug(tiposDeVehiculo.size());
            list<TipoVehiculo> tipoListObj = new list<TipoVehiculo>();

            for (DSALES_Tipodevehculo__c mapTV : tiposDeVehiculo ) {

                TipoVehiculo tv = new TipoVehiculo();

                tv.id = mapTV.id;
                tv.nombre = mapTV.Name;
                tv.activo = mapTV.DSALES_Activo__c;
                tv.descripcion= mapTV.DSALES_Descripcin__c;
                
                tipoListObj.add(tv);

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


        global class TipoVehiculo{
            global String id {get;set;}
            global Boolean activo{get;set;}
            global String nombre{get;set;}
            global String descripcion{get;set;}
            
       
        }
        global class TipoVehiculoResponse{ 
            global Boolean exitoso {get;set;}
            global String mensaje_error {get;set;}
            global Integer codigo_error{get;set;}
            global List<TipoVehiculo> data {get;set;}
        }
        


    
}
