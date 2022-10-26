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
}
global class PaymentResponse{
    global Boolean success {get;set;}
    global String error_message {get;set;}
    global String paymentInfo_id {get;set;}
    }

}