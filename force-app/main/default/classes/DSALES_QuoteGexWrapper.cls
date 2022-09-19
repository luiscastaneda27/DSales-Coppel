global class DSALES_QuoteGexWrapper {
    global class QuoteGexRequest{
        //global String tangible_name	{get; set;}
        //global Double tangible_price {get; set;}
        //global String type_service {get; set;}
        //global String vendor_id	{get; set;}
        global String store_id {get; set;}
        global String client_number {get;set;}
        global String first_name {get; set;}
        global String middle_name {get;set;}
        global String last_name {get;set;}
        global String suffix {get;set;}
        global Date birthdate {get;set;}
        global String division {get;set;}
        global String region {get;set;}
        global String method_payment {get;set;}
        global String email {get;set;}
        //global String telephone {get;set;}
        global Date Estimated_delivery_date {get;set;}
        global String Address_Store {get;set;}
        //global String vendedor_name {get;set;}
        global String store_name {get;set;}
        global List<Product> productList {get;set;}
 }
	global class Product {
		global String sku {get;set;}
		global Double Quantity_tangible_products {get;set;}
        global String article {get; set;}
        global String model {get; set;}
        global String brand {get; set;}
        global String product_type {get; set;}
	}

    global class QuoteGexResponse{
        global String	quote_id	{get;set;}
        global String	intangible_name	{get;set;}
        global String	category	{get;set;}
        global String	class1	{get;set;}
        global String	family	{get;set;}
        global double	price	{get;set;}
        global double	total_cost	{get;set;}
        global String	service_type	{get;set;}
        
    }
    
}