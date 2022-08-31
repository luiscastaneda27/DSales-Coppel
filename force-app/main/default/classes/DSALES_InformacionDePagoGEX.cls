public class DSALES_InformacionDePagoGEX {
    
    public class InformacionDePagoRequest{
        public String store_id {get;set;}
        public String store_name{get;set;}
        public String address_store {get;set;}
        public String box_id {get;set;}
        public String seller_id {get;set;}
        public String phone_store {get;set;}
        public String exp_in {get;set;}
        public String client_number {get;set;}
        public String first_name {get; set;}
        public String middle_name {get;set;}
        public String last_name {get;set;}
        public String suffix {get;set;}
        public String state_code {get;set;}
        public String town_code {get;set;}
        public String suburb_code{get;set;}
        public String zip_code {get;set;}
        public String client_address {get;set;}
        public String sku {get;set;}
        public String description {get;set;}
        public Decimal price {get;set;}
        public Integer warranty_time {get;set;}
        public Decimal total_cash {get;set;}
        public Decimal electronic_money_payment {get;set;}
        public Decimal less_down_payment {get;set;}
        public Decimal cash_payment {get;set;}
        public Decimal change {get;set;}
        public Decimal credit_with_vat {get;set;}
        public Decimal earned_electronic_money {get;set;}
        public Decimal electronic_money_balance {get;set;}
        public Integer date_of_monthly_payments {get;set;}
        public Decimal Monthly_payment {get;set;}
        public Decimal deferred_payments {get;set;}
        public Decimal total_furniture_balance {get;set;}
    }
    
    public class InformacionDePagoResponse{
        public Boolean success {get;set;}
        public String error_message {get;set;}
        public String payment_information_id {get;set;}
    }
}