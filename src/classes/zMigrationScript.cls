public with sharing class zMigrationScript {
	private static final String LIVE_WORK_PREFERENCE_NAME = 'Live or Work in San Francisco Preference';
	private static final String COP_PREFERENCE_NAME = 'Certificate of Preference (COP)';
	private static final String DTHP_PREFERENCE_NAME = 'Displaced Tenant Housing Preference (DTHP)';
	private static final String NEIGHBORHOOD_PREFERENCE_NAME = 'Neighborhood Resident Housing Preference (NRHP)';
	
	//returns a map<listingid, map<preferenceID, listingLotteryPreference>
	private static Map<ID,Map<ID,Listing_Lottery_Preference__c>> getListingLotteryPreferences(Set<ID> listingIDS) {
		Map<ID,Map<ID,Listing_Lottery_Preference__c>> listingPrefMap = new Map<ID,Map<ID,Listing_Lottery_Preference__c>>();
		List< Listing_Lottery_Preference__c> prefList = [Select id, Name, Listing__c,Auto_Grants_Preference__c, Lottery_Preference__c, Preference_Name__c From Listing_Lottery_Preference__c where Listing__c in :listingIDS];
		if(prefList.size()>0)
        for (Listing_Lottery_Preference__c lotPref:  prefList) {
			Map<ID,Listing_Lottery_Preference__c> listingLotteryPrefMap  = (listingPrefMap.containsKey(lotPref.Listing__c))? listingPrefMap.get(lotPref.Listing__c) : new  Map<ID,Listing_Lottery_Preference__c>(); 
			listingLotteryPrefMap.put(lotPref.Lottery_Preference__c,lotPref);
			listingPrefMap.put(lotPref.Listing__c,listingLotteryPrefMap);
		}
		return listingPrefMap; 
	}
	
	//returns a map<listingid, map<id, applications>
	private static Map<ID,Map<ID,Application__c>> getApplicationsMap(List<Application__c> appList) {
		Map<ID,Map<ID,Application__c>> listingAppMap = new Map<ID,Map<ID,Application__c>>();
		//update this
		/*List<Application__c> appList = [Select id, Listing__c,DTHP_Preference_Member__c,DTHP_Preference_Manual__c,DTHP_Preference_Rank__c,
										DTHP_Opt_Out__c,DTHP_Preference__c,Neighborhood_Preference_Member__c,Neighborhood_Preference_Manual__c,
										Neighborhood_Preference_Rank__c,NRHP_Opt_Out__c,Neighborhood_Preference_Proof__c,Neighborhood_Preference__c,
										Neighborhood_Preference_Address__c,COP_Preference_Member__c,COP_Preference_Manual__c,COP_Preference_Rank__c,
										COP_Opt_Out__c,COP_Preference__c,Live_in_SF_Preference_Member__c,Live_Work_Preference_Paper__c,
										Live_Work_Preference_Rank__c,Live_Work_Opt_Out__c,Live_in_SF_Preference_Proof__c,Live_Work_Preference__c 
										From Application__c where Listing__c in :listingIDS];
		*/
		for (Application__c app:  appList) {
			Map<ID,Application__c> appMap  = (listingAppMap.containsKey(app.Listing__c))? listingAppMap.get(app.Listing__c) : new  Map<ID,Application__c>(); 
			appMap.put(app.id,app);
			listingAppMap.put(app.Listing__c,appMap);
		}
		return listingAppMap; 
	}
	
	public static void createApplicationPreference(List<Application__c> appList) {
		Set<Id> listingIds = new Set<Id>();
		for (Application__c app : appList) {
			listingIds.add(app.Listing__c);
		}
		
		Map<ID,Listing__c> allListingMap = new Map<ID,Listing__c>([SELECT Id FROM Listing__c WHERE Id IN :listingIds]);
		
		Map<ID,Map<ID,Application__c>> appMap  = getApplicationsMap(appList);
		Map<ID,Map<ID,Listing_Lottery_Preference__c>> prefMap =  getListingLotteryPreferences(allListingMap.keySet());

		List<Application_Preference__c> appPrefList = new List<Application_Preference__c>();
		for (ID listingId : allListingMap.keyset()) {
            
            if(prefMap.size()>0) {
			for (ID lotteryPrefId : prefMap.get(listingId).keySet()) {
				if (appMap.get(listingId) == null || appMap.get(listingId).isEmpty()) {
					continue;
				}
				for (Id appId : appMap.get(listingId).keySet()) {
					Application__c currentApp = appMap.get(listingId).get(appId);
					appPrefList.add(buildApplicationPreference(prefMap.get(listingId).get(lotteryPrefId),currentApp));
				}
			}
           
                
            }
            
		}
		if (appPrefList.size() > 0) {
            system.debug('********************************APP Pref Size**************************************** ' + appPrefList.size());
			insert appPrefList;
		}
	}
	
	private static Application_Preference__c buildApplicationPreference(Listing_Lottery_Preference__c listingPref, Application__c currentApp) {
		Application_Preference__c newAppPref = new Application_Preference__c();
		
		newAppPref.Application__c = currentApp.Id;
		newAppPref.Listing_Preference_ID__c = listingPref.Id;
		
		if (listingPref.Preference_Name__c == DTHP_PREFERENCE_NAME) {
			newAppPref.Application_Member__c = currentApp.DTHP_Preference_Member__c;
			newAppPref.Lottery_Status__c = (currentApp.DTHP_Preference_Manual__c == 'Valid' ? 'Valid for lottery' : currentApp.DTHP_Preference_Manual__c == 'Invalid' ? 'Invalid for lottery' : currentApp.DTHP_Preference_Manual__c);
			newAppPref.Preference_Lottery_Rank__c = currentApp.DTHP_Preference_Rank__c;
			newAppPref.Opt_Out__c = currentApp.DTHP_Opt_Out__c;
			//newAppPref.Type_of_proof__c = currentApp.;
			//newAppPref.Receives_Preference__c = currentApp.DTHP_Preference__c;//formula field
		} else if (listingPref.Preference_Name__c == NEIGHBORHOOD_PREFERENCE_NAME) {
			newAppPref.Application_Member__c = currentApp.Neighborhood_Preference_Member__c;
			newAppPref.Lottery_Status__c = (currentApp.Neighborhood_Preference_Manual__c == 'Valid Address' ? 'Valid for lottery' : currentApp.Neighborhood_Preference_Manual__c == 'Invalid Address' ? 'Invalid for lottery' : currentApp.Neighborhood_Preference_Manual__c != null ? currentApp.Neighborhood_Preference_Manual__c.replace('Address ','') : currentApp.Neighborhood_Preference_Manual__c);
			newAppPref.Preference_Lottery_Rank__c = currentApp.Neighborhood_Preference_Rank__c;
			newAppPref.Opt_Out__c = currentApp.NRHP_Opt_Out__c;
			newAppPref.Type_of_proof__c = currentApp.Neighborhood_Preference_Proof__c;
			//newAppPref.Receives_Preference__c = currentApp.Neighborhood_Preference__c;//formula field
		} else if (listingPref.Preference_Name__c == COP_PREFERENCE_NAME) {
			newAppPref.Application_Member__c = currentApp.COP_Preference_Member__c;
			newAppPref.Lottery_Status__c = (currentApp.COP_Preference_Manual__c == 'Valid' ? 'Valid for lottery' : currentApp.COP_Preference_Manual__c == 'Invalid' ? 'Invalid for lottery' : currentApp.COP_Preference_Manual__c);
			newAppPref.Preference_Lottery_Rank__c = currentApp.COP_Preference_Rank__c;
			newAppPref.Opt_Out__c = currentApp.COP_Opt_Out__c;
			//newAppPref.Type_of_proof__c = currentApp.;
			//newAppPref.Receives_Preference__c = currentApp.COP_Preference__c;//formula field
		} else if (listingPref.Preference_Name__c == LIVE_WORK_PREFERENCE_NAME) {
            if(currentApp.Live_in_SF_Preference_Member__c == null) {
                if(currentApp.Work_in_SF_Preference_Member__c != null) {
                newAppPref.Application_Member__c = currentApp.Work_in_SF_Preference_Member__c;
                newAppPref.Type_of_proof__c = currentApp.Work_in_SF_Preference_Proof__c;
                newAppPref.Individual_preference__c = 'Work in SF';               
                newAppPref.Lottery_Status__c = !currentApp.Live_Work_Preference_Paper__c ? 'None' : null;
                newAppPref.Preference_Lottery_Rank__c = currentApp.Live_Work_Preference_Rank__c;
                newAppPref.Opt_Out__c = currentApp.Live_Work_Opt_Out__c;
            }
                else {
                	newAppPref.Preference_Lottery_Rank__c = currentApp.Live_Work_Preference_Rank__c;
                	newAppPref.Opt_Out__c = currentApp.Live_Work_Opt_Out__c;
                    if(currentApp.Neighborhood_Preference__c || currentApp.DTHP_Preference__c)
                        newAppPref.Lottery_Status__c = !currentApp.Live_Work_Preference_Paper__c ? 'None' : null;
                    else newAppPref.MOHCD_Preference_Assertion__c = currentApp.Live_Work_Preference_Paper__c ? 'Valid for lottery' : ''; 
                   // newAppPref.MOHCD_Preference_Assertion__c = currentApp.Live_Work_Opt_Out__c ? 'Invalid for Lottery' : newAppPref.MOHCD_Preference_Assertion__c;
                        }
            }
            else if(currentApp.Live_in_SF_Preference_Member__c != null){
			newAppPref.Application_Member__c = currentApp.Live_in_SF_Preference_Member__c;
			newAppPref.Lottery_Status__c = !currentApp.Live_Work_Preference_Paper__c ? 'None' : null;
			newAppPref.Preference_Lottery_Rank__c = currentApp.Live_Work_Preference_Rank__c;
            newAppPref.Individual_preference__c = 'Live in SF';
			newAppPref.Opt_Out__c = currentApp.Live_Work_Opt_Out__c;
			newAppPref.Type_of_proof__c = currentApp.Live_in_SF_Preference_Proof__c;
			//newAppPref.Receives_Preference__c = currentApp.Live_Work_Preference__c;//formula field
            }
		}
		return newAppPref;
	}
	

	
	/*
	


for each listing - 

	appmap  = getApplicationsForListing()
	prefMap =  getlistingPreferenceForListing
	for each listingPreference { 


		for each application  {

			create new AppPref(listingpref, application, appMember, status);
		}



	} 

listingPref.name = 
create new AppPref(listingpref, application, appMember, status) {
	if listingPref.name = 'dthp'
		fill in these values
		return
	else COP {
	
	}

}

	
	*/
}