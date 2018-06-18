// *****************************************************************************
// CLASS: ListingApplicationBigObjectQueueableTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 2018-05-14
// Description: Test class for ListingApplicationBigObjectQueueable
//            
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
@isTest
private class ListingApplicationBigObjectQueueableTest {
	@testSetup
    static void setup() {
         Account acc = new Account(Name = 'someAccount');
            insert acc;
            
            Listing__c lst = new Listing__c(Name = 'someListing', Account__c = acc.Id);
            insert lst;
			
        	Lottery_Preference__c lotPref = new Lottery_Preference__c(Name = 'Neighborhood Resident Housing Preference (NRHP)');
            Lottery_Preference__c lotPref2 = new Lottery_Preference__c(Name = 'Live or Work in San Francisco Preference');
            List<Lottery_Preference__c> lotPrefList = new List<Lottery_Preference__c>{lotPref,lotPref2};
            insert lotPrefList;
            
            Listing_Lottery_Preference__c listingPref = new Listing_Lottery_Preference__c(Listing__c = lst.Id, Lottery_Preference__c = lotPrefList[0].Id);
            Listing_Lottery_Preference__c listingPref2 = new Listing_Lottery_Preference__c(Listing__c = lst.Id, Lottery_Preference__c = lotPrefList[1].Id);
            List<Listing_Lottery_Preference__c> listingPrefList = new List<Listing_Lottery_Preference__c>{listingPref, listingPref2};
            insert listingPrefList;
            
            Application__c app = new Application__c(Listing__c = lst.Id, Status__c = 'Draft');
            insert app;

            Application_Member__c primaryApplicant = new Application_Member__c(
                Application__c = app.Id, Type__c = 'Primary Applicant',
                First_Name__c = 'Primary', Last_Name__c = 'Applicant', Date_of_Birth__c = Date.today()
            );
            insert primaryApplicant;
        
        	Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = acc.Id, Work_State__c = 'CO', Birthdate = date.today().addYears(-30));
			insert c;
			
        	Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test', Last_Name__c = 'lastName', Date_of_Birth__c = date.today().addYears(-20), Other_Language__c = 'Mandarin');
			insert appM;
    }
    
    static testmethod void testQueueable() {
        Listing__c lst = [SELECT Id FROM Listing__c limit 1];
        ListingApplicationBigObjectQueueable updater = new ListingApplicationBigObjectQueueable(new Set<Id>{lst.Id});
        Test.startTest();
        //DateHelper mockDH = (DateHelper)MockUtil.createMock(DateHelper.class);

        System.enqueueJob(updater);
        Test.stopTest();
    }
}