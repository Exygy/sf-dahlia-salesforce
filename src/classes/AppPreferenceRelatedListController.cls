public class AppPreferenceRelatedListController {
    public ID currentApplicationId { get; set; }
    public String currentAppPrefId { get; set; }
    public List<Application_Preference__c> appPreferencesList { get; set; }
    public Boolean isInlineEdit {get; set;}
    
    public AppPreferenceRelatedListController(ApexPages.StandardController sc) {
    	currentApplicationId = ((Application__c)sc.getRecord()).Id;
        
        isInlineEdit = false;
        appPreferencesList = [SELECT ID, Preference_Lottery_Rank__c, Person_who_claimed_Name__c, Application__c, Application__r.Name, Lottery_Status__c, Name, Application_Status__c,
                              Receives_Preference__c, Preference_Name__c, Individual_preference__c, Application_Member__c, Application_Member__r.Name, Opt_Out__c, Listing_Preference_ID__c, Listing_Preference_ID__r.Name
                              FROM Application_Preference__c WHERE Application__c = :currentApplicationId]; 
    }
    
    public PageReference EditApp() {
        return new PageReference('/' + currentAppPrefId + '/e?retURL=/' + currentAppPrefId);
    }
    
     public PageReference DelApp() {
         try {
             for (Application_Preference__c appPref : appPreferencesList) {
                 if(appPref.Id == (Id)currentAppPrefId) {
                     delete appPref;
                     break;
                 }
             }
         } catch (Exception e) {
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
         }
        return new PageReference('/' + currentApplicationId);
    }
    
    public PageReference saveAppPref() {
        update appPreferencesList;
        refreshAppPref();
        return new PageReference('/' + currentApplicationId);
    }
    
    private void refreshAppPref() {
        appPreferencesList = [SELECT ID, Preference_Lottery_Rank__c, Person_who_claimed_Name__c, Application__c, Application__r.Name, Lottery_Status__c, Name, Application_Status__c,
                              Receives_Preference__c, Preference_Name__c, Individual_preference__c, Application_Member__c, Application_Member__r.Name, Opt_Out__c, Listing_Preference_ID__c, Listing_Preference_ID__r.Name
                              FROM Application_Preference__c WHERE Application__c = :currentApplicationId];
    }
    
    public PageReference cancel() {
        return new PageReference('/' + currentApplicationId);
    }
    
    public PageReference createnewApplicationPreference() {
        return new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I0P000000xWmj&nooverride=1&save_new_url=%2Fa0w%2Fe&CF00N0P0000066s5Z='+appPreferencesList[0].Application__r.Name+'&CF00N0P0000066s5Z_lkid='+appPreferencesList[0].Application__c);
    }
}