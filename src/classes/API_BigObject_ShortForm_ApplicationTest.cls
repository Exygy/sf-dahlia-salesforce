// *****************************************************************************
// CLASS: API_BigObject_ShortForm_ApplicationTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 05/21/18
// Description: Test class for API_ShortForm.cls and API_BigObject_ShortForm_Application.cls
//
// *
@isTest
public class API_BigObject_ShortForm_ApplicationTest {
	private static Leasing_Settings__c leasingSettings;
	private static Account a;
	private static Contact c;
	private static Listing__c listing;
	private static Application__c app;
	private static Application_Member__c appM;
	private static Application_Member__c appM1;
	private static Application_Member__c appM2;
	private static Application_Preference__c appPref;
	private static List<Lottery_Preference__c> lotPrefList;
	private static List<Listing_Lottery_Preference__c> listingPrefList;
    
    private static void init() {
	}
	
	private static void initTestClass() {
		leasingSettings = new Leasing_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Default_Owner__c=UserInfo.getUserId());
		insert leasingSettings;
	
		a = new Account(Name = 'Household');
		insert a;

		c = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = a.Id, Work_State__c = 'CO', Birthdate = date.today().addYears(-30));
		insert c;
		
		Development__c dev = new Development__c();
		dev.Name_of_Development__c = 'amli';
		dev.Project_ID__c = '123';
        insert dev;
	  
		Building__c build = new Building__c();
		build.Development__c = dev.Id;
		build.Maximum_waitlist_size__c = 10;
		build.Number_of_people_currently_on_waitlist__c = 5;
		build.hasWaitlist__c = true;
	   	insert build;
		
		listing = new Listing__c();
		listing.Building__c  = build.id;
		insert listing;
	
        app = new Application__c(Applicant_Household__c = a.Id, Listing__c = listing.Id);
		insert app;
		
		appM = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test', Last_Name__c = 'lastName', Date_of_Birth__c = date.today().addYears(-20), Other_Language__c = 'Mandarin');
		insert appM;
        
        listing.Status__c = 'Lease Up';
        update listing;
	}
    
    /*
	 * get shortform
	*/
	static testMethod void API_ShortForm_GetTest() {
		initTestClass();
			
		Test.startTest();
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/LeasingAgentPortal/shortForm/Archive/' + app.Id;
			req.httpMethod = 'GET';
			RestContext.request = req;
			RestContext.response = res;

			API_LeaseUp_Application.ShortForm sf = API_BigObject_ShortForm_Application.doGet();
		Test.stopTest();
		
    }
    
    /*
	 * call GET without Id should fail
	*/
	static testMethod void fail_API_ShortForm_GetTest() {
		initTestClass();
			
		Test.startTest();
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/LeasingAgentPortal/shortForm/Archive/fail/' + app.Id;
			req.httpMethod = 'GET';
			RestContext.request = req;
			RestContext.response = res;

			API_LeaseUp_Application.ShortForm sf = API_BigObject_ShortForm_Application.doGet();
		Test.stopTest();
		
		System.assertEquals(res.statusCode, 400);
		
	}
}