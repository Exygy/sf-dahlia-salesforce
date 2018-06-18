trigger ContactTrigger on Contact (before delete, before insert, before update, after delete, after insert, after update) {

    if(trigger.isAfter && trigger.isUpdate) {
        Set<Id> contactIdSet = new Set<Id>();
        
        for(Contact c : trigger.new) {
            if(c.AccountId != (trigger.oldMap).get(c.Id).get('AccountId')) {
                contactIdSet.add(c.Id);
            }
        }

        if(contactIdSet.size()>0) {
			Map<Id,User> userMap = new Map<Id,User>([SELECT Id, AccountId, profileId FROM User WHERE ContactId IN :contactIdSet]);
            
            if(!userMap.isEmpty()) {
                
                purgeSharingRecords('Listing__Share',userMap.keySet());
                purgeSharingRecords('Application__Share',userMap.keySet());
                
        		UserTriggerHandler.runHandler(userMap.values());
            }
        }

    }
    
    public void purgeSharingRecords(String objectToPurge, Set<Id> userIds) {
        List<Sobject> purgeRecords = Database.query('SELECT Id, RowCause, UserOrGroupId FROM ' + objectToPurge + ' WHERE RowCause = \'Leasing_Agent_Listing_Share__c\' AND UserOrGroupId IN :userIds');
        System.debug(purgeRecords);
        Database.delete(purgeRecords);
    }
}