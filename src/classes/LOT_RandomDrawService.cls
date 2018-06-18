global with sharing class LOT_RandomDrawService {
    public class ErrorException extends Exception {}
    
    static webservice void runLottery(String listingID) {
        Listing__c listing = [SELECT Id, Name, Lottery_Status__c FROM Listing__c WHERE Id = : listingID];
        if(listing.Lottery_Status__c == null || listing.Lottery_Status__c == 'Not Yet Run'){
            
            Map<String,ID> entities = getEntities(listingID);
            if (entities == null || entities.size() == 0) {
                throw new ErrorException('There are no submitted applications for this listing.');
                return;
            }
            LOT_RandomDrawReq.Drawing drawing = new LOT_RandomDrawReq.Drawing();
            LOT_RandomDrawReq.DrawingParams params = new LOT_RandomDrawReq.DrawingParams();
            params.title = 'Drawing for listing - ' + listingID;
            //params.recordType = 'test'; //'public';
            params.entries = new List<String>(entities.keySet()); //our map is reversed-  
            params.winnerCount = (entities.size() < 50000) ? entities.size() : 50000;
            drawing.params = params;
            LOT_RandomDrawReq req = new LOT_RandomDrawReq(drawing);
            req.sendRequest();
            system.debug('error::::' + req);
            LOT_RandomDrawReq.DrawingResult drawResult = req.drawResult;
            
            //system.debug('drawResult.result:::' + drawResult.result);
            if (drawResult == null) {
                throw new ErrorException('There are no drawing results returned from Random.org.');
                return;
            } else if (drawResult.error != null) {
                throw new ErrorException(drawResult.error.message);
                return;
            }
            
            if (drawResult != null && drawResult.result.winners.size() > 0) {
                //update listing to in progress
                listing.Lottery_Status__c = 'In Progress';
                listing.Number_of_Applications__c = entities.size();
                listing.Draw_ID__c = '' + drawResult.result.drawID;
                //listing.LotteryResultsURL__c = drawResult.result.url;
                //listing.Lottery_End_Time__c = drawResult.result.completionTime;
                update listing;
                
                system.debug('drawResult.result.winners::::' + drawResult.result.winners);
                Database.executeBatch(new LOT_RandomDrawBatch(drawResult.result.winners, entities, listingID));
            } else {
                listing.Lottery_Status__c = 'Lottery Complete';
                update listing;
            }
        } else {
            listing.Lottery_Status__c = 'In Progress';
            update listing;
            calculateLotteryRanks(listingId);
        }
      
    }
    
    private static Map<String,ID>  getEntities(String listingID) {
        
        Map<String,ID> entities = new Map<String,ID>();
        List<Application__c> theApps = [select id, name from Application__c where status__c = 'Submitted' AND listing__c = :listingID ];
        
        for( Application__c app  :theApps){
            entities.put(app.name, app.id);
        }
        
        return entities;
    }
    /*
    public static void preferenceLottery(Id listingId) {
        //System.enqueueJob(new LOT_QueueUpPreferenceBatches(null, null, null, listingId));
        
        Map<string,string> applicationPreference = new Map<string,string>();
        
        applicationPreference.put('DTHP_Preference__c','DTHP_Preference_Rank__c');
        applicationPreference.put('COP_Preference__c','COP_Preference_Rank__c');
        applicationPreference.put('Live_Work_Preference__c','Live_Work_Preference_Rank__c');
        applicationPreference.put('Neighborhood_Preference__c','Neighborhood_Preference_Rank__c');
        applicationPreference.put('General_Lottery__c','General_Lottery_Rank__c');
        
        Map<string,string> listingTotalFields = new Map<string,string>();
        listingTotalFields.put('DTHP_Preference__c','DTHP_App_Total__c');
        listingTotalFields.put('COP_Preference__c','COP_App_Total__c');
        listingTotalFields.put('Live_Work_Preference__c','Live_Work_App_Total__c');
        listingTotalFields.put('Neighborhood_Preference__c','Neighborhood_App_Total__c');
        listingTotalFields.put('General_Lottery__c','General_App_Total__c');
        
        
        LOT_PreferenceRankBatch prevBatch = null;
        LOT_PreferenceRankBatch prefBatch = null;
        
        for(string pref : applicationPreference.keySet()){
            prefBatch = new LOT_PreferenceRankBatch(pref, applicationPreference.get(pref), listingTotalFields.get(pref), listingId);
            prefBatch.nextBatch = prevBatch;
            prevBatch = prefBatch;
            //Database.executeBatch(prefBatch);
        }
        
        Database.executeBatch(prefBatch);
    }*/
     static webservice void calculateLotteryRanks(Id listingId) {
        //System.enqueueJob(new LOT_QueueUpPreferenceBatches(null, null, null, listingId));
        Map<string,string> applicationPreference = new Map<string,string>();
        applicationPreference.put('General_Lottery__c','General_Lottery_Rank__c');
        
        Map<string,string> listingTotalFields = new Map<string,string>();
        listingTotalFields.put('General_Lottery__c','General_App_Total__c');
        
        String pref = 'General_Lottery__c';
        LOT_PreferenceRankBatch generalRankBatch = new LOT_PreferenceRankBatch(pref, applicationPreference.get(pref), listingTotalFields.get(pref), listingId); //general lottery batch
        LOT_ApplicationPreferenceUpdateBatch appprefbatch = new LOT_ApplicationPreferenceUpdateBatch(null,null);
        appprefbatch.nextbatch = generalRankBatch;
        LOT_ApplicationPreferenceRankBatch prefBatch = new LOT_ApplicationPreferenceRankBatch(listingId);
        prefBatch.nextBatch = appprefbatch;
        Database.executeBatch(prefBatch,1);
         
         
         
         
        //Map<ID,Listing_Lottery_Preference__c > lotteryPrefs = new Map<ID,Listing_Lottery_Preference__c >  ([select id ,Listing__c, Order__c from Listing_Lottery_Preference__c where listingID =:listingId]);
        /*List<Application_Preference__c > applicationPrefs = [select id ,Listing_Preference_ID__c, Application__c, Application__r.Lottery_Rank__c 
                                                             from Application_Preference__c 
                                                             where Application__r.listing__c = :listingId 
                                                                AND Application__r.Status__c = 'Submitted' 
                                                             order by Listing_Preference_ID__c, Application__r.Lottery_Rank__c];
        if (applicationPrefs.size() == 0) {
            return;
        }
        Integer counter=1;
        ID currentListingID = applicationPrefs[0].Listing_Preference_ID__c;
        for (Application_Preference__c appPref : applicationPrefs) {
            if (appPref.Listing_Preference_ID__c != currentListingID) {
                currentListingID = appPref.Listing_Preference_ID__c;
                counter = 1;
            }
            appPref.Preference_Lottery_Rank__c = counter++;
            system.debug('appPref:::' + appPref);
        }
        
        update applicationPrefs;
        
        counter = 1;
        List<Application__c> apps = [SELECT Id, General_Lottery_Rank__c 
                                     FROM Application__c 
                                     WHERE General_Lottery__c = true 
                                        AND listing__c = :listingId 
                                        AND Status__c = 'Submitted' 
                                     order by Lottery_Rank__c asc];
        for (Application__c app : apps) {
            app.General_Lottery_Rank__c = counter++;
        }
        update apps;
        
        Listing__c listing = [SELECT Id, Name, Lottery_Status__c FROM Listing__c WHERE Id = : listingID];
        
        listing.Lottery_Status__c = 'Lottery Complete';
        update listing;*/
     
    }
}