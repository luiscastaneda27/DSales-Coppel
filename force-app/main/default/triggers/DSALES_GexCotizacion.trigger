trigger DSALES_GexCotizacion on Quote (before insert, after insert, before update, after update) {
    fflib_SObjectDomain.triggerHandler(DSALES_GexCotizaciones.class);
}