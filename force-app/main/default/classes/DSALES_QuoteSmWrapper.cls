global class DSALES_QuoteSmWrapper {
    global class QuoteSmRequest{
        global String client_number {get;set;}
        global String first_name {get; set;}
        global String middle_name {get;set;}
        global String last_name {get;set;}
        global String suffix {get;set;}
        global String store_id {get; set;}
        global String vendedor {get;set;}
        global List<Product> productList {get;set;}
        
        //pedido por inter
        global String contact_phone {get; set;}
        global String contact_email {get;set;}
        global String contact_gender {get; set;}
        global Date contact_birth_date {get; set;}
        global String contact_state_code {get; set;}
        global String contact_township_code {get; set;}
        global Integer contact_suburb_code {get; set;}
        global String contact_zip_code{get; set;}
        global String vehicle_id {get; set;}
        global String payment_option {get; set;}
        global String packagge {get; set;}
        global date start_at {get; set;}
 }
    global class QuotePostProvedor{
        //Inter Cotizacion
        //global String tracking_id;
        global String business {get; set;} //sales-fijo
        global String insurance {get; set;} //sales-fijo
        global String contact_name {get; set;}//combinacion
        global String contact_method {get; set;}//sales-fijo
        global String contact_phone {get; set;}
        global String contact_email {get;set;}
        global String contact_gender {get; set;}
        global String contact_birth_date {get; set;}
        global String contact_state_code {get; set;}
        global String contact_township_code {get; set;}
        global Integer contact_suburb_code {get; set;}
        global String contact_zip_code{get; set;}
        global Boolean contact_now {get; set;}//fijo-sales
        global String vehicle_id {get; set;}
        global String vehicle_service {get; set;}//fijo-sales
        global String vehicle_use {get; set;}//fijo-sales
        global String vehicle_type {get; set;}//fijo-sales
        global String payment_option {get; set;}
        global String packagge {get; set;}
        global String promotion_code {get; set;}//fijo
        global String associate_id {get; set;}//fijo
        global String quote_date {get; set;}//fecha creacion-sales
        global String start_at {get; set;}
    }

	global class Product {
		global String sku {get;set;}

	}
    global class respuestaDelProveedor{
		global Integer code {get;set;}
        global Boolean success {get;set;}
        global Data data {get;set;}
	}

    global class RespuestaParaNpv{
        global String quoteId {get;set;}
        global String message {get;set;}
        global String Cliente {get;set;}
        global String oppor {get;set;}
        global String cotiza {get;set;}
        global Receipt rc {get;set;}
        global Receipt amp {get;set;}
    }

    global class CoveragesArray{
        global String code {get;set;}
        global String name {get;set;}
        global Integer deductive {get;set;}
        global String sum_assured {get;set;}
    }
    
    global class Data{
        global List<CoveragesArray> coverages_array {get;set;}
        global String quote_id {get;set;}
        global List<Receipt> receipts {get;set;}
        global InsurancePremium insurance_premium {get;set;}
        global String police_id {get;set;}
        global String company_logo {get;set;}
        global List<PaymentOptionsJson> payment_options_json {get;set;}
    }
    
    global class InsurancePremium{
        global Double net_premium {get;set;}
        global Integer commission {get;set;}
        global Double surcharge {get;set;}
        global Double tax {get;set;}
        global Double right {get;set;}
    }
    
    global class PaymentOptionsJson{
        global String value {get;set;}
        global String label {get;set;}
    }
    
    global class Receipt{
        global Integer numbere {get;set;}
        global String start_date {get;set;}
        global String end_date {get;set;}
        global String net_premium {get;set;}
        global String total_premium {get;set;}
        global String right {get;set;}
        global String recharge {get;set;}
        global String tax {get;set;}
        global String commission {get;set;}
    }
}