// *****************************************************************************
// CLASS: API_PersonTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for API_Person.cls and API_ApplicationService.cls
//
// *
@isTest
private without sharing class API_PersonTest {
    //check if the contact was created
    static testMethod void doPostCreateContact() {

        API_Application.Person pa = new API_Application.Person();
        pa.lastName = 'lastName';
        pa.firstname = 'firstname';
        pa.webAppID = '1234';
               
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Person/';
            req.httpMethod = 'POST';
        	req.requestBody = Blob.valueOf(JSON.serialize(pa));
            RestContext.request = req;
            RestContext.response = res;

            API_Application.Person pers = API_Person.doPost();
        	Contact c = [SELECT LastName, FirstName, webapp_id__c FROM Contact limit 1];
        	
        	//check if contact was created
        	system.assertEquals(c.LastName, 'lastName');
            system.assertEquals(c.FirstName, 'firstname');
            system.assertEquals(c.webapp_id__c, '1234');
        Test.stopTest();
        
    }
    
    //check if contact was updated
    static testMethod void doPostUpdateContact() {
        API_Application.Person pers = new API_Application.Person();
        pers.firstname='Person firstName';
        pers.lastName='Person lastname';
        pers.email='this@that.com';
        
        pers.DOB=System.today();
        pers.webAppID='1234';
        
         
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Person/';
            req.httpMethod = 'POST';
        	req.requestBody = Blob.valueOf(JSON.serialize(pers));
            RestContext.request = req;
            RestContext.response = res; 

            API_Application.Person persResult = API_Person.doPost();
        
            system.assertEquals(persResult.firstname,'Person firstName');
            system.assertEquals(persResult.email,'this@that.com');
            system.assertEquals(persResult.webAppID,'1234');
        
            req = new RestRequest();
             res = new RestResponse();
            req.requestURI = '/Person/' + persResult.contactId + '/';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            persResult = API_Person.doGet();
            system.assertEquals(persResult.firstname,'Person firstName');
            system.assertEquals(persResult.email,'this@that.com');
            system.assertEquals(persResult.webAppID,'1234');
        Test.stopTest();
        
    }
    
    //cascade update
    static testMethod void cascadeUpdate() {
		
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'email@yahoo.com', AccountId = a.Id);
        insert c;
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        List<Application__c> appList = new List<Application__c>();
        Application__c app = new Application__c();
        //app.Primary_Applicant__c = c.Id;
        app.Status__c = 'Submitted';
        app.Listing__c = listing.Id;
        appList.add(app);
        
        Application__c app1 = new Application__c();
        //app1.Primary_Applicant__c = c.Id;
        app1.Status__c = 'Draft';
        app1.Listing__c = listing.Id;
        appList.add(app1);
        
        Application__c app2 = new Application__c();
        //app2.Primary_Applicant__c = c.Id;
        app2.Status__c = 'Draft';
        app2.Listing__c = listing.Id;
        appList.add(app2);
        
        insert appList;
        
        List<Application_Member__c> appMemberList = new List<Application_Member__c>();
        Application_Member__c primaryApplicant1 = new Application_Member__c(Contact__c = c.Id, Application__c = app.Id, First_Name__c = 'FirstName', Last_Name__c = 'LastName', Date_of_Birth__c = date.today(), Email__c = 'email@yahoo.com');
        Application_Member__c primaryApplicant2 = new Application_Member__c(Contact__c = c.Id, Application__c = app.Id, First_Name__c = 'FirstName', Last_Name__c = 'LastName', Date_of_Birth__c = date.today(), Email__c = 'email@yahoo.com');
        Application_Member__c primaryApplicant3 = new Application_Member__c(Contact__c = c.Id, Application__c = app.Id, First_Name__c = 'FirstName', Last_Name__c = 'LastName', Date_of_Birth__c = date.today(), Email__c = 'email@yahoo.com');
        appMemberList.add(primaryApplicant1);
        appMemberList.add(primaryApplicant2);
        appMemberList.add(primaryApplicant3);
        insert appMemberList;
        
        API_Application.Person pa = new API_Application.Person(c);
        pa.lastName = 'Changed lastName';
        pa.firstname = 'Changed firstName';
        pa.email = 'changedEmail@test.com';
        pa.dob = system.today();
        pa.webAppID = '1234'; 
                
       	Application_Member__c appM = new Application_Member__c(Application__c = app1.Id, Contact__c = c.Id, First_Name__c = 'Test', Last_Name__c = 'LastName', Date_of_Birth__c = date.today(), Email__c = 'email@yahoo.com');
        insert appM;
        
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Person/';
            req.httpMethod = 'POST';
        	req.requestBody = Blob.valueOf(JSON.serialize(pa));
            RestContext.request = req;
            RestContext.response = res; 

            API_Application.Person pers = API_Person.doPost();
			
        	c = [SELECT id, LastName, FirstName, Email FROM Contact WHERE Id = :c.Id];
        	appMemberList = [SELECT First_Name__c, Last_Name__c, Email__c, Application__r.Status__c FROM Application_Member__c WHERE Contact__c = :c.Id];
			
        
            //check if application members are updated in cascade
        	for (Application_Member__c am : appMemberList) {
                //check for Draft apps the fields changed
                if (am.Application__r.Status__c == 'Draft') {
                    system.assertEquals(c.FirstName, am.First_Name__c);
                    system.assertEquals(c.LastName, am.Last_Name__c);
                    system.assertEquals(c.Email, am.Email__c);
                //check for Submitted apps the fields didn't change
                } else {
                    system.assertNotEquals(c.FirstName, am.First_Name__c);
                    system.assertNotEquals(c.LastName, am.Last_Name__c);
                    system.assertNotEquals(c.Email, am.Email__c);
                }
            }
            //included by luke - testing the post to get loop - 
	        req = new RestRequest();
	        res = new RestResponse();
            req.requestURI = '/Person/' + c.Id + '/';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            pers = API_Person.doGet();
            system.assertEquals(pers.firstname,'Changed firstName');
            system.assertEquals(pers.webAppID,'1234');
             
            system.assertEquals(pers.email,'changedemail@test.com');
            
           
            
        Test.stopTest();
    }
    
    //GET contact    
    static testMethod void doGetTest() {
        
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id, Work_State__c = 'CO');
        insert c;
        
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Person/' + c.Id + '/';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            API_Application.Person pers = API_Person.doGet();
        	system.debug(pers.contactId != null);
        	
        Test.stopTest();
    }
    

    
    //fail test
    static testMethod void doGet_failTest() {
        
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Person/';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            API_Application.Person pers = API_Person.doGet();
        	system.assert(res.statusCode == 400);
        Test.stopTest();
    }
    
    
}