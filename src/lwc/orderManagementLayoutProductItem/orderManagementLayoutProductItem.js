import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import labels            from'./orderManagementLayoutProductItemLabels'

export default class OrderManagementLayoutProductItem extends NavigationMixin(LightningElement) {

    labels = labels;

    @track _product;

    @api
    set product(product) {
        this._product = product;
    }

    showDetails(event) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId   : this.product.Id,
                actionName : 'view'
            }
        }).then(url => window.open(url));
    }

    addAction(event) {
        const addEvent = new CustomEvent('add', {
            detail   : this.product,
            bubbles  : true,
            composed : true
        });
        this.dispatchEvent(addEvent);
    }

    get product() {
        return this._product;
    }
}