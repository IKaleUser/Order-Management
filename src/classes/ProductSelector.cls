public without sharing class ProductSelector {

    public static List<Product__c> getSearchProducts(String query, String key) {
        return Database.query(query);
    }
}