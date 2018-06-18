// *****************************************************************************
// CLASS: HOP_ApplicationFormController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_ApplicationForm page.
//
// *****************************************************************************

public without sharing class HOP_ApplicationFormController extends HOP_ControllerBase {

    private static final String CUSTOM_PROOF = 'Custom Proof';
    
    public static Set<String> showHHMemberPreferences = new Set<String> {
        API_Application.L_W_RT_DEVELOPER_NAME,//'Live or Work in San Francisco Preference',
        API_Application.NRHP_RT_DEVELOPER_NAME,//'Neighborhood Resident Housing Preference (NRHP)',
        API_Application.ADHP_RT_DEVELOPER_NAME//'Anti-Displacement Housing Preference (ADHP)'
    };

    public static Set<String> showIndividualPreferences = new Set<String> {
        API_Application.L_W_RT_DEVELOPER_NAME,//'Live or Work in San Francisco Preference',
        API_Application.RB_AHP_RT_DEVELOPER_NAME//'Rent Burdened / Assisted Housing Preference'
    };

    public static Set<String> showTypeOfProofPreferences = new Set<String> {
        API_Application.L_W_RT_DEVELOPER_NAME,//'Live or Work in San Francisco Preference',
        API_Application.NRHP_RT_DEVELOPER_NAME,//'Neighborhood Resident Housing Preference (NRHP)',
        API_Application.ADHP_RT_DEVELOPER_NAME//'Anti-Displacement Housing Preference (ADHP)'
    };

    public static Set<String> showCOPHolderPreferences = new Set<String> {
        API_Application.COP_RT_DEVELOPER_NAME//'Certificate of Preference (COP)'
    };

    public static Set<String> showDTHPPreferences = new Set<String> {
        API_Application.DTHP_RT_DEVELOPER_NAME//'Displaced Tenant Housing Preference (DTHP)'
    };

    //public static Set<String> showPersonWhoClaimedPreferences = new Set<String> {
    //    'Displaced Tenant Housing Preference (DTHP)'
    //};
    
    public static Set<String> showPersonWhoClaimedPreferences = new Set<String> {
    	API_Application.L_W_RT_DEVELOPER_NAME,//'Live or Work in San Francisco Preference',
    	API_Application.NRHP_RT_DEVELOPER_NAME,//'Neighborhood Resident Housing Preference (NRHP)',
    	API_Application.ADHP_RT_DEVELOPER_NAME,//'Anti-Displacement Housing Preference (ADHP)',
        API_Application.COP_RT_DEVELOPER_NAME,//'Certificate of Preference (COP)',
        API_Application.RB_AHP_RT_DEVELOPER_NAME//'Rent Burdened / Assisted Housing Preference'
    };

    //Variable that indicates whether the application is created or edited
    public static Boolean isNew = true;
    
    // Variable that indicates whether any ApexPages Messages (errors) have been generated.
    public Boolean hasErrors {get; set;}
    public Boolean isValidationError {get; set;}

    // This will hold the current Application currently being edited (new or existing).
    public Application__c app {get; set;}
	
	// This will hold the current Listing tied to the Application currently being edited (new or existing).
	public Listing__c listing {get; set;}
	
	// True if "Reserve type" on any units attached to the listing = "developmental disabilities"
	public Boolean hasDevelopmentalDisabilitiesUnits { get; set; }
	
	// True if "Reserve type" on any units attached to the listing = "veterans"
	public Boolean hasVeteransUnits { get; set; }
	
    // Certain fields (read-only or cross-object) need to be queried separately
    // because the Application API can't set those on an Application__c object created from scratch
    public Application__c appName {get; set;}

    // The Primary Applicant on the Application
    public Application_Member__c primaryApplicant {get; set;}

    // The Alternate Contact on the Application
    public Application_Member__c alternateContact {get; set;}

    // A list of all the Household Members (without the Primary Applicant or the Alternate Contact!)
    // on the current Application.
    public List<Application_Member__c> householdMembers {get; set;}

	// A list of all Preferences on the current Application.
    public List<ShortFormPreferenceWrapper> shortFormPreferences {get; set;}
    
    //used when the user Cancel the changes
    public Application_Preference__c backupSfp { get; set; }

    // Because the adding/editing of Household Members must also work for brand new Applications,
    // in which case the Household Member records don't have an Id yet - we use their index in the
    // householdMembers list (0, 1 etc.) to uniquely identify them
    public List<Integer> householdMembersIndexes {
        get {
            householdMembersIndexes = new List<Integer>();
            if (householdMembers == null) return householdMembersIndexes;
            if (householdMembers.size() == 0) return householdMembersIndexes;
            for (Integer i = 0; i < householdMembers.size(); i++) {
                householdMembersIndexes.add(i);
            }
            return householdMembersIndexes;
        }
        set;
    }
    
    // Because the adding/editing of Shortform Preference must also work for brand new Applications,
    // in which case the Shortform Preference records don't have an Id yet - we use their index in the
    // shortformPreferences list (0, 1 etc.) to uniquely identify them
    public List<Integer> shortFormPreferencesIndexes {
        get {
            shortFormPreferencesIndexes = new List<Integer>();
            if (shortFormPreferences == null) return shortFormPreferencesIndexes;
            if (shortFormPreferences.size() == 0) return shortFormPreferencesIndexes;
            for (Integer i = 0; i < shortFormPreferences.size(); i++) {
            	shortFormPreferencesIndexes.add(i);
            }
            return shortFormPreferencesIndexes;
        }
        set;
    }
    

    // List of dropdown options for the three preference picklists - Neighborhood, DTHP and COP.
    // The list is made up of all the Household Members, plus the Primary Applicant and the --None-- option.
    // The household member index (0, 1 etc.) is used as the key for the SelectOption.
    // For the other two special options we use -1 for the --None-- option and -2 for the Primay Applicant.
    public List<SelectOption> householdMembersSO {
        get {
            householdMembersSO = new List<SelectOption>();
            householdMembersSO.add(new SelectOption('-1', '-- None --'));
            String primaryApplicantName = properName(primaryApplicant);
            if (!String.isBlank(primaryApplicantName)) {
                householdMembersSO.add(new SelectOption('-2', primaryApplicantName));
            }
            if (householdMembers == null) return householdMembersSO;
            if (householdMembers.size() == 0) return householdMembersSO;
            for (Integer i = 0; i < householdMembers.size(); i++) {
                householdMembersSO.add(new SelectOption(String.valueOf(i), properName(householdMembers[i])));
            }
            return householdMembersSO;
        }
        set;
    }
    
    // List of dropdown options including all preferences related to listing
    public List<SelectOption> listingPreferenceSO {
    	get {
    		listingPreferenceSO = new List<SelectOption>();
            listingPreferenceSO.add(new SelectOption('-1', '-- None --'));
            if (listingPrefs == null) return listingPreferenceSO;
            if (listingPrefs.size() == 0) return listingPreferenceSO;
            Set<String> selectedPrefs = new Set<String>();
    		//for (ShortFormPreferenceWrapper sfPrefW : shortFormPreferences) {
    		//	selectedPrefs.add(sfPrefW.shortFormPreference.Listing_Preference_ID__c);
    		//}
    		//for (Listing_Lottery_Preference__c lp : listingPrefs) {
            //    if (!selectedPrefs.contains(lp.Id) || lp.Id == selectedListingPreference) {//on edit selectedListingPreference should be displayed into the list
            //        listingPreferenceSO.add(new SelectOption(lp.Id, lp.Preference_Name__c));
            //    }
            //}
            system.debug('listingPrefs:::' + listingPrefs);
            for (ShortFormPreferenceWrapper sfPrefW : shortFormPreferences) {
    			selectedPrefs.add(sfPrefW.listingPrefName);
    		}
    		for (Integer i = 0; i < listingPrefs.size(); i++) {
                if (!selectedPrefs.contains(listingPrefs[i].Preference_Name__c) || String.valueOf(i) == selectedListingPreference) {//on edit selectedListingPreference should be displayed into the list
                    listingPreferenceSO.add(new SelectOption(String.valueOf(i), listingPrefs[i].Preference_Name__c));
                }
            }
            //for (Integer i = 0; i < listingPrefs.size(); i++) {
            //    listingPreferenceSO.add(new SelectOption(String.valueOf(i), listingPrefs[i].Preference_Name__c));
            //}
            return listingPreferenceSO;
    	}
    	set;
    }
    
    // The neighborhoodPreference variable is linked to the corresponding picklist, therefore its value
    // will be a number (0, 1 etc.) which is the index of the selected Household Member.
    // When setting this, also get the corresponding Household Member Id (if it exists)
    // and set it automatically on the Application variable.
    public String selectedApplicationMember {
        get;
        set {
            selectedApplicationMember = value;
            currentShortFormPreference.sfp.Application_Member__c = householdMemberIdFromPreference(selectedApplicationMember);
            currentShortFormPreference.personWhoClaimed = selectedApplicationMember != '-1' || currentShortFormPreference.sfp.Application_Member__c != null ? properName(householdMemberFromPreference(selectedApplicationMember)) : '';
            currentShortFormPreference.selectedAppMember = selectedApplicationMember;
        }
    }
    
    //selected listing preference
    public String selectedListingPreference {
    	get;
        set {
        	selectedListingPreference = value;
            Integer intValue = Integer.valueOf(value);
        	currentShortFormPreference.sfp.Listing_Preference_ID__c = intValue < 0 ? null : listingPrefs[intValue].Id;
        	Id sfPrefRtId = intValue < 0 ? null : (String.isEmpty(listingPrefs[intValue].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(API_Application.CUSTOM_RT_DEVELOPER_NAME) : API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(listingPrefs[intValue].Lottery_Preference__r.Record_Type_For_App_Preferences__c));
            currentShortFormPreference.sfp.RecordTypeId = intValue < 0 ? null : sfPrefRtId;
        	Boolean typeOfProof = intValue < 0 ? false : (listingPrefs[intValue].Requires_Proof__c != null ? listingPrefs[intValue].Requires_Proof__c : false);
        	currentShortFormPreference.sfp.Type_of_proof__c = (typeOfProof && sfPrefRtId == API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(API_Application.CUSTOM_RT_DEVELOPER_NAME)) ? CUSTOM_PROOF : currentShortFormPreference.sfp.Type_of_proof__c;
        	currentShortFormPreference.listingPrefName = intValue < 0 ? '' : listingPrefs[intValue].Preference_Name__c;
        }
    }

    public Boolean showHHMember {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return showHHMemberPreferences.contains(sfPrefRtName);
        }
    }

    public Boolean showIndividualPreference {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return showIndividualPreferences.contains(sfPrefRtName);
        }
    }

    public Boolean showTypeOfProof {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return showTypeOfProofPreferences.contains(sfPrefRtName);
        }
    }

    public Boolean showCOPHolder {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return showCOPHolderPreferences.contains(sfPrefRtName);
        }
    }

    public Boolean showDTHP {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return showDTHPPreferences.contains(sfPrefRtName);
        }
    }
    
    public Boolean showAntiDTHP {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return sfPrefRtName == API_Application.ADHP_RT_DEVELOPER_NAME;//'Anti-Displacement Housing Preference (ADHP)';
        }
    }
    
    public Boolean showNRHP {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return sfPrefRtName == API_Application.NRHP_RT_DEVELOPER_NAME;//'Neighborhood Resident Housing Preference (NRHP)';
        }
    }
    
    public Boolean showLiveWork {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return sfPrefRtName == API_Application.L_W_RT_DEVELOPER_NAME;//'Live or Work in San Francisco Preference';
        }
    }
    
    public Boolean showRentBurden {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return sfPrefRtName == API_Application.RB_AHP_RT_DEVELOPER_NAME;//'Rent Burdened / Assisted Housing Preference';
        }
    }

    public Boolean showPersonWhoClaimed {
        get {
            if (String.isBlank(selectedListingPreference)) return false;
            Integer intVal = Integer.valueOf(selectedListingPreference);
            if (intVal < 0) return false;
            String sfPrefRtName = (String.isEmpty(listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.CUSTOM_RT_DEVELOPER_NAME : listingPrefs[intVal].Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            return !showPersonWhoClaimedPreferences.contains(sfPrefRtName);
        }
    }

    // When editing a household member, this will hold that Household Member currently being edited.
    // If no household member is currently being edited, this will be null.
    public Application_Member__c currentHouseholdMember {get; set;}

	// When editing a shortform preference, this will hold that Shortform Preference currently being edited.
    // If no shortform preference is currently being edited, this will be null.
    public ShortFormPreferenceWrapper currentShortFormPreference {get; set;}
	
    // Most HOP pages support a retUrl parameter that enables "Back" navigation to the previous page.
    public String retUrl {get; set;}

    // The index of the currently selected Household Member that's being edited (-1 if none)
    public Integer selectedHouseholdMemberIdx {get; set;}

	// The index of the currently selected Preference that's being edited (-1 if none)
    public Integer selectedShortFormPreferenceIdx {get; set;}
    
    public boolean providedLease { 
    	get {
    		if (currentShortFormPreference.sfp.Id != null && currentShortFormPreference.sfp.Individual_preference__c == 'Assisted Housing' && currentShortFormPreference.sfp.Application_Member__c != null) {
    			providedLease = true;
    		}
    		return providedLease;
    	} 
    	set; 
    }
    public boolean includedLease { 
    	get {
    		if (currentShortFormPreference.sfp.Id != null && currentShortFormPreference.sfp.Individual_preference__c == 'Rent Burdened' && monthlyRentPecentage >= 50) {
    			includedLease = true;
    		}
    		return includedLease;
    	} 
    	set; 
    }
    public boolean providedProof { 
    	get {
    		if (currentShortFormPreference.sfp.Id != null && currentShortFormPreference.sfp.Individual_preference__c == 'Rent Burdened' && monthlyRentPecentage >= 50) {
    			providedProof = true;
    		}
    		return providedProof;
    	} 
    	set; 
    }
    public boolean disableAddBtn { 
    	get {
    		if (showRentBurden == true && 
    			((currentShortFormPreference.sfp.Individual_preference__c == 'Rent Burdened' && (monthlyRentPecentage < 50 || includedLease != true || providedProof != true)) || 
    			(currentShortFormPreference.sfp.Individual_preference__c == 'Assisted Housing' && providedLease != true))) {
    			return true;
    		} else {
    			return false;
    		}
    	}
    	set; 
    }
    
    public Decimal monthlyRentPecentage { 
    	get {
    		if (app.Total_Monthly_Rent__c == null || app.Annual_Income__c == null) return 0;
	        if (app.Total_Monthly_Rent__c < 0 || app.Annual_Income__c < 0) return 0;
	        return (app.Total_Monthly_Rent__c * 100)/(app.Annual_Income__c/12);
    	} 
    	set; 
    }
    
    public void getMonthlyRentPecentage() {
    	system.debug(LoggingLevel.INFO,'app.Annual_Income__c:::' + app.Annual_Income__c);
        system.debug(LoggingLevel.INFO,'app.Total_Monthly_Rent__c:::' + app.Total_Monthly_Rent__c);
        if (app.Total_Monthly_Rent__c == null || app.Annual_Income__c == null) { monthlyRentPecentage = 0; return; }
        if (app.Total_Monthly_Rent__c < 0 || app.Annual_Income__c < 0) { monthlyRentPecentage = 0; return; }
        monthlyRentPecentage = (app.Total_Monthly_Rent__c*100)/(app.Annual_Income__c/12);
    }
    
    public boolean isTotalMonthlyRentEditable {
    	get {
    		return Schema.SObjectType.Application__c.fields.getMap().get('Total_Monthly_Rent__c').getDescribe().isUpdateable();
		}
    	set;
    }

    /*public String neighborhoodPreference {
        get;
        set {
            neighborhoodPreference = value;
            app.Neighborhood_Preference_Member__c = householdMemberIdFromPreference(neighborhoodPreference);
        }
    }

    // Same thing for the DTHP preference
    public String dthpPreference {
        get;
        set {
            dthpPreference = value;
            app.DTHP_Preference_Member__c = householdMemberIdFromPreference(dthpPreference);
        }
    }

    // Same thing for the COP preference
    public String copPreference {
        get;
        set {
            copPreference = value;
            app.COP_Preference_Member__c = householdMemberIdFromPreference(copPreference);
        }
    }

    // Same thing for the Live in SF preference
    public String liveInSfPreference {
        get;
        set {
            liveInSfPreference = value;
            app.Live_in_SF_Preference_Member__c = householdMemberIdFromPreference(liveInSfPreference);
        }
    }

    // Same thing for the Work in SF preference
    public String workInSfPreference {
        get;
        set {
            workInSfPreference = value;
            app.Work_in_SF_Preference_Member__c = householdMemberIdFromPreference(workInSfPreference);
        }
    }
    
    public List<SelectOption> getIndividualPrefs() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','--None--'));
		if (currentShortFormPreference.listingPrefName == 'Live or Work in San Francisco Preference') {
			options.add(new SelectOption('Live in SF','Live in SF'));
			options.add(new SelectOption('Work in SF','Work in SF'));
		}
		if (currentShortFormPreference.listingPrefName == 'Rent Burdened / Assisted Housing Preference') {
			options.add(new SelectOption('Assisted Housing','Assisted Housing'));
			options.add(new SelectOption('Rent Burdened','Rent Burdened'));
		}
		return options;
    }
	
	public List<SelectOption> getTypeOfProofs() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','--None--'));
		if (currentShortFormPreference.sfp.Individual_preference__c != 'Work in SF') {
			options.add(new SelectOption('Telephone bill','Telephone bill'));
			options.add(new SelectOption('Cable and internet bill','Cable and internet bill'));
			options.add(new SelectOption('Gas bill','Gas bill'));
			options.add(new SelectOption('Electric bill','Electric bill'));
			options.add(new SelectOption('Garbage bill','Garbage bill'));
			options.add(new SelectOption('Water bill','Water bill'));
			options.add(new SelectOption('Paystub','Paystub'));
			options.add(new SelectOption('Public benefits record','Public benefits record'));
			options.add(new SelectOption('School record','School record'));
		}
		if (currentShortFormPreference.sfp.Individual_preference__c == 'Work in SF') {
			options.add(new SelectOption('Paystub with employer address','Paystub with employer address'));
			options.add(new SelectOption('Letter from employer','Letter from employer'));
		}
		if (currentShortFormPreference.sfp.Individual_preference__c == 'Live in SF' || currentShortFormPreference.listingPrefName == 'Neighborhood Resident Housing Preference (NRHP)' || currentShortFormPreference.listingPrefName == 'Anti-Displacement Housing Preference (ADHP)') {
			options.add(new SelectOption('Letter documenting homelessness','Letter documenting homelessness'));
		}
		return options;
	}*/
	
    // Listing Id & Name
    public Id listingId {get; set;}
    public String listingName {get; set;}

    // Listing Preferences
    public List<Listing_Lottery_Preference__c> listingPrefs {get; set;}

    // Looks up a Household Member (using its Id) in the list of existing Household Members
    // on the Application and returns its index in the list (0, 1 etc.)
    // Returns -2 if it's the Primary Applicant and -1 if not found at all.
    private String preferenceFromHouseholdMemberId(Id householdMemberId) {
        String preference = '-1';
        if (householdMemberId == null) return preference;
        if (householdMemberId == primaryApplicant.Id) return '-2';
        for (Integer i = 0; i < householdMembers.size(); i++) {
            if (householdMembers[i].Id == householdMemberId) {
                preference = String.valueOf(i);
                break;
            }
        }
        return preference;
    }
    
    private String preferenceFromHouseholdMember(String householdMember) {
        String FullName;
        String preference = '-1';
        if (householdMember == null) return preference;
        if (householdMember == (primaryApplicant.First_Name__c + ' ' + (primaryApplicant.Middle_Name__c != null ? primaryApplicant.Middle_Name__c + ' ' : '') + primaryApplicant.Last_Name__c)) return '-2';
        for (Integer i = 0; i < householdMembers.size(); i++) {
            FullName = householdMembers[i].First_Name__c + ' ' + (householdMembers[i].Middle_Name__c != null ? householdMembers[i].Middle_Name__c + ' ' : '') + householdMembers[i].Last_Name__c;
            if (FullName == householdMember) {
                preference = String.valueOf(i);
                break;
            }
        }
        return preference;
    }

    // The reverse operation, uses a preference key (-2, -1, 0, 1 etc.) to target an existing
    // Household Member (Primary Applicant for -2) and return its Id (or null for -1)
    private Id householdMemberIdFromPreference(String preference) {
        Application_Member__c am = householdMemberFromPreference(preference);
        return am == null ? null : am.Id;
    }

    // Uses a preference key (-2, -1, 0, 1 etc.) to target an existing Household Member (Primary Applicant for -2)
    // and returns the corresponding Application_Member__c record (or null for -1)
    private Application_Member__c householdMemberFromPreference(String preference) {
        return preference == '-1' ? null : preference == '-2' ? primaryApplicant : householdMembers[Integer.valueOf(preference)];
    }

    // Transforms a null String into an empty string, returns the original string otherwise
    private static String nvl(String s) {
        return s == null ? '' : s;
    }

    // Builds the Application Member's full and proper name from the First, Middle and Last Name.
    // Uses protection against null Text fields.
    private static String properName(Application_Member__c appMember) {
        return (nvl(appMember.First_Name__c) + ' ' + nvl(appMember.Middle_Name__c) + ' ' + nvl(appMember.Last_Name__c)).normalizeSpace();
    }
    
    //store additional info for existing application preference
    public static Map<Id,Application_Preference__c> existingAppPrefMap { get; set; }

    private void init() {
        app = new Application__c(Application_Language__c = 'English', Application_Submission_Type__c = HOP_Constants.PAPER_APPLICATION);
        primaryApplicant = new Application_Member__c();
        alternateContact = new Application_Member__c();
        //alternateContact = null;
        householdMembers = new List<Application_Member__c>();
        selectedHouseholdMemberIdx = -1;
        selectedShortFormPreferenceIdx = -1;
        shortFormPreferences = new List<ShortFormPreferenceWrapper>();
    }
    
    // Helper method that queries a Listing record by its Id
	private static Listing__c getListingById(String paramListingId) {
		List<Listing__c> listings = [
			SELECT
				Id, Name, Reserved_community_type__c,
				(SELECT Id, Unit__r.Reserved_Type__c FROM Listing_Units__r)
			FROM Listing__c
			WHERE Id = :paramListingId
		];

		if (listings.size() == 0) {
			return null;
		} else {
			return listings[0];
		}
	}
	
    public HOP_ApplicationFormController() {
        super();
        hasErrors = false;
        isValidationError = false;
        
        init();
        
        retUrl = ApexPages.currentPage().getParameters().get('retUrl');

        // The page expects either an Application Id parameter (to edit) or a Listing Id parameter (to add a new Application to)
        String paramApplicationId = ApexPages.currentPage().getParameters().get('id');
        String paramListingId = ApexPages.currentPage().getParameters().get('listingId');

        // If neither are provided, an error is triggered
        if (String.isBlank(paramApplicationId) && String.isBlank(paramListingId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_ID_OR_LISTINGID));
            hasErrors = true;
            return;
        }
        
        if (!String.isBlank(paramApplicationId)) {
            // If an Application Id parameter is provided:
            // Check to see if an Application with the provided Id exists. If not, display an error.
            API_Application.ShortForm sf = API_ApplicationService.getShortformById(paramApplicationId);
            if (sf == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_APPLICATION_NOT_FOUND));
                hasErrors = true;
                return;
            }

            // Query additionally needed info. Check to see that the Lottery is not yet Complete (if it is, do not allow the Application to be edited.)
            appName = [
                SELECT
                    Name, Listing__c, Listing__r.Account__c, Listing__r.Name, Status__c, Is_Lottery_Complete__c,
            		(SELECT Id, Preference_Name__c, Person_who_claimed_Name__c,Lottery_Status__c, Receives_Preference__c, Preference_Order__c FROM Application_Preferences__r order by Name)  //////// Added Lottery_Status__c by Nish to get status of AppPref //////////////
                FROM Application__c
                WHERE Id = :paramApplicationId
            ];
            if (appName.Is_Lottery_Complete__c == true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_LISTING_COMPLETE));
                hasErrors = true;
                return;
            }

            // Community users cannot edit Draft Applications, or Applications associated with an Account other than their own.
            if (myUser.Profile.UserLicense.Name == HOP_Constants.COMMUNITY_LICENSE_NAME &&
                (appName.Listing__r.Account__c != myUser.Contact.AccountId || appName.Status__c == HOP_Constants.DRAFT_APPLICATION)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_NO_ACCESS));
                hasErrors = true;
                return;
            }

            // Load the Application, Primary Applicant, Alternate Contact and Household Members into their corresponding variables.
            app = sf.toApplication();
            system.debug('app.Applicant__c:::' + app.Applicant__c);
			
            if (sf.primaryApplicant != null) {
                primaryApplicant = sf.primaryApplicant.toApplicationMember();
            }
            if (sf.alternateContact != null) {
                alternateContact = sf.alternateContact.toApplicationMember();
            }
            for (API_Application.Person p : sf.householdMembers) {
                householdMembers.add(p.toApplicationMember());
            }
            existingAppPrefMap = new Map<Id, Application_Preference__c>();
            for (Application_Preference__c appPref : appName.Application_Preferences__r) {
            	existingAppPrefMap.put(appPref.Id, appPref);
            }
            for (API_Application.ShortFormPreference sfPref : sf.shortFormPreferences) {
                shortFormPreferences.add(new ShortFormPreferenceWrapper(sfPref.toApplicationPreference()));
            }
            shortFormPreferences.sort();

            // For the five preferences, load the corresponding Household Member's index (-1 if not set) into five corresponding variables.
            /*neighborhoodPreference = preferenceFromHouseholdMemberId(app.Neighborhood_Preference_Member__c);
            dthpPreference = preferenceFromHouseholdMemberId(app.DTHP_Preference_Member__c);
            copPreference = preferenceFromHouseholdMemberId(app.COP_Preference_Member__c);
            liveInSfPreference = preferenceFromHouseholdMemberId(app.Live_in_SF_Preference_Member__c);
            workInSfPreference = preferenceFromHouseholdMemberId(app.Work_in_SF_Preference_Member__c);*/

            listingId = appName.Listing__c;
            listingName = appName.Listing__r.Name;
        	listing = getListingById(listingId);
        } else {
            // If a Listing Id parameter is provided:
            // Check to see if a Listing with the provided Id exists. If not, display an error.
            //List<Listing__c> listings = [SELECT Id, Name FROM Listing__c WHERE Id = :paramListingId];
            listing = getListingById(paramListingId);
            if (listing == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_LISTING_NOT_FOUND));
                hasErrors = true;
                return;
            }
            // The new Application is linked to the requested Listing and its Type is automatically set to Paper.
            app.Listing__c = listing.Id;
            app.Application_Submission_Type__c = HOP_Constants.PAPER_APPLICATION;

            listingId = listing.Id;
            listingName = listing.Name;
        }
        
        hasDevelopmentalDisabilitiesUnits = false;
		hasVeteransUnits = false;
		
		for (Listing_Unit__c listingUnit : listing.Listing_Units__r) {
			if (listingUnit.Unit__r.Reserved_Type__c == HOP_Constants.UNIT_DEVELOPMENTAL_DISABILITIES) {
				hasDevelopmentalDisabilitiesUnits = true;
			}
			if (listingUnit.Unit__r.Reserved_Type__c == HOP_Constants.UNIT_VETERAN) {
				hasVeteransUnits = true;
			}
		}

        listingPrefs = [
            SELECT Id, Preference_Name__c, Lottery_Preference__r.Record_Type_For_App_Preferences__c, Requires_Proof__c
            FROM Listing_Lottery_Preference__c
            WHERE Listing__c = :listingId
            ORDER BY /*Order__c, Preference_Name__c*/Name asc
            nulls last
        ];
        
    }


    // Saves the entire Application form at once (including Primary Applicant, Alternate Contact, Household Members and preferences)
    // using the ApplicationService API.
    public PageReference saveApplicationForm() {
        isNew = false;
        app.Applicant__r = primaryApplicant;
        system.debug('alternateContact:::' + alternateContact);
        app.Alternate_Contact__r = alternateContact.First_Name__c != null && alternateContact.Last_Name__c != null ? alternateContact : null;
        system.debug('app.Alternate_Contact__r:::' + app.Alternate_Contact__r);
        API_Application.ShortForm sf = new API_Application.ShortForm(app, householdMembers);
        
        sf.shortFormPreferences = new List<API_Application.ShortFormPreference>();
		if (shortFormPreferences != null) {
			for (ShortFormPreferenceWrapper sfPrefW : shortFormPreferences) {
				if (sfPrefW.sfp.Individual_preference__c == 'Rent Burdened') {
					sfPrefW.selectedAppMember = '-2';//primary applicant
					sfPrefW.sfp.Type_of_proof__c = 'Lease and rent proof';
				}
				if (sfPrefW.sfp.Individual_preference__c == 'Assisted Housing') {
					sfPrefW.sfp.Type_of_proof__c = 'Lease';
				}
				if (!String.isEmpty(sfPrefW.sfp.LW_Type_of_proof__c)) {
					sfPrefW.sfp.Type_of_proof__c = sfPrefW.sfp.LW_Type_of_proof__c;
				}
				API_Application.ShortFormPreference sfPref = new API_Application.ShortFormPreference(sfPrefW.sfp);
				if (/*app.Neighborhood_Preference_Member__c == null && */sfPrefW.selectedAppMember != null && sfPrefW.selectedAppMember != '-1') {
					sfPref.naturalKey = new API_Application.Person(householdMemberFromPreference(sfPrefW.selectedAppMember)).getKey();
				}
				sf.shortFormPreferences.add(sfPref);
				
			}
		}
		system.debug('sf.shortFormPreferences:::' + sf.shortFormPreferences);
		
        
       
        
        /*if (app.Neighborhood_Preference_Member__c == null && neighborhoodPreference != '-1') {
            sf.neighborhoodResidencePreferenceNatKey = new API_Application.Person(householdMemberFromPreference(neighborhoodPreference)).getKey();
        }
        if (app.DTHP_Preference_Member__c == null && dthpPreference != '-1') {
            sf.displacedPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(dthpPreference)).getKey();
        }
        if (app.COP_Preference_Member__c == null && copPreference != '-1') {
            sf.certOfPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(copPreference)).getKey();
        }
        if (app.Live_in_SF_Preference_Member__c == null && liveInSfPreference != '-1') {
            sf.liveInSfPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(liveInSfPreference)).getKey();
        }
        if (app.Work_in_SF_Preference_Member__c == null && workInSfPreference != '-1') {
            sf.workInSfPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(workInSfPreference)).getKey();
        }*/
        try {
        	sf = API_ApplicationService.upsertShortform(sf);
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0)));
            hasErrors = true;
            isValidationError = true;
            return null;
        }

        PageReference viewPage = new PageReference('/apex/HOP_ApplicationView?id=' + sf.id);
        viewPage.setRedirect(true);
        return viewPage;
    }

    // Save and New convenience button. Saves the current form and refreshes the page.
    public PageReference saveApplicationFormAndNew() {
        saveApplicationForm();
        init();
        app.Listing__c = listingId;
        return ApexPages.currentPage();
    }

    // Creates a new Household Member
    public void newHouseholdMember() {
        currentHouseholdMember = new Application_Member__c();
    }

    // Adds the new Household Member to the list. The currentHouseholdMember is now null.
    public void addHouseholdMember() {
        householdMembers.add(currentHouseholdMember);
        cancelHouseholdMember();
    }

    // Add and New convenience button. Adds the new Household Member to the list and prepares another new (empty) one
    public void addHouseholdMemberAndNew() {
        addHouseholdMember();
        newHouseholdMember();
    }

    // Saves the Household Member currently being edited
    public void saveHouseholdMember() {
        cancelHouseholdMember();
    }

    // Cancels the current Household Member edit
    public void cancelHouseholdMember() {
        currentHouseholdMember = null;
    }

    // Edits the selected existing Household Member
    public void editHouseholdMember() {
        if (selectedHouseholdMemberIdx != -1) {
            currentHouseholdMember = householdMembers[selectedHouseholdMemberIdx];
        }
    }

    // Delete the selected existing Household Member
    public void deleteHouseholdMember() {
        if (selectedHouseholdMemberIdx != -1) {
            householdMembers.remove(selectedHouseholdMemberIdx);
        }
    }
    
    // Creates a new Shortform Preference
    public void newShortFormPreference() {
        currentShortFormPreference = new ShortFormPreferenceWrapper(new Application_Preference__c());
        currentShortFormPreference.sfp.Application__c = app.Id;
        selectedListingPreference = '-1';
        selectedApplicationMember = '-1';
        selectedShortFormPreferenceIdx = -1;
    }

    // Adds the new Shortform Preference to the list. The currentShortformPreference is now null.
    public void addShortFormPreference() {
    	if (!String.isEmpty(currentShortFormPreference.sfp.LW_Type_of_proof__c)) {
			currentShortFormPreference.sfp.Type_of_proof__c = currentShortFormPreference.sfp.LW_Type_of_proof__c;
		}
				
        shortFormPreferences.add(currentShortFormPreference);
        shortFormPreferences.sort();
        cancelShortFormPreference();
    }

    // Add and New convenience button. Adds the new Shortform Preference to the list and prepares another new (empty) one
    public void addShortFormPreferenceAndNew() {
        addShortFormPreference();
        newShortFormPreference();
    }

    // Saves the Shortform Preference currently being edited
    public void saveShortFormPreference() {
    	if (!String.isEmpty(currentShortFormPreference.sfp.LW_Type_of_proof__c)) {
			currentShortFormPreference.sfp.Type_of_proof__c = currentShortFormPreference.sfp.LW_Type_of_proof__c;
		}
        cancelShortFormPreference();
    }

    // Cancels the current Shortform Preference
    public void cancelShortFormPreference() {
    	newShortFormPreference();
        currentShortFormPreference = null;
    }
    
    // Cancels the current Shortform Preference edit
    public void cancelEditShortFormPreference() {
    	if (backupSfp != null && currentShortFormPreference != null) {
    		system.debug('currentShortFormPreference:::' + currentShortFormPreference);
    		system.debug('currentShortFormPreference.sfp:::' + currentShortFormPreference.sfp);
    		system.debug('backupSfp:::' + backupSfp);
    		currentShortFormPreference.sfp = backupSfp.clone(true,true);
    	}
        currentShortFormPreference = null;
        cancelShortFormPreference();
    }
    
    // Refreshes the current Shortform Preference edit
    public void refreshShortFormPreference() {
        system.debug('currentShortFormPreference:::' + currentShortFormPreference);
        if (currentShortFormPreference != null && currentShortFormPreference.sfp != null) {
	    	currentShortFormPreference.sfp.Individual_preference__c = null;
	    	currentShortFormPreference.sfp.Type_of_proof__c = null;
        }
    }

    // Edits the selected existing Shortform Preference
    public void editShortFormPreference() {
    	system.debug('selectedShortFormPreferenceIdx:::' + selectedShortFormPreferenceIdx);
    	if (selectedShortFormPreferenceIdx != -1) {
            system.debug('shortFormPreferences:::' + shortFormPreferences);
    		currentShortFormPreference = shortFormPreferences[selectedShortFormPreferenceIdx];
    		backupSfp = currentShortFormPreference.sfp.clone(true,true);
            system.debug('currentShortFormPreference:::' + currentShortFormPreference);
            for (Integer i = 0; i < listingPrefs.size(); i++) {
                if (listingPrefs[i].Preference_Name__c == currentShortFormPreference.listingPrefName) {//on edit selectedListingPreference should be displayed into the list
            //for (SelectOption so : listingPreferenceSO) {
        	//	if (so.getLabel() == currentShortFormPreference.listingPrefName) {
        			selectedListingPreference = String.valueOf(i);//so.getValue();
        		}
        	}
    		system.debug('selectedListingPreference:::' + selectedListingPreference);
            //selectedListingPreference = String.valueOf(selectedShortFormPreferenceIdx);
            if (isNew == false) {
                selectedApplicationMember = preferenceFromHouseholdMemberId(currentShortFormPreference.sfp.Application_Member__c);
            } else {
                selectedApplicationMember = preferenceFromHouseholdMember(shortFormPreferences[selectedShortFormPreferenceIdx].personWhoClaimed);
            }
            system.debug('selectedApplicationMember:::' + selectedApplicationMember);
        }
    }

    // Delete the selected existing Shortform Preference
    public void deleteShortFormPreference() {
        if (selectedShortFormPreferenceIdx != -1) {
            shortFormPreferences.remove(selectedShortFormPreferenceIdx);
        }
        shortFormPreferences.sort();
    }
    
    // created this wrapper as some fields are formula fields and their values are available only after insert
    public class ShortFormPreferenceWrapper implements comparable {
    	public Application_Preference__c sfp { get; set; }
    	public String listingPrefName { get; set; }
        public String selectedAppMember { get; set; }
    	public String personWhoClaimed { get; set; }
        public String lotteryStatus { get; set; }
    	public Integer listingPrefOrder { get; set; }
    	public Integer prefOrder { get; set; }
    	public boolean receivesPreference { get; set; }
		
    	public ShortFormPreferenceWrapper(Application_Preference__c sfp) {
    		this.sfp = sfp;
    		this.listingPrefName = sfp.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(sfp.Id) ? existingAppPrefMap.get(sfp.Id).Preference_Name__c : '';
    		this.personWhoClaimed = sfp.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(sfp.Id) ? existingAppPrefMap.get(sfp.Id).Person_who_claimed_Name__c : '';
            this.lotteryStatus = sfp.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(sfp.Id) ? existingAppPrefMap.get(sfp.Id).Lottery_Status__c : '';
            this.receivesPreference = sfp.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(sfp.Id) ? existingAppPrefMap.get(sfp.Id).Receives_Preference__c : false;
            this.listingPrefOrder = sfp.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(sfp.Id) ? (Integer)existingAppPrefMap.get(sfp.Id).Preference_Order__c : 0;
            if (receivesPreference == true) {
				prefOrder = 0;//listingPrefOrder;
			} else {
				if (sfp.Opt_Out__c != true && sfp.Application_Member__c != null) {
					prefOrder = 1;//1000 + listingPrefOrder;
				} else if (sfp.Opt_Out__c == true) {
					prefOrder = 3;
				} else {
					prefOrder = 2;//2000 + listingPrefOrder;
				}
			}
        }
        
        public Integer compareTo(Object compareTo) {
			ShortFormPreferenceWrapper sfPref = (ShortFormPreferenceWrapper) compareTo;
			
			//if(this.prefOrder == null) {
			//	return 1;
			//}
			if(this.prefOrder < sfPref.prefOrder) {
				return -1;
			}
			if(this.prefOrder > sfPref.prefOrder) {
				return 1;
			}
			return 0;
		}
    }

}