global class DSALES_AssetWrapper {
    global class AssetRequest{
        global String name{get;set;}
        global String client_number{get;set;}
        global String contact_id{get;set;}
        global String product_type {get;set;}
        global String insurance_type {get;set;}
        global String service_type {get;set;}
        global String category {get;set;}
        global String subcategory {get;set;}
        global String class_type {get;set;}
        global String family {get;set;}
        //picklist values for Status: Adquirido,Cancelado,Devuelto 
        global String status {get;set;}
        global String region {get;set;}
        global String division {get;set;}
        global String sku {get;set;}
        global Integer warranty_duration {get;set;}
        global String serial_number {get;set;}
        global Date purchase_date {get;set;}
        global Integer quantity{get;set;}
        global Double price {get;set;}
        
   
    }
    global class AssetResponse{
        global Boolean success {get;set;}
        global String error_message {get;set;}
        global String asset_id {get;set;}
    }
}