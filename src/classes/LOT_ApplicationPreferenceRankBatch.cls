global class LOT_ApplicationPreferenceRankBatch implements Database.Batchable<sObject>, Database.Stateful {

    String query;
    Id listingId;
    Id listingPrefId;
    ID previousListingPreferenceID;
    Map<Id,Integer> appPrefRanksMap;
    public LOT_ApplicationPreferenceUpdateBatch nextBatch;
    
    
    global LOT_ApplicationPreferenceRankBatch(Id listingId) {
        this.previousListingPreferenceID = null;
        this.listingId = listingId;
        this.listingPrefId = listingPrefId;
        this.appPrefRanksMap = new Map<Id,Integer>();
        
        //query = 'select id ,Listing_Preference_ID__c, Application__c, Receives_Preference__c, Application__r.Lottery_Rank__c from Application_Preference__c where Application__r.listing__c = :listingId AND Listing_Preference_ID__c = :listingPrefId AND Application__r.Status__c = \'Submitted\' order by Listing_Preference_ID__c, Application__r.Lottery_Rank__c';
        query = 'SELECT Id, Listing__c FROM Listing_Lottery_Preference__c WHERE Listing__c = :listingId';
        system.debug('query:::' + query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Listing_Lottery_Preference__c> scope) {
        system.debug('scope:::' + scope);
        calculateRank(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('nextBatch:::' + nextBatch);
        if (nextBatch != null && appPrefRanksMap != null)
        {
            nextBatch.appPrefs = appPrefRanksMap; 
            nextbatch.listingid = listingid;
            Database.executeBatch(nextBatch);
            
        } else {
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

    public void calculateRank(List<Listing_Lottery_Preference__c> scope){
        Integer preferedRank = 0;
        List<Application_Preference__c> appPrefs = [select id ,Listing_Preference_ID__c, 
                                                    Application__c, Receives_Preference__c, Application__r.Lottery_Rank__c from Application_Preference__c 
                                                    where Application__r.listing__c = :scope[0].Listing__c AND 
                                                    Listing_Preference_ID__c = :scope[0].Id AND 
                                                    Receives_Preference__c = true and 
                                                    Application__r.Status__c = 'Submitted' order by Listing_Preference_ID__c, Application__r.Lottery_Rank__c];
        
        for (Application_Preference__c appPref : appPrefs) 
        {
            preferedRank += 1; 
            appPrefRanksMap.put(appPref.Id, preferedRank);
        }
    }
}