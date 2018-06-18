// *****************************************************************************
// CLASS: HOP_ApplicationViewControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ApplicationViewController class.
//
// *****************************************************************************

@isTest
private class HOP_ApplicationViewControllerTest {
	
	@isTest
	static void emptyIdTest() {
		Test.startTest();
			HOP_ApplicationViewController cnt = new HOP_ApplicationViewController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}
	
	@isTest
	static void badIdTest() {
		Test.startTest();
			ApexPages.currentPage().getParameters().put('id', UserInfo.getUserId());
			HOP_ApplicationViewController cnt = new HOP_ApplicationViewController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}

	@isTest
	static void communityUser_noAccessAccountTest() {
		Test.startTest();

			List<Profile> communityUserProfiles = [SELECT Id FROM Profile WHERE UserLicense.Name = :HOP_Constants.COMMUNITY_LICENSE_NAME LIMIT 1];
			if (communityUserProfiles.size() == 0) return;
			Id communityUserProfileId = communityUserProfiles[0].Id;

			Id PROPERTY_MANAGEMENT_ACCOUNT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Property_Management'].Id;
			Account cuAccount = new Account(RecordTypeId = PROPERTY_MANAGEMENT_ACCOUNT_RTID, Name = 'PMA');
        	insert cuAccount;
        
        	Account otherAccount = new Account(Name = 'OA');
        	insert otherAccount;
        	
			Listing__c otherListing = new Listing__c(Name = 'OtherListing', Account__c = otherAccount.Id);
			insert otherListing;

			Listing__c myListing = new Listing__c(Name = 'MyListing', Account__c = cuAccount.Id);
			insert myListing;

			Application__c otherApp = new Application__c(Listing__c = otherListing.Id);
			insert otherApp;

			Application__c myDraftApp = new Application__c(Listing__c = myListing.Id, Status__c = HOP_Constants.DRAFT_APPLICATION);
			insert myDraftApp;
        	
            Development__c dev = new Development__c();
            dev.Name_of_Development__c = 'amli';
            dev.Project_ID__c = '123';
            insert dev;
          
            Building__c build = new Building__c();
            build.Development__c = dev.Id;
            build.Developer__c = cuAccount.Id;
            insert build;
        
        	Unit__c unit = new Unit__c();
            unit.property__c  = build.id;
            unit.BMR_Rent_Monthly__c = 400;
            unit.Rent_Multiple__c=3;
            unit.of_AMI_for_Pricing_Unit__c=55;
            unit.Listing__c = myListing.id;
            unit.Number_of_Bedrooms__c = 3;
        	unit.Reserved_Type__c = 'Developmental disabilities';
            insert unit;

	        Id LENDING_AGENT_CONTACT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Lending_Agent'].Id;
			Contact cuContact = new Contact(RecordTypeId = LENDING_AGENT_CONTACT_RTID, AccountId = cuAccount.Id, LastName = 'PMC');
	        insert cuContact;
        
	        User cuUser = new User(	UserName = 'cuUser@cuUser.comcom', Alias = 'PMU', LastName = 'PMU', Email = 'cuUser@cuUser.comcom', IsActive = true,
	        						ProfileId = communityUserProfileId, EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'America/Denver',
	        						LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ContactId = cuContact.Id);
	        insert cuUser;
        
			System.runAs(cuUser) {
				ApexPages.currentPage().getParameters().put('id', otherApp.Id);
				HOP_ApplicationViewController cnt = new HOP_ApplicationViewController();
				System.assert(cnt.hasErrors == true);

				ApexPages.currentPage().getParameters().put('id', myDraftApp.Id);
				cnt = new HOP_ApplicationViewController();
				System.assert(cnt.hasErrors == true);
			}
		Test.stopTest();
	}

	@isTest
	static void positiveTest() {
		Test.startTest();

			Account someAccount = new Account(Name = 'someAccount');
        	insert someAccount;
        	
			Listing__c someListing = new Listing__c(Name = 'someListing', Account__c = someAccount.Id);
			insert someListing;
			
        	Lottery_Preference__c lotPref = new Lottery_Preference__c(Name = 'Neighborhood Resident Housing Preference (NRHP)',Record_Type_For_App_Preferences__c = 'NRHP');
            Lottery_Preference__c lotPref2 = new Lottery_Preference__c(Name = 'Live or Work in San Francisco Preference',Record_Type_For_App_Preferences__c = 'L_W');
            Lottery_Preference__c lotPref3 = new Lottery_Preference__c(Name = 'Certificate of Preference (COP)',Record_Type_For_App_Preferences__c = 'COP');
            Lottery_Preference__c lotPref4 = new Lottery_Preference__c(Name = 'Displaced Tenant Housing Preference (DTHP)',Record_Type_For_App_Preferences__c = 'DTHP');
            List<Lottery_Preference__c> lotPrefList = new List<Lottery_Preference__c>{lotPref,lotPref2,lotPref3,lotPref4};
            insert lotPrefList;
            
            Listing_Lottery_Preference__c listingPref = new Listing_Lottery_Preference__c(Listing__c = someListing.Id, Lottery_Preference__c = lotPrefList[0].Id);
            Listing_Lottery_Preference__c listingPref2 = new Listing_Lottery_Preference__c(Listing__c = someListing.Id, Lottery_Preference__c = lotPrefList[1].Id);
            Listing_Lottery_Preference__c listingPref3 = new Listing_Lottery_Preference__c(Listing__c = someListing.Id, Lottery_Preference__c = lotPrefList[2].Id);
            Listing_Lottery_Preference__c listingPref4 = new Listing_Lottery_Preference__c(Listing__c = someListing.Id, Lottery_Preference__c = lotPrefList[3].Id);
            List<Listing_Lottery_Preference__c> listingPrefList = new List<Listing_Lottery_Preference__c>{listingPref, listingPref2, listingPref3, listingPref4};
            insert listingPrefList;
            
			Application__c someApplication = new Application__c(Listing__c = someListing.Id);
			insert someApplication;

			Application_Member__c primaryApplicant = new Application_Member__c(Application__c = someApplication.Id, First_Name__c = 'Name2', Last_Name__c = 'LastName2', Date_of_Birth__c = date.today());
			insert primaryApplicant;

			Application_Member__c alternateContact = new Application_Member__c(Application__c = someApplication.Id, First_Name__c = 'Name', Last_Name__c = 'LastName', Date_of_Birth__c = date.today());
			insert alternateContact;
			
			someApplication.Applicant__c = primaryApplicant.Id;
			someApplication.Alternate_Contact__c = alternateContact.Id;
			update someApplication;
			
			Flagged_Record_Set__c someFlaggedRecordSet = new Flagged_Record_Set__c(Listing__c = someListing.Id);
			insert someFlaggedRecordSet;

			Flagged_Application__c someFlaggedApplication = new Flagged_Application__c(Flagged_Record_Set__c = someFlaggedRecordSet.Id, Application__c = someApplication.Id);
			insert someFlaggedApplication;

			ApexPages.currentPage().getParameters().put('id', someApplication.Id);
			HOP_ApplicationViewController cnt = new HOP_ApplicationViewController();
			System.assert(cnt.hasErrors == false);
			System.assert(cnt.app.Id == someApplication.Id);
			System.assert(cnt.flaggedRecordSetString == '\'' + someFlaggedRecordSet.Id + '\'');
			
        	cnt.currentRecId = cnt.appPreferences[0].appPref.Id;
        	cnt.toggleDetails();
        	for (HOP_ApplicationViewController.ApplicationPreference ap : cnt.appPreferences) {
                if (ap.appPref.Preference_Name__c == 'Neighborhood Resident Housing Preference (NRHP)') {
                	System.assert(ap.showHHMember == true);
                    system.debug('ap.showIndividualPreference:::' + ap.showIndividualPreference);
                	System.assert(ap.showIndividualPreference == false);
                	System.assert(ap.showTypeOfProof == true);
                	System.assert(ap.showCOPHolder == false);
                	System.assert(ap.showDTHP == false);
                	System.assert(ap.showAntiDTHP == false);
                	System.assert(ap.showNRHP == true);
                	System.assert(ap.showLiveWork == false);
            		System.assert(ap.showRentBurden == false);
            		System.assert(ap.showPersonWhoClaimed == false);
            	}
            }
		Test.stopTest();
	}
	
}