public with sharing class OrderManagerService {

    @AuraEnabled
    public static ResultData createRecords(String orderResultString, List<String> orderItemResultStrings) {
        ResultData result = new ResultData();
        try {
            insertRecords(createOrder(orderResultString), createOrderItems(orderItemResultStrings));
            result.resultJSON = JSON.serialize(Constants.ANSWER_STATUS_SUCCESS);
        } catch (Exception ex) {
            result.status  = Constants.ANSWER_STATUS_ERROR;
            result.message = ex.getMessage();
        }

        return result;
    }

    private static void insertRecords(Order__c order, List<OrderItem__c> orderItems){
        Database.SaveResult orderInsertResult = Database.insert(order, true);

        if (orderInsertResult.isSuccess()) {

            for(OrderItem__c orderItem : orderItems) {
                orderItem.OrderId__c = orderInsertResult.getId();
            }
            Database.SaveResult[] orderItemsInsertResult = Database.insert(orderItems, true);
        }
    }

    private static Order__c createOrder(String orderResultString) {
        OrderResult orderResult = (OrderResult)JSON.deserialize(orderResultString, OrderResult.class);
        Order__c order = new Order__c(
                AccountId__c = orderResult.accountId
        );
        System.debug(order);

        return order;
    }

    private static List<OrderItem__c> createOrderItems(List<String> orderItemResultStrings) {
        List<OrderItem__c> orderItems = new List<OrderItem__c>();

        for (String orderItemResultString : orderItemResultStrings) {
            OrderItemResult orderItemResult = (OrderItemResult)JSON.deserialize(orderItemResultString, OrderItemResult.class);
            orderItems.add(new OrderItem__c(
                    ProductId__c = orderItemResult.productId,
                    Quantity__c  = orderItemResult.quantity,
                    Price__c     = orderItemResult.price
            ));
        }

        System.debug(orderItems);
        return orderItems;
    }

    public class ResultData {
        @AuraEnabled public String status = Constants.ANSWER_STATUS_SUCCESS;
        @AuraEnabled public String message = '';
        @AuraEnabled public String resultJSON;
    }

    public class OrderResult {
        @AuraEnabled public String accountId;
    }

    public class OrderItemResult {
        @AuraEnabled public String productId;
        @AuraEnabled public Integer quantity;
        @AuraEnabled public Decimal price;
    }
}