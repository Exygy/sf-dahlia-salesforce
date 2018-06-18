// *****************************************************************************
// CLASS: ListingLotteryResultApiTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingLotteryResultApi.cls and ListingService.cls
//
// *

@isTest
public with sharing class ListingLotteryResultApiTest {
    private static Account acc;
    static ID listingID, listing1ID ;
    static Application__c app;
    static Application__c app2;
    
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
        insert listing;
        
        app = new Application__c(Listing__c = listing.Id, Lottery_Number_Manual__c = '1');
		
		app2 = new Application__c(Listing__c = listing.Id, Lottery_Number_Manual__c = '1');
		insert new List<Application__c>{app,app2};
		
		Application_Member__c appM = new Application_Member__c(Application__c = app.Id, First_Name__c = 'Test', Last_Name__c = 'lastName', Date_of_Birth__c = date.today().addYears(-20));
		insert appM;
		
		app.Live_in_SF_Preference_Member__c = appM.Id;
		app.DTHP_Preference_Member__c = appM.Id;
		app.COP_Preference_Member__c = appM.Id;
		app.Neighborhood_Preference_Member__c = appM.Id;
		app.Work_in_SF_Preference_Member__c = appM.Id;
		update app;
		
		listingID = listing.id;
    }
    
	/* 
	 * test GET applications by listing Id and lottery number
	 */    
    static testMethod void doGetById() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        app = [SELECT Lottery_Number__c from Application__c WHERE Id = :app.Id];
        req.requestURI = '/Listing/LotteryResult/' + listingID + '/' + app.Lottery_Number__c;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        ListingService.LotteryResult listingRes = ListingLotteryResultApi.doGet();
		
        //check if returned application is the right one and has the same lottery number
        system.assert(listingRes.ListingId == listingID);	
        //system.assert(listingRes.applicationResults[0].lotteryNumber == app.Lottery_Number__c);
    }
    
    /* 
	 * test GET bucket lottery results
	 */	
	static testMethod void doGetBucketById() {
		setupTestData();
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		
		req.requestURI = '/Listing/LotteryResult/' + listingID;
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		ListingService.LotteryResult listingRes = ListingLotteryResultApi.doGet();
		
		//check if returned application is the right one and has the same listing id
		system.assert(listingRes.ListingId == listingID);
		
		//check when Lottery Rank = null no records are returned
		for (ListingService.LotteryBucket lotteryBucket : listingRes.lotteryBuckets) {
			system.assert(lotteryBucket.preferenceResults.size() == 0);
		}
		
		app.Lottery_Status__c = 'Valid - Added';
		app.Lottery_Rank__c = 1;
		app2.Lottery_Rank__c = 1;
		update new List<Application__c>{app,app2};
		
		req.requestURI = '/Listing/LotteryResult/' + listingID;
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		listingRes = ListingLotteryResultApi.doGet();
		
		//check if returned bucket has the right records when Lottery Rank != null
		for (ListingService.LotteryBucket lotteryBucket : listingRes.lotteryBuckets) {
			system.assert(lotteryBucket.preferenceResults.size() == 2);
			if (lotteryBucket.preferenceName != 'generalLottery') {
				system.assert(lotteryBucket.preferenceResults[0].applicationID == app.Id);
			} else {
				system.assert(lotteryBucket.preferenceResults[0].applicationID == app2.Id);
			}
		}
	}
}