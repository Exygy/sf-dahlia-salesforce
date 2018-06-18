// *****************************************************************************
// CLASS: HOP_ApplicationsControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ApplicationsController class.
//
// *****************************************************************************

@isTest
private class HOP_ApplicationsControllerTest {
	
	@isTest
	static void HOP_ApplicationsControllerTest() {
		Test.startTest();
        	Account someAccount = new Account(Name = 'someAccount');
        	insert someAccount;
        	
			Listing__c someListing = new Listing__c(Name = 'someListing', Account__c = someAccount.Id, Lottery_Status__c = 'Lottery Complete');
			insert someListing;

			Application__c someApp = new Application__c(Listing__c = someListing.Id, Status__c = 'Submitted');
			insert someApp;

			HOP_ApplicationsController cnt = new HOP_ApplicationsController();
			System.assert(cnt.myUser != null);
		Test.stopTest();
	}
    
    @isTest
	static void communityUser_HOP_ApplicationsControllerTest() {
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

	        Id LENDING_AGENT_CONTACT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Lending_Agent'].Id;
			Contact cuContact = new Contact(RecordTypeId = LENDING_AGENT_CONTACT_RTID, AccountId = cuAccount.Id, LastName = 'PMC');
	        insert cuContact;
        
	        User cuUser = new User(	UserName = 'cuUser@cuUser.comcom', Alias = 'PMU', LastName = 'PMU', Email = 'cuUser@cuUser.comcom', IsActive = true,
	        						ProfileId = communityUserProfileId, EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'America/Denver',
	        						LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ContactId = cuContact.Id);
	        insert cuUser;
        
			System.runAs(cuUser) {
				HOP_ApplicationsController cnt = new HOP_ApplicationsController();
			}
		Test.stopTest();
	}
	
}