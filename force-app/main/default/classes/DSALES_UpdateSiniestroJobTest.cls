@isTest
public class DSALES_UpdateSiniestroJobTest {
    @isTest
    static void SiniestroJob(){
        Test.startTest();
        DSALES_UpdateSiniestroJob job = new DSALES_UpdateSiniestroJob();
        job.execute(null);
       	Test.stopTest(); 
    }

}