trigger ConfigItemTrigger on Simploud__Configuration_Item__c (after insert, after update, after delete) {
    
    Simploud__SimploudOrgSettings__c run=[Select Simploud__IgnoreConfigTrigger__c from Simploud__SimploudOrgSettings__c ]; 
    
    
    if(!run.Simploud__IgnoreConfigTrigger__c)
    {
            if( Trigger.isAfter ){
                if( Trigger.isInsert ){
                    
                    // Creating set<Id> for sending Ids to future method
                    Set<Id> insertedConfigItemsId = new Set<Id>();
                    for( Simploud__Configuration_Item__c newItems : Trigger.new ){
                        
                        // By checking the Imported_Record_Id__c, we can know that the record is being created manually from this org,
                        // not from any other org (through middleware)
                        if( newItems.Imported_Record_Id__c == null || newItems.Imported_Record_Id__c == '' ){
                            
                            // Adding those record Id's which needs to be sent with callout and to be created in other org.
                            insertedConfigItemsId.add( newItems.Id );
                        }
                    }
                    
                    // Check to only make the callout, when we have atleast one record which is being created manually from this org.
                    if( insertedConfigItemsId.size() > 0 ){
                        
                        // Calling the helper for API callout to the middleware with event action as 'insertion'
                        // and Sending set<Id> to future method because future method only supports primitive datatypes.
                        configItemTriggerHelper.configItemCreated( insertedConfigItemsId, 'insertion' );    
                    }
                    
                } 
                else if( Trigger.isUpdate ) {
                    Set<Id> updatedConfigItemsId = new Set<Id>();
                    Map<Id, Simploud__Configuration_Item__c> oldConfigItemsMap = Trigger.oldMap;
                    Map<Id, Simploud__Configuration_Item__c> newConfigItemsMap = Trigger.newMap;
                    for( Id cId : newConfigItemsMap.keySet() ) {
                        
                        // By checking the Imported_Record_Id__c from new & old map, we can see the relation b/w records of different orgs
                        if( oldConfigItemsMap.get( cId ).Imported_Record_Id__c == newConfigItemsMap.get(cId).Imported_Record_Id__c 
                           // By checking the Stop_Recursion__c from old & new Map, we can see that the recursion should not take place,
                           // while inserting records from another org!
                           && oldConfigItemsMap.get( cId ).Stop_Recursion__c == newConfigItemsMap.get(cId).Stop_Recursion__c ) {
                               
                               if(newConfigItemsMap.get(cId).Simploud__External_ID__c==oldConfigItemsMap.get(cId).Simploud__External_ID__c)
                              {
                                   // Adding those record Id's which needs to be sent with callout and to be created in other org.
                                   updatedConfigItemsId.add( cId );
                              }
                           }
                        
                        System.debug('Old Id:'+oldConfigItemsMap.get( cId ).Imported_Record_Id__c);
                        System.debug('New Id:'+newConfigItemsMap.get( cId ).Imported_Record_Id__c);
                    }
                    
                    // Check to only make the callout, when we have atleast one record which is being updated manually from this org.
                    if( updatedConfigItemsId.size() > 0 ){
                        
                        // Calling the helper for API callout to the middleware with event action as 'updation'
                        configItemTriggerHelper.configItemCreated( updatedConfigItemsId, 'updation' );    
                    }
                }
                else if( Trigger.isDelete ){
                    Set<String> importIds = new Set<String>();
                    for( Simploud__Configuration_Item__c delItem : Trigger.old ){
                        if( !String.isBlank(delItem.Imported_Record_Id__c) ){
                            importIds.add( delItem.Imported_Record_Id__c.substring(0,15) );   
                        }
                    }
                    configItemTriggerHelper.configItemDeleted( importIds ); 
                }
            }
    }
}