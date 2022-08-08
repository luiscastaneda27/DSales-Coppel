({
	init : function(component, event, helper) {
		var action = component.get("c.getClone");
        action.setParams({
            recordId : component.get("v.recordId")
        });  
        action.setCallback(this, function(response) {
            var object = response.getReturnValue();
            component.set("v.esClone", object.DSALES_EsClone__c);
            component.set("v.cloneId", object.DSALES_CloneMatriz__c);
        });
        $A.enqueueAction(action);
    },
    cancelar : function(component, event, helper) {
		helper.hCancelar();
	},
    clonar : function(component, event, helper) {
        let esClone = component.get("v.esClone");
        let cloneId = component.get("v.cloneId");
        if(cloneId == null){
            var action = component.get("c.clonarMatriz");
            action.setParams({
                recordId : component.get("v.recordId")
            });  
            action.setCallback(this, function(response) {
                cloneId = response.getReturnValue();
                helper.navigationRecord(cloneId);
                helper.hCancelar();
            });
            $A.enqueueAction(action);
        }else{
            helper.navigationRecord(cloneId);
            helper.hCancelar();  
        }
        
	},
    actualizar : function(component, event, helper) {
        var action = component.get("c.actualizarMatrizOriginal");
        action.setParams({
            recordId : component.get("v.recordId")
        });  
        action.setCallback(this, function(response) {
            let cloneId = response.getReturnValue();
            helper.navigationRecord(cloneId);
            helper.hCancelar();
        });
        $A.enqueueAction(action);
        
	}
})