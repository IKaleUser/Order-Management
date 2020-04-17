@IsTest
public with sharing class TestFactory {

    public static List<OrderItem__c> createOrderItems(List<Product__c> products, List<Order__c> orders, Integer quantity) {
        List<OrderItem__c> orderItems = new List<OrderItem__c>();
        for (Order__c order : orders) {
            for (Product__c product : products) {
                orderItems.add(new OrderItem__c(
                        OrderId__c   = order.Id,
                        ProductId__c = product.Id,
                        Quantity__c  = quantity,
                        Price__c     = quantity * product.Price__c
                ));
            }
        }
        insert orderItems;

        return orderItems;
    }

    public static List<Order__c> createOrders(List<Account> accounts) {
        List<Order__c> orders = new List<Order__c>();

        for (Account account : accounts) {
            orders.add(new Order__c(
                    AccountId__c = account.Id
            ));
        }
        insert orders;

        return orders;
    }

    public static List<Account> createAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(
                    Name = 'Test' + i
            ));
        }
        insert accounts;

        return accounts;
    }

    public static List<Product__c> createProducts(Integer count, Decimal price, String name) {
        List<Product__c> products = new List<Product__c>();
        for (Integer i = 0; i < count; i++) {
            products.add(new Product__c(
                    Name = name + i,
                    Description__c = 'Test',
                    Price__c = price
            ));
        }
        insert products;

        return products;
    }
}