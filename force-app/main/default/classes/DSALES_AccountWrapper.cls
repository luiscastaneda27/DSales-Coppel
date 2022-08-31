public class DSALES_AccountWrapper {
	
    public class AccountRequest{
        public String client_number {get;set;}
        public String first_name {get; set;}
        public String middle_name {get;set;}
        public String last_name {get;set;}
        public String suffix {get;set;}
        public String telephone {get;set;}
        public String email {get;set;}
        public String contact_method {get;set;}
        public String gender {get;set;}
        public Date birthdate {get;set;}
        public String state_code {get;set;}
        public String town_code {get;set;}
        public String suburb_code{get;set;}
        public String zip_code {get;set;}
        public Boolean contact_now {get;set;}       
    }
    public class AccountResponse{
        public Boolean success {get;set;}
        public String error_message {get;set;}
        public String account_id {get;set;}
    }
}