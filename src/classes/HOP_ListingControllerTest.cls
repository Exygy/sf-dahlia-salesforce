// *****************************************************************************
// CLASS: HOP_ListingControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ListingController class.
//
// *****************************************************************************

@isTest
private class HOP_ListingControllerTest {

	@isTest
	static void emptyIdTest() {
		Test.startTest();
			HOP_ListingController cnt = new HOP_ListingController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}

	@isTest
	static void badIdTest() {
		Test.startTest();
			ApexPages.currentPage().getParameters().put('id', UserInfo.getUserId());
			HOP_ListingController cnt = new HOP_ListingController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}

	@isTest
	static void communityUser_diffAccountTest() {
		Test.startTest();

			List<Profile> communityUserProfiles = [SELECT Id, Name FROM Profile WHERE UserLicense.Name = :HOP_Constants.COMMUNITY_LICENSE_NAME];
			if (communityUserProfiles.size() == 0) return;
            Id communityUserProfileId;    
            for (Profile p : communityUserProfiles) {
                if (p.Name == 'MOHCD - Leasing Agent Partner') {
                	communityUserProfileId = communityUserProfiles[0].Id;
                }
            }
        	system.debug('communityUserProfileId:::' + communityUserProfileId);

        	Account otherAccount = new Account(Name = 'OA');
        	insert otherAccount;

			Listing__c otherListing = new Listing__c(Name = 'OtherListing', Account__c = otherAccount.Id);
			insert otherListing;

			Id PROPERTY_MANAGEMENT_ACCOUNT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Property_Management'].Id;
			Account cuAccount = new Account(RecordTypeId = PROPERTY_MANAGEMENT_ACCOUNT_RTID, Name = 'PMA');
        	insert cuAccount;

			Listing__c cuListing = new Listing__c(Name = 'MyListing', Account__c = cuAccount.Id, Share_Listing__c = true);
			insert cuListing;

	        Id LENDING_AGENT_CONTACT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Lending_Agent'].Id;
			Contact cuContact = new Contact(RecordTypeId = LENDING_AGENT_CONTACT_RTID, AccountId = cuAccount.Id, LastName = 'PMC');
	        insert cuContact;
			system.debug('cuContact:::' + cuContact);

	        User cuUser = new User(	UserName = 'cuUser@cuUser.comcom', Alias = 'PMU', LastName = 'PMU', Email = 'cuUser@cuUser.comcom', IsActive = true,
	        						ProfileId = communityUserProfileId, EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'America/Denver',
	        						LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ContactId = cuContact.Id);
	        insert cuUser;
			system.debug('cuContact:::' + [SELECT Id FroM Listing__c]);
				

				ApexPages.currentPage().getParameters().put('id', otherListing.Id);
				HOP_ListingController cnt = new HOP_ListingController();

				ApexPages.currentPage().getParameters().put('id', cuListing.Id);
				cnt = new HOP_ListingController();
                system.debug('cuContact:::' + [SELECT Id FroM Listing__c]);
				//System.assert(cnt.hasErrors == false);
				//System.assert(cnt.lst.Id == cuListing.Id);
				//cnt.lst.Name = 'NewName';
				//cnt.saveListing();
				//System.assert(cnt.lst.Id == cuListing.Id);
				//System.assert(cnt.lst.Name == 'NewName');


		Test.stopTest();
	}

}