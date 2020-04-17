@IsTest
public with sharing class TestOrderItemTriggerHandler {
    @TestSetup
     static void testSetup() {
        Integer count = 3;
        List<Product__c> products     = TestFactory.createProducts(count, 10, 'Test');
        List<Account> accounts        = TestFactory.createAccounts(count);
        List<Order__c> orders         = TestFactory.createOrders(accounts);
        List<OrderItem__c> orderItems = TestFactory.createOrderItems(products, orders , count);

    }

    @IsTest
    private static void ProcessAfterInsertTest() {
        List<Order__c> orders = [
                SELECT
                        Name, AccountId__c, TotalProductCount__c, TotalPrice__c
                FROM
                        Order__c
                LIMIT
                        10000
        ];
        for (Order__c order : orders) {
            System.assertEquals(3, order.TotalProductCount__c);
            System.assertEquals(90, order.TotalPrice__c);
        }
    }
}