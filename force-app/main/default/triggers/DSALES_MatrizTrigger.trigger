trigger DSALES_MatrizTrigger on DSales_Matriz_GEX__c (before insert, after insert) {
	fflib_SObjectDomain.triggerHandler(DSALES_Matriz.class);
}