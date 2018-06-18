global class UpdateListingRollupsBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator('Select Id from Listing__c');
	}

   	global void execute(Database.BatchableContext BC, List<Listing__c> scope) {
        
        for (Listing__c l : scope) {
            Application__c app = new Application__c(Listing__c = l.Id);
            insert app;
            delete app;
        }
	}
	
	global void finish(Database.BatchableContext BC) {
        System.debug('Completed');
	}
}