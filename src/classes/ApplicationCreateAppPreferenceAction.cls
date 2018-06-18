// *****************************************************************************
// CLASS: ApplicationCreateAppPreferenceAction
// *****************************************************************************
//
// Author: Vertiba
// Date: 2017-06-28
// Description: Create Application Preference for each existing Listing Preference
//              
// *****************************************************************************
public without sharing class ApplicationCreateAppPreferenceAction extends TriggerAction {
    boolean shouldRun;
    private Set<ID> applicationIDS;
    private Set<ID> listingIDs;
    //private List<Application__c> appList;
    
    public ApplicationCreateAppPreferenceAction(List<SObject> objs) {
        
        super(objs);
        system.debug('objs::' + objs);
        
        
        applicationIDS = new Set<ID>();
        listingIDs = new Set<ID>();
        for (SObject obj : objs) { 
            Application__c app = (Application__c) obj;
            applicationIDS.add(app.Id);
            ID listingID = (ID)app.Listing__c; 
            listingIDs.add(listingID);
        }
        
        shouldRun = true;
    }
    
    //returns a map<listingID, map<listinglotterypreferenceID, applicationPreference>
    private Map<ID,List<Listing_Lottery_Preference__c>> getListingPreferences() {
        List<Listing_Lottery_Preference__c> listingPrefs = [Select id, Listing__c, Lottery_Preference__r.Record_Type_For_App_Preferences__c From Listing_Lottery_Preference__c where listing__c in : listingIDs];
        Map<ID,List<Listing_Lottery_Preference__c>> listingPrefMap = new Map<ID,List<Listing_Lottery_Preference__c>>();
        for (Listing_Lottery_Preference__c listingPref : listingPrefs) {
            if (!listingPrefMap.containsKey(listingPref.Listing__c)) {
                listingPrefMap.put(listingPref.Listing__c, new List<Listing_Lottery_Preference__c>());
            }
            listingPrefMap.get(listingPref.Listing__c).add(listingPref);
        }
        return listingPrefMap;
    }
    
    //returns a map<applicationID, map<listinglotterypreferenceID, applicationPreference>
    private Map<ID,Map<ID,Application_Preference__c>> getApplicationPreferences(Set<ID> applicationIDS ) {
        Map<ID,Map<ID,Application_Preference__c>> applicationPrefMap = new Map<ID,Map<ID,Application_Preference__c>>();
        List< Application_Preference__c> prefList = [Select id, application__c, Auto_Grants_Preference__c, Listing_Preference_ID__c From Application_Preference__c where Application__c in :applicationIDS];
        for (Application_Preference__c appPref:  prefList) {
            Map<ID,Application_Preference__c> appPrefByListingPref  = (applicationPrefMap.containsKey(appPref.application__c))? applicationPrefMap.get(appPref.application__c) : new  Map<ID,Application_Preference__c>(); 
            appPrefByListingPref.put(appPref.Listing_Preference_ID__c,appPref);
            applicationPrefMap.put(appPref.application__c,appPrefByListingPref);
        }
        return applicationPrefMap; 
    }
    
    public static boolean disableTrigger = false;
    
    public override Boolean shouldRunOnInsert() { //return disableTrigger; 
        if (disableTrigger ==false) {
             return shouldRun;
        } else {
            return false; 
        }
    }
    public override Boolean shouldRunOnDelete() { return false; } 
    public override Boolean shouldRunOnUpdate() { //return disableTrigger; 
        if (disableTrigger ==false) {
             return shouldRun;
        } else {
            return false; 
        }
    }

    public override void doAction() {
        List<Application_Preference__c> newApplicationPrefs = new List<Application_Preference__c>();
        
        Map<ID,List<Listing_Lottery_Preference__c>> listingPrefMap = getListingPreferences();
        Map<ID,Map<ID,Application_Preference__c>> applicationPrefMap = getApplicationPreferences(applicationIDS);
        
        for (Sobject app : triggerList) {
            Application__c currentApp = (Application__c)app;
            System.debug('CurrentApp************** ' + currentApp);
            System.debug('ListingPrefMap************** ' + listingPrefMap);
            
            if (listingPrefMap == null || listingPrefMap.isEmpty() || !listingPrefMap.containsKey(currentApp.Listing__c)) continue;
            
            for (Listing_Lottery_Preference__c lp : listingPrefMap.get(currentApp.Listing__c)) {
                Map<ID,Application_Preference__c> appPrefByListingPref = applicationPrefMap.containsKey(currentApp.Id) ? applicationPrefMap.get(currentApp.Id) : null;
                //if Application Preference exist then continue
                if (appPrefByListingPref != null && appPrefByListingPref.containsKey(lp.Id)) continue;
                
                system.debug(LoggingLevel.INFO,'lp.Lottery_Preference__r.Record_Type_For_App_Preferences__c::: ' + lp.Lottery_Preference__r.Record_Type_For_App_Preferences__c);
                Id appPrefRtId = String.isEmpty(lp.Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(API_Application.CUSTOM_RT_DEVELOPER_NAME) : API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(lp.Lottery_Preference__r.Record_Type_For_App_Preferences__c);
                System.debug('RecordTypeId*** ' + appPrefRtId);
                newApplicationPrefs.add(new Application_Preference__c(Application__c = currentApp.Id, Listing_Preference_ID__c = lp.Id, RecordTypeId = appPrefRtId));
            }
        }
        
        if (newApplicationPrefs.size() > 0) {
            insert newApplicationPrefs;
        }
    }

    public static void runHandler() {
        if (trigger.isAfter && trigger.isInsert) {
            ApplicationCreateAppPreferenceAction action = new ApplicationCreateAppPreferenceAction(Trigger.new);
            
            system.debug(LoggingLevel.INFO,'should run insert::: ' + action.shouldRunOnInsert());
            if (action.shouldRunOnInsert()) {
                action.doAction(); 
            }
        }
        if (trigger.isAfter && trigger.isUpdate) {
            ApplicationCreateAppPreferenceAction action = new ApplicationCreateAppPreferenceAction(Trigger.new);

            system.debug(LoggingLevel.INFO,'should run update::: ' + action.shouldRunOnInsert());
            if (action.shouldRunOnUpdate()) {
                action.doAction(); 
            }
        }
    }
    
}