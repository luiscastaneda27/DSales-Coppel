import { LightningElement, track, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import crearSiniestro from '@salesforce/apex/DSALES_SiniestroController.Siniestro';  
import validateDocs from '@salesforce/apex/DSALES_SiniestroController.validarDoc';  


export default class dSALES_SiniestroButton extends LightningElement {
    @api recordId
    resul ='';
    closeQuickAction(){
      const closeQA = new CustomEvent('close');
      this.dispatchEvent(closeQA);
    }
  
    sendSiniestro() {

        validateDocs({ idObject: this.recordId })
            .then(result => {
                this.resul = result;
                console.log(result);
                if (result >= 18) {
                    crearSiniestro({ idSiniestro: this.recordId })
                        .then(result => {
                            this.resul = result;
                            console.log(result);
                            this.pushMessage('Exitoso', 'success', 'Siniestro Enviado exitosamente.');
                            eval("$A.get('e.force:refreshView').fire();");

                        }).catch(error => {
                            console.log('Error en enviar Siniestro');
                            console.log(this.estatus);
                            this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
                        });
                

            }else if (result < 18) {
                this.pushMessage('Error', 'error', 'Faltan documentos por subir');
            }


    }).catch(error => {
        console.log('Error en enviar Siniestro');
console.log(this.estatus);
this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
            });

    }

    crearSiniestroMain() {
        crearSiniestro({ idSiniestro: this.recordId })
            .then(result => {
                this.resul = result;
                console.log(result);
                this.pushMessage('Exitoso', 'success', 'Siniestro Enviado exitosamente.');
                eval("$A.get('e.force:refreshView').fire();");

            }).catch(error => {
                console.log('Error en enviar Siniestro');
                console.log(this.estatus);
                this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
            });
    }

    pushMessage(title,variant,msj){
        const message = new ShowToastEvent({
            "title": title,
            "variant": variant,
            "message": msj
            });
            this.dispatchEvent(message);
            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA);
    }
}