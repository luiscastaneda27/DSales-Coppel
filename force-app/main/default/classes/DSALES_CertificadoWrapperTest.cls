@isTest
global with sharing class DSALES_CertificadoWrapperTest {
    @testSetup
    static void SetUp(){
        Account ac= new Account(Name='DannyTest',CP_WalletCustomerNumber__c=123456);  
        insert ac;
        Contact con = new Contact(lastname= 'Test', AccountId= ac.Id, Email= 'johndoeus@salesforce.com');
        insert con;
        Asset ass = new Asset(Name='Test',AccountId= ac.Id,ContactId=con.Id);
        insert ass;
        Tienda__c tienda = new Tienda__c(DSales_TiendaID__c='1234');
        insert tienda;
        DSALES_Certificado__c certificado = new DSALES_Certificado__c(DSALES_Email__c='dsanmiguel@deloittemx.com',DSALES_ProductoAdquirido__c=ass.id);
        insert certificado;
    }
    @isTest static void CreateRecordTest()
    {
        Tienda__c tienda = [SELECT Id FROM Tienda__c WHERE DSales_TiendaID__c='1234'];
        Account acc=[SELECT CP_WalletCustomerNumber__c FROM ACCOUNT WHERE NAME='DannyTest' LIMIT 1];
        contact c= [SELECT Id, FirstName, LastName, AccountId from Contact];
        Asset ast =[select Id, Name, AccountId from Asset];
        
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
       String body = '{"id_producto_adquirido":"'+ast.id+'","id_cuenta":"'+acc.id+'","id_tienda":"'+tienda.id+'","numero_caja_coppel": "1234","id_vendedor": "1234","direccion_cliente": "Montreal 169 Paseo Montejo","correo_cliente": "dsanmiguel@deloittemx.com","telefono_cliente": "8130912906","celular_cliente": "812091342","sku": "ABCDS12","modelo_tangible": "Italika","marca_tangible": "Samsung","numero_serie": "90001","descripcion_tangible": "Muy bueno","precio_tangible": "900","fecha_compra_tangible": "2022-09-06","garantia_coppel_tangible": "12","costo_garantia": "900","fecha_compra_garantia": "2022-09-06","fecha_fin_garantia_extendida": "2022-09-06","fecha_inicio_garantia_extendida": "2022-09-06"}';
        request.requestURI='/apexrest/insertCertificado'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_CertificadoWrapper.CertificadoRequest certificado =  (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize (body,DSALES_CertificadoWrapper.CertificadoRequest.class);
        certificado.numero_cliente=String.ValueOf(acc.CP_WalletCustomerNumber__c);
        
        Test.startTest();
        DSALES_CertificadoWrapperRequest.createCertificado();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
    @isTest static void putRecordTest()
    {
       
        Asset prod =[SELECT id FROM Asset WHERE Name='Test' LIMIT 1 ];
        DSALES_Certificado__c certi= [SELECT id,Name FROM DSALES_Certificado__c WHERE DSALES_Email__c='dsanmiguel@deloittemx.com' LIMIT 1];
         String name=certi.Name,name1='';
        Boolean asset=true,asset1=false;
        String estado='Can',estado1='Dev',estado2='';
        
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        String body = '{"name":"'+name+'","estado":"'+estado+'","asset":"'+asset+'" }';
        request.requestURI='/apexrest/insertCertificado'; 
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_CertificadoWrapper.CertificadoRequest certificado =  (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize (body,DSALES_CertificadoWrapper.CertificadoRequest.class);
        Test.startTest();
        DSALES_CertificadoWrapperRequest.putCertificado(name,estado,asset);
        DSALES_CertificadoWrapperRequest.putCertificado(name,estado1,asset1);
        DSALES_CertificadoWrapperRequest.putCertificado(name,estado2,asset);
        DSALES_CertificadoWrapperRequest.putCertificado(name1,estado2,asset);
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
    }
     @isTest static void FailedRecordTest()
    {
                
        RestRequest request=new RestRequest();
        RestResponse response = new RestResponse();
        String body = '{"numero_caja_coppel": "1234","id_vendedor": "1234","direccion_cliente": "Montreal 169 Paseo Montejo","correo_cliente": "dsanmiguel@deloittemx.com","telefono_cliente": "8130912906","celular_cliente": "812091342","sku": "ABCDS12","modelo_tangible": "Italika","marca_tangible": "Samsung","numero_serie": "90001","descripcion_tangible": "Muy bueno","precio_tangible": "900","fecha_compra_tangible": "2022-09-06","garantia_coppel_tangible": "12","costo_garantia": "900","fecha_compra_garantia": "2022-09-06","fecha_fin_garantia_extendida": "2022-09-06","fecha_inicio_garantia_extendida": "2022-09-06"}';
        request.requestURI='/apexrest/insertCertificado'; 
        request.httpMethod='POST';
        RestContext.request=request;
        request.requestBody=Blob.valueOf(body);
        RestContext.response=response;
        DSALES_CertificadoWrapper.CertificadoRequest certificado =  (DSALES_CertificadoWrapper.CertificadoRequest)JSON.deserialize (body,DSALES_CertificadoWrapper.CertificadoRequest.class);
        
        Test.startTest();
        DSALES_CertificadoWrapperRequest.createCertificado();
        Test.stopTest();
        RestContext.request = request;
        RestContext.response= response;
        
    }
}