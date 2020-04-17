import {LightningElement, api, track, wire} from 'lwc';
import { getRecord, getFieldValue }         from 'lightning/uiRecordApi';
import{ CurrentPageReference }              from 'lightning/navigation';
import getSearchResults                     from '@salesforce/apex/OrderManagementContainerCtr.getSearchResults';
import constants                            from './orderManagementContainerConstants'
import createFormFields                     from './orderManagementContainerCreateFormFields'
import accountFields                        from './orderManagementContainerAccountFields';
import filterFields                         from './orderManagementContainerFilterFields';
import labels                               from './orderManagementContainerLabels'

export default class OrderManagementContainer extends LightningElement {

    labels           = labels;
    constants        = constants;
    createFormFields = createFormFields;

    @api recordId;
    @track products = [];
    @track cart;
    @track isLoaded;

    filterFields        = [];
    accountFields       = [];
    searchKey           = '';
    filterData = {
        family : '',
        type : ''
    };
    error;
    status;

    @wire(getRecord, { recordId: constants.CURRENT_USER_ID, fields: constants.USER_IS_MANAGER_FIELD})
    user;

    @wire(CurrentPageReference)
    pageRef;

    renderedCallback() {
        if (!this.recordId && this.recordIdFromState) {
            this.recordId = this.recordIdFromState;
        }
    }

    connectedCallback() {
        // this.recordId = window.location.href.slice(-15);
        this.searchProducts();
        this.setTargetFields(accountFields, this.accountFields);
        this.setTargetFields(filterFields, this.filterFields);
    }

    filterApplyHandler(event) {
        this.filterData = event.detail;
        this.isLoaded   = false;
        this.searchProducts();
    }

    searchProductHandler(event) {
        this.searchKey = event.detail;
        this.isLoaded  = false;
        this.searchProducts();
    }

    searchProducts() {
        getSearchResults({key: this.searchKey,  filterResultString : JSON.stringify(this.filterData)})
            .then(result => {
                this.products = this.checkProductListForEmpty(JSON.parse(result.resultJSON));
                this.isLoaded = true;
            })
            .catch(error => {
                this.error  = error.message;
                this.status = error.status;
            })
    }

    createNewProduct() {
        this.recordManager.show();
    }

    openShoppingCart() {
        this.shoppingCart.show();
    }

    deleteCartItem(event) {
        let cartItemIndex = this.getCartItemIndex(event.detail);
        cartItemIndex !== -1 ? this.cart.splice(cartItemIndex, 1) : '';
        this.cart = (this.cart.length === 0) ? null : this.cart;

    }

    setCartItemUpdatedParams(event) {
        let cartItemIndex = this.getCartItemIndex(event.detail.id);
        if (cartItemIndex !== -1) {
            this.cart.splice(cartItemIndex, 1,{...this.cart[cartItemIndex], ...{
                    ProductCount : event.detail.quantity,
                    TotalPrice   : event.detail.quantity * this.cart[cartItemIndex].Price__c
                }});
        }
    }

    addToCart(event){
        if (this.cart) {
            let cartItemIndex = this.getCartItemIndex(event.detail.Id);
            if (cartItemIndex !== -1) {
                let count = this.getCount(this.cart[cartItemIndex]);
                this.cart[cartItemIndex] = {...this.cart[cartItemIndex], ...{
                        ProductCount : count,
                        TotalPrice   : count * this.cart[cartItemIndex].Price__c
                    }};
            } else {
                this.cart.push(this.getCartItem(event.detail));
            }
        } else {
            this.cart = [];
            this.cart.push(this.getCartItem(event.detail));
        }
        console.log(JSON.parse(JSON.stringify(this.cart)));
    }

    getCartItemIndex(productId){
        return this.cart.findIndex(item => item.Id === productId);
    }

    getCount(cartItem) {
        return ++cartItem.ProductCount;
    }

    getCartItem(product) {
        let Count = {
            ProductCount: 1,
            TotalPrice : product.Price__c
        };

        return {...product, ...Count};
    }

    handleCheckout(event) {
        this.cart = event.detail;
    }

    handleSuccess(event) {
        let record = event.detail;
        let productObject = {};

        for(let field in this.createFormFields) {
            let fieldApiName            = this.createFormFields[field].fieldApiName;
            productObject[fieldApiName] = record.fields[fieldApiName].value;
        }
        productObject.Id = record.id;

        this.products.unshift(
            productObject
        );
    }

    setTargetFields(fieldsObject, resultArray) {
        for (let field in fieldsObject) {
            resultArray.push(fieldsObject[field].fieldApiName);
        }
    }

    checkProductListForEmpty(productList) {
        return  productList.length > 0 ? productList : null;
    }

    get recordIdFromState(){
        return this.pageRef.state.c__recordId;
    }

    get isManager() {
        return getFieldValue(this.user.data, constants.USER_IS_MANAGER_FIELD);
    }

    get populatedFieldsToCreate() {
        return {}
    };

    get recordManager() {
        return this.template.querySelector('c-record-edit-form-manager');
    }

    get shoppingCart() {
        return this.template.querySelector('c-order-management-shopping-cart');
    }

}