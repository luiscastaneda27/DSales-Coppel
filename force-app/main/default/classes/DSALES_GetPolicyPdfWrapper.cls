public with sharing class DSALES_GetPolicyPdfWrapper {
    public class requestWrapper{
    public String Poliza{get;set;}
    public String insurance{get;set;}
    public String business{get;set;}
    public String tracking_id{get;set;}
    }

    public class Data {
    public string policy_url { get; set; }
    public List<Errors> errors {get;set;}

    }
    public class responseWrapper {
    public Integer code { get; set; }
    public Boolean success { get; set; }
    public Data data { get; set; } 

    }

    public class Policy {
    public string message { get; set; }

    }
    public class Errors {
    public Policy policy { get; set; } 

    }
}