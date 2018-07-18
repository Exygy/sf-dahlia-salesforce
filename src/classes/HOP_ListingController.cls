// *****************************************************************************
// CLASS: HOP_ListingController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_Listing page.
//
// *****************************************************************************

public with sharing class HOP_ListingController extends HOP_ControllerBase {

	// This will hold the current Listing currently being viewed
    public Listing__c lst {get; set;}
	
	// REMOVED
	public Boolean editMode {get; set;}
	
	// Variable that indicates whether any ApexPages Messages (errors) have been generated.
    public Boolean hasErrors {get; set;}
	
	// Most HOP pages support a retUrl parameter that enables "Back" navigation to the previous page.
    public String retUrl {get; set;}
	
	// The List of Listing Preference on the Listing record
	public List<Listing_Lottery_Preference__c> listingPreferences {get; set;}
	
	// Helper method that queries a List of Preference by their application record Id
	private static List<Listing_Lottery_Preference__c> getPreferencesByListingId(String paramListingId) {
		return [
			SELECT Id,Preference_Name__c, Description__c, PDF_URL__c, Order__c, Available_Units__c
			FROM Listing_Lottery_Preference__c
			WHERE Listing__c = :paramListingId
			order by Order__c, Name
		];
	}
	
	// Helper method that queries a Listing__c record by its Id
	private static Listing__c getListingById(String paramListingId) {
		List<Listing__c> listings = [
			SELECT
				Id, OwnerId, Owner.Name, Application_Due_Date__c, Name, Status__c, Building__c, Building__r.Name, Min_BR__c, Lottery_Winners__c,
				Max_BR__c, Lottery_Results__c, Min_Income__c, Account__c, Account__r.Name, Max_Income__c, 
				Min_Occupancy__c, Max_Occupancy__c, Building_Name__c, Neighborhood__c, Building_Street_Address__c, Developer__c, Building_City__c,
				Building_URL__c, Building_State__c, Year_Built__c, Building_Zip_Code__c, Description__c, Lottery_Preferences__c, Accessibility__c,
				Fee__c, Amenities__c, Deposit_Min__c, Costs_Not_Included__c, Deposit_Max__c, Lottery_Date__c, Lottery_Results_Date__c,
				Lottery_Venue__c, Lottery_Summary__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_URL__c, Draw_ID__c,
				AMI_Percentage__c, Application_Phone__c, Application_Organization__c, Application_Street_Address__c, 
				Application_City__c, Download_URL__c, Application_State__c, Application_Postal_Code__c,
				Number_of_Applications__c, nSubmitted_Applications__c,
				Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c,
				Legal_Disclaimers__c, Building_Selection_Criteria__c, Pet_Policy__c, Required_Documents__c, Smoking_Policy__c,
				Eviction_History__c, Criminal_History__c, Credit_Rating__c, Lottery_Status__c, Office_Hours__c
			FROM Listing__c
			WHERE Id = :paramListingId
		];

		if (listings.size() == 0) {
			return null;
		} else {
			return listings[0];
		}
	}

	public HOP_ListingController() {
		super();
		editMode = false;
		hasErrors = false;
		retUrl = ApexPages.currentPage().getParameters().get('retUrl');

		// The page expects a Listing Id parameter. If not provided, display an error.
        String paramListingId = ApexPages.currentPage().getParameters().get('id');
		if (String.isBlank(paramListingId)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_ID_NOT_PROVIDED));
            hasErrors = true;
            return;
		}

		// Check to see if a Listing record with the provided Id exists. If not, display an error.
		lst = getListingById(paramListingId);
		if (lst == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_LISTING_NOT_FOUND));
			hasErrors = true;
			return;
		}

		// Community users cannot access Listings associated with an Account other than their own.
        if (myUser.Profile.UserLicense.Name == HOP_Constants.COMMUNITY_LICENSE_NAME && lst.Account__c != myUser.Contact.AccountId) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_NO_ACCESS));
			hasErrors = true;
			return;
		}
		
		listingPreferences = getPreferencesByListingId(paramListingId);
	}

	// REMOVED
	public void saveListing() {
		upsert lst;
		editMode = false;
		lst = getListingById(lst.Id);
	}

}