public class DSALES_ControladorCertificadoPDF {
    
    public String html{get;set;}
    private static final String NOMBRE_OBJETO = 'DSALES_Certificado__c';
    private static final String NOMBRE_PLANTILLA = 'Certificado PDF';
    private static final String NOMBRE_DATE = 'DATE';
    private static final String NOMBRE_DOUBLE = 'DOUBLE';
    
    public DSALES_ControladorCertificadoPDF(){
        String recordId = ApexPages.currentPage().getParameters().get('certificadoId');
        //html = [Select Id, HtmlValue, Subject from EmailTemplate Where DeveloperName = :NOMBRE_PLANTILLA].HtmlValue;
        html = [select Id, DSALES_Plantilla__c  from DSALES_Generador__c Where Name = :NOMBRE_PLANTILLA].DSALES_Plantilla__c;
        html = html.replace('border-color: #ffffff;', 'border-image: initial; border: .3px solid blue;');
        html=html.replace('p style="text-align:center"', 'text-align:center; font-size:10px; color:rgb(0, 101, 173);');
        html=html.replace('<div>&nbsp;&nbsp;&nbsp;</div>', '<div style="page-break-after:always;" />');
        Map<String, String> mapCampos = getField(NOMBRE_OBJETO);
        String query = 'Select ';
        for(String item: mapCampos.keySet()){
            query += item+',';
        }
        query = query.substring(0, query.length() -1);
        query += ' From DSALES_Certificado__c Where Id = :recordId';
        DSALES_Certificado__c certificado = DataBase.query(query);
        html = html.replace('certificado.', '');
        for(String item: mapCampos.keySet()){
            if(html.contains(item)){
                String replace = '';
                if(certificado.get(item)!= null){
                    if(mapCampos.get(item) == NOMBRE_DATE){
                        replace = String.valueOf(Date.valueOf(certificado.get(item)).format());
                    }else if (mapCampos.get(item) == NOMBRE_DOUBLE ){
                        replace = String.valueOf(Decimal.valueOf( String.valueOf(certificado.get(item)) ).format());
                    }else{
                        replace = String.valueOf(certificado.get(item));
                    }
                }
                html = html.replace(item, replace);
            }
        }
        System.debug('html: '+html);
    }
    
    
    private static Map<String, String> getField(String ObjName){
        Map<String, String> mapCampos = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(ObjName).getDescribe().fields.getMap();
        for(Schema.SObjectField Sfield : fieldMap.Values()){
            schema.describefieldresult Field = sfield.getDescribe();
            mapCampos.put(Field.getName(), String.valueOf(Field.getType())); 
        }
        return mapCampos;
    }


}