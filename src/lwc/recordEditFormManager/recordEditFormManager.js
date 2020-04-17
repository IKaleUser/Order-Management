import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import utils  from 'c/utils'
import labels from './recordEditFormManagerLabels'

export default class RecordEditFormManager extends LightningElement {

    labels = labels;

    @api columns = 2;
    @api objectApiName;
    @api fields;
    @api populatedFields;
    @api overflow = 'visible';
    @track objectInfo;
    @track fieldValues = {};
    @track isLoading;
    @track isNeedToCloseWindow;

    @wire(getObjectInfo, { objectApiName : '$objectApiName' })
    getObjectInfo(response) {
        if (response.data) {
            this.objectInfo = response.data;
        } else if (response.error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            utils.showNotification('', message, utils.TOAST_TYPE.ERROR);
        }
    }

    @api
    show() {
        this.objectApiName = this.objectApiName;
        this.fieldValues   = {};
        this.modalWindow.showModalWindow();
        this.resetFields();
    }

    handleChange(event) {
        this.fieldValues[event.currentTarget.parentElement.dataset.field] = event.currentTarget.value;
    }

    handleSuccess() {
        this.isLoading = false;
        utils.showNotification('', 'New ' + this.objectInfo.label + ' has been created', utils.TOAST_TYPE.SUCCESS);

        if (this.isNeedToCloseWindow) {
            this.doCancel();
        } else {
            this.fieldValues = {};
            this.resetFields();
        }
    }

    handleError() {
        this.isLoading = false;
    }

    doSave(event) {
        this.isLoading           = true;
        this.isNeedToCloseWindow = event.currentTarget.dataset.window === 'true';
        this.form.submit({...this.fieldValues, ...this.populatedFields});
    }

    doCancel() {
        this.modalWindow.hideModalWindow();
    }

    resetFields() {
        this.template.querySelectorAll('lightning-input-field').forEach(field => {
            field.reset();
        });
    }

    get headerText() {
        if (this.objectInfo) {
            return 'New ' + this.objectInfo.label;
        } else {
            return ''
        }
    }

    get fieldsToInput() {
        let fieldsToInput = [];

        if (this.objectInfo) {
            let iterableArray = Array.isArray(this.fields) ? this.fields : Object.values(this.fields);

            iterableArray.forEach(field => {
                let fieldApiName = Array.isArray(this.fields) ? field : field.fieldApiName;
                let fieldInfo    = this.objectInfo.fields[fieldApiName];

                if (fieldInfo) {
                    fieldsToInput.push({
                        label   : fieldInfo.label,
                        apiName : fieldApiName
                    })
                }
            });
        }
        return fieldsToInput;
    }

    get bodyStyle() {
        const staticStyle = 'max-height: 75vh;';

        return staticStyle + 'overflow-y: ' + this.overflow;
    }

    get fieldClass() {
        return 'slds-form-element_stacked slds-col slds-size--1-of-' + this.columns;
    }

    get modalWindow() {
        return this.template.querySelector('c-modal-window')
    }

    get form() {
        return this.template.querySelector('lightning-record-edit-form')
    }
}