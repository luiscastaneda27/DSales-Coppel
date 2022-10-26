trigger DSALES_CertificadoTrigger on DSALES_Certificado__c (before insert, after insert, before update, after update) {
    fflib_SObjectDomain.triggerHandler(DSALES_Certificados.class);
}