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
          /*  producto= [select Id, RecordTypeId from product2 Where RecordTypeId = ];
           String recordId= producto[0].Id;
           String recordId */
        //String tipoRegistroId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('DSALES_ProdTangible').getRecordTypeId();
        
        String query = 'Select Id, Name, StockKeepingUnit, DSALES_Categoria__r.Name, DSALES_SubCategoria__r.Name, DSALES_Clase__r.Name, ';
        query += ' DSALES_Familia__r.Name, DSales_Servicio__c, DSales_Seguro__c, DSALES_TipoServicio__c, DSALES_Noaplica__c, RecordTypeId ';
        query += 'from Product2 Where RecordTypeId != null and DSALES_Noaplica__c = false and DSales_Servicio__c = false and DSales_Seguro__c= false ';
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
        //String tipoRegistroId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('DSales_Tipo_de_Producto__c').getRecordTypeId();
        String query = 'Select Id, Name, StockKeepingUnit, DSALES_Categoria__r.Name, DSALES_SubCategoria__r.Name, DSALES_Clase__r.Name, ';
        query += ' DSALES_Familia__r.Name, DSales_Servicio__c, DSales_Seguro__c, RecordTypeId, DSALES_TipoServicio__c, DSALES_Noaplica__c ';
        query += 'from Product2 Where StockKeepingUnit = :sku ';
        query += ' order by DSales_Servicio__c asc';
        System.debug('Query: '+query);
        return consultarProductos(DataBase.query(query));
    }
    
     
   /* @AuraEnabled
    public static List<AsignarProductos> getBuscarVinculacion(String servicio){
        if(String.isBlank(servicio)){
            return new List<AsignarProductos>();
        }
       // String tipoRegistroId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('DSALES_ProdTangible').getRecordTypeId();
        String query = 'Select DSales_Producto__c, DSales_NombreProducto__c, DSALES_Departamento__c, DSALES_Clase__c, DSALES_Familia__c, DSALES_SKU__c, CreatedDate';
        query += 'from DSales_Asignacion_de_Productos__c';
        query += 'Where Name =:servicio';
        query += ' order by DSALES_Departamento__c asc';
        System.debug('Query: '+query);
        return consultarAsignaciones(DataBase.query(query));
    } */
    
    @AuraEnabled
    public static List<AsignarProductos> getBuscarVinculacion(String servicio){
       
        List<AsignarProductos> listasignacion = new List<AsignarProductos>();
        List<Product2> producto= new List<Product2>(); 
        List<Servicio> listServicios = new List<Servicio>();
        producto= [Select Name, Id from product2 Where Id = :servicio and DSales_Tipo_de_Producto__c= 'Servicio'];
        String idproducto= producto[0].Id;

        for(DSales_Asignacion_de_Productos__c item: [Select Id, DSales_Producto__c, DSales_NombreProducto__c, DSALES_Departamento__c, DSALES_Subcategoria__c, DSALES_Clase__c,
         DSALES_Familia__c, DSALES_SKU__c, CreatedDate, CreatedBy.Name, DSALES_Activo__c, DSales_Servicio_Seguro__c from DSales_Asignacion_de_Productos__c Where DSales_Producto__c =:idproducto and DSALES_Activo__c=:true order by DSales_NombreProducto__c asc])
    {
        AsignarProductos asignarProductos = new AsignarProductos(); 
        asignarProductos.id = item.Id;
        asignarProductos.nombre = item.DSales_NombreProducto__c;
        asignarProductos.servicio = item.DSales_Producto__c;
        asignarProductos.productoid = item.DSales_Servicio_Seguro__c;
        asignarProductos.sku = item.DSALES_SKU__c;
        asignarProductos.departamento = item.DSALES_Departamento__c;
        asignarProductos.subcategoria = item.DSALES_Subcategoria__c;
        asignarProductos.familia = item.DSALES_Familia__c;
        asignarProductos.clase = item.DSales_Clase__c;
        asignarProductos.creadoPor = item.CreatedBy.Name;
        asignarProductos.createdDate = item.CreatedDate.format();
        asignarProductos.estado = item.DSALES_Activo__c;
        asignarProductos.seleccionadoSku= false;
        listasignacion.add(asignarProductos); 
    }  
        return listasignacion;
    }
    

    @AuraEnabled
    public static String getidservicio(String sku){
       
        List<Product2> producto= new List<Product2>(); 
        producto= [Select Name, Id, StockKeepingUnit from product2 Where StockKeepingUnit = :sku];
        String idproducto= producto[0].Id;
        return idproducto;
    
    }

    
    @AuraEnabled
    public static List<AsignarProductos> getBuscarProducto(String servicio){
        List<AsignarProductos> listproductos = new List<AsignarProductos>();
        List<String> idproducto= new List<String>();
        List<DSales_Asignacion_de_Productos__c> producto= new List<DSales_Asignacion_de_Productos__c>(); 
        
        producto= [Select DSales_Servicio_Seguro__c from DSales_Asignacion_de_Productos__c Where DSALES_Activo__c=true and DSales_Producto__c=:servicio ];
        
        for(integer i=0; i<producto.size(); i++)
        {
            idproducto.add(producto[i].DSales_Servicio_Seguro__c);
        }
        
        for(Product2 item: [Select Id, (Select Id from Asignaciones_de_Productos1__r Where DSales_Producto__c = :servicio and DSALES_Activo__c=false), Name, StockKeepingUnit, DSALES_Depa__c, DSALES_SubCategorias__c, DSALES_Class__c,
                            DSALES_Family__c from Product2 Where DSales_Tipo_de_Producto__c= 'Producto' and Id not in :idproducto and isActive = true order by Name asc])
        {
            AsignarProductos asignarProductos = new AsignarProductos(); 
            if(item.Asignaciones_de_Productos1__r.size()>0){
                asignarProductos.id= item.Asignaciones_de_Productos1__r[0].Id;
                
            }
            
            asignarProductos.productoid = item.Id;
            asignarProductos.nombre = item.Name;
            //asignarProductos.servicio = item.DSales_Producto__c;
            asignarProductos.sku = item.StockKeepingUnit;
            asignarProductos.departamento = item.DSALES_Depa__c;
            asignarProductos.subcategoria = item.DSALES_SubCategorias__c;
            asignarProductos.familia = item.DSALES_Family__c;
            asignarProductos.clase = item.DSALES_Class__c;
            asignarProductos.seleccionadoSku= false;
            listproductos.add(asignarProductos); 
            
        }  
        return listproductos;
        
    }

    @AuraEnabled
    public static void upsertVinculacion(String dataJSON){
        List<AsignarProductos> listSkuSelected= (List<AsignarProductos>) JSON.deserialize(dataJSON, List<AsignarProductos>.class);
       
        List<DSales_Asignacion_de_Productos__c> listUpsertVinculacion = new List<DSales_Asignacion_de_Productos__c>();
        for(AsignarProductos item: listSkuSelected)
        {
           
            if(item.seleccionadoSku)
            {
            listUpsertVinculacion.add(new DSales_Asignacion_de_Productos__c(id=item.id,DSALES_Activo__c=!item.seleccionadoSku));
            }
            
            
        }
        upsert listUpsertVinculacion;
        
    }

    @AuraEnabled
    public static void insertVinculacion(String dataJSON,  String idservicio){
        List<AsignarProductos> listIdProductos= (List<AsignarProductos>) JSON.deserialize(dataJSON, List<AsignarProductos>.class);
        List<DSales_Asignacion_de_Productos__c> listInsertVinculacion = new List<DSales_Asignacion_de_Productos__c>();      
        
        
        for(AsignarProductos item: listIdProductos)
        {
           
            if(item.seleccionadoSku)
            {
                listInsertVinculacion.add(new DSales_Asignacion_de_Productos__c(Id=Item.id, DSALES_Servicio_Seguro__c=item.productoid, DSALES_Activo__c=true, DSales_Producto__c= idservicio));
            }
            
            
        }
       
        upsert listInsertVinculacion;
        
    }
   /*
   public static List<AsignarProductos> consultarAsignaciones(List<DSales_Asignacion_de_Productos__c> listAsignaciones){
        List<AsignarProductos> listAsignarProductos = new List<AsignarProductos>();
        for(DSales_Asignacion_de_Productos__c item: listAsignaciones ){
            AsignarProductos asignarProductos = new AsignarProductos(); 
            asignarProductos.id = item.Id;
            asignarProductos.nombre = item.DSales_NombreProducto__c;
            asignarProductos.servicio = item.DSales_Producto__c;
            asignarProductos.sku = item.DSALES_SKU__c;
            asignarProductos.departamento = item.DSALES_Departamento__c;
            asignarProductos.familia = item.DSALES_Familia__c;
            asignarProductos.clase = item.DSales_Clase__c;
            asignarProductos.creadoPor = item.CreatedById;
            asignarProductos.createdDate = item.CreatedDate;
        
        listAsignarProductos.add(asignarProductos); 
    }
    return listAsignarProductos;
}*/
    
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
        List<Servicio> objeto= (List<Servicio>) JSON.deserialize(allData, List<Servicio>.class);
        system.debug(objeto);
        List<Product2> listProductos= new List<Product2>();
        for(Servicio item: objeto){
            listProductos.add(new Product2(Id = item.id, DSALES_Servicio__c = item.servicio, 
                                           DSALES_Seguro__c = item.seguro, DSALES_NoAplica__c = item.noAplica));
        }
        upsert listProductos;
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
    
    //mi primera funcion en apex
    @AuraEnabled
    public static String checkProfileType(string profile)
    {
        Id id1 = UserInfo.getProfileId(); 
       Profile perfilSM = [SELECT id From Profile WHERE Name =: profile LIMIT 1];
       Profile perfilAdmi = [SELECT id From Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
       if(perfilAdmi.Id== id1)
       {
            return 'Administrador del sistema';
       }
       else {
        
             if(id1 == perfilSM.Id)
            {
            return profile;	
            }
            else
            {
                return 'No corresponde';        
            }
        
        }
    }

    @AuraEnabled
    public static List<PicklistOp> getcategories(string recordName){
        List<PicklistOp>listcategories = new List<PicklistOp>();
        for(DSALES_Categoria__c item: [Select Id, Name From DSALES_Categoria__c where RecordType.name=: recordName])
    {
        PicklistOp p = new PicklistOp();
        p.label= item.name;
        p.value = item.Id;
        listcategories.add(p);
    }  
        return listcategories;
    }

    @AuraEnabled
    public static List<PicklistOp> getSubCategories(string valueCategoria){

        List<PicklistOp>listSubCategories = new List<PicklistOp>();

        for(DSALES_SubCategoria__c item: [Select Id, Name,DSALES_Categoria__c from DSALES_SubCategoria__c Where DSALES_Categoria__c =:valueCategoria])
    {
        PicklistOp option = new PicklistOp();
        option.label= item.name;
        option.value = item.Id;
        listSubCategories.add(option);
    }  
        return listSubCategories;
    }

    @AuraEnabled
    public static List<PicklistOp> getClases(string valueCategoria){

        List<PicklistOp>listClases = new List<PicklistOp>();
        System.debug(valueCategoria);
        for(DSALES_Clase__c item: [Select Id, Name from DSALES_Clase__c where DSALES_SubCategoria__c=: valueCategoria])
    {
        PicklistOp option = new PicklistOp();
        option.label= item.name;
        option.value = item.Id;
        listClases.add(option);
    }  
        return listClases;
    }

    @AuraEnabled
    public static List<PicklistOp> getFamilias(string valueClases){

        List<PicklistOp>listFamilias = new List<PicklistOp>();

        for(DSALES_Familia__c item: [Select Id, Name,DSALES_Clase__c from DSALES_Familia__c Where DSALES_Clase__c =:valueClases])
    {
        PicklistOp option = new PicklistOp();
        option.label= item.name;
        option.value = item.Id;
        listFamilias.add(option);
    }  
        return listFamilias;
    }

    @AuraEnabled
    public static List<Servicio> getMatriz(){

        List<Servicio>listMatrices = new List<Servicio>();

        for(DSales_Matriz_GEX__c item: [Select Id, Name, DSALES_Servicio__c, DSALES_Tipo__c from DSales_Matriz_GEX__c where DSALES_Servicio__c= '' and DSALES_Tipo__c = 'Matriz Original'])
    {
        Servicio a = new Servicio();
        a.tipoServicio= item.DSALES_Servicio__c;
        a.tipoMatriz= item.DSALES_Tipo__c;
        a.label= item.name;
        a.value = item.Id;

        listMatrices.add(a);
    }  
        return listMatrices;
    }

    @AuraEnabled
    public static void updateMatriz(String allData, String typeServicio){
        List<String> objetoMatrices = (List<String>) JSON.deserialize(allData, List<String>.class);
        List<DSales_Matriz_GEX__c> listMatrizSelected= new List<DSales_Matriz_GEX__c>();
      
        for(Integer i=0; objetoMatrices.size()>i; i++)
        {
            listMatrizSelected.add(new DSales_Matriz_GEX__c(Id = objetoMatrices[i], DSALES_Servicio__c=typeServicio));
        }
        upsert listMatrizSelected;
    }

    @AuraEnabled
    public static void insertListaPrecios(String idproductoservicio, String opcion, String JSON2){
        List<Servicio> listaPreciosSelected = (List<Servicio>) JSON.deserialize(JSON2, List<Servicio>.class);
        List<Pricebook2> idlistaprecios= new List<Pricebook2>(); 
        idlistaprecios= [select id, name, IsStandard from Pricebook2 where  name= 'Standard Price Book' limit 1];
        String idprecios= idlistaprecios[0].Id;
        List<PricebookEntry> listPrices= new List<PricebookEntry>();
        if(opcion=='1')
        {
        listPrices.add(new PricebookEntry(Product2Id = idproductoservicio, Pricebook2Id=idprecios, IsActive=true, UnitPrice=1));
        insert listPrices;
        }
        else {
            for(Servicio item:listaPreciosSelected){
                if(item.servicio==true || item.seguro==true){
                    listPrices.add(new PricebookEntry(Product2Id = item.id, Pricebook2Id=idprecios, IsActive=true, UnitPrice=1));
                    }
            }
            insert listPrices;
        }
         
    }

    @AuraEnabled
    public static List<PicklistOp> getPickListValuesIntoList1(){
        List<PicklistOp> pickListValuesList1= new List<PicklistOp>();
        Schema.DescribeFieldResult fieldResult = Product2.DSALES_ServicioSeguro__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            PicklistOp option = new PicklistOp();
            option.label= pickListVal.getLabel();
            option.value = pickListVal.getValue();
            pickListValuesList1.add(option);
        }
        return pickListValuesList1;
        }


        @AuraEnabled
        public static List<PicklistOp> getPickListValuesIntoList2(){
            List<PicklistOp> pickListValuesList2= new List<PicklistOp>();
            Schema.DescribeFieldResult fieldResult = Product2.DSALES_ServEspecifico__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                PicklistOp option = new PicklistOp();
                option.label= pickListVal.getLabel();
                option.value = pickListVal.getValue();
                pickListValuesList2.add(option);
            }
            return pickListValuesList2;
            }

            @AuraEnabled
            public static List<PicklistOp> getPickListValuesIntoList3(){
                List<PicklistOp> pickListValuesList3= new List<PicklistOp>();
                Schema.DescribeFieldResult fieldResult = Product2.DSALES_Matriz__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry pickListVal : ple){
                    PicklistOp option = new PicklistOp();
                    option.label= pickListVal.getLabel();
                    option.value = pickListVal.getValue();
                    pickListValuesList3.add(option);
                }
                return pickListValuesList3;
                }

                @AuraEnabled
                public static List<PicklistOp> getPickListValuesIntoList4(){
                    List<PicklistOp> pickListValuesList4= new List<PicklistOp>();
                    Schema.DescribeFieldResult fieldResult = Product2.DSALES_SegEspecifico__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        PicklistOp option = new PicklistOp();
                        option.label= pickListVal.getLabel();
                        option.value = pickListVal.getValue();
                        pickListValuesList4.add(option);
                    }
                    return pickListValuesList4;
                    }

              

    @AuraEnabled
    public static Product2 createProductIntan(Product2 productIntan, String sku){
        try{
            insert productIntan;
            return productIntan;
            
        }
        catch(Exception e){
           
        throw new AuraHandledException(e.getMessage());
    }
                    
    }     
    @AuraEnabled
    public static void insertPocentajeCobro(String idservicio, String JSONP){
       // List<String> listaPorcentajes = (List<String>) JSON.deserialize(JSONP, List<String>.class);
       DSALES_ClasificacionServicioWrapper objeto = (DSALES_ClasificacionServicioWrapper) JSON.deserialize(JSONP, DSALES_ClasificacionServicioWrapper.class);
       system.debug(objeto);
       List<DASALES_Porcentajedecobro__c> listInsertPorcentajes= new List <DASALES_Porcentajedecobro__c>();
        
           /* for(Integer i=0; listaPorcentajes.size()>i; i++)
            {
                    listInsertPorcentajes.add(new DASALES_Porcentajedecobro__c(DSALES_Anios__c=1, DSALES_Porcentaje__c=listaPorcentajes[i], DSALES_Product__c= idservicio));
            }
            insert listInsertPorcentajes;*/
            
        
                    
    }     

    @AuraEnabled
    public static DSales_Asignacion_de_Productos__c createVinculacion(DSales_Asignacion_de_Productos__c asignacion){
          
        try{
            insert asignacion;
            return asignacion;
        }
        catch(Exception e){
      
        throw new AuraHandledException(e.getMessage());
    }
                    
    }     
    
   /* @AuraEnabled
    public static List<String> getSkuSelected(List<String> skuSelected){

        List<String> listSkuSelected = new List<String>();


        for(DSALES_Familia__c item: [Select Id, Name,DSALES_Clase__c from DSALES_Familia__c Where DSALES_Clase__c =:valueClases])
    {
        PicklistOp option = new PicklistOp();
        option.label= item.name;
        option.value = item.Id;
        listFamilias.add(option);
    }  
        return listFamilias;
    }*/


    public class PickListOp{
        @AuraEnabled public String  value;
        @AuraEnabled public String  label;
        @AuraEnabled public String  depende;
        @AuraEnabled public String  seleccionado;
        
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
        @AuraEnabled public String tipoMatriz;
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String recordId;

    }

    public class AsignarProductos{
        @AuraEnabled public String id;
        @AuraEnabled public String nombre;
        @AuraEnabled public String servicio;
        @AuraEnabled public String productoid;
        @AuraEnabled public String sku;
        @AuraEnabled public String departamento;
        @AuraEnabled public String subcategoria;
        @AuraEnabled public String clase;
        @AuraEnabled public String familia;
        @AuraEnabled public String creadoPor;
        @AuraEnabled public String createdDate;
        @AuraEnabled public Boolean estado;
        @AuraEnabled public Boolean seleccionadoSku;
        @AuraEnabled public String idasignacion;
        



       
    }

    //guardo correctamente 5:25 pm"
}