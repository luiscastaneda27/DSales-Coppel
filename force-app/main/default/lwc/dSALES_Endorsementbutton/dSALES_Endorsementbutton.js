import { LightningElement, track, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import crearEndoso from '@salesforce/apex/DSALES_EndorsementController.crearEndoso';
import validarDoc from '@salesforce/apex/DSALES_EndorsementController.validarDoc';

export default class DSALES_Endorsementbutton extends LightningElement {
    @api recordId;
    estatus = true;
    isModalOpen = true;
    result = '';
    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    sendEndorsement() {
        validarDoc({ idObject: this.recordId })
            .then(result => {
                this.result = result;
                console.log(result);
                if (result >= 18) {
                    crearEndoso({ idEndoso: this.recordId })
                        .then(result => {
                            this.estatus = result;
                            console.log(this.estatus);
                            this.pushMessage('Exitoso', 'success', 'Endoso Enviado exitosamente.');
                            this.dispatchEvent(new CloseActionScreenEvent());

                        }).catch(error => {
                            console.log('Error en sendEndorsement');
                            console.log(this.estatus);
                            this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
                            this.dispatchEvent(new CloseActionScreenEvent());
                        });
                } else {
                    this.pushMessage('Error', 'error', 'Faltan documentos por subir.');
                    this.dispatchEvent(new CloseActionScreenEvent());
                }
            }).catch(error => {
                console.log('Error en enviar Siniestro');
                console.log(this.estatus);
                this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
                this.dispatchEvent(new CloseActionScreenEvent());
            });

    }

    pushMessage(title, variant, msj) {
        const message = new ShowToastEvent({
            "title": title,
            "variant": variant,
            "message": msj
        });
        this.dispatchEvent(message);
        eval("$A.get('e.force:refreshView').fire();");
    }

}