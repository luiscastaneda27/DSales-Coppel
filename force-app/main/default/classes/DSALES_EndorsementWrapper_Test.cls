@isTest
public class DSALES_EndorsementWrapper_Test {
    @isTest
    static void objecto(){
        DSALES_EndorsementWrapper.endorsementRequest objpost= new DSALES_EndorsementWrapper.endorsementRequest();
        objpost.uid = 'gg';
        objpost.TipoEndoso = 'gg';
        objpost.NumeroPoliza = 'gg';
        objpost.FechaEndoso = date.newInstance(1991, 2, 15);
        objpost.Estatus = 'gg';
        objpost.salesforceid = 'gg';
       
        objpost.Documentos = new DSALES_EndorsementWrapper.documento();
        objpost.Documentos.TipoDocumento = 'gg';
        objpost.Documentos.Documento = 'gg';
        objpost.Documentos.IdDocumento='gg';
        
        objpost.Datos = new DSALES_EndorsementWrapper.dato();
        objpost.Datos.TipoDato = 'gg';
        objpost.Datos.Valor = 'gg';
        objpost.Datos.IdDato = 'gg';
        
        DSALES_EndorsementWrapper.endorsementResponse obj= new DSALES_EndorsementWrapper.endorsementResponse();
        obj.ok = 'ok';
        obj.response = 'ok';
        obj.msg = 'ok';
        obj.Endoso = new DSALES_EndorsementWrapper.Endoso();
        obj.Endoso.uid='ssff';
        
        DSALES_EndorsementWrapper.getResponse obj2= new DSALES_EndorsementWrapper.getResponse();
        obj2.uid = 'gg';
        obj2.TipoEndoso = 'gg';
        obj2.NumeroPoliza = 'gg';
        obj2.FechaEndoso = '45-45-56';
        obj2.FechaAplicacionEndoso = '12/12/23';
        obj2.Estatus = 'gg';
        obj2.ComentarioEstatus = 'gg';
        //
        obj2.salesforceid = 'gg';
        obj2.Datos = new List<DSALES_EndorsementWrapper.dato>();
        DSALES_EndorsementWrapper.dato datoAux = new DSALES_EndorsementWrapper.dato();
        datoAux.TipoDato = 'gg';
        datoAux.Valor = 'gg';
        datoAux.IdDato = 'gg';
        obj2.Datos.add(datoAux);
        obj2.Documentos = new List<DSALES_EndorsementWrapper.documento>();
        DSALES_EndorsementWrapper.documento docuAux = new DSALES_EndorsementWrapper.documento();
        docuAux.TipoDocumento = 'gg';
        docuAux.Documento = 'gg';
        docuAux.IdDocumento='gg';
        obj2.Documentos.add(docuAux);
       
        
        
    }

}