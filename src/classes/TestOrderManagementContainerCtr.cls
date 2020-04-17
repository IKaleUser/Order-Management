@IsTest
public with sharing class TestOrderManagementContainerCtr {
    @TestSetup
    static void testSetup() {
        List<Product__c> bred = TestFactory.createProducts(3, 7, 'Bread');
        List<Product__c> milk = TestFactory.createProducts(5, 10, 'Milk');
    }

    @IsTest
    private static void processAfterInsertEmptySearchTest() {
        String searchKey    = 'Milk';
        String filterResult = JSON.serialize(new FilterResult('Clock', ''));
        OrderManagementContainerCtr.ResultData result = OrderManagementContainerCtr.getSearchResults(searchKey, filterResult);
        List<Product__c> products = ( List<Product__c>)JSON.deserialize(
                result.resultJSON,  List<Product__c>.class
        );
        System.assertEquals('SUCCESS', result.status);
        System.assertEquals(0, products.size());
    }

    @IsTest
    private static void processAfterInsertNotEmptySearchTest() {
        String searchKey    = 'Milk';
        String filterResult = JSON.serialize(new FilterResult('', ''));
        OrderManagementContainerCtr.ResultData result = OrderManagementContainerCtr.getSearchResults(searchKey, filterResult);
        List<Product__c> products = ( List<Product__c>)JSON.deserialize(
                result.resultJSON,  List<Product__c>.class
        );
        System.assertEquals('SUCCESS', result.status);
        System.assertEquals(5, products.size());
    }

    public class FilterResult {
        public String family;
        public String type;
        FilterResult(String family, String type) {
            this.family = family;
            this.type = type;
        }
    }
}