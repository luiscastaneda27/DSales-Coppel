trigger DSALES_GexCotizacion on Quote (after update,after insert) {
    If(trigger.isAfter && (trigger.isInsert ||trigger.isUpdate)) {
        fflib_SObjectDomain.triggerHandler(DSALES_GexCotizaciones.class);
    }
}