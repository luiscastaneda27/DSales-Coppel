global class DSALES_VentaSM {
		global class VentaSMRequest{
			global String quoteId{get;set;}
			global DSALES_PaymentInfoWrapper.PaymentRequest pagos {get;set;}
			global DSALES_IPAssetWrapper.IPAssetRequest activos {get;set;}
			global DSALES_AccountWrapper.AccountRequest cliente{get;set;}
		}

		global class VentaSMResponse{
			global String message {get;set;}
		}
}