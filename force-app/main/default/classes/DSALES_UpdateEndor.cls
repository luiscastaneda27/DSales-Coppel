global class DSALES_UpdateEndor Implements Schedulable{
        global void execute(SchedulableContext ctx){
            DSALES_EndorsementCalls.updateEndoso();
    }
}