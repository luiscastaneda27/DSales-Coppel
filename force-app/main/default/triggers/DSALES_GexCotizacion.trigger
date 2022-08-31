trigger DSALES_GexCotizacion on Quote (before insert, after insert, before update, after update) {
    for(Quote coti:Trigger.new)
    { 
        
        if(coti.DSALES_Enviarcotizacion__c)
        {
            //coti.DSALES_CorreoEnviado__c=true;
            fflib_SObjectDomain.triggerHandler(DSALES_GexCotizaciones.class);
        }
    }
}