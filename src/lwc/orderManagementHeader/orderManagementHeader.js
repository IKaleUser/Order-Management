import {LightningElement, api} from 'lwc';

export default class OrderManagementHeader extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api fields;
}