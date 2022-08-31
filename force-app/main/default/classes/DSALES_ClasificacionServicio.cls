public without sharing class DSALES_ClasificacionServicio {
    
    private static final String NOMBRE_OBJETO_CS = 'DSales_ClasificacionDeServicio__c';

    @AuraEnabled
    public static DSALES_ClasificacionServicioWrapper getPickListCategoria(){
        DSALES_ClasificacionServicioWrapper respuesta = new DSALES_ClasificacionServicioWrapper();
        respuesta.listCategorias = new List <PickListOption>();
        respuesta.listSubCategorias = new List <PickListOption>();
        respuesta.listClases = new List <PickListOption>();
        respuesta.listFamilias = new List <PickListOption>();
        respuesta.listServicios = new List <Servicio>();
        for(DSALES_Categoria__c item: [Select Id, Name From DSALES_Categoria__c order by Name Asc]){
            PicklistOption option = new PicklistOption();
            option.etiqueta = item.Name;
            option.valor = item.Id;
            option.seleccionado = false;
            option.mostrar = true;
            respuesta.listCategorias.add(option);
        }
        return respuesta;
    }
    
    @AuraEnabled
    public static DSALES_ClasificacionServicioWrapper getRecords(String allData){
        DSALES_ClasificacionServicioWrapper objeto = (DSALES_ClasificacionServicioWrapper) JSON.deserialize(allData, DSALES_ClasificacionServicioWrapper.class);
        List<String> listCategorias = itemSeleccionados(objeto.listCategorias);
        List<String> listSubCategorias = itemSeleccionados(objeto.listSubCategorias);
        List<String> listClases = itemSeleccionados(objeto.listClases);
        List<String> listFamilias = itemSeleccionados(objeto.listFamilias);
        
        if(listCategorias.size() == 0 && listSubCategorias.size() == 0 &&
           listClases.size() == 0 && listFamilias.size() == 0){
               objeto.listServicios = new List<Servicio>();
               return objeto;
           }
        String tipoRegistroId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('DSALES_ProdTangible').getRecordTypeId();
        
        String query = 'Select Id, Name, StockKeepingUnit, DSALES_Categoria__r.Name, DSALES_SubCategoria__r.Name, DSALES_Clase__r.Name, ';
        query += ' DSALES_Familia__r.Name, DSales_Servicio__c, DSales_Seguro__c, DSALES_TipoServicio__c, DSALES_Noaplica__c ';
        query += 'from Product2 Where RecordTypeId = :tipoRegistroId ';
        query += listCategorias.size() > 0 ? ' And DSales_Categoria__c in :listCategorias ' : '';
        query += listSubCategorias.size() > 0 ? ' And DSALES_SubCategoria__c in :listSubCategorias ' : '';
        query += listClases.size() > 0 ? ' And DSales_Clase__c in :listClases ' : '';
        query += listFamilias.size() > 0 ? ' And DSALES_Familia__c in :listFamilias ' : '';
        query += ' order by DSales_Servicio__c asc';
        objeto.listServicios = consultarProductos(DataBase.query(query));
        System.debug('Query: '+query);
        return objeto;
    }
    
    @AuraEnabled
    public static List<Servicio> getBuscarSKU(String sku){
        if(String.isBlank(sku)){
            return new List<Servicio>();
        }
        String tipoRegistroId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('DSALES_ProdTangible').getRecordTypeId();
        String query = 'Select Id, Name, StockKeepingUnit, DSALES_Categoria__r.Name, DSALES_SubCategoria__r.Name, DSALES_Clase__r.Name, ';
        query += ' DSALES_Familia__r.Name, DSales_Servicio__c, DSales_Seguro__c, DSALES_TipoServicio__c, DSALES_Noaplica__c ';
        query += 'from Product2 Where RecordTypeId = :tipoRegistroId And StockKeepingUnit = :sku ';
        query += ' order by DSales_Servicio__c asc';
        System.debug('Query: '+query);
        return consultarProductos(DataBase.query(query));
    }
    
    public static List<Servicio> consultarProductos(List<Product2> listProductos){
        List<Servicio> listServicios = new List<Servicio>();
        for(Product2 item: listProductos){
            Servicio servicio = new Servicio(); 
            servicio.id = item.Id;
            servicio.nombre = item.Name;
            servicio.sku = item.StockKeepingUnit;
            servicio.categoria = item.DSALES_Categoria__r.Name;
            servicio.subCategoria = item.DSALES_SubCategoria__r.Name;
            servicio.familia = item.DSALES_Familia__r.Name;
            servicio.clase = item.DSales_Clase__r.Name;
            servicio.servicio = item.DSALES_Servicio__c;
            servicio.seguro = item.DSales_Seguro__c;
            servicio.noAplica = item.DSALES_NoAplica__c;
            servicio.tipoServicio = item.DSALES_TipoServicio__c;
            listServicios.add(servicio); 
        }
        return listServicios;
    }
    
    
    @AuraEnabled
    public static void upsertRecord(String allData){
        DSALES_ClasificacionServicioWrapper objeto = (DSALES_ClasificacionServicioWrapper) JSON.deserialize(allData, DSALES_ClasificacionServicioWrapper.class);
        List<Product2> listProductos= new List<Product2>();
        for(Servicio item: objeto.listServicios){
            listProductos.add(new Product2(Id = item.id, DSALES_Servicio__c = item.servicio, 
                                           DSALES_Seguro__c = item.seguro, DSALES_NoAplica__c = item.noAplica));
        }
        update listProductos;
    }
    
    public static List<String> itemSeleccionados(List<PicklistOption> listPickList){
        List<String> listItems = new List <String>();
        for(PicklistOption item: listPickList){
            if(item.seleccionado){
                listItems.add(item.valor);
            }
        }
        return listItems;
    }
    
    @AuraEnabled
    public static DSALES_ClasificacionServicioWrapper getPicklistOptionsDependent(String allData){
        DSALES_ClasificacionServicioWrapper objeto = (DSALES_ClasificacionServicioWrapper) JSON.deserialize(allData, DSALES_ClasificacionServicioWrapper.class);
        DSALES_ClasificacionServicioWrapper objetoNuevo = (DSALES_ClasificacionServicioWrapper) JSON.deserialize(allData, DSALES_ClasificacionServicioWrapper.class);
        List<String> campos = new List<String>();
        objetoNuevo.listSubCategorias = new List <PickListOption>();
        objetoNuevo.listClases = new List <PickListOption>();
        objetoNuevo.listFamilias = new List <PickListOption>();
        
        List<String> listCategorias = itemSeleccionados(objeto.listCategorias);
        List<String> listSubCategorias = itemSeleccionados(objeto.listSubCategorias);
        List<String> listClases = itemSeleccionados(objeto.listClases);
        
        for(DSALES_SubCategoria__c item: [Select Id, Name,DSALES_Categoria__c from DSALES_SubCategoria__c Where DSALES_Categoria__c in : listCategorias order by Name]){
            PicklistOption option = new PicklistOption();
            option.etiqueta = item.Name;
            option.valor = item.Id;
            option.depende = item.DSALES_Categoria__c;
            option.seleccionado = false;
            option.mostrar = true;
            objetoNuevo.listSubCategorias.add(option);
        }
        for(PicklistOption item: objeto.listSubCategorias){
            for(PicklistOption itemNuevo: objetoNuevo.listSubCategorias){
                if(item.valor == itemNuevo.valor){
                    itemNuevo.seleccionado = item.seleccionado;
                    itemNuevo.mostrar = item.mostrar;
                }
            }
        }
        
        
        for(DSALES_Clase__c item: [Select Id, Name,DSALES_SubCategoria__c from DSALES_Clase__c Where DSALES_SubCategoria__c in : listSubCategorias order by Name]){
            PicklistOption option = new PicklistOption();
            option.etiqueta = item.Name;
            option.valor = item.Id;
            option.depende = item.DSALES_SubCategoria__c;
            option.seleccionado = false;
            option.mostrar = true;
            objetoNuevo.listClases.add(option);
        }
        for(PicklistOption item: objeto.listClases){
            for(PicklistOption itemNuevo: objetoNuevo.listClases){
                if(item.valor == itemNuevo.valor){
                    itemNuevo.seleccionado = item.seleccionado;
                    itemNuevo.mostrar = item.mostrar;
                }
            }
        }

        for(DSALES_Familia__c item: [Select Id, Name,DSALES_Clase__c from DSALES_Familia__c Where DSALES_Clase__c in : listClases order by Name]){
            PicklistOption option = new PicklistOption();
            option.etiqueta = item.Name;
            option.valor = item.Id;
            option.depende = item.DSALES_Clase__c;
            option.seleccionado = false;
            option.mostrar = true;
            objetoNuevo.listFamilias.add(option);
        }
        for(PicklistOption item: objeto.listFamilias){
            for(PicklistOption itemNuevo: objetoNuevo.listFamilias){
                if(item.valor == itemNuevo.valor){
                    itemNuevo.seleccionado = item.seleccionado;
                    itemNuevo.mostrar = item.mostrar;
                }
            }
        }
        return objetoNuevo;
    }
    
    public class DSALES_ClasificacionServicioWrapper{
        @AuraEnabled public List <PickListOption> listCategorias{get;set;}
        @AuraEnabled public List <PickListOption> listSubCategorias{get;set;}
        @AuraEnabled public List <PickListOption> listClases{get;set;}
        @AuraEnabled public List <PickListOption> listFamilias{get;set;}        
        @AuraEnabled public List <Servicio> listServicios{get;set;}  
        @AuraEnabled public String sku;
    }
    public class PickListOption{
        @AuraEnabled public String etiqueta;
        @AuraEnabled public String valor;
        @AuraEnabled public String depende;
        @AuraEnabled public Boolean seleccionado;
        @AuraEnabled public Boolean mostrar;
    }
    
    public class Servicio{
        @AuraEnabled public String id;
        @AuraEnabled public String nombre;
        @AuraEnabled public String sku;
        @AuraEnabled public String categoria;
        @AuraEnabled public String subCategoria;
        @AuraEnabled public String clase;
        @AuraEnabled public String familia;
        @AuraEnabled public Boolean servicio;
        @AuraEnabled public Boolean seguro;
        @AuraEnabled public Boolean noAplica;
        @AuraEnabled public String tipoServicio;
    }
}