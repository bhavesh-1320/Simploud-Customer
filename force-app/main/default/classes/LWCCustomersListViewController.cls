public with sharing class LWCCustomersListViewController {
    public LWCCustomersListViewController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Customer> getAllCustomers(){
        try {
            return [SELECT Name, CustomerStatusType FROM Customer];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Customer getCustomer(Id customerId){
        try {
            return [SELECT Name, CustomerStatusType FROM Customer WHERE Id =: customerId Limit 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id getCustomerRelatedConfigItem(Id customerId){
        try {
            Customer cust = [SELECT Id, (SELECT Id FROM Configuration_Items__r) FROM Customer WHERE Id =: customerId Limit 1];

            System.debug(cust.Configuration_Items__r[0].Id);
            return cust.Configuration_Items__r[0].Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}