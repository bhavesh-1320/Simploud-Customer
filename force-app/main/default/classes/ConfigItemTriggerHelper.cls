public class ConfigItemTriggerHelper {
    @future(callout=true)
    public static void configItemCreated( Set<Id> newConfigId, String eventAction ) {        
        // Quering the Config Item records from the set<Id> which is being inserted & sent from the trigger
        List<Simploud__Configuration_Item__c> newConfigItems = [SELECT
                                                                Id,
                                                                Name, 
                                                                Simploud__Configuration_Area__c, 
                                                                Simploud__Type__c,
                                                                Simploud__Description__c, 
                                                                Imported_Record_Id__c, 
                                                                Stop_Recursion__c,
                                                                Simploud__Category__c,
                                                                Simploud__CID__c,
                                                                Simploud__Comments__c,
                                                                Simploud__Date_Closed__c,
                                                                Simploud__Discussion__c,
                                                                Simploud__External_ID__c,
                                                                Simploud__Ignore_Trigger__c,
                                                                Simploud__Is_Closed__c,
                                                                Simploud__Is_Locked__c,
                                                                Simploud__Keywords__c,                                                                	
                                                                Simploud__Migration_Related__c,
                                                                Simploud__Object_API__c,
                                                                Simploud__CPREFIX__c,
                                                                Simploud__Priority__c,
                                                                Simploud__Production_Issue__c,                                                               
                                                                Simploud__Release_Date__c,
                                                                Simploud__Request__c,
                                                                Simploud__Responsibility__c,
                                                                Simploud__Solution__c,
                                                                Simploud__Status__c,
                                                                Simploud__Sub_Type__c,
                                                                Simploud__Suggested_Solution__c,
                                                                Simploud__Summary__c,
                                                                Simploud__Target_Date__c,
                                                                Simploud__Task_Subject__c,
                                                                Simploud__Tasks__c,                                                                	
                                                                Simploud__Update_Status__c,
                                                                Simploud__Update_Status_Comment__c,
                                                                Simploud__Validation_Related__c,
                                                                Simploud__Last_Message__c,
                                                                Simploud__Question_ID__c,
                                                                Simploud__Test_Execution_ID__c
                                                                FROM Simploud__Configuration_Item__c WHERE Id IN :newConfigId
                                                               ];
        
        // Declaring the JSON body variable
        String resBody = '{"data":[';
        
        boolean flag =true;
        
        for( Simploud__Configuration_Item__c newItem : newConfigItems ){
            
            if(newItem.Simploud__External_ID__c!=null)
            {
                flag=false;
            }
            
            String extId = '';
            
            // Checking for eventAction and then assinging the external ID accordingly, 
            // w.r.t. insertion or updation
            if( eventAction == 'insertion' ){
                extId = newItem.Id.to15();
            }else if( eventAction == 'updation' ){
                extId = newItem.Imported_Record_Id__c;
            }
            
            System.debug(newItem.Simploud__External_ID__c);
            
            // Creating the JSON Body
            resBody += '{'; 
            
            resBody += (newItem.Simploud__External_ID__c == null ? '"Simploud__External_ID__c":"'+newItem.ID +'",'  : '') ;
            
            resBody += '"Imported_Record_Id__c":"' 				+ extId + '",';
            resBody += '"Name":' 								+ (newItem.Name == null ? '""' : JSON.serialize(newItem.Name)) + ',';
            resBody += '"Simploud__Configuration_Area__c":' 	+ (newItem.Simploud__Configuration_Area__c == null ? '""' : JSON.serialize(newItem.Simploud__Configuration_Area__c)) + ',';
            resBody += '"Simploud__Type__c":' 					+ (newItem.Simploud__Type__c == null ? '""' : JSON.serialize(newItem.Simploud__Type__c)) + ',';
            resBody += '"Simploud__Description__c":' 			+ (newItem.Simploud__Description__c == null ? '""' : JSON.serialize(newItem.Simploud__Description__c)) + ',';
            resBody += '"Simploud__Category__c":' 				+ (newItem.Simploud__Category__c == null ? '""' : JSON.serialize(newItem.Simploud__Category__c)) + ',';
            resBody += '"Simploud__CID__c":' 					+ (newItem.Simploud__CID__c == null ? '""' : JSON.serialize(newItem.Simploud__CID__c)) + ',';
            resBody += '"Simploud__Comments__c":' 				+ (newItem.Simploud__Comments__c == null ? '""' : JSON.serialize(newItem.Simploud__Comments__c)) + ',';
            resBody += '"Simploud__Date_Closed__c":' 			+ (newItem.Simploud__Date_Closed__c == null ? '""' : JSON.serialize(newItem.Simploud__Date_Closed__c)) + ',';
            resBody += '"Simploud__Discussion__c":' 			+ (newItem.Simploud__Discussion__c == null ? '""' : JSON.serialize(newItem.Simploud__Discussion__c)) + ',';
            resBody += '"Simploud__Ignore_Trigger__c":' 		+ (newItem.Simploud__Ignore_Trigger__c == null ? '""' : JSON.serialize(newItem.Simploud__Ignore_Trigger__c)) + ',';
            resBody += '"Simploud__Is_Closed__c":' 				+ (newItem.Simploud__Is_Closed__c == null ? '""' : JSON.serialize(newItem.Simploud__Is_Closed__c)) + ',';
            resBody += '"Simploud__Is_Locked__c":' 				+ (newItem.Simploud__Is_Locked__c == null ? '""' : JSON.serialize(newItem.Simploud__Is_Locked__c)) + ',';
            resBody += '"Simploud__Keywords__c":' 				+ (newItem.Simploud__Keywords__c == null ? '""' : JSON.serialize(newItem.Simploud__Keywords__c)) + ',';
            resBody += '"Simploud__Last_Message__c":' 			+ (newItem.Simploud__Last_Message__c == null ? '""' : JSON.serialize(newItem.Simploud__Last_Message__c)) + ',';
            resBody += '"Simploud__Migration_Related__c":' 		+ (newItem.Simploud__Migration_Related__c == null ? '""' : JSON.serialize(newItem.Simploud__Migration_Related__c)) + ',';
            resBody += '"Simploud__Object_API__c":' 			+ (newItem.Simploud__Object_API__c == null ? '""' : JSON.serialize(newItem.Simploud__Object_API__c)) + ',';
            resBody += '"Simploud__CPREFIX__c":' 				+ (newItem.Simploud__CPREFIX__c == null ? '""' : JSON.serialize(newItem.Simploud__CPREFIX__c)) + ',';
            resBody += '"Simploud__Priority__c":' 				+ (newItem.Simploud__Priority__c == null ? '""' : JSON.serialize(newItem.Simploud__Priority__c)) + ',';
            resBody += '"Simploud__Production_Issue__c":' 		+ (newItem.Simploud__Production_Issue__c == null ? '""' : JSON.serialize(newItem.Simploud__Production_Issue__c)) + ',';
            resBody += '"Simploud__Question_ID__c":' 			+ (newItem.Simploud__Question_ID__c == null ? '""' : JSON.serialize(newItem.Simploud__Question_ID__c)) + ',';
            resBody += '"Simploud__Release_Date__c":' 			+ (newItem.Simploud__Release_Date__c == null ? '""' : JSON.serialize(newItem.Simploud__Release_Date__c)) + ',';
            resBody += '"Simploud__Request__c":' 				+ (newItem.Simploud__Request__c == null ? '""' : JSON.serialize(newItem.Simploud__Request__c)) + ',';
            resBody += '"Simploud__Responsibility__c":' 		+ (newItem.Simploud__Responsibility__c == null ? '""' : JSON.serialize(newItem.Simploud__Responsibility__c)) + ',';
            resBody += '"Simploud__Solution__c":' 				+ (newItem.Simploud__Solution__c == null ? '""' : JSON.serialize(newItem.Simploud__Solution__c)) + ',';							                                                
            resBody += '"Simploud__Status__c":' 				+ (newItem.Simploud__Status__c == null ? '""' : JSON.serialize(newItem.Simploud__Status__c)) + ',';
            resBody += '"Simploud__Sub_Type__c":' 				+ (newItem.Simploud__Sub_Type__c == null ? '""' : JSON.serialize(newItem.Simploud__Sub_Type__c)) + ',';
            resBody += '"Simploud__Suggested_Solution__c":' 	+ (newItem.Simploud__Suggested_Solution__c == null ? '""' : JSON.serialize(newItem.Simploud__Suggested_Solution__c)) + ',';
            resBody += '"Simploud__Summary__c":' 				+ (newItem.Simploud__Summary__c == null ? '""' : JSON.serialize(newItem.Simploud__Summary__c)) + ',';
            resBody += '"Simploud__Target_Date__c":' 			+ (newItem.Simploud__Target_Date__c == null ? '""' : JSON.serialize(newItem.Simploud__Target_Date__c)) + ',';
            //resBody += '"Simploud__Task_Subject__c":' 			+ (newItem.Simploud__Task_Subject__c == null ? '' : newItem.Simploud__Task_Subject__c) + '",';
            resBody += '"Simploud__Tasks__c":' 					+ (newItem.Simploud__Tasks__c == null ? '""' : JSON.serialize(newItem.Simploud__Tasks__c)) + ',';
            resBody += '"Simploud__Test_Execution_ID__c":' 		+ (newItem.Simploud__Test_Execution_ID__c == null ? '""' : JSON.serialize(newItem.Simploud__Test_Execution_ID__c)) + ',';
            resBody += '"Simploud__Update_Status__c":' 			+ (newItem.Simploud__Update_Status__c == null ? '""' : JSON.serialize(newItem.Simploud__Update_Status__c)) + ',';
            resBody += '"Simploud__Update_Status_Comment__c":' 	+ (newItem.Simploud__Update_Status_Comment__c == null ? '""' : JSON.serialize(newItem.Simploud__Update_Status_Comment__c)) + ',';
            resBody += '"Simploud__Validation_Related__c":' 	+ (newItem.Simploud__Validation_Related__c == null ? '""' : JSON.serialize(newItem.Simploud__Validation_Related__c)) + ',';                                                  
            resBody += '"Stop_Recursion__c":' 					+ JSON.serialize(newItem.Stop_Recursion__c);
            resBody += '},';
        }
        resBody = resBody.substring(0,resBody.length()-1 );
        
        resBody+='],"CreationSuccessful":"'+flag+'", "OrgId":"'+UserInfo.getOrganizationId().substring(0,15)+'", "UserId":"'+UserInfo.getUserId() +'", "UserName":"'+UserInfo.getName() +'", "eventAction":"'+ eventAction +'", "instance":"Customer","loginUrl":"' + getOrgURL() + '"';
        
        
        
        //getting last message
        List<Simploud__Configuration_Item_Message__c> lastMessages=[select Id, 
                                                             Simploud__Message__c,
                                                             fromApi__c,
                                                             Simploud__File_ID__c,
                                                             Simploud__Type__c,
                                                             Simploud__Date_Sent__c,
                                                             Simploud__Date_Sent_String__c,
                                                             Simploud__Sender__c,
                                                             createddate
                                                             from Simploud__Configuration_Item_Message__c
                                                             WHERE Simploud__Configuration_Item__c IN :newConfigId
                                                             order by createddate desc];
        Simploud__Configuration_Item_Message__c lastMessage;
        System.debug(lastMessage);
        if( lastMessages.size() > 0 ){
            lastMessage = lastMessages[0];
            String toSend=lastMessage.Simploud__Message__c;
            toSend=Json.serialize(toSend);
            resBody+=',"message":{"lastMessage":'+toSend;
            resBody+=(lastMessage.Simploud__Sender__c!=null?',"UserName":"'+[select name from user where id=:lastMessage.Simploud__Sender__c limit 1].name+'","PhotoUrl":"'+[select smallphotourl from user where id=:lastMessage.Simploud__Sender__c limit 1].smallphotoUrl+'"':'');
            resBody+=',"fromFileChat":"Yes","externalId":"'+lastMessage.Id+'","date":"'+lastMessage.Simploud__Date_Sent__c+'","dateString":"'+lastMessage.Simploud__Date_Sent_String__c+'","username":"'+lastMessage.Simploud__Sender__c+'","type":"'+lastMessage.Simploud__Type__c+'","FileId":"'+lastMessage.Simploud__File_ID__c+'" ';
            resBody += (lastMessage.fromApi__c!='Sent'&&lastMessage.fromApi__c!='Recived'? '' : ',"fromApi":"'+lastMessage.fromApi__c+'"')+'}}' ;
            
            System.debug(resBody.substring(resBody.length()-100));
        }else{
            resBody+='}';
            System.debug(resBody);
        }
        
        
        // Making http callout to middleware
        try {
            
            AWS_Server_EndPoint__c aws=[select EndPoint__c from AWS_Server_EndPoint__c limit 1];
            
            System.debug(aws);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(aws.endPoint__c+'/postConfigItem');
           	// req.setEndpoint('https://e7e5-103-118-168-153.in.ngrok.io/postConfigItem');
           	//req.setEndpoint('https://697c-103-118-168-153.in.ngrok.io/postConfigItem');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(resBody);
            req.setMethod('POST');
            HttpResponse res = h.send(req);
            System.debug(res.getBody());
            if( lastMessage != null ){
                lastMessage.fromApi__c='Sent';
                lastMessage.Simploud__Success__c=true;
                update lastMessage;
                System.debug(lastMessage.fromApi__c);   
            }
        } catch( Exception e) {
            lastMessage.Simploud__Success__c=false;
            update lastMessage;
            System.debug('Error in Callout for middleware!!');
            System.debug('Error:: ' + e.getMessage());
            // System.debug(e);
        }
    }
    
    @future(callout=true)
    public static void configItemDeleted( Set<String> configIds ){
        Boolean isSandbox = [SELECT isSandbox FROM Organization].isSandbox;
        String resBody = '{"data":[';
        System.debug(resBody);
        System.debug(configIds);
        for( String cItem : configIds){
            resBody+='{"Imported_Record_Id__c":"'+cItem+'", "Deleted_From_Source__c":"true"},';           
        } 
        resBody = resBody.substring(0,resBody.length()-1 );
        
        resBody+='], "eventAction":"delete", "instance":"Customer","loginUrl":"' + getOrgURL() + '"}';
        System.debug(resBody);
        try {
            AWS_Server_EndPoint__c aws=[select EndPoint__c from AWS_Server_EndPoint__c limit 1];
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(aws.endPoint__c+'/postConfigItem');
            //req.setEndpoint('http://ec2-3-72-235-182.eu-central-1.compute.amazonaws.com:3000/postConfigItem');
			// req.setEndpoint('https://e7e5-103-118-168-153.in.ngrok.io/postConfigItem');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(resBody);
            req.setMethod('POST');
            HttpResponse res = h.send(req);
            System.debug(res.getBody());
        } catch( Exception e) {
            System.debug('Error in Callout for middleware!!');
            System.debug('Error:: ' + e.getMessage());
            // System.debug(e);
        }
    }
    
    
    public static String getOrgURL() {
        Boolean isSandbox = [SELECT isSandbox FROM Organization].isSandbox;
        if(isSandbox) {
            return 'https://test.salesforce.com';
        } else {
            return 'https://login.salesforce.com';
        }
    }
}