trigger DSALES_ResumenDePagos on ClaimPaymentSummary (after insert) {
    fflib_SObjectDomain.triggerHandler(DSALES_ResumenPagos.class);

}