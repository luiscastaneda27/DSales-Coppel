public class DSALES_InformacionPagoHandler {
    public static void CambiaClienteCautivo(List<DSALES_InformacionDePago__c>actualInfoPago){
        List<Account> clientes = new List<Account>();    
        for(DSALES_InformacionDePago__c info: actualInfoPago){
            if(info.DSALES_Estatus__c == 'Acreditado'){
                Account aux  = [SELECT Id, FinServ__Status__c FROM Account WHERE Id=:info.DSALES_Cliente__c];
                Aux.FinServ__Status__c = 'Cautivo';
                clientes.add(aux);           
            }
        }
        update clientes;       
    }
}