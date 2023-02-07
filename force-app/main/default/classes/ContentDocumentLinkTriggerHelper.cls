public with sharing class ContentDocumentLinkTriggerHelper {
    @future(Callout=true)
    public static void uploadDocument( Set< Id > newDocIds ){
        Boolean isSandbox = [SELECT isSandbox FROM Organization].isSandbox;
        List< ContentDocumentLink > contDocLinks = [SELECT Id, ContentDocument.FileExtension, 
                                                    LinkedEntityId , ContentDocument.Title, 
                                                    ContentDocument.LatestPublishedVersion.VersionData,
                                                    ContentDocument.LatestPublishedVersion.PathOnClient,
                                                    ContentDocumentId
                                                    FROM ContentDocumentLink WHERE Id IN :newDocIds
                                                   ];
        Map< Id, List<ContentDocumentLink> > configItemIdContLinkMap = new Map< Id, List<ContentDocumentLink> >(); 
        for( ContentDocumentLink contDocLink : contDocLinks ){
            String sObjName = contDocLink.LinkedEntityId.getSObjectType().getDescribe().getName();
            if( sObjName == 'Simploud__Configuration_Item__c' ){
                if( !configItemIdContLinkMap.containsKey( contDocLink.LinkedEntityId ) ){
                    configItemIdContLinkMap.put( contDocLink.LinkedEntityId, new List<ContentDocumentLink>() );
                }
                configItemIdContLinkMap.get( contDocLink.LinkedEntityId ).add( contDocLink );    
            }
        }
        System.debug(configItemIdContLinkMap);
        if( !configItemIdContLinkMap.isEmpty() ){
            List<Simploud__Configuration_Item__c> configItems = [SELECT Id, Imported_Record_Id__c FROM 
                                                                 Simploud__Configuration_Item__c WHERE 
                                                                 Id IN :configItemIdContLinkMap.keySet() 
                                                                ];
            if( !configItems.isEmpty() ){
                String payLoad = '{"instance":"Customer","contentVersion":{';
                for( Simploud__Configuration_Item__c configItem : configItems ){
                    List< ContentDocumentLink > contDocLinksOfInq = configItemIdContLinkMap.get( configItem.Id );
                    payLoad+= '"'+configItem.Imported_Record_Id__c+'":[';
                    for( ContentDocumentLink contDocL : contDocLinksOfInq ){
                        payload+='{"Stop_Recursion__c":"true", "PathOnClient":"'+contDocL.ContentDocument.LatestPublishedVersion.PathOnClient+'", "Title":"'+contDocL.ContentDocument.Title+'",';
                        payload+='"VersionData":"'+EncodingUtil.base64Encode(contDocL.ContentDocument.LatestPublishedVersion.VersionData)+'"},'; 
                    } 
                    payload = payload.substring(0,payload.length()-1 );
                    payload += '],';
                }
                payload = payload.substring(0,payload.length()-1 );
                payload+='},"loginUrl":"' + ConfigItemTriggerHelper.getOrgURL() + '","ContentDocumentId":"'+contDocLinks[0].ContentDocumentId+'"}';
                
                
                
                //System.debug(payload);
                
                AWS_Server_EndPoint__c aws=[select EndPoint__c from AWS_Server_EndPoint__c limit 1];
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                req.setEndpoint(aws.EndPoint__c+'/postNotesAttachments');
                // req.setEndpoint('https://e7e5-103-118-168-153.in.ngrok.io/postNotesAttachments');
                //req.setEndpoint('https://697c-103-118-168-153.in.ngrok.io/postNotesAttachments');
                req.setHeader('Content-Type', 'application/json');
                req.setBody(payload);
                req.setMethod('POST');
                HttpResponse res = h.send(req);
                System.debug(res.getBody());
                
            }        
        }
    }
}