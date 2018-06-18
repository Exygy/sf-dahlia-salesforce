@isTest
public class MigrateAppPrefBatchTest {
    public static testmethod void testMigrationScript() {
    	Listing__c listing = new Listing__c();
        listing.Name = 'Test';
        insert listing;
        
        List<Lottery_Preference__c> lpList = new List<Lottery_Preference__c>();
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Displaced Tenant Housing Preference (DTHP)'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Certificate of Preference (COP)'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Live or Work in San Francisco Preference'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Neighborhood Resident Housing Preference (NRHP)'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Rent Burdened / Assisted Housing Preference'));
        insert lpList;
        
        List<Listing_Lottery_Preference__c> llpList = new List<Listing_Lottery_Preference__c>();
        for (Lottery_Preference__c lp : lpList) {
            llpList.add(new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lp.Id));
        }
        insert llpList;
        
        Application__c app = new Application__c();
        app.Listing__c = listing.Id;
        app.Status__c = 'Submitted';
        insert app;
        
        Application_Preference__c appPref1 = new Application_Preference__c();
        appPref1.Application__c = app.Id;
        appPref1.Listing_Preference_ID__c = llpList[0].Id;
        insert appPref1;
        
        /*Application_Preference__c appPref2 = new Application_Preference__c();
        appPref2.Application__c = app.Id;
        appPref2.Listing_Preference_ID__c = llpList[1].Id;
        insert appPref2;
        
        Application_Preference__c appPref3 = new Application_Preference__c();
        appPref3.Application__c = app.Id;
        appPref3.Listing_Preference_ID__c = llpList[2].Id;
        insert appPref3;
        
        Application_Preference__c appPref4 = new Application_Preference__c();
        appPref4.Application__c = app.Id;
        appPref4.Listing_Preference_ID__c = llpList[3].Id;
        insert appPref4;
        
        Application_Preference__c appPref5 = new Application_Preference__c();
        appPref5.Application__c = app.Id;
        appPref5.Listing_Preference_ID__c = llpList[4].Id;
        insert appPref5;*/
        
        Test.startTest();
        	Id batchJobId = Database.executeBatch(new MigrateAppPrefBatch());
        Test.stopTest();
    }
}