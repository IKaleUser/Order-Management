import {LightningElement, api} from 'lwc';
import labels from './orderManagementFilterLabels'

export default class OrderManagementFilter extends LightningElement {

    labels = labels;

    @api filterObjectApiName;
    @api filterFields;

    filterApply() {
        const applyEvent = new CustomEvent('apply', {detail : this.getFilterData()});
        this.dispatchEvent(applyEvent);
    }

    clearFilter() {
        this.filter.forEach(filterItem => {
                filterItem.value = '';
            }
        );
    }

    getFilterData() {
        let filterData = {};

        this.filter.forEach(filterItem => {
            filterData[this.fieldsApiNameToVariableName(filterItem.fieldName)] = filterItem.value;
            }
        );

        return filterData;
    }

    fieldsApiNameToVariableName(fieldsApiName) {
        return fieldsApiName.indexOf('__c') + 1 ?
               fieldsApiName.charAt(0).toLowerCase() + fieldsApiName.substring(1, fieldsApiName.length - 3) :
               fieldsApiName.charAt(0).toLowerCase() + fieldsApiName.slice(1);
    }

    get filter() {
        return this.template.querySelectorAll('lightning-input-field');
    }
}