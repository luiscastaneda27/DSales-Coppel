global class DSALES_VentaSM {
		global class VentaSMRequest{
			global String quoteId{get;set;}
			global DSALES_PaymentInfoWrapper.PaymentRequest pagos {get;set;}
			global DSALES_IPAssetWrapper.IPAssetRequest activos {get;set;}
			global DSALES_AccountWrapper.AccountRequest cliente{get;set;}
		}

		global class VentaSMResponse{
			global Boolean success {get;set;}
			global String client_id{get;set;}
			global List<String> payments_id {get;set;}
			global List<String> assets_id {get;set;}
			global String error_message {get;set;}
			global Integer error_code {get;set;}
		
		}
}