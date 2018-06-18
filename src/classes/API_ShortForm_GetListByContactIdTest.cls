// *****************************************************************************
// CLASS: API_ShortForm_GetListByContactIdTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for API_ShortForm_GetListByContactId.cls
//
// *
@isTest
private without sharing class API_ShortForm_GetListByContactIdTest {
	
	static testMethod void API_ShortForm_GetListByContactIdTest() {
		Account a = new Account(Name = 'Household');
        insert a;
        
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', Work_State__c = 'CO', Birthdate = date.today());
        insert c;
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        Application__c app = new Application__c(Listing__c = listing.Id, Applicant_Household__c = a.Id);
        insert app;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'FirstName', Last_Name__c = 'LastName', Date_of_Birth__c = date.today(), Email__c = 'email@yahoo.com');
        insert appM;
        
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm/list/' + c.Id;
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            List<API_Application.ShortForm> sfs = API_ShortForm_GetListByContactId.doGet();
        Test.stopTest();
        
        System.assertEquals(sfs.size(), 0);
    }
    
    static testMethod void failAPI_ShortForm_GetListByContactIdTest() {
		Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm/list/';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            List<API_Application.ShortForm> sfs = API_ShortForm_GetListByContactId.doGet();
        Test.stopTest();
        
        System.assertEquals(res.statusCode, 400);
    }

}