global class DeleteAppPrefBatch implements Database.Batchable<sObject>{
    String query;
    Set<Id> idSet;
    String listingId;
	
    global DeleteAppPrefBatch(String listingId) {
        idSet = new Set<Id>();
        this.listingId = listingId;
    	
    	query = 'SELECT Id, Is_Migrated__c FROM Application__c WHERE Listing__c = :listingId and Is_Migrated__c = false';
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Application__c> scope) {
        
        for(Application__c app : scope) {
    		idSet.add(app.id);
        	//app.Is_Migrated__c = false;
        }
        
        List<Application_Preference__c> appPrefList = [Select id FROM Application_Preference__c Where Application__c IN :idSet];
        delete appPrefList;
		//update scope;
	}
	
	global void finish(Database.BatchableContext BC) {
        System.debug('Completed');
	}
}