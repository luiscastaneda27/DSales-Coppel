trigger DSALES_InformacionPago on DSALES_InformacionDePago__c (before insert,after insert, before update, after update) {
    fflib_SObjectDomain.triggerHandler(DSALES_InformacionDePago.class);

}