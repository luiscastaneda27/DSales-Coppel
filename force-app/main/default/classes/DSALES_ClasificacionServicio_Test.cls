@isTest
public class DSALES_ClasificacionServicio_Test {
    
    @testSetup
    static void testSetup(){
        DSALES_Categoria__c categoria = new DSALES_Categoria__c();
        categoria.Name = 'Test';
        insert categoria;
        
        DSALES_SubCategoria__c subC = new DSALES_SubCategoria__c ();
        subC.Name = 'Test';
        subC.DSALES_Categoria__c = categoria.Id;
        insert subC;
        
        DSALES_Clase__c clase = new DSALES_Clase__c();
        clase.Name = 'Test';
        clase.DSALES_SubCategoria__c = subC.Id;
        insert clase;
        
        DSALES_Familia__c familia = new DSALES_Familia__c();
        familia.DSALES_Clase__c = clase.Id;
        familia.Name = 'Test';
        insert familia;
        
        Product2 producto = new Product2();
        producto.Name = 'test';
        producto.DSales_Categoria__c = categoria.Id;
        producto.DSALES_SubCategoria__c = subC.Id;
        producto.DSALES_Clase__c = clase.Id;
        producto.DSALES_Familia__c = familia.Id;
        producto.StockKeepingUnit = 'SKU123';
        producto.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('DSALES_ProdTangible').getRecordTypeId();
        insert producto;
    }
    
    @isTest
    static void ClasificacionServicio(){
        DSALES_ClasificacionServicio.DSALES_ClasificacionServicioWrapper controller = DSALES_ClasificacionServicio.getPickListCategoria();
        controller.listCategorias[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getPicklistOptionsDependent(JSON.serialize(controller));
        controller.listSubCategorias[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getPicklistOptionsDependent(JSON.serialize(controller));
        controller.listClases[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getPicklistOptionsDependent(JSON.serialize(controller));
        controller.listFamilias[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getRecords(JSON.serialize(controller));
        
        DSALES_ClasificacionServicio.upsertRecord(JSON.serialize(controller));
        
        controller.sku = 'SKU123';
        controller.listServicios = DSALES_ClasificacionServicio.getBuscarSKU(controller.sku);
        System.assertEquals(controller.listServicios.size(), 1);
    }
}