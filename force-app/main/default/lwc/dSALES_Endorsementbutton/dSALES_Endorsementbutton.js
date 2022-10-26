import { LightningElement, track, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import crearEndoso from '@salesforce/apex/DSALES_EndorsementController.crearEndoso';  

export default class DSALES_Endorsementbutton extends LightningElement {
    @api recordId;
    estatus = true;
    isModalOpen = true;

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    sendEndorsement(){
        crearEndoso({idEndoso: this.recordId})
        .then(result => {
            this.estatus = result;
            console.log(this.estatus);
            this.pushMessage('Exitoso', 'success', 'Endoso Enviado exitosamente.');
            eval("$A.get('e.force:refreshView').fire();");
        }).catch(error => {
            console.log('Error en sendEndorsement');
            console.log(this.estatus);
            this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
        });
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    pushMessage(title,variant,msj){
        const message = new ShowToastEvent({
            "title": title,
            "variant": variant,
            "message": msj
            });
            this.dispatchEvent(message);
    }
}