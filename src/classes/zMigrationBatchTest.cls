@isTest
public with sharing class zMigrationBatchTest {
    public static testmethod void testMigrationScript() {
    	Listing__c listing = new Listing__c();
        listing.Name = 'Test';
        insert listing;
        
        Listing__c listing2 = new Listing__c();
        listing.Name = 'Test2';
        insert listing2;
        
        List<Lottery_Preference__c> lpList = new List<Lottery_Preference__c>();
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Displaced Tenant Housing Preference (DTHP)'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Certificate of Preference (COP)'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Live or Work in San Francisco Preference'));
        lpList.add(new Lottery_Preference__c(Active__c = true,Name = 'Neighborhood Resident Housing Preference (NRHP)'));
        insert lpList;
        
        List<Listing_Lottery_Preference__c> llpList = new List<Listing_Lottery_Preference__c>();
        for (Lottery_Preference__c lp : lpList) {
            llpList.add(new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lp.Id));
            llpList.add(new Listing_Lottery_Preference__c(Listing__c = listing2.Id, Lottery_Preference__c = lp.Id));
        }
        insert llpList;
        
        Application__c app = new Application__c();
        app.Listing__c = listing.Id;
        app.Status__c = 'Submitted';
        insert app;
        
        Application__c app2 = new Application__c();
        app2.Listing__c = listing2.Id;
        app2.Status__c = 'Submitted';
        insert app2;
        
        Test.startTest();
        Set<ID> idSet = new Set<ID>{};
        	Id batchJobId = Database.executeBatch(new zMigrationBatch(idSet, null, null));
        
        Test.stopTest();
    }
}