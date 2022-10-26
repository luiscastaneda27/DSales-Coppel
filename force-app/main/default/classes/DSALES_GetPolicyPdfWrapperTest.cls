@isTest
public class DSALES_GetPolicyPdfWrapperTest {
	@isTest
    public static void wrapperTest(){
       DSALES_GetPolicyPdfWrapper.requestWrapper req = new DSALES_GetPolicyPdfWrapper.requestWrapper();
       req.business='test';
       req.insurance='test';
       req.Poliza='1243we6fg';
       req.tracking_id='test';
        
        DSALES_GetPolicyPdfWrapper.Policy policy = new DSALES_GetPolicyPdfWrapper.Policy();
        policy.message='esto es una prueba';
        
        /*List<DSALES_GetPolicyPdfWrapper.Errors> error = new List<DSALES_GetPolicyPdfWrapper.Errors>();
        error[0].policy=policy;*/
        
        DSALES_GetPolicyPdfWrapper.Data data = new DSALES_GetPolicyPdfWrapper.Data();
        data.policy_url='test';
       // data.errors=error;*/
        
        DSALES_GetPolicyPdfWrapper.responseWrapper response= new DSALES_GetPolicyPdfWrapper.responseWrapper();
        response.code=200;
        response.success=true;
        response.data=data;
        
    }
}