trigger DSALES_InsurancePolicy on InsurancePolicy (before insert,before update,after insert,after update) {
    fflib_SObjectDomain.triggerHandler(DSALES_InsurancePolicyHandler.class);
    
}