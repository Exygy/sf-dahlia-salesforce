public without sharing class ListingPreferenceSetAutoGrantAction extends TriggerAction {
	
	private Set<ID> listingIDS;
 	//private Map<ID, Lottery_Preference__c> lotteryPrefs;
 	//private Set<ID> preferenceIds;
 	public ListingPreferenceSetAutoGrantAction (List<SObject> objs) {
		
		super(objs);
		listingIDS = new Set<ID>();
		for (SObject obj : objs) {
			Listing_Lottery_Preference__c listingPref = (Listing_Lottery_Preference__c) obj;
			listingIDS.add(listingPref.Listing__c);
		}
		//get all the listinIDS
		//set the autoGrant or remove it if it shoudln't be there.
		/*  for each listing
					 listingPreferenceMap = new map<preference,listing_lottery_pref>
					
					for each preference
						if preference.autoGrants another preference
						listingPrefernece = listingPreferenceMap.get(preference);
						grantedListingPrefernce = listingPreferenceMap.(preference.autograntedPreference)
						if listingPreferennce.autoGrant = grantedListingPrefernce;
						
						
					*/
	}
	
	private Map<ID,Lottery_Preference__c> getPreferences() {
		
		return new Map<ID, Lottery_Preference__c> ([Select id, Auto_Grants_Preference__c From Lottery_Preference__c ]);
	}
	//returns a map<listingid, map<preferenceID, listingLotteryPreference>
	private static Map<ID,Map<ID,Listing_Lottery_Preference__c>> getListingLotteryPreferences(Set<ID> listingIDS) {
		Map<ID,Map<ID,Listing_Lottery_Preference__c>> listingPrefMap = new Map<ID,Map<ID,Listing_Lottery_Preference__c>>();
		List< Listing_Lottery_Preference__c> prefList = [Select id, Listing__c,Auto_Grants_Preference__c, Lottery_Preference__c From Listing_Lottery_Preference__c where Listing__c in :listingIDS];
		for (Listing_Lottery_Preference__c lotPref:  prefList) {
			Map<ID,Listing_Lottery_Preference__c> listingLotteryPrefMap  = (listingPrefMap.containsKey(lotPref.Listing__c))? listingPrefMap.get(lotPref.Listing__c) : new  Map<ID,Listing_Lottery_Preference__c>(); 
			listingLotteryPrefMap.put(lotPref.Lottery_Preference__c,lotPref);
			listingPrefMap.put(lotPref.Listing__c,listingLotteryPrefMap);
		}
		return listingPrefMap; 
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
		for each listing
					 listingPreferenceMap = new map<preference,listing_lottery_pref>
					
					for each preference
						if preference.autoGrants another preference
						listingPrefernece = listingPreferenceMap.get(preference);
						grantedListingPrefernce = listingPreferenceMap.(preference.autograntedPreference)
						if listingPreferennce.autoGrant = grantedListingPrefernce;
						*/
		//returns a map<listingid, map<preferenceID, listingLotteryPreference>
		system.debug('hello');
		List<Listing_Lottery_Preference__c> updatedListingLotteryPrefs = new List<Listing_Lottery_Preference__c>();
		Map<ID,Lottery_Preference__c> prefMap = getPreferences();
		Map<ID,Map<ID,Listing_Lottery_Preference__c>> listingPrefMap = getListingLotteryPreferences(listingIDS);
		for (ID listingID: listingPrefMap.keyset()) {
			//listingPrefMap.get(listingID);
					system.debug('listing:: ' +listingID );
			
			Map<ID,Listing_Lottery_Preference__c> listingLotteryPrefMap = listingPrefMap.get(listingID);
			for (ID preferenceID: listingLotteryPrefMap.keyset()) {
			//	listingLotteryPrefMap.get
				Lottery_Preference__c preference = prefMap.get(preferenceID);
									system.debug('Lottery_Preference__c:: ' +preference );
				
				if (preference.Auto_Grants_Preference__c==null) { // if the preference grants another preference
					continue;
				}
				Listing_Lottery_Preference__c currentlistingLotteryPref = listingLotteryPrefMap.get(preferenceID);
				Listing_Lottery_Preference__c grantedListingPref = listingLotteryPrefMap.get(preference.Auto_Grants_Preference__c);
				system.debug('currentlistingLotteryPref ' +currentlistingLotteryPref );
				system.debug('grantedListingPref ' +grantedListingPref );
				if (grantedListingPref!=null && currentlistingLotteryPref.Auto_Grants_Preference__c!= grantedListingPref.id) {
					currentlistingLotteryPref.Auto_Grants_Preference__c =grantedListingPref.id;
					updatedListingLotteryPrefs.add(currentlistingLotteryPref); 
					
					system.debug('grantedListingPref ' +grantedListingPref );
					
				}
			}
			
		}
		if (updatedListingLotteryPrefs.size()>0) {
			update updatedListingLotteryPrefs;
		}
		
	}
	
	 
	
    public static void runHandler() {
    	if (trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        	ListingPreferenceSetAutoGrantAction action = new ListingPreferenceSetAutoGrantAction(Trigger.new);
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