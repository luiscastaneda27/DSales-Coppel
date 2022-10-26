public class DSALES_PolizaWrapper {
    
	 //wrapper de campos para enviar a inter
    public class polizaRequest{
        public String tracking_id {get; set;}
        public String quote_id{get; set;}
        public String business{get; set;}
        public String insurance{get; set;}
        public String package_id{get; set;}
        public String payment_plan{get; set;}
        public String payment_option {get;set;}
        public String vehicle_id{get; set;}
        public String vehicle_service{get; set;}
        public String vehicle_use{get; set;}
        public String vehicle_vin{get; set;}
        public String vehicle_plate{get; set;}
        public String vehicle_type {get;set;}
        public String vehicle_model{get; set;}
        public String contractor_first_name{get; set;}
        public String contractor_lastname{get; set;}
        public String contractor_second_lastname{get; set;}
        public String contractor_birth_date{get;set;}
        public String contractor_rfc{get; set;}
        public String contractor_email{get; set;}
        public String contractor_phone{get;set;}
        public String contractor_gender{get;set;}
        public String contractor_zip_code{get;set;}
        public String contractor_state_code{set;get;}
        public String contractor_township_code{get;set;}
        public String contractor_suburb_code{get;set;}
        public String emision_date{get; set;}
        public String start_at{get; set;}
    }

    public class Insured_data {
        public string policy { get; set; }
        public string start_date { get; set; }
        public string end_date { get; set; }
        public string emission_date { get; set; }
        public string vehicle_summ { get; set; }
       
    }
    public class Value_resume {
        public string net_premium { get; set; }
        public string total_premium { get; set; }
        public string right { get; set; }
        public string tax { get; set; }
       
    }
    public class Data {
        public string emission_id { get; set; }
        public string tracking_id { get; set; }
        public string policy_number { get; set; }
       public Insured_data insured_data { get; set; } 
       public Value_resume value_resume { get; set; } 
       
    }
    public class Payment_data {
       public Data data { get; set; } 
       
    }
    public class Datos {
       public Payment_data payment_data { get; set; }
       public List<Errors> errors { get; set; }
       
    }
    public class Application {
        public Integer code { get; set; }
        public Boolean success { get; set; }
        public Datos data { get; set; } 
       
    }

    public class Service {
        public string type { get; set; }
        public string message { get; set; }
       public Data data { get; set; } 
       
       }
       public class Errors {
       public Service service { get; set; } 
       
       }
       
}