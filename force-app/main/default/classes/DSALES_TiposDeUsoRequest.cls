@RestResource(urlMapping='/tiposUso/*')
global with sharing class DSALES_TiposDeUsoRequest {
    @HttpGet
    global static TipoUsoResponse  getTiposDeUso() {

        TipoUsoResponse responsePayload = new TipoUsoResponse();
        
        responsePayload.exitoso = true;

        try { 
            list<DSALES_TipodeUso__c> tipoDeUso = [SELECT Id,Name, DSALES_Activo__c, DSALES_Descripcin__c
                                                  FROM DSALES_TipodeUso__c WHERE DSALES_Activo__c= true];
            System.debug(tipoDeUso.size());
            list<TipoUso> tipoListObj = new list<TipoUso>();

            for (DSALES_TipodeUso__c tipoUso2 : tipoDeUso ) {

                TipoUso tu = new TipoUso();

                tu.id = tipoUso2.id;
                tu.nombre = tipoUso2.Name;
                tu.activo = tipoUso2.DSALES_Activo__c;
                tu.descripcion= tipoUso2.DSALES_Descripcin__c;
                
                tipoListObj.add(tu);

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


        global class TipoUso{
            global String id {get;set;}
            global Boolean activo{get;set;}
            global String nombre{get;set;}
            global String descripcion{get;set;}
            
       
        }
        global class TipoUsoResponse{ 
            global Boolean exitoso {get;set;}
            global String mensaje_error {get;set;}
            global Integer codigo_error {get;set;}
            global List<TipoUso> data {get;set;}
        }
        
    
}
