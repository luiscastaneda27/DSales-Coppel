import { LightningElement, api } from "lwc";
import { CloseActionScreenEvent } from "lightning/actions";


export default class QuickActionLWC extends LightningElement {
    @api
    myRecordId;

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert('No. of files uploaded : ' + uploadedFiles.length);
    }
    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleSave = event =>{
        event.preventDefault();
    }
       
    
}