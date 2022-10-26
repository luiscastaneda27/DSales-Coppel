trigger DSALES_InsurancePolicyAsset on InsurancePolicyAsset (before insert, before update,after insert,after update) {
    fflib_SObjectDomain.triggerHandler(DSALES_InsurancePolicyAssetsHandler.class);
    

}