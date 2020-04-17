import {LightningElement, api} from 'lwc';

export default class ModalWindow extends LightningElement {
    @api header;
    @api openModal;
    @api showSpinner;
    @api spinnerSize;

    @api
    hideModalWindow() {
        this.openModal = false;
    }

    @api
    showModalWindow() {
        this.openModal = true;
    }

    get spinnerEffect() {
        return this.showSpinner ? 'filter: blur(1px)' : '';
    }
}