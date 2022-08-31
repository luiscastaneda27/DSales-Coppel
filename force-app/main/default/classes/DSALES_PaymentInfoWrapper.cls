public class DSALES_PaymentInfoWrapper {
    public class PaymentRequest{
    public String cashier_box {get;set;} 
    public String id_store {get;set;}
    public String client_number {get;set;}
    public String article_description {get;set;}
    public String bill {get;set;}
    public String payment_method {get;set;}
    public String engine {get;set;}
    public String serial_number {get;set;}
    public String store_name {get;set;}
    public String salesman_name {get;set;}
    public double price {get;set;}
    public String id_quote {get;set;}
    }
    public class PaymentResponse{
        public Boolean success {get;set;}
        public String error_message {get;set;}
        public String account_id {get;set;}
    }

}