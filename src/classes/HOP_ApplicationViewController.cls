// *****************************************************************************
// CLASS: HOP_ApplicationViewController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_ApplicationView page.
//
// *****************************************************************************

public with sharing class HOP_ApplicationViewController extends HOP_ControllerBase {

	// This will hold the current Application currently being viewed
	public Application__c app {get; set;}

	// This will hold the current Listing tied to the Application currently being viewed
	public Listing__c listing {get; set;}

	// The Primary Applicant on the Application
	public Application_Member__c primaryApplicant {get; set;}

	// The Alternate Contact on the Application
	public Application_Member__c alternateContact {get; set;}

	// The List of Application Preference on the Application record
	public List<ApplicationPreference> appPreferences {get; set;}

	// Variable that indicates whether any ApexPages Messages (errors) have been generated.
	public Boolean hasErrors {get; set;}

	// The List of Attachments on the Application record
	public List<Attachment> attachments {get; set;}

	// The Map <ParentId, Attachment> on the Application Preference record
	public Map<Id,Attachment> attachmentsMap {get; set;}


	// A String beginning and ending in quotes and containing a comma separated list
	// of all the Flagged Record Sets this Application is a Flagged Application on
	public String flaggedRecordSetString {get; set;}

	// Most HOP pages support a retUrl parameter that enables "Back" navigation to the previous page.
	public String retUrl {get; set;}

	// True if "Reserve type" on any units attached to the listing = "developmental disabilities"
	public Boolean hasDevelopmentalDisabilitiesUnits { get; set; }

	// True if "Reserve type" on any units attached to the listing = "veterans"
	public Boolean hasVeteransUnits { get; set; }

	public String currentRecId { get; set; }

	// Helper method that queries a List of Attachments by their parent record Id
	private static List<Attachment> getAttachmentsByParent(String parentId) {
		return [
			SELECT Id, Name, BodyLength
			FROM Attachment
			WHERE ParentId = :parentId
		];
	}

	// Helper method that get a Map of Attachments by their parent record Id
	private static Map<Id,Attachment> getAttachmentMapByParent(Set<Id> customAttachmentIds) {
		Map<Id,Attachment> attachmentsMap = new Map<Id,Attachment>();

		List<Attachment> attList = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :customAttachmentIds];
		for (Attachment att : attList) {
			attachmentsMap.put(att.ParentId,att);
		}

		return attachmentsMap;
	}

	// Helper method that queries a Listing record by its Id
	private static Listing__c getListingById(String paramListingId) {
		List<Listing__c> listings = [
			SELECT
				Id, Name,
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

	// Helper method that queries an Application__c record by its Id
	private static Application__c getApplicationById(String paramApplicationId) {
		List<Application__c> applications = [
			SELECT
				Id, Name, Applicant__c, Alternate_Contact__c, Listing__c, Listing__r.Name, Listing__r.Account__c, Status__c,
				Listing__r.Reserved_community_type__c,
				Total_Household_Size__c, Application_Submission_Type__c, Application_Submitted_Date__c, CreatedBy.Name,
				Annual_Income__c, Monthly_Income__c, Is_Lottery_Complete__c, Housing_Voucher_or_Subsidy__c, Referral_Source__c,
				Application_Language__c,
				Lottery_Rank__c,
				Lottery_Number_Manual__c, Lottery_Number__c, Total_Monthly_Rent__c, General_Lottery__c, General_Lottery_Rank__c,
				Answered_Community_Screening__c, Has_Military_Service__c, Has_DevelopmentalDisability__c, Has_ADA_Priorities_Selected__c
			FROM Application__c
			WHERE Id = :paramApplicationId
		];

		if (applications.size() == 0) {
			return null;
		} else {
			return applications[0];
		}
	}

	// Helper method that queries an Application_Member__c record by its Id
	private static Application_Member__c getApplicantById(String applicantId) {
		List<Application_Member__c> applicants = [
			SELECT
				Name__c, Date_of_Birth__c, Phone_Type__c, Phone__c, Second_Phone_Type__c, Second_Phone__c, Email__c,
				Primary_Language__c, Residence_Address__c, Mailing_Address__c, Agency_Name__c,
				Alternate_Contact_Type__c, Alternate_Contact_Type_Other__c
			FROM Application_Member__c
			WHERE Id = :applicantId
		];

		if (applicants.size() == 0) {
			return null;
		} else {
			return applicants[0];
		}
	}

	// Helper method that queries a List of Preference by their application record Id
	private static List<Application_Preference__c> getPreferencesByAppId(String appId) {
		return [
			SELECT Id, Name, RecordType.DeveloperName, Preference_Name__c, Person_who_claimed_Name__c, Type_of_proof__c, Opt_Out__c, Individual_preference__c,
				Lottery_Status__c, Preference_Lottery_Rank__c, Receives_Preference__c, Application_Member__c, Preference_Order__c, Certificate_Number__c, 
				(SELECT Id, Name FROM Custom_Attachments__r)
			FROM Application_Preference__c
			WHERE Application__c = :appId
			order by /*Listing_Preference_ID__r.Order__c, Name*/Listing_Preference_ID__r.Name
		];
	}



	public HOP_ApplicationViewController() {
		super();
		hasErrors = false;
		attachments = new List<Attachment>();
		retUrl = ApexPages.currentPage().getParameters().get('retUrl');

		// The page expects an Application Id parameter. If not provided, display an error.
		String paramApplicationId = ApexPages.currentPage().getParameters().get('id');
		if (String.isBlank(paramApplicationId)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_ID_NOT_PROVIDED));
			hasErrors = true;
			return;
		}

		// Check to see if an Application record with the provided Id exists. If not, display an error.
		app = getApplicationById(paramApplicationId);
		if (app == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_APPLICATION_NOT_FOUND));
			hasErrors = true;
			return;
		}

		listing = getListingById(app.Listing__c);

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

		// Community users cannot edit Draft Applications, or Applications associated with an Account other than their own.
		if (myUser.Profile.UserLicense.Name == HOP_Constants.COMMUNITY_LICENSE_NAME &&
			(app.Listing__r.Account__c != myUser.Contact.AccountId || app.Status__c == HOP_Constants.DRAFT_APPLICATION)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_NO_ACCESS));
			hasErrors = true;
			return;
		}

		// Load the Primary Applicant and Alternate Contact into their corresponding variables.
		if (app.Applicant__c != null) {
			primaryApplicant = getApplicantById(app.Applicant__c);
		}
		if (app.Alternate_Contact__c != null) {
			alternateContact = getApplicantById(app.Alternate_Contact__c);
		}

		//Load Application Preferences on the Application record
		List<Application_Preference__c> appPrefs = getPreferencesByAppId(app.Id);
		appPreferences = new List<ApplicationPreference>();
		Set<Id> customAttachmentIds = new Set<Id>();
		for (Application_Preference__c appPref : appPrefs) {
			for (Attachment__c att : appPref.Custom_Attachments__r) {
				customAttachmentIds.add(att.Id);
			}
			appPreferences.add(new ApplicationPreference(appPref));
		}
		appPreferences.sort();

		// Load the Attachments Map on for Application Preference record
		attachmentsMap = getAttachmentMapByParent(customAttachmentIds);

		// Load the Attachments on the Application record
		attachments = getAttachmentsByParent(app.Id);

		// Check to see if there are any Flagged Record Sets this Application is a Flagged Application on
		List<String> flaggedRecordSetList = new List<String>();
		for (Flagged_Application__c flaggedApplication : [SELECT Flagged_Record_Set__c FROM Flagged_Application__c WHERE Application__c = :app.Id]) {
			flaggedRecordSetList.add('\'' + flaggedApplication.Flagged_Record_Set__c + '\'');
		}

		// Builds a comma separated string with all the Flagged Record Sets' Ids (or a pair of single quotes if none exist.)
		flaggedRecordSetString = flaggedRecordSetList.size() > 0 ? String.join(flaggedRecordSetList, ',') : '\'\'';
	}

	public void toggleDetails() {
		for (ApplicationPreference appPreference : appPreferences) {
			if (appPreference.appPref.Id == currentRecId) {
				appPreference.viewDetails = !appPreference.viewDetails;
			}
		}
	}

	public class ApplicationPreference  implements comparable {

		public Application_Preference__c appPref { get; set; }
		public Integer prefOrder { get; set; }
		public boolean hasAttachment { get; set; }
		public boolean viewDetails { get; set; }

		public Boolean showHHMember {
	        get {
	            return HOP_ApplicationFormController.showHHMemberPreferences.contains(appPref.RecordType.DeveloperName);
	        }
	    }

	    public Boolean showIndividualPreference {
	        get {
	            return HOP_ApplicationFormController.showIndividualPreferences.contains(appPref.RecordType.DeveloperName);
	        }
	    }

	    public Boolean showTypeOfProof {
	        get {
	            return HOP_ApplicationFormController.showTypeOfProofPreferences.contains(appPref.RecordType.DeveloperName);
	        }
	    }

	    public Boolean showCOPHolder {
	        get {
	            return HOP_ApplicationFormController.showCOPHolderPreferences.contains(appPref.RecordType.DeveloperName);
	        }
	    }

	    public Boolean showDTHP {
	        get {
	            return HOP_ApplicationFormController.showDTHPPreferences.contains(appPref.RecordType.DeveloperName);
	        }
	    }

	    public Boolean showAntiDTHP {
	        get {
	            return appPref.RecordType.DeveloperName == API_Application.ADHP_RT_DEVELOPER_NAME;
	        }
	    }

	    public Boolean showNRHP {
	        get {
	            return appPref.RecordType.DeveloperName == API_Application.NRHP_RT_DEVELOPER_NAME;
	        }
	    }

	    public Boolean showLiveWork {
	        get {
	            return appPref.RecordType.DeveloperName == API_Application.L_W_RT_DEVELOPER_NAME;
	        }
	    }

	    public Boolean showRentBurden {
	        get {
	            return appPref.RecordType.DeveloperName == API_Application.RB_AHP_RT_DEVELOPER_NAME;
	        }
	    }
	    
	    public Boolean showPersonWhoClaimed {
	        get {
	            return !HOP_ApplicationFormController.showPersonWhoClaimedPreferences.contains(appPref.RecordType.DeveloperName);
	        }
	    }

		public ApplicationPreference(Application_Preference__c appPref) {
			this.appPref = appPref;
			this.viewDetails = false;
			this.hasAttachment = appPref.Custom_Attachments__r != null && appPref.Custom_Attachments__r.size() > 0;
			if (appPref.Receives_Preference__c == true) {
				prefOrder = 0;//(Integer)appPref.Preference_Order__c;
			} else {
				if (appPref.Opt_Out__c != true && appPref.Application_Member__c != null) {
					prefOrder = 1;//1000 + (Integer)appPref.Preference_Order__c;
				} else if (appPref.Opt_Out__c == true) {
					prefOrder = 3;
				} else {
					prefOrder = 2;//2000 + (Integer)appPref.Preference_Order__c;
				}
			}
		}

		public Integer compareTo(Object compareTo) {
			ApplicationPreference appPref = (ApplicationPreference) compareTo;

			//if(this.prefOrder == null) {
			//	return 1;
			//}
			if(this.prefOrder < appPref.prefOrder) {
				return -1;
			}
			if(this.prefOrder > appPref.prefOrder) {
				return 1;
			}
			return 0;
		}
	}

}