({
   recordUpdate: function(component, event, helper) {
       var clm =(component.get("v.claim").ClaimType);
       if(clm!= 'Robo Total'){
           alert("there");
       }
           
    }, 
    handleUploadFinished: function (cmp, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));    
        //get the success message
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The file has been uploaded successfully."
        })
        
        toastEvent.fire();
    },
    
    handleClick : function (cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();
        
    }
    
});