public without sharing class ApplicationPreferenceSetAutoGrantAction extends TriggerAction {
    private Set<ID> applicationIDS;
	private Set<ID> listingIDs;
	
 	//private Map<ID, Lottery_Preference__c> lotteryPrefs;
 	//private Set<ID> preferenceIds;
 	public ApplicationPreferenceSetAutoGrantAction (List<SObject> objs) {
		
		super(objs);
        system.debug('objs::' + objs);
		applicationIDS = new Set<ID>();
		listingIDs = new Set<ID>();
		for (SObject obj : objs) { 
			Application_Preference__c appPref = (Application_Preference__c) obj;
			applicationIDS.add(appPref.application__c);
			ID listingID = (ID)appPref.Listing_ID__c; 
			listingIDs.add(listingID);
		}
        system.debug('applicationIDS::' + applicationIDS);
		/* get all the applicationIDS
		   set the autoGrant or remove it if it shoudln't be there.
		   	//returns a map<applicationID, map<listinglotterypreferenceID, applicationPreference>
		   
		   for each Application
					 listingPreferenceMap = new map<preference,listing_lottery_pref>
					
					for each listingPreference
						if listingPreference.autoGrants another listingPreference
						appPref = listingPreferenceMap.get(listingPreference.id);
						grantedAppPref = listingPreferenceMap.(preference.autograntedPreference)
						appPref.autoGrant = grantedAppPref;
						
						
					*/
	}
	
	private Map<ID,Listing_Lottery_Preference__c> getListingPreferences() {
		
		return new Map<ID, Listing_Lottery_Preference__c> ([Select id, Auto_Grants_Preference__c From Listing_Lottery_Preference__c where listing__c in : listingIDs]);
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
	 
	
	
	public override boolean shouldRunOnInsert() {
		return true;
		
	}
	public override boolean shouldRunOnDelete() { 
		return true;
	
	} 
	public override boolean shouldRunOnUpdate() {
		return true;
		
	} 
	
	public override void doAction() {
		/*
		for each app
					 appPrefByListingPref = new map<preference,application_preference>
					
					for each preference
						if listingPref.autoGrants another listingPreference
						applicationPref = appPrefByListingPref.get(listingPref);
						grantedAppPrefernce = appPrefByListingPref.(listingPreference.autograntedPreference)
						if listingPreferennce.autoGrant = grantedListingPrefernce;
						*/
		//returns a map<listingid, map<preferenceID, listingLotteryPreference>
		system.debug('hello');
		List<Application_Preference__c> updatedApplicationPrefs = new List<Application_Preference__c>();
		Map<ID,Listing_Lottery_Preference__c> listingPrefMap = getListingPreferences();
		Map<ID,Map<ID,Application_Preference__c>> applicationPrefMap = getApplicationPreferences(applicationIDS);
        system.debug('applicationPrefMap:' + applicationPrefMap);
		for (ID applicationID: applicationPrefMap.keyset()) {
					system.debug('listing ' +applicationID );
			
			Map<ID,Application_Preference__c> appPrefByListingPref = applicationPrefMap.get(applicationID);
			for (ID listingPrefID: appPrefByListingPref.keyset()) {
			//	listingLotteryPrefMap.get
				Listing_Lottery_Preference__c preference = listingPrefMap.get(listingPrefID);
                system.debug('preference::' + preference);
				//(preference is only null with bad data);
				if (preference==null || preference.Auto_Grants_Preference__c==null ) { // if the preference grants another preference
					continue;
				}
				Application_Preference__c currentPref = appPrefByListingPref.get(listingPrefID);
				Application_Preference__c grantedPref = appPrefByListingPref.get(preference.Auto_Grants_Preference__c);
				system.debug('currentlistingLotteryPref ' +currentPref );
				system.debug('grantedListingPref ' +grantedPref );
                system.debug('appPrefByListingPref:: ' + appPrefByListingPref );
				if (grantedPref!=null && currentPref.Auto_Grants_Preference__c!= grantedPref.id) {
					currentPref.Auto_Grants_Preference__c =grantedPref.id;
					updatedApplicationPrefs.add(currentPref); 
					
					
				}
			}
			
		}
		if (updatedApplicationPrefs.size()>0) {
			update updatedApplicationPrefs;
		}
		
	}
	
	 
	
    public static void runHandler() {
    	if (trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        	ApplicationPreferenceSetAutoGrantAction action = new ApplicationPreferenceSetAutoGrantAction(Trigger.new);
            action.doAction(); 
            return;
        }
        /*
        if (trigger.isAfter && trigger.isUpdate){
        	ListingPreferenceSetAutoGrantAction action = new ListingPreferenceSetAutoGrantAction(Trigger.newMap, Trigger.oldMap);
            action.doAction(); 
            return;
        }
        if (trigger.isBefore && (trigger.isDelete)){
        	system.debug('before delete:::');
			ListingPreferenceSetAutoGrantAction action = new ListingPreferenceSetAutoGrantAction(Trigger.old);
	        action.doAction(); 
	        return;
        	
        }
        */
       
    }
}