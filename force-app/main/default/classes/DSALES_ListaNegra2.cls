public class DSALES_ListaNegra2 {
    public static final String NOMBRE_SERVICIO = 'DSALES_ListaNegra';
    	public static void listaNegra(Id cotizacion){
            Quote updateCheck = [SELECT Id,Name, AccountId,DSALES_NombreCliente__c, Lista_negra__c, Motivo_de_lista_negra__c FROM Quote WHERE Id =:cotizacion];
            Account cuenta = [SELECT Id, Name, LastName, FirstName, MiddleName,Suffix, PersonBirthdate FROM Account WHERE Id =:updateCheck.AccountId];
            String nombre1 = cuenta.FirstName;
            String nombre2 =cuenta.MiddleName;
            String apellidoPat = cuenta.LastName;
            String apellidoMat = cuenta.Suffix;
            String nombreCompleto=nombre1;
            if(nombre2!=null){
              nombreCompleto += ' ' +nombre2;  
            }
            nombreCompleto += ' ' +apellidoPat; 
            if(apellidoMat!=null){
              nombreCompleto += ' ' +apellidoMat;  
            }
            date cumpleanos = cuenta.PersonBirthdate;
            String rfc = getRFC(nombre1,nombre2,apellidoPat,apellidoMat,cumpleanos);
            system.debug('RFC es :::: '+rfc);
            DSALES_ListaNegraWrapper.responseListaNegra respuesta = callWebService(rfc, nombreCompleto);
            if(respuesta.estatus =='false'){
                updateCheck.Lista_negra__c = false;
                updateCheck.Motivo_de_lista_negra__c= 'campo inter';
            }
            if(respuesta.estatus =='true'){
                updateCheck.Lista_negra__c = true;
                updateCheck.Motivo_de_lista_negra__c= 'Pedir descrip';
            }
            update updateCheck; 
                  
        }
    
        public static String getRFC(String nombre, String nombre2, String apellidoPat, String apellidoMat,date cumpleanos){
        String part1 = getPart1(apellidoPat.toUpperCase());
        String part2 = getPart2(apellidoMat.toUpperCase());
        String part3 = getPart3(nombre.toUpperCase());
        String part4 = getPart4(cumpleanos);
        String rfc = part1+part2+part3+part4;    
        return rfc;
        
    }
    
    public static String getPart1(String apellidoPat){
        String primeraLetra = apellidoPat.substring(0,1);
        String SegundaLetra ='';
        if (primeraLetra == 'Ñ'){
            primeraLetra = 'X';
        }
        
        for (Integer i=1; i <apellidoPat.length(); i++){
            String aux = apellidoPat.substring(i,i+1);
            if(aux == 'A'||aux == 'E'||aux == 'I'||aux == 'O'||aux == 'U'){
                SegundaLetra = aux;
                break;
            }else{SegundaLetra = 'X';}
        }
        return primeraLetra+SegundaLetra;        
    }
    
    public static String getPart2(String apellidoMat){
        String aux='X';
        if(apellidoMat!=null){
            aux = apellidoMat.substring(0,1);
            if (aux == 'Ñ'){
                aux = 'X';
            }
        }
        system.debug('letar: '+aux);
        return aux;        
    }
    
    public static String getPart3(String name){
        String aux = name.substring(0,1);
        return aux;       
    }
    
    public static String getPart4(date cumple){
        String anio=String.valueOf(cumple);
        String day=anio.substring(8,10);
        String month=anio.substring(5,7);
        String year=anio.substring(2,4);
        return year+month+day;       
    }
    
    public static DSALES_ListaNegraWrapper.responseListaNegra callWebService(String rfc, String name){
        DSALES_ListaNegraWrapper.responseListaNegra respuesta;
        DSALES_ListaNegraWrapper.enviarListaNegra dato = new  DSALES_ListaNegraWrapper.enviarListaNegra();
        dato.nombre = name;
        dato.rfc = rfc;
        String body = JSON.serialize(dato);
        System.debug('Campos se envian: '+ body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = DSALES_Utility.getEndpoint(NOMBRE_SERVICIO);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
            DSALES_ListaNegraWrapper.responseListaNegra resp = (DSALES_ListaNegraWrapper.responseListaNegra) JSON.deserialize(response.getbody(), DSALES_ListaNegraWrapper.responseListaNegra.class);
            if(resp.ok == 'true'){
                return resp;
            }else{
                System.debug('Respuesta no es ok');
                return resp;
            }    
        }else{
            System.debug('___Fallo____: comuncacion: ' + response.getBody());
        }
        return null;           
    }

}