import { LightningElement,wire, track} from "lwc";
import { CloseActionScreenEvent } from "lightning/actions";
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import DSALES_TIPO_DE_ENDOSO__C from '@salesforce/schema/DSALES_Endoso__c.DSALES_Tipodeendoso__c';


export default class QuickActionLWC extends LightningElement {
    
    @track pickListValues;
    @track error;
    @track values;
    
    @wire(getPicklistValues, { 
        recordTypeId: '012000000000000AAA', 
        fieldApiName: DSALES_TIPO_DE_ENDOSO__C 
    })
   
    wiredPickListValue({data, error}){
        if(data){
            console.log(`pickList values are `,data.values);
            this.pickListValues= data.values;
            this.error= undefined;
        }
        if(error){
            console.log(`Error while fetching the pickList values ${error}`);
            this.pickListValues= undefined;
            this.error= error;
        }
    }

    get acceptedFormats() {
        return ['.pdf', '.png', '.xlsx', '.xls', '.csv', '.doc', '.docx'];
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
    handleChange() {
       
    }     
    
}