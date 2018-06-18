@isTest
private without sharing class API_LeaseUp_ApplicationServiceTest {
	static Account acc;
	static Contact contact;
	static Listing__c listing;
	static Application__c app;
	static Application_Member__c appM;
	static Application_Member__c appM1;
	
	private static void init() {
		
		acc = new Account(Name = 'Household');
		insert acc;
		
		date myDate = date.newInstance(1998, 10, 21);
		contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = acc.Id, Work_State__c = 'CO', Birthdate = myDate);
		insert contact;

		listing = new Listing__c();
		insert listing;
		
		app = new Application__c(Listing__c = listing.Id, Applicant_Household__c = acc.Id, Lottery_Number_Manual__c = '2', Status__c = 'Draft');
		insert app;
		
		appM = new Application_Member__c(Contact__c = contact.Id, Application__c = app.Id, First_Name__c = 'Test', Last_Name__c = 'Test Name', Date_of_Birth__c = myDate, Type__c = 'Household Member');
		insert appM;
		
	}
	
	static testMethod void newShortformTest() {
		
		init();
		
		API_LeaseUp_Application.Person pers = new API_LeaseUp_Application.Person();
		pers.lastName = 'LastName';
		pers.firstname = 'FirstName';
		pers.contactId = contact.Id;
		pers.DOB = contact.Birthdate;

		API_LeaseUp_Application.Person appMPerson = new API_LeaseUp_Application.Person(appM);
		
		API_LeaseUp_Application.ShortForm sf = new API_LeaseUp_Application.ShortForm();
		sf.primaryApplicant = pers;
		sf.listingId = listing.Id;
		sf.alternateContact = pers;
		sf.householdMembers = new List<API_LeaseUp_Application.Person>();
		sf.householdMembers.add(appMPerson);
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/shortForm';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(JSON.serialize(sf));
		RestContext.request = req;
		RestContext.response = res;
		
		
		sf = API_LeaseUp_ShortForm.doPost();
		
		System.assertNotEquals(sf.Id, null);
		System.assertEquals(sf.primaryApplicant.contactId, contact.Id);
		
		System.assertEquals(API_LeaseUp_ApplicationService.getPersonByApplicationMemberId(appM.id).contactId, contact.id);
		System.assertEquals(API_LeaseUp_ApplicationService.getApplicationMemberByContactId(contact.id).size(), 2);
		System.assertEquals(API_LeaseUp_ApplicationService.getContactsByHouseholdId(acc.id).size(), 1);
		System.assertEquals(API_LeaseUp_ApplicationService.getPersonById(contact.id).contactId, contact.Id);
		System.assertEquals(API_LeaseUp_ApplicationService.getPersonByContactId(contact.id).contactId, contact.Id);
		//System.assertEquals(API_LeaseUp_ApplicationService.getShortformsByContactId(contact.id)[0].id, app.Id);
		//System.assertEquals(API_LeaseUp_ApplicationService.upsertContactAndCascadeUpdate(pers).contactId, contact.Id);
		//System.assertEquals(API_LeaseUp_ApplicationService.upsertApplicationMemberPerson(appMPerson).contactId, contact.Id);
		
		sf.householdMembers.add(pers);
		System.assertNotEquals(API_LeaseUp_ApplicationService.upsertShortform(sf).id, app.Id);
		Id getDefaultAccOwner = API_LeaseUp_ApplicationService.getDefaultAccoutOwner();
		Boolean isCommunityUser = API_LeaseUp_ApplicationService.isCommunityUser(contact.Id);
		//String getAppMemIdByShortformId = API_LeaseUp_ApplicationService.getApplicationMemberIdByShortformId(sf, 'Primary' , 'Alternate');
		//String getAppMemIdByShortformId1 = API_LeaseUp_ApplicationService.getApplicationMemberIdByShortformId(sf, 'Alternate' , 'Alternate');
		
		sf.householdMembers.add(pers);
		//String getAppMemIdByShortformId2 = API_LeaseUp_ApplicationService.getApplicationMemberIdByShortformId(sf, 'Other' , 'Alternate');
		//String getContactIdByShortFormId = API_LeaseUp_ApplicationService.getContactIdByShortformId(sf);
		
		API_LeaseUp_ApplicationService.deleteShortform(sf);
		API_LeaseUp_ApplicationService.deletePerson(pers);
        API_LeaseUp_ApplicationService.getShortformPreferencesByApplicationIds(new Set<ID>{app.Id});
        API_LeaseUp_ApplicationService.getHouseholdById(acc.Id);
        API_LeaseUp_ApplicationService.getApplicationByListingIds(new Set<ID>{listing.Id});
        API_LeaseUp_ApplicationService.getApplicationsByPrimaryApplicantId(contact.Id);
	}

}