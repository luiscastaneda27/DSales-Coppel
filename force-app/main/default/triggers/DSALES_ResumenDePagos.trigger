trigger DSALES_ResumenDePagos on ClaimPaymentSummary (after insert) {
    DSALES_ResumenPagos.onAfterInsert(trigger.newMap);
    //fflib_SObjectDomain.triggerHandler(DSALES_ResumenPagos.class);

}