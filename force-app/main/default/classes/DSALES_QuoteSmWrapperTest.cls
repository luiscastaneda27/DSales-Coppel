@isTest
public class DSALES_QuoteSmWrapperTest {
    @isTest 
    static void CreateQuoteCredito(){
        DSALES_QuoteSmWrapper.QuoteSmRequest requestnpv = new DSALES_QuoteSmWrapper.QuoteSmRequest();
        requestnpv.client_number = 'dato';
        requestnpv.vehicle_use='Moto';
        requestnpv.vehicle_type='Comercial';
        requestnpv.rfc='wrr2r2r';
        requestnpv.plazo='12';
        requestnpv.first_name = 'dato';
        requestnpv.middle_name = 'dato';
        requestnpv.last_name = 'dato';
        requestnpv.suffix = 'dato';
        requestnpv.store_id = 'dato';
        requestnpv.vendedor = 'dato';
        requestnpv.productList = new List<DSALES_QuoteSmWrapper.Product>();
        DSALES_QuoteSmWrapper.Product aux = new DSALES_QuoteSmWrapper.Product();
        aux.sku = '2323';
        requestnpv.productList.add(aux);
        requestnpv.contact_phone = 'dato';
        requestnpv.contact_email = 'dato';
        requestnpv.contact_gender = 'dato';
        requestnpv.contact_birth_date = date.newInstance(1991, 2, 15);
        requestnpv.contact_state_code = 'dato';
        requestnpv.contact_township_code = 'dato';
        requestnpv.contact_suburb_code = 12;
        requestnpv.contact_zip_code = 'dato';
        requestnpv.vehicle_id = 'dato';
        requestnpv.payment_option = 'dato';
        requestnpv.packagge = 'dato';
        requestnpv.start_at = date.newInstance(1991, 2, 15);
        
        DSALES_QuoteSmWrapper.QuotePostProvedor requesAInter = new DSALES_QuoteSmWrapper.QuotePostProvedor();
        requesAInter.business = 'dato';
        requesAInter.insurance = 'dato';
        requesAInter.contact_name = 'dato';
        requesAInter.contact_method = 'dato';
        requesAInter.contact_phone = 'dato';
        requesAInter.contact_email = 'dato';
        requesAInter.contact_gender = 'dato';
        requesAInter.contact_birth_date ='23-2-333';
        requesAInter.contact_state_code = 'dato';
        requesAInter.contact_township_code = 'dato';
        requesAInter.contact_suburb_code = 3;
        requesAInter.contact_zip_code ='23';
        requesAInter.contact_now = true;
        requesAInter.vehicle_id = 'dato';
        requesAInter.vehicle_service = '34';
        requesAInter.vehicle_use = 'dato';
        requesAInter.vehicle_type = 'dato';
        requesAInter.payment_option = 'dato';
        requesAInter.packagge = 'dato';
        requesAInter.promotion_code = 'dato';
        requesAInter.associate_id = 'dato';
        requesAInter.quote_date = '12-12-12';
        requesAInter.start_at = '12-12-12';
        
        
        DSALES_QuoteSmWrapper.respuestaDelProveedor response = new DSALES_QuoteSmWrapper.respuestaDelProveedor();
        response.code = 12;
        response.data = new DSALES_QuoteSmWrapper.Data();
        response.success = true;
        
        
        DSALES_QuoteSmWrapper.RespuestaParaNpv responseNpv = new DSALES_QuoteSmWrapper.RespuestaParaNpv();
        responseNpv.quoteId = 'dads';
        responseNpv.message= 'dads';
        responseNpv.Cliente= 'dads';
        responseNpv.oppor ='dads';
        responseNpv.cotiza ='dads';
        responseNpv.rc = new DSALES_QuoteSmWrapper.Receipt();
        responseNpv.rc.numbere = 23;
        responseNpv.rc.start_date = '23';
        responseNpv.rc.end_date = '23';
        responseNpv.rc.net_premium = '23';
        responseNpv.rc.total_premium = '23';
        responseNpv.rc.right = '23';
        responseNpv.rc.recharge = '23';
        responseNpv.rc.tax = '23';
        responseNpv.rc.commission = '23';
        responseNpv.amp = new DSALES_QuoteSmWrapper.Receipt();
        
        DSALES_QuoteSmWrapper.Data dat = new DSALES_QuoteSmWrapper.Data();
        dat.coverages_array = new List<DSALES_QuoteSmWrapper.CoveragesArray>();
        DSALES_QuoteSmWrapper.CoveragesArray cover = new DSALES_QuoteSmWrapper.CoveragesArray();
        cover.code='2';
        cover.deductive=123;
        cover.name='2';
        cover.sum_assured='2';
        dat.coverages_array.add(cover);
        
        dat.quote_id = 'nsq';
        dat.receipts = new List<DSALES_QuoteSmWrapper.Receipt>();
        dat.insurance_premium = new DSALES_QuoteSmWrapper.InsurancePremium();
        dat.insurance_premium.net_premium = 12.43;
        dat.insurance_premium.commission = 12;
        dat.insurance_premium.surcharge = 12.43;
        dat.insurance_premium.tax = 12.43;
        dat.insurance_premium.right = 12.43;
        
        dat.payment_options_json = new List<DSALES_QuoteSmWrapper.PaymentOptionsJson>();
        DSALES_QuoteSmWrapper.PaymentOptionsJson payOption = new DSALES_QuoteSmWrapper.PaymentOptionsJson();
        payOption.value = 'ads';
        payOption.label = 'ads';
        dat.payment_options_json.add(payOption);
        dat.police_id ='123';
        dat.company_logo = 'qweq';
        

    }

}