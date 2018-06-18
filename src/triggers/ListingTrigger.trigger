trigger ListingTrigger on Listing__c (before insert, after insert, before update, after update, before delete, after delete) {
    	
   							//runHandler(String shareObject, String objToQuery, String whereClause, String parentField, String targetField)
		ApexSharingRuleClass.runHandler('Listing__Share', 'Listing__c', 'Id', 'Account__c', 'Share_Listing__c');
    	ApexSharingRuleClass.runHandler('Application__Share', 'Application__c', 'Listing__c', 'Account__c', 'Share_Listing__c');
    	ListingApplicationBigObjectAction.runHandler();
}