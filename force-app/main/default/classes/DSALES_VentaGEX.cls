global class DSALES_VentaGEX {
    
    global class VentaGexRequest{
        global String quoteId{get;set;}
        global List<DSALES_AssetWrapper.AssetRequest> listAssets {get;set;}
        global List<DSALES_PaymentInfoWrapperGEX.PaymentGEXRequest> paymentInformation {get;set;}
        global List<DSALES_CertificadoWrapper.CertificadoRequest> certificado{get;set;}
        global DSALES_AccountWrapper.AccountRequest cliente{get;set;}
    }
    
    global class VentaGexResponse{
        global Boolean success {get;set;}
        global String error_message {get;set;}
        global String error_code {get;set;}
        global List<String> assets_id {get;set;}
        global List<String> certifieds_id {get;set;}
        global List<String> payments_id {get;set;}
    }
    
}