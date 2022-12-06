@RestResource(urlMapping='/insertClaimPaymentSummary/*')
global with sharing class DSALES_SiniestroResumenPagos {
    @HttpPost
    global static DSALES_SiniestroRPWrapper.SiniestroRPResponse createSiniestroRP()
    {
        Boolean success=false;
        String message='';
        Integer code;
        ClaimPaymentSummary SiniestroRPRecord = new ClaimPaymentSummary();
        if(RestContext.request != null){
            String Body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(Body)){
                try{
                    DSALES_SiniestroRPWrapper.SiniestroRPRequest SiniestroRP = (DSALES_SiniestroRPWrapper.SiniestroRPRequest)JSON.deserialize(body, DSALES_SiniestroRPWrapper.SiniestroRPRequest.class);
                    Claim siniestro=[SELECT Id FROM Claim WHERE id=:SiniestroRP.claimpayment_info];
                        
                            SiniestroRPRecord.ClaimId=siniestro.Id;
                            SiniestroRPRecord.PaymentAmount= SiniestroRP.payment_amount;
                            SiniestroRPRecord.Name = SiniestroRP.claimpayment_name;
                            SiniestroRPRecord.DSALES_Tipopago__c= SiniestroRP.payment_type;
                            SiniestroRPRecord.PaymentDate= SiniestroRP.payment_date;
							upsert SiniestroRPRecord;
                            
                             
                            success = true;
                            
                    
                    
                }catch(Exception.JSONException ed){
                    success =false;
                    message= DSALES_Utility.BAD_REQUEST_MSJ;
                    code= DSALES_Utility.BAD_REQUEST_CODE;

                }catch(Exception e){
                    success =false;
                    message= DSALES_Utility.INTERNAL_ERROR_MSJ;
                    code= DSALES_Utility.INTERNAL_ERROR_CODE; 
                }
                
            }
        }
        DSALES_SiniestroRPWrapper.SiniestroRPResponse responsePayload = new DSALES_SiniestroRPWrapper.SiniestroRPResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.error_code = code;
        responsePayload.claimpayment_id = SiniestroRPRecord.id;
        
         System.debug('Termina proceso');
        return responsePayload;
        
    }	     
}