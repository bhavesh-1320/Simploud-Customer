@isTest
public class ConfigItemTriggerTest {
    @testSetup
    static void testSet(){
        Simploud__SimploudOrgSettings__c run= new Simploud__SimploudOrgSettings__c( Simploud__IgnoreConfigTrigger__c = false );
        INSERT run;
        AWS_Server_EndPoint__c aws= new AWS_Server_EndPoint__c(EndPoint__c='test.com');
        INSERT aws;
    }
    @isTest
    static void unitTest1(){
        Test.setMock(HttpCalloutMock.class, new ServerCallout());
        List<Simploud__Configuration_Item__c> configItems = new List<Simploud__Configuration_Item__c>();
        for( Integer j = 0; j<10; j++ ){
            Simploud__Configuration_Item__c configItem = new Simploud__Configuration_Item__c();
            configItem.Name = 'Test Customer 123 ' + j;
            configItems.add(configItem);
        }
        insert configItems;
        DELETE [SELECT Id FROM Simploud__Configuration_Item__c LIMIT 1];
        
        ConfigItemTriggerHelper.getOrgURL();
    }
}