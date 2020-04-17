public with sharing class OrderManagementContainerCtr {

    @AuraEnabled(cacheable=true)
    public static ResultData getSearchResults(String key, String filterResultString) {
        FilterResult filterResult = (FilterResult)JSON.deserialize(filterResultString, FilterResult.class);
        ResultData result = new ResultData();
        try {
            result.resultJSON = JSON.serialize(getSearchedProducts(key, filterResult));
        } catch (Exception ex) {
            result.status  = Constants.ANSWER_STATUS_ERROR;
            result.message = ex.getMessage();
        }

        return result;
    }

    private static List<Product__c> getSearchedProducts(String key, FilterResult filterResult) {
        String query =  'Select Id, Name, Description__c, Type__c, Family__c, Image__c, Price__c ' +
                        'FROM Product__c ' +
                        getCondition(key, filterResult) +
                        ' LIMIT 50000';

        return ProductSelector.getSearchProducts(query, key);
    }

    private static String getCondition(String key, FilterResult filterResult) {
        return  DBSOQLProcessor.setCondition(
                new List<String>{
                        DBSOQLProcessor.getConditionLike('Name', key),
                        DBSOQLProcessor.getConditionEqual('Family__c', filterResult.family),
                        DBSOQLProcessor.getConditionEqual('Type__c', filterResult.type)
                }
        );

    }

    public class ResultData {
        @AuraEnabled public String status = Constants.ANSWER_STATUS_SUCCESS;
        @AuraEnabled public String message = '';
        @AuraEnabled public String resultJSON;
    }

    public class FilterResult {
        @AuraEnabled public String family;
        @AuraEnabled public String type;
    }
}