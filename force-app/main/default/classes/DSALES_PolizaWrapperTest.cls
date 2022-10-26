@isTest
public class DSALES_PolizaWrapperTest {
	@isTest
    public static void wrapperTest(){
        DSALES_PolizaWrapper.polizaRequest req = new DSALES_PolizaWrapper.polizaRequest();
        req.business='test';
        req.contractor_birth_date='30/11/98';
        req.contractor_email='test@mail.com';
        req.contractor_first_name='Test';
        req.contractor_gender='Femenino';
        req.contractor_lastname='Test';
        req.contractor_phone='9785674532';
        req.contractor_rfc='245rtd33';
        req.contractor_second_lastname='Test';
        req.contractor_state_code='12';
        req.contractor_suburb_code='12';
        req.contractor_township_code='12';
        req.contractor_zip_code='12';
        req.emision_date='07/10/2022';
        req.insurance='qwrstvu75323';
        req.package_id='234689asd';
        req.payment_option='cdfgvbhui';
        req.payment_plan='test';
        req.quote_id='134dt7687';
        req.start_at='test';
        req.tracking_id='1234567lkjhgfds';
        req.vehicle_id='test';
        req.vehicle_model='test';
        req.vehicle_plate='test';
        req.vehicle_service='test';
        req.vehicle_type='test';
        req.vehicle_use='test';
        req.vehicle_vin='test';
        
        DSALES_PolizaWrapper.Insured_data insured = new DSALES_PolizaWrapper.Insured_data();
        insured.emission_date='12/102022';
        insured.end_date='12/10/2023';
        insured.policy='test';
        insured.start_date='07/10/2022';
        insured.vehicle_summ='test';
        
        DSALES_PolizaWrapper.Value_resume values= new DSALES_PolizaWrapper.Value_resume();
        values.net_premium='12.4';
        values.right='test';
        values.tax='test';
        values.total_premium='12.56';
        
        DSALES_PolizaWrapper.Data data = new DSALES_PolizaWrapper.Data();
        data.emission_id='test';
        data.policy_number='test';
        data.tracking_id='test';
        data.value_resume=values;
        data.insured_data=insured;
        DSALES_PolizaWrapper.Payment_data payment = new DSALES_PolizaWrapper.Payment_data();
        payment.data=data;
        
        DSALES_PolizaWrapper.Service service = new  DSALES_PolizaWrapper.Service();
        service.data=data;
        service.message='test';
        service.type='test';
        
        DSALES_PolizaWrapper.Datos datos=new DSALES_PolizaWrapper.Datos();
        datos.payment_data=payment;
        DSALES_PolizaWrapper.Application ap=new DSALES_PolizaWrapper.Application();
        ap.code=200;
        ap.data=datos;
        ap.success=true;
        
        DSALES_PolizaWrapper.Errors err=new DSALES_PolizaWrapper.Errors();
        err.service=service;
        
       
        
        
    }
}