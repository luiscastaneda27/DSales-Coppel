trigger DSALES_UpdateCliente on DSALES_InformacionDePago__c (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        DSALES_InformacionPagoHandler.CambiaClienteCautivo(trigger.new);       
    }
}