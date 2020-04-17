import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import createRecords     from '@salesforce/apex/OrderManagerService.createRecords';
import utils             from 'c/utils'
import labels            from './orderManagementShoppingCartLabels'

export default class OrderManagementShoppingCart extends NavigationMixin(LightningElement) {

    labels = labels;

    @api cartItems;
    @api accountId;
    @api currencyCode;
    @track isLoading;

    deleteAction(event) {
        const deleteEvent = new CustomEvent('delete', {detail: event.currentTarget.dataset.id});
        this.dispatchEvent(deleteEvent);
    }

    handleQuantityChange(event) {
        if (event.currentTarget.value > 0) {
            const changeQuantityEvent = new CustomEvent('changequantity', {
                detail: {
                    quantity : event.currentTarget.value,
                    id       : event.currentTarget.dataset.id
                }
            });
            this.dispatchEvent(changeQuantityEvent);
        } else {
            event.currentTarget.value = 1;
        }
    }

    navigateToProductViewRecordPage(event) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId   : event.currentTarget.dataset.id,
                actionName : 'view'
            }
        }).then(url => window.open(url));
    }

    checkoutAction() {
        this.isLoading = true;

        createRecords({orderResultString: this.generateOrderJSON(),  orderItemResultStrings : this.generateOrderItemJSONArray()})
            .then(result => {
                this.isLoading = false;
                utils.showNotification('', 'Your Order was successfully created', utils.TOAST_TYPE.SUCCESS);
                this.modalWindow.hideModalWindow();
                const successEvent = new CustomEvent('checkout', {detail: undefined});
                this.dispatchEvent(successEvent);
            })
            .catch(error => {
                this.isLoading = false;
                this.error     = error.message;
                this.status    = error.status;
                utils.showNotification('', error.message, utils.TOAST_TYPE.ERROR);
            })
    }

    generateOrderItemJSONArray() {
        let orderItemJSONArray = [];

        this.cartItems.forEach(cartItem => {
            orderItemJSONArray.push(JSON.stringify(
                {
                    productId : cartItem.Id,
                    quantity  : cartItem.ProductCount,
                    price     : cartItem.TotalPrice
                }
            ))
        });

        return orderItemJSONArray;
    }

    generateOrderJSON() {
        return JSON.stringify(
            {
                accountId : this.accountId
            }
        );
    }

    @api
    show() {
        this.modalWindow.showModalWindow();
    }

    get globalTotal() {
        if (this.cartItems){
            return this.cartItems.reduce((sum, cartItem) => sum + cartItem.TotalPrice, 0);
        }
    }

    get modalWindow() {
        return this.template.querySelector('c-modal-window');
    }
}