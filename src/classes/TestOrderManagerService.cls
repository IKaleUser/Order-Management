@IsTest
public with sharing class TestOrderManagerService {
    @TestSetup
    static void testSetup() {
        List<Product__c> products = TestFactory.createProducts(3, 10, 'Test');
        List<Account> accounts    = TestFactory.createAccounts(1);

    }

    @IsTest
    private static void createRecordsTest() {
        List<Account> accounts    = [SELECT Name FROM Account LIMIT 1];
        List<Product__c> products = [SELECT Name FROM Product__c LIMIT 5000];

        String orderResultString = JSON.serialize(new OrderResult(accounts[0].Id));
        List<String> orderItemResultStrings = new List<String>();

        for (Product__c product : products) {
            orderItemResultStrings.add(JSON.serialize(
                    new OrderItemResult( product.Id, 3, 2)));
        }

        OrderManagerService.ResultData result = OrderManagerService.createRecords(orderResultString, orderItemResultStrings);
        List<Order__c> orders         = [SELECT Name FROM Order__c LIMIT 2000];
        List<OrderItem__c> orderItems = [SELECT Name FROM OrderItem__c LIMIT 2000];

        System.assertEquals('SUCCESS', result.status);
        System.assertEquals(1, orders.size());
        System.assertEquals(3, orderItems.size());
        System.assertEquals(orderItems.size(), products.size());
    }

    public class OrderItemResult {
        public String productId;
        public Integer quantity;
        public Decimal price;

        OrderItemResult(String productId, Integer quantity, Decimal price) {
            this.productId = productId;
            this.quantity = quantity;
            this.price = price;
        }
    }

    public class OrderResult {
        public String accountId;

        OrderResult(String accountId) {
            this.accountId = accountId;
        }
    }
}