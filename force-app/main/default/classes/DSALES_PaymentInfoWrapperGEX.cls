global class DSALES_PaymentInfoWrapperGEX {
    global class PaymentGEXRequest{
        global date sale_date {get;set;}
        global String store_key {get;set;}
        global String store_id {get;set;}
        global String product_type {get;set;}
        global String status {get;set;}
        global String bill {get;set;}
        global String cashier_box {get;set;}
        global String vendor_id {get;set;}
        global String vendor_name {get;set;}
        global String exp_en {get;set;}
        global String client_id {get;set;}
        global String customer_adress {get;set;}
        global String customer_number {get;set;}
        global String telephone {get;set;}
        global String movilPhone {get;set;}
        global String asset_id {get;set;}
        global String sku {get;set;}
        global double price {get;set;}
        global double cash_total {get;set;}
        global double credit_VAT {get;set;}
        global double electronic_money {get;set;}
        global double paymentElectronic_money {get;set;}
        global double cash_payment {get;set;}
        global double change {get;set;}
        global double wonElectronic_money {get;set;}
        global boolean GEX_paid {get;set;}
        global String certified_id {get;set;}
        global String opportunity_id {get;set;}
        global double price_noVAT {get;set;}
        global double price_DiscountVAT {get;set;}
        global double price_DiscountNoVAT {get;set;}
	}
	global class PaymentGEXResponse{
        global Boolean success {get;set;}
        global String error_message {get;set;}
        global String paymentInfo_id {get;set;}
     }

}