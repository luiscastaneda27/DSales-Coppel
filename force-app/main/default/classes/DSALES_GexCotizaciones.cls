public class DSALES_GexCotizaciones extends fflib_SObjectDomain {
    public DSALES_GexCotizaciones(List<Quote> sObjectList){
        Super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<Sobject> sObjectList){
            return new DSALES_GexCotizaciones(sObjectList);
        }
    }
    
    
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        DSALES_GexCotizacionesHelper.envioCotizacionGex(JSON.serialize(records), JSON.serialize(existingRecords));
    }
}