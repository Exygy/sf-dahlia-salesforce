global class LOT_ApplicationPreferenceUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public Map<Id,Integer> appPrefs;
    public Id listingid;
    String query;
    Set<Id> appPrefIds;
    public LOT_PreferenceRankBatch nextBatch;
    
    global LOT_ApplicationPreferenceUpdateBatch(Id templistingid, Map<Id,Integer> tempappPrefs) {
        listingid = templistingid;
        appPrefs = tempappPrefs;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        appPrefIds = new set<Id>();
        if(appPrefs != null)
            appPrefIds = appPrefs.keyset();
        query = 'select id,Listing_Preference_ID__c, Application__c, Receives_Preference__c, Application__r.Lottery_Rank__c' + 
            ' from Application_Preference__c where Application__r.Status__c = \'Submitted\' and Application__r.listing__c = :listingid';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Application_Preference__c> scope) {
        system.debug('scope:::' + scope);
        updateRank(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('nextBatch:::' + nextBatch);
        if (nextBatch != null) {
            Database.executeBatch(nextBatch);
        } else if(listingId != null) {
            
            Listing__c listing = new Listing__c(Id=listingId);
            listing.Lottery_Status__c = 'Lottery Complete';
            try
            {
                update listing;
            }
            catch(Exception ex)
            {
                
            }
        }
    }
    
    public void updateRank(List<Application_Preference__c> scope){
        for (Application_Preference__c appPref : scope) {
            if (appPrefs != null && appPrefs.containsKey(appPref.Id)) {
                appPref.Preference_Lottery_Rank__c = appPrefs.get(appPref.Id);
            } else {
                appPref.Preference_Lottery_Rank__c = null;
            }
        }
        
        update scope;
    }
}