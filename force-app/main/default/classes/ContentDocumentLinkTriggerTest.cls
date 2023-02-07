@isTest
public class ContentDocumentLinkTriggerTest {
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
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv; 
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        Simploud__Configuration_Item__c configItem = new Simploud__Configuration_Item__c();
        configItem.Name = 'Test Customer 123 ';
        INSERT configItem;
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = configItem.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;        
    }
}