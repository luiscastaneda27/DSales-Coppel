global class DSALES_IPAssetWrapper {
    global class IPAssetRequest{
        global String store{get;set;}
        //Información de Pago
        global String payment_info{get;set;}
        //global String ticket{get;set;}
        global String partner{get;set;}
       // global String client_id{get;set;}
        //global String client_name{get;set;}
        global Boolean external_motorcycle{get;set;}
        //global String invoice_number{get;set;}
        
        global Double invoice_value{get;set;}
        global String status{get;set;}
        global String key_amis{get;set;}
        global String key_vehicle{get;set;}
        global String description{get;set;}
        global String brand{get;set;}
        global String model{get;set;}
        global String motor_number{get;set;}
        global String serial_number{get;set;}
        global String license_plate{get;set;}
        global String service{get;set;}
        global String use{get;set;}
        global String asset_name{get;set;}
        global String motorcycle_delivered{get;set;}
        
        
        
   
    }
    global class IPAssetResponse{
        global Boolean success {get;set;}
        global String error_message {get;set;}
        global Integer error_code {get;set;}
        global String asset_id {get;set;}
    }
}