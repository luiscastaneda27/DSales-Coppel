global class DSALES_AccountWrapper {
	
    global class AccountRequest{
        global String client_number {get;set;}
        global String first_name {get; set;}
        global String middle_name {get;set;}
        global String last_name {get;set;}
        global String suffix {get;set;}
        global string marital_status {get;set;}
        global String telephone {get;set;}
        global String email {get;set;}
        global String contact_method {get;set;}
        global String gender {get;set;}
        global Date birthdate {get;set;}
        global String state_code {get;set;}
        global String city_code {get;set;}
        global String town_code {get;set;}
        global String suburb_code{get;set;}
        global String zip_code {get;set;}
        global Boolean contact_now {get;set;}       
    }
    global class AccountResponse{
        global Boolean success {get;set;}
        global String error_code {get;set;}
        global String error_message {get;set;}
        global String account_id {get;set;}
    }
}