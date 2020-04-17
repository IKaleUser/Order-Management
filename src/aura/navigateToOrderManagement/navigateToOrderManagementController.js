({
    doInit : function(component, helper) {
        $A.get("e.force:closeQuickAction").fire();
        let recordId = component.get('v.recordId');
        let pageReference = {
            "type": "standard__navItemPage",
            "attributes": {
                "apiName": "Order_Management"
            },
            "state": {
                "c__recordId": recordId
            }
        };
        let navService = component.find("navService");
        navService.navigate(pageReference);
    }
});