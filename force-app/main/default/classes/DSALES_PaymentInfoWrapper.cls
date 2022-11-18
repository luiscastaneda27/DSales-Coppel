global class DSALES_PaymentInfoWrapper {
    global class PaymentRequest{
    global String cashier_box {get;set;} 
    global String article_description {get;set;}
	global String payment_method {get;set;}
    global String bill {get;set;}
    global String customer_adress {get;set;}
    global String sku {get;set;}
    global String telephone {get;set;}
    global double total {get;set;}
    global String salesman_name {get;set;}
    global String opportunity_name {get;set;}
    global boolean moto_delivered {get;set;}
    global boolean external_moto {get;set;}
    global boolean moto_noInsurance {get;set;}
    global String tipoProducto{get;set;}
    
    //Lo nuevo
    global String quoteid {get;set;}
    global String AccountId {get;set;}
    global List<pago> ListadePagos{get;set;}
    
}
global class PaymentResponse{
    global String message {get;set;}
    global Integer errorCode {get;set;}
    global Boolean success {get;set;}
    global List<Id> paymentInfo_ids {get;set;}
    }
    
global class pago{
    global double total {get;set;}
    global String producto {get;set;}
    }

}