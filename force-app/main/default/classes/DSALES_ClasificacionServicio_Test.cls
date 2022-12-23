@isTest
public class DSALES_ClasificacionServicio_Test {
    
    @testSetup
    static void testSetup(){
        String recordTypeId = Schema.SObjectType.DSALES_Categoria__c.getRecordTypeInfosByName().get('Garantía Extendida').getRecordTypeId();
        DSALES_Categoria__c categoria = new DSALES_Categoria__c();
        categoria.Name = 'Test';
        categoria.RecordTypeId=recordTypeId;
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
          
        DSales_Matriz_GEX__c mat = new DSales_Matriz_GEX__c();
        mat.Name= 'test1';
        mat.DSALES_Activo__c= true;
        mat.DSALES_Region__c ='Hermosillo';
        mat.DSALES_Tiempogex__c = '2 años';
        insert mat;
        
        DSALES_Matriz_de_Cotizacion__c matItem = new DSALES_Matriz_de_Cotizacion__c();
        matItem.DSales_Matriz_GEX__c = mat.Id;
        matItem.SALES_Precio_GEX__c = 3500;
        matItem.DSALES_Rango_interior_GEX__c=7000;
        matItem.DSALES_Rango_Superior_GEX__c = 8500;
        matItem.DSALES_Tiempo_de_Garantia_Extendida_GEX__c = '1 año';
        
        matItem.DSales_Matriz_GEX__c = mat.Id;
        matItem.SALES_Precio_GEX__c = 4500;
        matItem.DSALES_Rango_interior_GEX__c=7000;
        matItem.DSALES_Rango_Superior_GEX__c = 8500;
        matItem.DSALES_Tiempo_de_Garantia_Extendida_GEX__c = '2 años';
        insert matItem;
       
        Product2 producto = new Product2();
        producto.Name = 'test';
        producto.DSales_Categoria__c = categoria.Id;
        producto.DSALES_SubCategoria__c = subC.Id;
        producto.DSALES_Clase__c = clase.Id;
        producto.DSALES_Familia__c = familia.Id;
        producto.StockKeepingUnit = 'SKU1234353464565654665';
        producto.DSales_Tipo_de_Producto__c= 'Producto';
        producto.IsActive=true;
        insert producto;
        
        Product2 producto2 = new Product2();
        producto2.Name = 'test2';
        producto2.DSales_Categoria__c = categoria.Id;
        producto2.DSALES_SubCategoria__c = subC.Id;
        producto2.DSALES_Clase__c = clase.Id;
        producto2.DSALES_Familia__c = familia.Id;
        producto2.StockKeepingUnit = 'SKU1234353464565654';
        producto2.DSales_Tipo_de_Producto__c= 'Producto';
        producto2.IsActive=true;
        insert producto2;
        
        Product2 objetoserv = new Product2();
        objetoserv.Name= 'test';
        objetoserv.DSales_Categoria__c = categoria.Id;
        objetoserv.DSALES_SubCategoria__c = subC.Id;
        objetoserv.DSALES_Clase__c = clase.Id;
        objetoserv.DSALES_Familia__c = familia.Id;
        objetoserv.StockKeepingUnit = 'SKU12346VG';
        objetoserv.DSales_Tipo_de_Producto__c= 'Servicio';
        objetoserv.isActive=true;
        insert objetoserv;
        
        DSales_Asignacion_de_Productos__c asignacionprod = new DSales_Asignacion_de_Productos__c();
        asignacionprod.Name='Test';
        asignacionprod.DSales_Servicio_Seguro__c= producto.Id;
        asignacionprod.DSales_Producto__c=objetoserv.Id;
        asignacionprod.DSALES_Activo__c=true;
        insert asignacionprod;
        
    }
    
    @isTest
    static void ClasificacionServicio(){
        Product2 idprueba= [Select id from Product2 limit 1];
        DSALES_Categoria__c idcat = [select id from DSALES_Categoria__c limit 1];
        DSALES_SubCategoria__c idsubc= [select id from DSALES_SubCategoria__c limit 1];
        DSALES_Clase__c idclass=  [select id from DSALES_Clase__c limit 1];
        DSales_Matriz_GEX__c idmat= [select id from DSales_Matriz_GEX__c limit 1];
        DSALES_ClasificacionServicio.DSALES_ClasificacionServicioWrapper controller = DSALES_ClasificacionServicio.getPickListCategoria();
        controller.listCategorias[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getPicklistOptionsDependent(JSON.serialize(controller));
        controller.listSubCategorias[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getPicklistOptionsDependent(JSON.serialize(controller));
        controller.listClases[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getPicklistOptionsDependent(JSON.serialize(controller));
        controller.listFamilias[0].seleccionado = true;
        
        controller = DSALES_ClasificacionServicio.getRecords(JSON.serialize(controller));
        //DSALES_ClasificacionServicio.upsertRecord(JSON.serialize(controller));
        
        controller.sku = 'SKU1234353464565654665';
        controller.listServicios = DSALES_ClasificacionServicio.getBuscarSKU(controller.sku);
        DSALES_ClasificacionServicio.getBuscarVinculacion(DSALES_ClasificacionServicio.getidservicio('SKU12346VG'));
        DSALES_ClasificacionServicio.getBuscarProducto(DSALES_ClasificacionServicio.getidservicio('SKU1234353464565654665'));
        DSALES_ClasificacionServicio.upsertVinculacion(JSON.serialize( DSALES_ClasificacionServicio.getBuscarVinculacion(DSALES_ClasificacionServicio.getidservicio('SKU12346VG'))));
        DSALES_ClasificacionServicio.insertVinculacion(JSON.serialize( DSALES_ClasificacionServicio.getBuscarProducto(DSALES_ClasificacionServicio.getidservicio('SKU12346VG'))), DSALES_ClasificacionServicio.getidservicio('SKU12346VG'));
        DSALES_ClasificacionServicio.checkProfileType('Administrador GEX');
        DSALES_ClasificacionServicio.getcategories('Garantía Extendida');
        DSALES_ClasificacionServicio.getSubCategories(idcat.id);
        DSALES_ClasificacionServicio.getClases(idsubc.id);
        DSALES_ClasificacionServicio.getFamilias(idclass.id);
        DSALES_ClasificacionServicio.getMatriz();
        DSALES_ClasificacionServicio.upsertRecord('[{"categoria":"LÍNEA BLANCA","clase":"COOLER","familia":"VENTANA","id":"'+idprueba.id+'","noAplica":true,"nombre":"Extractor de Aire 6p Volteck color Blanco","seguro":false,"servicio":false,"sku":"48671001","subCategoria":"COOLER","tipoServicio":"0"}]');
        DSALES_ClasificacionServicio.RecordTypeId('Garantía Extendida');
        DSALES_ClasificacionServicio.updateMatriz( '["'+idmat.id+'"]', DSALES_ClasificacionServicio.getidservicio('SKU12346VG'));
        //DSALES_ClasificacionServicio.insertListaPrecios(DSALES_ClasificacionServicio.getidservicio('SKU12346VG'),'1','[]');
        DSALES_ClasificacionServicio.insertPocentajeCobro(DSALES_ClasificacionServicio.getidservicio('SKU12346VG'),'{"anio1":"6","anio2":"5","anio3":"9","anio4":3,"anio5":2,"anio6":1}');
        DSALES_ClasificacionServicio.getPickListValuesIntoList1();
        DSALES_ClasificacionServicio.getPickListValuesIntoList2();
        DSALES_ClasificacionServicio.getPickListValuesIntoList3();
        DSALES_ClasificacionServicio.getPickListValuesIntoList4();
       // DSALES_ClasificacionServicio.createProductIntan('{valueSelectedtipoProducto: 'Servicio', DSales_Tipo_de_Producto__c: 'Servicio', tipoSeguroServicio: Array(1), ValueClasesSelected: 'a3275000000D7zAAAS', ValuefamiliasSelected: ''}', 'sku8080');
        System.assertEquals(controller.listServicios.size(), 1);
        
        //Modificacion OVG a partir de aqui
        
    }
}