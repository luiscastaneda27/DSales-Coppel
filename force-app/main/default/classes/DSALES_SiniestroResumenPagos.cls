@RestResource(urlMapping='/insertClaimPaymentSummary/*')
global with sharing class DSALES_SiniestroResumenPagos {
    @HttpPost
    global static DSALES_SiniestroRPWrapper.SiniestroRPResponse createSiniestroRP()
    {
        Boolean success=false;
        String message='';
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
                            message = 'Claim Payment Summary successfully saved';
                    
                    
                }catch(Exception e){
                    success = false;
                    message = 'Error: ' + e.getMessage() +' Line: '+e.getLineNumber();
                    
                }
                
            }
        }
        DSALES_SiniestroRPWrapper.SiniestroRPResponse responsePayload = new DSALES_SiniestroRPWrapper.SiniestroRPResponse();
        responsePayload.success = success;
        responsePayload.error_message = message;
        responsePayload.claimpayment_id = SiniestroRPRecord.id;
        
         System.debug('Termina proceso');
        return responsePayload;
        
    }	     
}