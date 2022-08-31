import { LightningElement, api, track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getCategoria from '@salesforce/apex/DSALES_ClasificacionServicio.getPickListCategoria';
import SendCat from '@salesforce/apex/DSALES_ClasificacionServicio.getPicklistOptionsDependent';
import getRecords from '@salesforce/apex/DSALES_ClasificacionServicio.getRecords';
import upsertRecord from '@salesforce/apex/DSALES_ClasificacionServicio.upsertRecord';
import getSku from '@salesforce/apex/DSALES_ClasificacionServicio.getBuscarSKU';

const columns = [
    { label: 'Nombre', fieldName: 'etiqueta' }

];

export default class DSALES_ClasificacionServiciolwc extends LightningElement {
    @track data = {};
    columns = columns;
    checkCategoria = false;
    checkSubCategoria = false;
    checkClase = false;
    checkFamilia = false;
    showSpinner = true;
    popServicios = false;
    show = false;
    show2 = false;
    showc=false;
    buscarCategoria='';
    buscarSCat='';
    buscarClase='';
    buscarFami='';
    buscarSkuString='';


    connectedCallback() {
        this.init();
    }


    init(){
        getCategoria()
        .then(result => {
            this.data = result;
            this.showSpinner = false;
            this.showc=true;

        })
        .catch(error => {
            this.showSpinner = false;
        });  
        
        this.show = false;
        this.show2 = false;
        this.show3 = false;
        this.checkCategoria = false;
        this.checkSubCategoria = false;
        this.checkClase = false;
        this.checkFamilia = false;
    }

    changeSku(event){   
        this.buscarSkuString = event.target.value;
    }
    buscarSku(){
        this.showSpinner = true;
        getSku({sku: this.buscarSkuString})
        .then(result => {
            this.data.listServicios = result;
            this.showSpinner = false;
            if(this.data.listServicios.length > 0){
                this.popServicios = true;
                this.recordServicio();
            }else{
                this.pushMessage('Advertencia', 'warning', 'No se han encontrado productos.');
            }
        }).catch(error => {
            this.showSpinner = false;
        });

    }

    buscadorC(event){
        this.buscarCategoria = event.target.value;
        this.buscarCategoria = this.quitaAcento(this.buscarCategoria);
        if(this.buscarCategoria.length > 2){
            for (let i = 0; i < this.data.listCategorias.length; i++){
                let etiqueta = this.quitaAcento(this.data.listCategorias[i].etiqueta);
                this.data.listCategorias[i].mostrar = etiqueta.includes(this.buscarCategoria);
            }
        }else{
            for (let i = 0; i < this.data.listCategorias.length; i++){
                this.data.listCategorias[i].mostrar = true;
            }
        }
    }

    buscadorSubC(event){
        this.buscarSCat = event.target.value;
        this.buscarSCat = this.quitaAcento(this.buscarSCat);
        if(this.buscarSCat.length > 2){
            for (let i = 0; i < this.data.listSubCategorias.length; i++){
                let etiqueta = this.quitaAcento(this.data.listSubCategorias[i].etiqueta);
                this.data.listSubCategorias[i].mostrar = etiqueta.includes(this.buscarSCat);
            }
        }else{
            for (let i = 0; i < this.data.listSubCategorias.length; i++){
                this.data.listSubCategorias[i].mostrar = true;
            }
        }
    }

    buscadorCla(event){
        this.buscarClase = event.target.value;
        this.buscarClase = this.quitaAcento(this.buscarClase);
        if(this.buscarClase.length > 2){
            for (let i = 0; i < this.data.listClases.length; i++){
                let etiqueta = this.quitaAcento(this.data.listClases[i].etiqueta);
                this.data.listClases[i].mostrar = etiqueta.includes(this.buscarClase);  
            }
        }else{
            for (let i = 0; i < this.data.listClases.length; i++){
                this.data.listClases[i].mostrar = true;
            }
        }
    }

    buscadorFami(event){
        this.buscarFami = event.target.value;
        this.buscarFami = this.quitaAcento(this.buscarFami);
        if(this.buscarFami.length > 2){
            for (let i = 0; i < this.data.listFamilias.length; i++){
                let etiqueta =this.quitaAcento(this.data.listFamilias[i].etiqueta);
                this.data.listFamilias[i].mostrar = etiqueta.includes(this.buscarFami);
            }
        }else{
            for (let i = 0; i < this.data.listFamilias.length; i++){
                this.data.listFamilias[i].mostrar = true;
            }
        }
    }


    quitaAcento(cadena){
        cadena = cadena.toUpperCase();
        cadena = cadena.replace('Á', 'A');
        cadena = cadena.replace('É', 'E');
        cadena = cadena.replace('Í', 'I');
        cadena = cadena.replace('Ó', 'O');
        cadena = cadena.replace('Ú', 'U');
        return cadena;
    }
    mostrarSubcategoria(){
        this.show= true;
        this.cargarPickList();
    }

    mostrarClase(){
        this.show2= true;
        this.cargarPickList();
    }

    mostrarFamilia(){
        this.show3= true;
        this.cargarPickList();
    }


    cargarPickList(){
        this.showSpinner = true;
        SendCat({allData: JSON.stringify(this.data)})
        .then(result => {
            this.data = result;
            this.showSpinner = false;
        }).catch(error => {
            this.showSpinner = false;
        });
    }

    onclickCategoria(event){
        let x = false;
        const valor = event.target.name;
        const check = event.target.checked;
        for (let i = 0; i < this.data.listCategorias.length; i++){           
            if(valor == this.data.listCategorias[i].valor){
                this.data.listCategorias[i].seleccionado = check ;
            }
            if(this.data.listCategorias[i].seleccionado){
                x = true;
                this.checkCategoria = true;
            }        
        }
        if(x == false){
            this.checkCategoria = false;
        }
    }

    onclickSubCategoria(event){  
        let x = false;
        const valor = event.target.name;
        const check = event.target.checked;
        for (let i = 0; i < this.data.listSubCategorias.length; i++){           
            if(valor == this.data.listSubCategorias[i].valor){
                this.data.listSubCategorias[i].seleccionado = check ;
            }
            if(this.data.listSubCategorias[i].seleccionado){
                x = true;
                this.checkSubCategoria = true;
            }        
        }
        if(x == false){
            this.checkSubCategoria = false;
        }
    }

    onclickListFamilias(event){
        let x = false;
        const valor = event.target.name;
        const check = event.target.checked;
        for (let i = 0; i < this.data.listFamilias.length; i++){           
            if(valor == this.data.listFamilias[i].valor){
                this.data.listFamilias[i].seleccionado = check ;
            }
            if(this.data.listFamilias[i].seleccionado){
                x = true;
                this.checkFamilia = true;
            }        
        }
        if(x == false){
            this.checkFamilia = false;
        }
    }

    onclicklistClases(event){
        let x = false;
        const valor = event.target.name;
        const check = event.target.checked;
        for (let i = 0; i < this.data.listClases.length; i++){           
            if(valor == this.data.listClases[i].valor){
                this.data.listClases[i].seleccionado = check ;
            }
            if(this.data.listClases[i].seleccionado){
                x = true;
                this.checkClase = true;
            }        
        }
        if(x == false){
            this.checkClase = false;
        }
    }
    
    selectAllCategoria(event){      
        const check = event.target.checked;
        for (let i = 0; i < this.data.listCategorias.length; i++){            
            this.data.listCategorias[i].seleccionado = check ;               
        }
        this.checkCategoria = check;
    }

    selectAllSubCategoria(event){      
        const check = event.target.checked;
        for (let i = 0; i < this.data.listSubCategorias.length; i++){            
            this.data.listSubCategorias[i].seleccionado = check ;               
        }
        this.checkSubCategoria = check;
    }

    selectAllFamilia(event){      
        const check = event.target.checked;
        for (let i = 0; i < this.data.listFamilias.length; i++){            
            this.data.listFamilias[i].seleccionado = check ;               
        }
        this.checkFamilia = check;
    }

    selectAllClase(event){      
        const check = event.target.checked;
        for (let i = 0; i < this.data.listClases.length; i++){            
            this.data.listClases[i].seleccionado = check ;               
        } 
        this.checkClase = check;
    }

    search(){
        this.showSpinner = true;
        getRecords({allData: JSON.stringify(this.data)})
        .then(result => {
            this.showSpinner = false;
            this.data = result;
            this.data.registroSeguro = false;
            this.data.registroServicio = false;
            if(this.data.listServicios.length > 0){
                this.popServicios = true;
                this.recordServicio();
            }else{
                this.pushMessage('Advertencia', 'warning', 'No se han encontrado productos.');
            }
        })
        .catch(error => {
            this.showSpinner = false;
            this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte su administrador.');
        });
    }

    guardar(){
        this.showSpinner = true;
        this.popServicios = false;
        upsertRecord({allData: JSON.stringify(this.data)})
        .then(result => {
            this.cancelar();
            this.pushMessage('Exitoso', 'success', 'Datos guardados exitosamente.');
        }).catch(error => {
            this.showSpinner = false;
            this.pushMessage('Error', 'error', 'Ha ocurrido un error al actualizar los registros.');
        });
    }

    cancelar(){
        this.popServicios = false;
        this.showSpinner = false;
    }

    onchangeSeguro(event){
        const name = event.target.name;
        const check = event.target.checked;
        for(let i=0; i<this.data.listServicios.length; i++){
            if(this.data.listServicios[i].id == name){
                this.data.listServicios[i].seguro = check;
                this.asignarTipoServicio(i);
            }
        }
        this.recordServicio();
    }
    onchangeNoAplica(event){
        const name = event.target.name;
        const check = event.target.checked;
        for(let i=0; i<this.data.listServicios.length; i++){
            if(this.data.listServicios[i].id == name){
                this.data.listServicios[i].noAplica = check;
                //this.asignarTipoServicio(i);
            }
        }
        this.recordServicio();
    }
    onchangeAllSeguro(event){
        this.data.registroSeguro = event.target.checked;
        for(let i=0; i<this.data.listServicios.length; i++){
            this.data.listServicios[i].seguro = this.data.registroSeguro;
            this.asignarTipoServicio(i);
        }
        this.recordServicio();
    }

    onchangeAllNoAplica(event){
        this.data.noAplica = event.target.checked;
        for(let i=0; i<this.data.listServicios.length; i++){
            this.data.listServicios[i].noAplica = this.data.noAplica;
            //this.asignarTipoServicio(i);
        }
        this.recordServicio();
    }

    onchangeServicio(event){
        const name = event.target.name;
        const check = event.target.checked;
        for(let i=0; i<this.data.listServicios.length; i++){
            if(this.data.listServicios[i].id == name){
                this.data.listServicios[i].servicio = check;
                this.asignarTipoServicio(i);
            }
        }
        this.recordServicio();
    }

    onchangeAllServicio(event){
        this.data.registroServicio = event.target.checked;
        for(let i=0; i<this.data.listServicios.length; i++){
            this.data.listServicios[i].servicio = this.data.registroServicio;
            this.asignarTipoServicio(i);
        }
        this.recordServicio();
    }

    asignarTipoServicio(index){
        if(this.data.listServicios[index].servicio && this.data.listServicios[index].seguro){
            this.data.listServicios[index].tipoServicio = "3";
        }else if(this.data.listServicios[index].servicio){
            this.data.listServicios[index].tipoServicio = "2";
        }else if(this.data.listServicios[index].seguro){
            this.data.listServicios[index].tipoServicio = "1";
        }else{
            this.data.listServicios[index].tipoServicio = "0";
        }
    }

    recordServicio(){
        this.data.registroSeguro = false;
        this.data.registroServicio = false;
        this.data.noAplica = false;
        for(let i=0; i<this.data.listServicios.length; i++){
            if(this.data.listServicios[i].seguro){
                this.data.registroSeguro = true;
            }
            if(this.data.listServicios[i].servicio){
                this.data.registroServicio = true;
            }
            if(this.data.listServicios[i].noAplica){
                this.data.noAplica = true;
            }
        }
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