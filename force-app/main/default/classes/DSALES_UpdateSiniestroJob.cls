global class DSALES_UpdateSiniestroJob Implements Schedulable{
    global void execute(SchedulableContext ctx){
            DSALES_SiniestroCalls.updateSiniestro();
    }

}