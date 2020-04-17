public with sharing class OrderItemTriggerHandler {

    public static void processAfterInsert(List<OrderItem__c> orderItems) {
        updateOrder(orderItems);
    }

    private static void updateOrder(List<OrderItem__c> orderItems) {
        Map<Id, List<OrderItem__c>> orderItemMap = getOrderIdsMap(orderItems);
        List<Order__c> existingOrders = gerOrderObject(orderItemMap);

        for (Order__c order : existingOrders) {
            setOrderFields(order, orderItemMap);
        }
        update existingOrders;
    }

    private static Map<Id, List<OrderItem__c>> getOrderIdsMap(List<OrderItem__c> orderItems) {
        Map<Id, List<OrderItem__c>> orderItemMap = new Map<Id, List<OrderItem__c>>();

        for (OrderItem__c orderItem : orderItems) {
            Id OrderId = orderItem.OrderId__c;

            if (orderItemMap.containsKey(OrderId)) {
                List<OrderItem__c> keyValue = orderItemMap.get(OrderId);
                keyValue.add(orderItem);
                orderItemMap.put(OrderId, keyValue);
            } else {
                orderItemMap.put(OrderId, new List<OrderItem__c>{orderItem});
            }
        }

        return orderItemMap;
    }

    private static Order__c setOrderFields(Order__c order, Map<Id, List<OrderItem__c>> orderItemMap) {
        List<OrderItem__c> orderItems = orderItemMap.get(order.Id);
        order.TotalProductCount__c = orderItems.size();
        Decimal totalPrice         = 0;

        for (OrderItem__c orderItem : orderItems) {
            totalPrice += orderItem.Price__c;
        }
        order.TotalPrice__c = totalPrice;

        return order;
    }

    private static List<Order__c> gerOrderObject(Map<Id, List<OrderItem__c>> orderItemMap) {
        return [
                SELECT
                        TotalProductCount__c, TotalPrice__c
                FROM
                        Order__c
                WHERE
                        Id IN :orderItemMap.keySet()
                LIMIT
                        10000
        ];
    }
}