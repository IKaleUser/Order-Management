trigger OrderItemTrigger on OrderItem__c (after insert) {
    if (Trigger.isInsert && Trigger.isAfter) {
        OrderItemTriggerHandler.processAfterInsert(Trigger.new);
    }
}