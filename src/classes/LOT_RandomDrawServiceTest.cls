// *****************************************************************************
// CLASS: LOT_RandomDrawServiceTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 9/16/2016
// Description: Test class for LOT_RandomDrawService.cls, LOT_RandomBaseRequest.cls, LOT_RandomDrawReq.cls
//
// *
@isTest
public with sharing class LOT_RandomDrawServiceTest {
    
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static Application__c app;
    private static List<Application_Preference__c> appPrefs;
    static  ID listingID ;
    static List<Id> listListingId;
    static String preferenceName ;
    
    static void setupTestData() {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = rtId;
        acc.AccountNumber = '12345';
        insert acc;
        
        Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        dev.Project_ID__c = '123';
        insert dev;
      
        Building__c build = new Building__c();
        build.Development__c = dev.Id;
        build.Developer__c = acc.Id;
       	insert build;
        
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        listing.Building__c  = build.id;
        listing.Account__c = acc.Id;
        listing.Status__c = 'Active';
        listing.Does_Match__c = true;
        listing.Lottery_Status__c = 'Not Yet Run';
        insert listing;
        
        
        app = new Application__c(Applicant_Household__c = acc.Id, Listing__c = listing.Id, Status__c = 'Submitted');
        insert app;
        
        //Application__c app2 = new Application__c(Applicant_Household__c = acc.Id, Listing__c = listing.Id, Status__c = 'Submitted');
        //insert app2;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, First_Name__c = 'Test', Last_Name__c = 'lastName', Date_of_Birth__c = date.today().addYears(-20), Preference_Address_Match__c = 'Matches');
        insert appM;
        
        Lottery_Preference__c lotPref = new Lottery_Preference__c(Name = 'Neighborhood Resident Housing Preference (NRHP)');
		//Lottery_Preference__c lotPref2 = new Lottery_Preference__c(Name = 'Live or Work in San Francisco Preference');
		//Lottery_Preference__c lotPref3 = new Lottery_Preference__c(Name = 'Certificate of Preference (COP)');
		//Lottery_Preference__c lotPref4 = new Lottery_Preference__c(Name = 'Displaced Tenant Housing Preference (DTHP)');
		List<Lottery_Preference__c> lotPrefList = new List<Lottery_Preference__c>{lotPref/*,lotPref2,lotPref3,lotPref4*/};
		insert lotPrefList;
		
		Listing_Lottery_Preference__c listingPref = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[0].Id);
		//Listing_Lottery_Preference__c listingPref2 = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[1].Id);
		//Listing_Lottery_Preference__c listingPref3 = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[2].Id);
		//Listing_Lottery_Preference__c listingPref4 = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[3].Id);
		List<Listing_Lottery_Preference__c> listingPrefList = new List<Listing_Lottery_Preference__c>{listingPref/*, listingPref2, listingPref3, listingPref4*/};
		insert listingPrefList;
		
		Application_Preference__c appPref = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[0].Id, Application_Member__c = appM.Id);
        //Application_Preference__c appPref2 = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[1].Id, Application_Member__c = appM.Id);
        //Application_Preference__c appPref3 = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[2].Id, Application_Member__c = appM.Id);
        //Application_Preference__c appPref4 = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[3].Id, Application_Member__c = appM.Id);
        appPrefs = new List<Application_Preference__c>{appPref/*,appPref2,appPref3,appPref4*/};
        insert appPrefs;
            
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        listingID = listing.id;
        listListingId = new List<Id>();
        listListingId.add(listingID);
        
        External_Connections__c extConnection = new External_Connections__c();
        extConnection.Name = 'random.org';
        extConnection.API_Key__c = '59431712-899c-44d0-9b78-b033f1469be8';
        extConnection.End_Point__c = 'https://draws.random.org/api/json-rpc/2/invoke';
        extConnection.Password__c = 'asdf1234';
        extConnection.User_Name__c = 'luke@vertiba.com';
		extConnection.RecordType__c = 'test';
		extConnection.Active__c = true;
		insert extConnection;
    }
    /*public static testmethod void testReRunLottery() {
    	setupTestData();
        app = [SELECT Id, Name, Lottery_Number__c from Application__c WHERE Id = :app.Id];
    	//LOT_PreferenceRankBatch prefRankBatch = new LOT_PreferenceRankBatch();
    	test.startTest();
			HttpCalloutMockGeneratorTest mock = new HttpCalloutMockGeneratorTest();
			mock.statusCode=200;
			mock.status = 'OK';
			mock.body = '{    "jsonrpc": "2.0","result": {        "drawId": 22993,        "status": "completed",        "entryCount": 3,        "winners": ["' + app.Name + '"],        "completionTime": "2011-10-10 13:19:12Z",        "recordUrl": "https://draws.random.org/records/draw=22993"    },   "error": null,    "id": 42}';
			Test.setMock(HttpCalloutMock.class, mock);
	    	//LOT_RandomDrawService.runLottery(listingID,true);
        	
        test.stopTest();
    }*/
    
    public static testmethod void testRunLottery() {
    	setupTestData();
        app = [SELECT Id, Name, Lottery_Number__c from Application__c WHERE Id = :app.Id];
    	//LOT_PreferenceRankBatch prefRankBatch = new LOT_PreferenceRankBatch();
    	test.startTest();
			HttpCalloutMockGeneratorTest mock = new HttpCalloutMockGeneratorTest();
			mock.statusCode=200;
			mock.status = 'OK';
			mock.body = '{    "jsonrpc": "2.0","result": {        "drawId": 22993,        "status": "completed",        "entryCount": 3,        "winners": ["' + app.Name + '"],        "completionTime": "2011-10-10 13:19:12Z",        "recordUrl": "https://draws.random.org/records/draw=22993"    },   "error": null,    "id": 42}';
			Test.setMock(HttpCalloutMock.class, mock);
	    	LOT_RandomDrawService.runLottery(listingID);
        test.stopTest();
    }
}