// *****************************************************************************
// CLASS: API_LeaseUp_Application
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Class that holds ShortForm and Person data models.
//
// *****************************************************************************

global without sharing class API_LeaseUp_Application {
	//appmember types
	public static final String PRIMARY_APPLICANT = 'Primary Applicant';
	public static final String ALTERNATE_CONTACT = 'Alternate Contact';
	private static final String HOUSEHOLD_MEMBER = 'Household Member';
	private static final integer InsertRetry = Integer.valueOf(Label.INSERT_RETRY_NUMBER);
	private static final String CONTACT_APPLICANT_RT_DEVELOPER_NAME = 'Applicant';
	private static final String ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME = 'Household';
	private static final String BMR_RT_DEVELOPER_NAME = 'Rental_Short_Form';
	//private static final String MULTI_RT_DEVELOPER_NAME = 'Multi_Family_Rental_Short_Form';

	//application preference record types
	public static final String ADHP_RT_DEVELOPER_NAME = 'ADHP';
	public static final String COP_RT_DEVELOPER_NAME = 'COP';
	public static final String CUSTOM_RT_DEVELOPER_NAME = 'Custom';
	public static final String DTHP_RT_DEVELOPER_NAME = 'DTHP';
	public static final String L_W_RT_DEVELOPER_NAME = 'L_W';
	public static final String NRHP_RT_DEVELOPER_NAME = 'NRHP';
	public static final String RB_AHP_RT_DEVELOPER_NAME = 'RB_AHP';
	public static final String AG_RT_DEVELOPER_NAME = 'AG';
	
	private static final ID APPLICATION_BMR_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application__c',BMR_RT_DEVELOPER_NAME);
	//private static final ID APPLICATION_MULTI_RT_ID =  RecordTypeUtil.getRecordTypeIDByDevName('Application__c',MULTI_RT_DEVELOPER_NAME);
	private static final ID CONTACT_APPLICANT_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Contact',CONTACT_APPLICANT_RT_DEVELOPER_NAME);
	private static final ID ACCOUNT_HOUSEHOLD_RT_ID =  RecordTypeUtil.getRecordTypeIDByDevName('Account',ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME);

	//application preference record type ids
	private static final ID APP_PREF_ADHP_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',ADHP_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_COP_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',COP_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_CUSTOM_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',CUSTOM_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_DTHP_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',DTHP_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_L_W_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',L_W_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_NRHP_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',NRHP_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_RB_AHP_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',RB_AHP_RT_DEVELOPER_NAME);
	private static final ID APP_PREF_AG_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c',AG_RT_DEVELOPER_NAME);
	
	public static final Map<String,String> APP_PREF_RT_DEVNAME_TO_ID = new Map<String,String> {
																			ADHP_RT_DEVELOPER_NAME => APP_PREF_ADHP_RT_ID,
																			COP_RT_DEVELOPER_NAME => APP_PREF_COP_RT_ID,
																			CUSTOM_RT_DEVELOPER_NAME => APP_PREF_CUSTOM_RT_ID,
																			DTHP_RT_DEVELOPER_NAME => APP_PREF_DTHP_RT_ID,
																			L_W_RT_DEVELOPER_NAME => APP_PREF_L_W_RT_ID,
																			NRHP_RT_DEVELOPER_NAME => APP_PREF_NRHP_RT_ID,
																			RB_AHP_RT_DEVELOPER_NAME => APP_PREF_RB_AHP_RT_ID,
																			AG_RT_DEVELOPER_NAME => APP_PREF_AG_RT_ID
																		};

	public static final Map<String,String> APP_PREF_RT_ID_TO_DEVNAME = new Map<String,String> {
																			APP_PREF_ADHP_RT_ID => ADHP_RT_DEVELOPER_NAME,
																			APP_PREF_COP_RT_ID => COP_RT_DEVELOPER_NAME,
																			APP_PREF_CUSTOM_RT_ID => CUSTOM_RT_DEVELOPER_NAME,
																			APP_PREF_DTHP_RT_ID => DTHP_RT_DEVELOPER_NAME,
																			APP_PREF_L_W_RT_ID => L_W_RT_DEVELOPER_NAME,
																			APP_PREF_NRHP_RT_ID => NRHP_RT_DEVELOPER_NAME,
																			APP_PREF_RB_AHP_RT_ID => RB_AHP_RT_DEVELOPER_NAME,
																			APP_PREF_AG_RT_ID => AG_RT_DEVELOPER_NAME
																		};

	private static boolean isNullorBlank(String value) {
		return (value == null || value.length() == 0) ? true: false;
	}
	/* this is how you would stub out a new form/and/or short form
	global class Multi_ShortForm extends ShortForm {
		global String prioritiesSelected;
		global String qualifyingDevelopmentalDisability;
		global String qualifyingRentBurdenHUD;
		global String qualifyingServedInMilitary;
		global String totalMonthlyRent;
		global Person primaryApplicant;
		global Multi_ShortForm(Application__c app, List<Application_Member__c> hms) {
			super(app,hms);
	//		this.qualifyingDevelopmentalDisability=app.Qualifying_Developmental_Disability__c;
			system.debug('this will never get called');
		}
		global override Application__c toApplication() {
			Application__c app = super.toApplication();
		//	app.Qualifying_Developmental_Disability__c=  this.qualifyingDevelopmentalDisability;
			return app;
		}
	} */

	global static ShortForm newShortForm(Application__c app,List<Application_Member__c> hms){
		ShortForm theForm;
		if (app.recordTypeID== APPLICATION_BMR_RT_ID){
			theForm = new ShortForm(app,hms);
			return theForm;

		}
		/*
		if (app.recordTypeID== APPLICATION_MULTI_RT_ID){
			theForm = new Multi_ShortForm(app,hms);
			return theForm;

		}*/
		return null;
	}

	global static API_LeaseUp_Application.ShortForm newShortForm(String jsonForm){ 
        API_LeaseUp_Application.ShortForm shortForm = (API_LeaseUp_Application.ShortForm)JSON.deserialize(jsonForm, API_LeaseUp_Application.ShortForm.class);
		/*	if (shortForm.appRTType == MULTI_RT_DEVELOPER_NAME ) {
		shortForm = (API_LeaseUp_Application.ShortForm)JSON.deserialize(jsonForm, API_LeaseUp_Application.Multi_ShortForm.class);

		}else if sf.appRTType == MULTI_RT_DEVELOPER_NAME 
			ShortForm shortForm = (ShortForm)JSON.deserialize(JSON, ShortForm.class);
			we do not write this out as bmr is the default shortform
		*/
		return shortForm;
	}
	// the default form is the bmr short form or - just "short form"  all others are derivatives
	global virtual class ShortForm {
		global String appRTType;
		global String id;
		global String name;
		global ID listingID;
		global Person primaryApplicant;
		global Person alternateContact;
		global List<Person> householdMembers;
		global List<ShortFormPreference> shortFormPreferences;
		global String referral;
		global Boolean agreeToTerms;
		global String householdVouchersSubsidies;
		global Decimal annualIncome;
		global Decimal monthlyIncome;
		global Decimal totalMonthlyRent;
		global String status;
		global String applicationLanguage;
		global String applicationSubmissionType;
		global Date applicationSubmittedDate;
		global String lotteryNumber;
		global String lotteryNumberManual;
		global String formMetadata;
		global String adaPrioritiesSelected;
		global String hasPublicHousing;
		global String hasMilitaryService;
		global String hasDevelopmentalDisability;
		global String answeredCommunityScreening;
		global Decimal householdAssets;
		global String processingStatus;
		global Decimal HHTotalIncomeWithAssets;
		global String externalSessionId;
		global Decimal numberOfDependents;
		global String snapshotId;
		global String didApplicantUseHousingCounselingAgency;
		global String whichOne;
        global String other;
		global String hasSenior;
		
		global ShortForm() {}

		global ShortForm(Application__c app, List<Application_Member__c> hms) {
			this.id = app.Id;
			this.name = app.Name;
			this.listingID =  app.Listing__c;
			if (app.recordTypeID == APPLICATION_BMR_RT_ID) {
				appRTType = BMR_RT_DEVELOPER_NAME;
			}

			this.primaryApplicant = app.Applicant__r == null ? null : new Person(app.Applicant__r);
			this.alternateContact = app.Alternate_Contact__r == null ? null : new Person(app.Alternate_Contact__r);
			this.householdMembers = new List<Person>();
			if (hms != null) {
				for (Application_Member__c am : hms) {
					if (am.Type__c != PRIMARY_APPLICANT && am.Type__c != ALTERNATE_CONTACT) {
						this.householdMembers.add(new Person(am));
					}
				}
			}
			this.shortFormPreferences = new List<ShortFormPreference>();
			if (app.Application_Preferences__r != null) {
				for (Application_Preference__c appPref : app.Application_Preferences__r) {
					this.shortFormPreferences.add(new ShortFormPreference(appPref));
				}
			}
			//this.worksInSanFrancisco = app.Work_in_SF_Preference__c;
			this.referral = app.Referral_Source__c;
			this.agreeToTerms = app.Terms_Acknowledged__c;
			this.householdVouchersSubsidies = app.Housing_Voucher_or_Subsidy__c;
			this.annualIncome = app.Annual_Income__c;
			this.monthlyIncome = app.Monthly_Income__c;
			this.totalMonthlyRent = app.Total_Monthly_Rent__c;
            this.externalSessionId = app.Third_Party_External_ID__c != null ?  app.Third_Party_External_ID__c : '';
			this.status = app.Status__c;
			this.applicationLanguage = app.Application_Language__c;
			this.applicationSubmissionType = app.Application_Submission_Type__c;
			this.applicationSubmittedDate = app.Application_Submitted_Date__c;
			this.lotteryNumber = app.Lottery_Number__c;
			this.lotteryNumberManual = app.Lottery_Number_Manual__c;
			this.formMetadata = app.Form_Metadata__c;
			this.adaPrioritiesSelected = app.Has_ADA_Priorities_Selected__c;
			this.hasPublicHousing = app.Has_Rent_Burden_HUD__c;
			this.hasMilitaryService = app.Has_Military_Service__c;
			this.hasDevelopmentalDisability = app.Has_DevelopmentalDisability__c;
			this.answeredCommunityScreening = app.Answered_Community_Screening__c;
			this.householdAssets = app.Household_Assets__c;
			this.processingStatus = app.Processing_Status__c;
			this.HHTotalIncomeWithAssets = app.HH_Total_Income_with_Assets_Annual__c;
			this.numberOfDependents = app.Number_of_Dependents__c;
			this.snapshotId = app.Snapshot_ID__c;
			this.didApplicantUseHousingCounselingAgency = app.Applicant_used_housing_counseling_agency__c;
			this.whichOne = app.Which_One__c;
			this.other = app.Other__c;
			this.hasSenior = app.Reserved_Senior__c;
		}
		
		global ShortForm(ShortForm_Application__b app, List<Person__b> hms, List<ShortForm_Preference__b> appPrefs) {
			this.id = app.Application__c;
			this.appRTType = app.Application_Record_Type__c;
			this.name = app.Name__c;
			this.listingID =  app.Listing_ID__c;
			//app.Applicant__c = this.primaryApplicant == null ? null : this.primaryApplicant.appMemberId;
			//app.Alternate_Contact__c = this.alternateContact == null ? null : this.alternateContact.appMemberId;
			
			//this.primaryApplicant = app.Applicant__r == null ? null : new PersonBig(app.Applicant__r);
			//this.alternateContact = app.Alternate_Contact__r == null ? null : new PersonBig(app.Alternate_Contact__r);
			this.householdMembers = new List<Person>();
			for (Person__b am : hms) {
				if (am.Application_Member_Type__c == PRIMARY_APPLICANT) {
					this.primaryApplicant = new Person(am);
				} else if (am.Application_Member_Type__c == ALTERNATE_CONTACT) {
					this.alternateContact = new Person(am);
				} else if (am.Application_Member_Type__c != PRIMARY_APPLICANT && am.Application_Member_Type__c != ALTERNATE_CONTACT) {
					this.householdMembers.add(new Person(am));
				}
			}
			this.shortFormPreferences = new List<ShortFormPreference>();
			if (appPrefs != null) {
				for (ShortForm_Preference__b appPref : appPrefs) {
					this.shortFormPreferences.add(new ShortFormPreference(appPref));
				}
			}
			
			
			this.referral = app.Referral__c;
			this.agreeToTerms = app.Agree_To_Terms__c != null ? boolean.valueOf(app.Agree_To_Terms__c) : false;
			this.householdVouchersSubsidies = app.Household_Vouchers_Subsidies__c;
			//app.Rental_Assistance__c = this.householdVouchersSubsidies;
			this.annualIncome = app.Annual_Income__c;
			this.monthlyIncome = app.Monthly_Income__c;
			this.totalMonthlyRent = app.Total_Monthly_Rent__c;
			this.status = app.Status__c;
			this.applicationLanguage = app.Application_Language__c;
			this.applicationSubmissionType = app.Application_Submission_Type__c;
			this.applicationSubmittedDate = app.Application_Submission_Date__c != null ? date.valueOf(app.Application_Submission_Date__c) : null;
			this.formMetadata = app.Form_Metadata__c;
			this.lotteryNumber = app.Lottery_Number__c;
			this.lotteryNumberManual = app.Lottery_Number_Manual__c;
			this.adaPrioritiesSelected = app.ADA_Priorities_Selected__c;
			//app.Has_Rent_Burden_HUD__c = this.hasPublicHousing;
			this.hasMilitaryService = app.Has_Military_Service__c;
			this.hasDevelopmentalDisability = app.Has_Developmental_Disabilities__c;
			this.answeredCommunityScreening = app.Answered_Community_Screening__c;
			this.externalSessionId = app.External_Session_Id__c;
			this.householdAssets = app.Household_Assets__c;
			this.HHTotalIncomeWithAssets = app.Household_Total_Income_With_Assets__c;
			this.numberOfDependents = app.Number_Of_Dependents__c;
			this.hasPublicHousing = app.Has_Public_Housing__c;
			this.processingStatus = app.Processing_Status__c;
			this.snapshotId = app.Snapshot_ID__c;
			this.whichOne = app.Which_One__c;
			this.other = app.Other__c;
			this.hasSenior = app.Reserved_Senior__c;
		}

		global virtual Application__c toApplication() {
			Application__c app = new Application__c(Listing__c = this.listingID);
			app.Id = this.id;
			app.Applicant__c = this.primaryApplicant == null ? null : this.primaryApplicant.appMemberId;
			app.Alternate_Contact__c = this.alternateContact == null ? null : this.alternateContact.appMemberId;
			app.Referral_Source__c = this.referral;
			app.Terms_Acknowledged__c = (this.agreeToTerms == null ? false : this.agreeToTerms);
			app.Housing_Voucher_or_Subsidy__c = this.householdVouchersSubsidies;// == null ? false : this.householdVouchersSubsidies);
			app.Annual_Income__c = this.annualIncome;
			app.Monthly_Income__c = this.monthlyIncome;
			if (Schema.SObjectType.Application__c.fields.getMap().get('Total_Monthly_Rent__c').getDescribe().isUpdateable()) {
				app.Total_Monthly_Rent__c = this.totalMonthlyRent;
			}
			app.Status__c = this.status;
			app.Application_Language__c = this.applicationLanguage;
			app.Application_Submission_Type__c = this.applicationSubmissionType;
			app.Application_Submitted_Date__c = this.applicationSubmittedDate;
			app.Form_Metadata__c = this.formMetadata;
			app.Lottery_Number_Manual__c = this.lotteryNumberManual;
			app.Has_ADA_Priorities_Selected__c = this.adaPrioritiesSelected;
			app.Has_Rent_Burden_HUD__c = this.hasPublicHousing;
			app.Has_Military_Service__c = this.hasMilitaryService;
			app.Has_DevelopmentalDisability__c = this.hasDevelopmentalDisability;
			app.Answered_Community_Screening__c = this.answeredCommunityScreening;
			app.Third_Party_External_ID__c = this.externalSessionId;
			app.Household_Assets__c = this.householdAssets;
			app.HH_Total_Income_with_Assets_Annual__c = this.HHTotalIncomeWithAssets;
			app.Number_of_Dependents__c = this.numberOfDependents;
			app.Snapshot_ID__c = this.snapshotId;
			app.Applicant_used_housing_counseling_agency__c = this.didApplicantUseHousingCounselingAgency;
    		app.Which_One__c = this.whichOne;
    		app.Other__c = this.other;
			app.Reserved_Senior__c = this.hasSenior;
			return app;
		}
		
		global virtual ShortForm_Application__b toApplicationBig() {
			ShortForm_Application__b app = new ShortForm_Application__b(Listing_ID__c = this.listingID);
			app.Application__c = this.id;
			app.Application_Record_Type__c = this.appRTType;
			app.Name__c = this.name;
			//app.Applicant__c = this.primaryApplicant == null ? null : this.primaryApplicant.appMemberId;
			//app.Alternate_Contact__c = this.alternateContact == null ? null : this.alternateContact.appMemberId;
			app.Referral__c = this.referral;
			app.Agree_To_Terms__c = (this.agreeToTerms == null ? false : this.agreeToTerms) + '';
			app.Household_Vouchers_Subsidies__c = this.householdVouchersSubsidies;// == null ? false : this.householdVouchersSubsidies);
			//app.Rental_Assistance__c = this.householdVouchersSubsidies;
			app.Annual_Income__c = this.annualIncome;
			app.Monthly_Income__c = this.monthlyIncome;
			app.Total_Monthly_Rent__c = this.totalMonthlyRent;
			app.Status__c = this.status;
			app.Application_Language__c = this.applicationLanguage;
			app.Application_Submission_Type__c = this.applicationSubmissionType;
			app.Application_Submission_Date__c = this.applicationSubmittedDate;
			app.Form_Metadata__c = this.formMetadata;
			app.Lottery_Number__c = this.lotteryNumber;
			app.Lottery_Number_Manual__c = this.lotteryNumberManual;
			app.ADA_Priorities_Selected__c = this.adaPrioritiesSelected;
			//app.Has_Rent_Burden_HUD__c = this.hasPublicHousing;
			app.Has_Military_Service__c = this.hasMilitaryService;
			app.Has_Developmental_Disabilities__c = this.hasDevelopmentalDisability;
			app.Answered_Community_Screening__c = this.answeredCommunityScreening;
			app.External_Session_Id__c = this.externalSessionId;
			app.Household_Assets__c = this.householdAssets;
			app.Household_Total_Income_With_Assets__c = this.HHTotalIncomeWithAssets;
			app.Number_Of_Dependents__c = this.numberOfDependents;
			app.Has_Public_Housing__c = this.hasPublicHousing;
			app.Processing_Status__c = this.processingStatus;
			app.Snapshot_ID__c = this.id;
			app.Housing_Counselling_Agency__c = this.didApplicantUseHousingCounselingAgency;
    		app.Which_One__c = this.whichOne;
    		app.Other__c = this.other;
    		app.Reserved_Senior__c = this.hasSenior;
			return app;
		}

		global void validate() {
			if (this.id == null) {
				validateLotteryRun();
			}

			if (primaryApplicant == null) {
				throw new IncompleteApplicationException ();
			}
			this.primaryApplicant.validate();
			if (householdMembers != null) {
				for (Person householdMember : householdMembers)
				{
					householdMember.validate();
				}
			}
		}

		global void validateLotteryRun() {
			Integer timeoutlooplimit = integer.valueOf(label.INSERT_RETRY_TIMEOUT);
			//20171026_Vertiba: Updated code to try the upsert 5 times in case the Record Currently Unavailable error comes


	        for(Integer i=0;i<=InsertRetry;i++)
	        {
		        System.debug('******** Try Number ' + i);
		        try
		        {
                    System.debug('******** this.listingID ' + this.listingID);
					System.debug('******** label.FOR_UPDATE_QUERY_CLAUSE ' + label.FOR_UPDATE_QUERY_CLAUSE);
					List<Listing__c> currentListing = ListingService.getListingByID(this.listingID,label.FOR_UPDATE_QUERY_CLAUSE);
					if (currentListing[0].Lottery_Status__c == 'In Progress' || currentListing[0].Lottery_Status__c == 'Lottery Complete')
					{
						throw new LotteryAlreadyRunException ();
					}
					break;
		        }
		        catch(Exception ex)
		        {
		        	System.debug('********Exception in Listing Query' + ex.getMessage());
		        	if(i > 0)
		        		timeoutlooplimit = timeoutlooplimit/10;
		        	//20171026_Vertiba: Setting an Interval by runing a loop 100 times
		        	if(i<InsertRetry-1)
		        	{
			        	for(Integer j=0;j<timeoutlooplimit;j++)
			        	{

			        	}
		        	}
		        	else
		        		throw new API_LeaseUp_ApplicationService.RecordLockException(ex.getMessage());	
		        	continue;
		        }
    		}
		}
	}

	global class IncompleteApplicationException extends Exception {}
	global class LotteryAlreadyRunException extends Exception {}
	global class ListingPreferenceMissingException extends Exception {}
	global class RecordTypeMissingException extends Exception {}


	global class Person {
		global String webAppID;
		//global String webAppIDSource;
		global String appMemberId;
		global String applicationId;
		global String contactId;
		global String firstName;
		global String lastName;
		global String middleName;
		global Date DOB;
		global String email;
		global String phone;
		global String phoneType;
		global String alternatePhone;
		global String alternatePhoneType;
		global String address;
		global String city;
		global String state;
		global String zip;
		global String mailingAddress;
		global String mailingCity;
		global String mailingState;
		global String mailingZip;
		global String workInSf;
		global String gender;
		global String genderOther;
		global String sexualOrientation;
		global String sexualOrientationOther;
		global Boolean hiv;
		global String ethnicity;
		global String race;
        global String sexAtBirth;
		global String language;
		global String languageOther;
		global String relationship;
		global String alternateContactType;
		global String agency;
		global String appMemberType; //maps to household member type
		global String alternateContactTypeOther;
		global String hasSameAddressAsApplicant;
		global String preferenceAddressMatch;
		global Boolean noPhone;
		global Boolean noEmail;
		global Boolean noAddress;
		global Boolean hasAltMailingAddress;
		global String xCoordinate;
		global String yCoordinate;
		global String whichComponentOfLocatorWasUsed;
		global Decimal candidateScore;
		global String nickname;
		global String maritalStatus;

		private String parseDate(Date inputDate) {
			if (inputDate != null) {
				Time myTime = Time.newInstance(0, 0, 0, 0);
				Date today =inputDate;
				Datetime tempDateTime = datetime.newInstance(today, myTime);
				String prettyDate = tempDateTime.format('yyyy-MM-dd');
				system.debug(prettyDate);
				return prettyDate;
				/*Integer m = inputDate.month();
				Integer d = inputDate.day();
				Integer y = inputDate.year();
				return y + '-' + m + '-' + d;*/
			}
			return '';
		}

		global void validate() {
			if (isNullorBlank(this.firstName) || isNullorBlank(this.lastName) || (DOB == null) ) {
				throw new IncompleteApplicationException();
			}
		}

		global String getKey() {
			if (this.firstName != null && this.lastName != null && this.DOB!=null) {
				return this.firstName.toLowerCase() + ',' + this.lastName.toLowerCase() + ',' + this.parseDate(this.dob);
			}
			else return null;
		}

		global Person() {}


		global Person(Contact c) {
			this.contactId = c.Id;
			this.firstName = c.FirstName;
			this.lastName = c.LastName;
			this.middleName = c.Middle_Name__c;
			this.DOB = c.Birthdate;
			this.email = c.Email;
			this.webAppID = c.Webapp_Id__c;

			this.appMemberType = (c.recordtypeid == CONTACT_APPLICANT_RT_ID)?  PRIMARY_APPLICANT : '';
			//we keep those fields blank because we forseeing using in the future
			/*this.phone = c.Phone;
			this.phoneType = c.Phone_Type__c;
			this.alternatePhone = c.Work_Phone__c;
			this.alternatePhoneType = c.Second_Phone_Type__c;
			this.address = c.Street_Name__c;
			this.city = c.City__c;
			this.state = c.State__c;
			this.zip = c.Zip_Code__c;
			this.mailingAddress = c.MailingStreet;
			this.mailingCity = c.MailingCity;
			this.mailingState = c.MailingState;
			this.mailingZip = c.MailingPostalCode;
			this.workInSf = c.Work_in_SF__c;
			this.gender = c.Gender__c;
			this.sexualOrientation = c.Sexual_Orientation__c;
			this.sexualOrientationOther = c.Sexual_Orientation_Other__c;
			this.hiv = c.Living_with_disabling_HIVAIDS__c;
			this.ethnicity = c.Ethnicity__c;
			this.race = c.Race__c;
			this.language = c.Primary_Language__c;
			this.hasSameAddressAsApplicant = false;*/
		}

		global Person(Application_Member__c am) {
			this.appMemberId = am.Id;
			this.applicationId = am.Application__c;
			this.contactId = am.Contact__c;
			this.firstName = am.First_Name__c;
			this.lastName = am.Last_Name__c;
			this.middleName = am.Middle_Name__c;
			this.DOB = am.Date_of_Birth__c;
			this.email = am.Email__c;
			this.phone = am.Phone__c;
			this.phoneType = am.Phone_Type__c;
			this.alternatePhone = am.Second_Phone__c;
			this.alternatePhoneType = am.Second_Phone_Type__c;
			this.address = am.Street__c;
			this.city = am.City__c;
			this.state = am.State__c;
			this.zip = am.Zip_Code__c;
			this.mailingAddress = am.Mailing_Street__c;
			this.mailingCity = am.Mailing_City__c;
			this.mailingState = am.Mailing_State__c;
			this.mailingZip = am.Mailing_Zip_Code__c;
			this.workInSf = am.Work_in_SF__c;
			this.gender = am.Gender__c;
			this.genderOther = am.Gender_Other__c;
			this.sexualOrientation = am.Sexual_Orientation__c;
			this.sexualOrientationOther = am.Sexual_Orientation_Other__c;
			this.hiv = am.Living_with_HIV_AIDS__c;
			this.ethnicity = am.Ethnicity__c;
			this.race = am.Race__c;
            this.sexAtBirth = am.Sex_at_Birth__c;
			this.language = am.Primary_Language__c;
			this.languageOther = am.Other_Language__c;
			this.relationship = am.Relationship_to_Applicant__c;
			this.alternateContactType = am.Alternate_Contact_Type__c;
			this.agency = am.Agency_Name__c;
			this.alternateContactTypeOther = am.Alternate_Contact_Type_Other__c;
			this.hasSameAddressAsApplicant = am.Same_Address_as_Applicant__c;
			this.preferenceAddressMatch = am.Preference_Address_Match__c;
			this.webappID = am.Contact_WebappID__c;
			this.noPhone = am.No_Phone__c;
			this.noEmail = am.No_Email__c;
			this.noAddress = am.No_Address__c;
			this.hasAltMailingAddress = am.Has_Alt_Mailing_Address__c;
			this.appMemberType = am.type__c;
			this.xCoordinate = am.X_Coordinate__c;
			this.yCoordinate = am.Y_Coordinate__c;
			this.whichComponentOfLocatorWasUsed = am.Which_component_of_locator_was_used__c;
			this.candidateScore = am.Candidate_Score__c;
			this.nickname = am.Nickname__c;
			this.maritalStatus = am.Marital_Status__c;
		}
		
		global Person(Person__b p) {
			this.appMemberId = p.Application_Member__c;
			this.applicationId = p.Application__c;
			this.contactId = p.Contact_Id__c;
			this.firstName = p.First_Name__c;
			this.lastName = p.Last_Name__c;
			this.middleName = p.Middle_Name__c;
			this.DOB = p.Date_of_Birth__c != null ? date.valueOf(p.Date_of_Birth__c) : null;
			this.email = p.Email__c;
			this.phone = p.Phone__c;
			this.phoneType = p.Phone_Type__c;
			this.webAppID = p.Web_App_Id__c;
			this.alternatePhone = p.Alternate_Phone__c;
			this.alternatePhoneType = p.Alternate_Phone_Type__c;
			this.address = p.Address__c;
			this.city = p.City__c;
			this.state = p.State__c;
			this.zip = p.Zip__c;
			this.mailingAddress = p.Mailing_Address__c;
			this.mailingCity = p.Mailing_City__c;
			this.mailingState = p.Mailing_State__c;
			this.mailingZip = p.Mailing_Zip__c;
			this.workInSf = p.Work_In_SF__c;
			this.gender = p.Gender__c;
			this.genderOther = p.Gender_Other__c;
			this.sexualOrientation = p.Sexual_Orientation__c;
			this.sexualOrientationOther = p.Sexual_Orientation_Other__c;
			this.hiv = p.HIV__c != null ? boolean.valueOf(p.HIV__c) : false;
			this.ethnicity = p.Ethnicity__c;
			this.race = p.Race__c;
            this.sexAtBirth = p.Sex_At_Birth__c;
			this.language = p.Language__c;
			this.languageOther = p.Language_Other__c;
			this.relationship = p.Relationship__c;
			this.alternateContactType = p.Alternate_Contact_Type__c;
			this.agency = p.Agency__c;
			this.alternateContactTypeOther = p.Alternate_Contact_Type_Other__c;
			this.hasSameAddressAsApplicant = p.Has_Same_Address_As_Applicant__c;
			this.preferenceAddressMatch = p.Preference_Address_Match__c;
			this.noPhone = p.No_Phone__c != null ? boolean.valueOf(p.No_Phone__c) : false;
			this.noEmail = p.No_Email__c != null ? boolean.valueOf(p.No_Email__c) : false;
			this.noAddress = p.No_Address__c != null ? boolean.valueOf(p.No_Address__c) : false;
			this.hasAltMailingAddress = p.Has_Alternate_Mailing_Address__c != null ? boolean.valueOf(p.Has_Alternate_Mailing_Address__c) : false;
			this.appMemberType = p.Application_Member_Type__c;
			this.xCoordinate = p.X_Coordinate__c;
			this.yCoordinate = p.Y_Coordinate__c;
			this.whichComponentOfLocatorWasUsed = p.Locator_Used__c;
			this.candidateScore = p.Candidate_Score__c;
			this.nickname = p.Nickname__c;
			this.maritalStatus = p.Marital_Status__c;
		}

		global Contact toContact() {
			Contact c = new Contact();
			c.Id = this.contactId;
			c.FirstName = this.firstName;
			c.LastName = this.lastName;
			c.Middle_Name__c = this.middleName;
			c.Birthdate = this.DOB;
			c.Email = this.email;
			c.Webapp_Id__c = this.webAppID;
			c.recordtypeid = CONTACT_APPLICANT_RT_ID;//(this.appMemberType== PRIMARY_APPLICANT ) ? CONTACT_APPLICANT_RT_ID:'';
			//we keep those fields blank because we forseeing using in the future
			/*c.Phone = this.phone;
			c.Phone_Type__c = this.phoneType;
			c.Work_Phone__c = this.alternatePhone;
			c.Second_Phone_Type__c = this.alternatePhoneType;
			c.Street_Name__c = this.address;
			c.City__c = this.city;
			c.State__c = this.state;
			c.Zip_Code__c = this.zip;
			c.MailingStreet = this.mailingAddress;
			c.MailingCity = this.mailingCity;
			c.MailingState = this.mailingState;
			c.MailingPostalCode = this.mailingZip;
			c.Work_in_SF__c = this.workInSf == null ? false : this.workInSf;
			c.Gender__c = this.gender;
			c.Sexual_Orientation__c = this.sexualOrientation;
			c.Sexual_Orientation_Other__c = this.sexualOrientationOther;
			c.Living_with_disabling_HIVAIDS__c = (this.hiv == null ? false : this.hiv);
			c.Ethnicity__c = this.ethnicity;
			c.Race__c = this.race;
			c.Primary_Language__c = this.language;*/
			return c;
		}
		
		global Application_Member__c toApplicationMember() {
			Application_Member__c am = new Application_Member__c();
			am.Id = this.appMemberId;
			am.Contact__c = this.contactId;
			am.First_Name__c = this.firstName;
			am.Last_Name__c = this.lastName;
			am.Middle_Name__c = this.middleName;
			am.Date_of_Birth__c = this.DOB;
			am.Email__c = this.email;
			am.Phone__c = this.phone;
			am.Phone_Type__c = this.phoneType;
			am.Second_Phone__c = this.alternatePhone;
			am.Second_Phone_Type__c = this.alternatePhoneType;
			am.Street__c = this.address;
			am.City__c = this.city;
			am.State__c = this.state;
			am.Zip_Code__c = this.zip;
			am.Mailing_Street__c = this.mailingAddress;
			am.Mailing_City__c = this.mailingCity;
			am.Mailing_State__c = this.mailingState;
			am.Mailing_Zip_Code__c   = this.mailingZip;
			am.Work_in_SF__c = this.workInSf;// == null ? false : this.workInSf);
			am.Gender__c = this.gender;
			am.Gender_Other__c = this.genderOther;
			am.Sexual_Orientation__c = this.sexualOrientation;
			am.Sexual_Orientation_Other__c = this.sexualOrientationOther;
			am.Living_with_HIV_AIDS__c = (this.hiv == null ? false : this.hiv);
			am.Ethnicity__c = this.ethnicity;
			am.Race__c = this.race;
            am.Sex_at_Birth__c = this.sexAtBirth;
			am.Primary_Language__c = this.language;
			am.Other_Language__c = this.languageOther;
			am.Relationship_to_Applicant__c = this.relationship;
			am.Alternate_Contact_Type__c = this.alternateContactType;
			am.Agency_Name__c = this.agency;
			am.Alternate_Contact_Type_Other__c = this.alternateContactTypeOther;
			am.Same_Address_as_Applicant__c = this.hasSameAddressAsApplicant;// == null ? false : this.hasSameAddressAsApplicant);
			am.Preference_Address_Match__c = this.preferenceAddressMatch;
			am.No_Phone__c = this.noPhone == null ? false : this.noPhone;
			am.No_Email__c = this.noEmail == null ? false : this.noEmail;
			am.No_Address__c = this.noAddress == null ? false : this.noAddress;
			am.Has_Alt_Mailing_Address__c = this.hasAltMailingAddress == null ? false : this.hasAltMailingAddress;
			am.type__c = this.appMemberType;
			am.X_Coordinate__c = this.xCoordinate;
			am.Y_Coordinate__c = this.yCoordinate;
			am.Which_component_of_locator_was_used__c = this.whichComponentOfLocatorWasUsed;
			am.Candidate_Score__c = this.candidateScore;
			am.Nickname__c = this.nickname;
			am.Marital_Status__c = this.maritalStatus;

			return am;
		}
		
		global Person__b toPersonBig() {
			Person__b p = new Person__b();
			p.Application_Member__c = this.appMemberId;
			p.Application__c = this.applicationId;
			p.Contact_Id__c = this.contactId;
			p.First_Name__c = this.firstName;
			p.Last_Name__c = this.lastName;
			p.Middle_Name__c = this.middleName;
			p.Date_of_Birth__c = this.DOB;
			p.Email__c = this.email;
			p.Phone__c = this.phone;
			p.Phone_Type__c = this.phoneType;
			p.Web_App_Id__c = this.webAppID;
			p.Alternate_Phone__c = this.alternatePhone;
			p.Alternate_Phone_Type__c = this.alternatePhoneType;
			p.Address__c = this.address;
			p.City__c = this.city;
			p.State__c = this.state;
			p.Zip__c = this.zip;
			p.Mailing_Address__c = this.mailingAddress;
			p.Mailing_City__c = this.mailingCity;
			p.Mailing_State__c = this.mailingState;
			p.Mailing_Zip__c   = this.mailingZip;
			p.Work_In_SF__c = this.workInSf;
			p.Gender__c = this.gender;
			p.Gender_Other__c = this.genderOther;
			p.Sexual_Orientation__c = this.sexualOrientation;
			p.Sexual_Orientation_Other__c = this.sexualOrientationOther;
			p.HIV__c = (this.hiv == null ? false : this.hiv) + '';
			p.Ethnicity__c = this.ethnicity;
			p.Race__c = this.race;
            p.Sex_At_Birth__c = this.sexAtBirth;
			p.Language__c = this.language;
			p.Language_Other__c = this.languageOther;
			p.Relationship__c = this.relationship;
			p.Alternate_Contact_Type__c = this.alternateContactType;
			p.Agency__c = this.agency;
			p.Alternate_Contact_Type_Other__c = this.alternateContactTypeOther;
			p.Has_Same_Address_As_Applicant__c = this.hasSameAddressAsApplicant;
			p.Preference_Address_Match__c = this.preferenceAddressMatch;
			p.No_Phone__c = (this.noPhone == null ? false : this.noPhone) + '';
			p.No_Email__c = (this.noEmail == null ? false : this.noEmail) + '';
			p.No_Address__c = (this.noAddress == null ? false : this.noAddress) + '';
			p.Has_Alternate_Mailing_Address__c = (this.hasAltMailingAddress == null ? false : this.hasAltMailingAddress) + '';
			p.Application_Member_Type__c = this.appMemberType;
			p.X_Coordinate__c = this.xCoordinate;
			p.Y_Coordinate__c = this.yCoordinate;
			p.Locator_Used__c = this.whichComponentOfLocatorWasUsed;
			p.Candidate_Score__c = this.candidateScore;
			p.Nickname__c = this.nickname;
			p.Marital_Status__c = this.maritalStatus;
			
			return p;
		}
	}
	
	global class ShortFormPreference {
		global String recordTypeDevName;
		global String shortformPreferenceID;
		global String applicationID;
		global String appMemberID;
		global String naturalKey;
		global String listingPreferenceID;
		global String preferenceProof;
		global String lwPreferenceProof;
		global boolean optOut;
		global String individualPreference;
		global String certificateNumber;
		global boolean requiresProof;
		global String postLotteryValidation;
		global String address;
		global String city;
		global String state;
		global String zipCode;
		

		global void validate() {
			system.debug('this.listingPreferenceID:::' + this.listingPreferenceID);
			if (isNullorBlank(this.listingPreferenceID)) {
				throw new ListingPreferenceMissingException();
			}
			if (isNullorBlank(this.recordTypeDevName)) {
				throw new RecordTypeMissingException();
			}
		}

		global String getKey() {
			if (this.listingPreferenceID != null && this.appMemberId != null) {
				return this.listingPreferenceID + '#' + this.appMemberId;
			}
			else return null;
		}

		global ShortFormPreference(Application_Preference__c appPref) {
			this.recordTypeDevName = APP_PREF_RT_ID_TO_DEVNAME.get(appPref.RecordTypeId);

			this.shortformPreferenceID = appPref.Id;
			this.applicationID = appPref.Application__c;
			this.appMemberID = appPref.Application_Member__c;
			this.listingPreferenceID = appPref.Listing_Preference_ID__c;
			this.preferenceProof = appPref.Type_of_proof__c;
			this.lwPreferenceProof = appPref.LW_Type_of_proof__c;
			this.optOut = appPref.Opt_Out__c;
			this.individualPreference = appPref.Individual_preference__c;
			this.certificateNumber = appPref.Certificate_Number__c;
			this.requiresProof = appPref.Requires_Proof__c;
			this.postLotteryValidation = appPref.Post_Lottery_Validation__c;
			this.address = appPref.Street__c;
			this.city = appPref.City__c;
			this.state = appPref.State__c;
			this.zipCode = appPref.Zip_Code__c;
		}
		
		global ShortFormPreference(ShortForm_Preference__b appPref) {
			this.shortformPreferenceID = appPref.Application_Preference__c;
			this.recordTypeDevName = appPref.Record_Type_Developer_Name__c;
			this.applicationID = appPref.Application__c;
			this.individualPreference = appPref.Individual_Preference__c;
			this.appMemberID = appPref.Application_Member_Id__c;
			this.listingPreferenceID = appPref.Listing_Preference_Id__c;
			this.optOut = appPref.Opt_Out__c != null ? boolean.valueOf(appPref.Opt_Out__c) : false;
			this.certificateNumber = appPref.Certificate_Number__c;
			this.preferenceProof = appPref.Preference_Proof__c;
			this.lwPreferenceProof = appPref.LW_Preference_Proof__c;
			//appPref.Natural_Key__c = this.postLotteryValidation;
			this.requiresProof = appPref.Requires_Proof__c != null ? boolean.valueOf(appPref.Requires_Proof__c) : false;
			
		}

		global Application_Preference__c toApplicationPreference() {
			Application_Preference__c appPref = new Application_Preference__c();
			appPref.Id = this.shortformPreferenceID;

			appPref.RecordTypeId = APP_PREF_RT_DEVNAME_TO_ID.get(this.recordTypeDevName);
			if (this.shortformPreferenceID == null) {
				appPref.Application__c = this.applicationID;
			}
			if (this.recordTypeDevName == L_W_RT_DEVELOPER_NAME || this.recordTypeDevName == RB_AHP_RT_DEVELOPER_NAME) {
				appPref.Individual_preference__c = this.individualPreference;
			}
			appPref.Application_Member__c = this.appMemberID;
			appPref.Listing_Preference_ID__c = this.listingPreferenceID;
			appPref.Opt_Out__c = this.optOut == null ? false : this.optOut;
			if (this.recordTypeDevName == COP_RT_DEVELOPER_NAME || this.recordTypeDevName == DTHP_RT_DEVELOPER_NAME) {
				appPref.Certificate_Number__c = this.certificateNumber;
			}
			if (this.recordTypeDevName == L_W_RT_DEVELOPER_NAME || this.recordTypeDevName == NRHP_RT_DEVELOPER_NAME ||
				this.recordTypeDevName == ADHP_RT_DEVELOPER_NAME || this.recordTypeDevName == CUSTOM_RT_DEVELOPER_NAME ||
				this.recordTypeDevName == RB_AHP_RT_DEVELOPER_NAME) {

				appPref.Type_of_proof__c = this.preferenceProof;
				appPref.LW_Type_of_proof__c = this.lwPreferenceProof;
				if (this.recordTypeDevName == L_W_RT_DEVELOPER_NAME && String.isEmpty(this.preferenceProof) && !String.isEmpty(this.lwPreferenceProof)) {
					appPref.Type_of_proof__c = this.lwPreferenceProof;
				}
				if (this.recordTypeDevName == L_W_RT_DEVELOPER_NAME && !String.isEmpty(this.preferenceProof) && String.isEmpty(this.lwPreferenceProof)) {
					appPref.LW_Type_of_proof__c = this.preferenceProof;
				}
			}
			appPref.Post_Lottery_Validation__c = this.postLotteryValidation;
			if (this.recordTypeDevName == AG_RT_DEVELOPER_NAME) {
				appPref.Street__c = this.address;
				appPref.City__c = this.city;
				appPref.State__c = this.state;
				appPref.Zip_Code__c = this.zipCode;
                appPref.Type_of_proof__c = this.preferenceProof;
			}
			return appPref;
		}
		
		global ShortForm_Preference__b toApplicationPreferenceBig() {
			ShortForm_Preference__b appPref = new ShortForm_Preference__b();
			appPref.Application_Preference__c = this.shortformPreferenceID;
			appPref.Record_Type_Developer_Name__c = this.recordTypeDevName;
			appPref.Application__c = this.applicationID;
			appPref.Individual_Preference__c = this.individualPreference;
			appPref.Application_Member_Id__c = this.appMemberID;
			appPref.Listing_Preference_Id__c = this.listingPreferenceID;
			appPref.Opt_Out__c = (this.optOut == null ? false : this.optOut) + '';
			appPref.Certificate_Number__c = this.certificateNumber;
			appPref.Preference_Proof__c = this.preferenceProof;
			appPref.LW_Preference_Proof__c = this.lwPreferenceProof;
			//appPref.Natural_Key__c = this.postLotteryValidation;
			appPref.Requires_Proof__c = (this.requiresProof == null ? false : this.requiresProof) + '';
			
			return appPref;
		}

	}

	global class Attachment {
		global String attachmentID;
		global String customAttachmentID;
		global String ApplicationID;
		global String ApplicationMemberID;
		global String ApplicationPreferenceID;
		global String DocumentType;
		global Date uploadDate;
		global BLOB body;
		global Decimal BodyLength;
		global String Description;
		global String fileName;

		global Attachment(Attachment__c customAttachment) {

			this.customAttachmentID = customAttachment.Id;
			this.ApplicationID = customAttachment.Related_Application__c;
	        this.ApplicationMemberID = customAttachment.Related_Application_Member__c;
	        this.ApplicationPreferenceID = customAttachment.Related_Application_Preference__c;
	        this.uploadDate = customAttachment.Upload_Date__c;
	        this.DocumentType = customAttachment.Document_Type__c;

	        SObject att = getRelatedAttachment(customAttachment.Id);
			this.attachmentID = att.Id;
	        this.body = (Blob)att.get('Body');
	        this.BodyLength = (Decimal)att.get('BodyLength');
	        this.fileName = (String)att.get('Name');
	        this.description = (String)att.get('Description');
		}

		//define this to return a SObject because the code it confuses Attchment class with Attachment standard object
		public SObject getRelatedAttachment(Id customAttachmentId) {
			SObject att = [SELECT Id, Body, BodyLength, Description, Name FROM Attachment WHERE ParentId = :customAttachmentId];
			if (att == null) {
				return Schema.getGlobalDescribe().get('Attachment').newSObject();
			}
			return att;
		}
	}
}