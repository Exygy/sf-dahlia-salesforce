public class UserTriggerHandler {

	public static void runHandler(List<User> triggerValue) {
		Map<Id,Id> accountUserMap = new Map<Id,Id>();
		Id profileID = [Select Id From Profile Where Name = 'MOHCD - Leasing Agent Partner'].Id;

    	for(User u : triggerValue) {
            if(u.profileId == profileID) {
            	accountUserMap.put(u.AccountId,u.Id);
            }
    	}
        if(!accountUserMap.isEmpty()) {
			Database.executeBatch(new ApexSharingForUser(accountUserMap, 'Listing__Share', 'Listing__c', 'Id', 'Account__c', 'Share_Listing__c'));
    		Database.executeBatch(new ApexSharingForUser(accountUserMap, 'Application__Share', 'Application__c', 'Listing__c', 'Account__c', 'Listing__r.Share_Listing__c'));
        }
    }
}