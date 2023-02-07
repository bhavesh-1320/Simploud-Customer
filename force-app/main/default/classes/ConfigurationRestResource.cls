@RestResource(urlMapping='/DeployConfig/')
global class ConfigurationRestResource {
	@HttpPost
    global static String updateAccStatus(){
    	RestRequest request=RestContext.request;
        map<string,object> jsonbody =(map<string,object>)Json.deserializeUntyped(string.valueof(request.requestBody.toString()));
        
        System.debug(jsonbody);
        
        /*
         Id accId = (Id)jsonbody.get('accId');
        String status = (String)jsonbody.get('status');
        Account acc = [SELECT Deployment_Status__c FROM Account WHERE Id = :accId LIMIT 1];
        if( acc != null ){
            acc.Deployment_Status__c = status;
            UPDATE acc;
        	return 'retrieved';
        }
        return 'Error';
		*/
        return 'successsss';
    }
}