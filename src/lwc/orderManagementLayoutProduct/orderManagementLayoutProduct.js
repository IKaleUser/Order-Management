import {LightningElement,api, track} from 'lwc';
import labels                        from './orderManagementLayoutProductLabels'

export default class OrderManagementLayoutProduct extends  LightningElement {

    labels = labels;
    productName;
    error;
    status;

    @track _products;
    @track _isLoaded;

    @api
    set products(products) {
        this._products = products;
    }

    @api
    set isLoaded(loaded) {
        this._isLoaded = loaded;
    }

    connectedCallback() {
        this.isLoaded = true;
    }

    searchProducts() {
        const nameEnteredEvent = new CustomEvent('search', {detail : this.productName});
        this.dispatchEvent(nameEnteredEvent);

    }

    handleNameChange(event) {
        this.productName = event.currentTarget.value;
    }

    get isLoaded() {
        return this._isLoaded;
    }

    get products() {
        return this._products;
    }
}