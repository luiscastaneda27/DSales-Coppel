({
	showMessage : function(typeMessage,message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": typeMessage,
            "message": message
        }); 
        toastEvent.fire();
    },
    actualizarRegistros : function(component){
        var data = component.get("v.data");
        var action = component.get("c.actualizarRegistros");
        action.setParams({
            jsonString : JSON.stringify(data.listMatriz),
            recordId : component.get("v.recordId")
        });  
        action.setCallback(this, function(response) {
            this.showMessage('success', "Datos guardados exitosamente.");
            component.set("v.showSpinner", false);
            var object = {};
            object.count = 0;
            object.listMatriz = response.getReturnValue();
            object.siguienteDes = object.listMatriz.length < 3;
            object.anteriorDes = true;
            component.set("v.data", object);
            this.asignarMatriz(component);
            this.getClone(component);
        });
        $A.enqueueAction(action);
    },
    asignarMatriz : function(component){
        var object = component.get("v.data");
        for(let i=0; i<object.listMatriz.length; i++){
            for(let j=0; j<object.listMatriz[i].listMatriz.length; j++){
                object.listMatriz[i].listMatriz[j].seleccionado = false;
            }
        }
        var objectShow = {};
        objectShow.matriz1 = object.listMatriz[object.count];
        objectShow.seleccionadoPag1 = false;
        objectShow.matriz2 = {};
        if(object.count + 1 < object.listMatriz.length){
            objectShow.matriz2 = object.listMatriz[object.count + 1];
            objectShow.seleccionadoPag2 = false;
        }
        component.set("v.dataShow", objectShow);
    },
    eliminarData : function(component){
        var data = component.get("v.data");
        var dataShow = component.get("v.dataShow");
        var listRecord = data.popEliminarPag1 ? dataShow.matriz1.listMatriz : dataShow.matriz2.listMatriz;
        console.log("Listo "+data.popEliminarPag1);
        var action = component.get("c.eliminarRegistros");
        action.setParams({
            jsonString : JSON.stringify(listRecord),
            recordId : component.get("v.recordId")
        });  
        action.setCallback(this, function(response) {
            this.showMessage('success', "Datos guardados exitosamente.");
            component.set("v.showSpinner", false);
            var object = {};
            object.count = 0;
            object.listMatriz = response.getReturnValue();
            object.siguienteDes = object.listMatriz.length < 3;
            object.anteriorDes = true;
            component.set("v.data", object);
            component.set("v.showSpinner", false);
            this.asignarMatriz(component);
            this.hCancelar(component);
            this.getClone(component);
        });
        $A.enqueueAction(action);
    },
    hCancelar: function(component) {
        var object = component.get("v.data");
        object.popEliminarPag1 = false;
        object.popEliminarPag2 = false;
        object.popGuardar = false;
        component.set("v.data", object);
    },
    getClone : function(component){
        var data = component.get("v.data");
        var action = component.get("c.getClone");
        action.setParams({
            recordId : component.get("v.recordId")
        });  
        action.setCallback(this, function(response) {
            var object = response.getReturnValue();
            data.esClone = object.DSALES_EsClone__c;
            component.set("v.data", data);
        });
        $A.enqueueAction(action);
    }
    
})