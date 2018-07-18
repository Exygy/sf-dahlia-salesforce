// *****************************************************************************
// CLASS: LOT_RandomDrawBatchTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 9/16/2016
// Description: Test class for LOT_RandomDrawBatch.cls
//
// *
@isTest
private class LOT_RandomDrawBatchTest {
    private static List<Application__c> apps;
    private static Listing__c listing;
    
    static void setupTestData() {
        // Implement test code
        listing = new Listing__c();
        listing.Name = 'test';
        insert listing;

        apps = new List<Application__c>();
        Application__c ap = new Application__c();
        ap.Listing__c = listing.Id;
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        apps.add(ap); 

        insert apps;
        
        Set<string> winnerNames = new Set<string>();
        List<string> winners = new List<string>();
        Map<String,ID> entities = new Map<string,ID>();

        for( Application__c app  :apps){
            if(!winnerNames.contains(app.Name)){
            winnerNames.add(app.Name);
            winners.add(app.Name);
            entities.put(app.Name, app.id);
            }
        }
    }
    
    @isTest static void test_method_RandomDrawBatch() {
        setupTestData();
        
        Set<string> winnerNames = new Set<string>();
        List<string> winners = new List<string>();
        Map<String,ID> entities = new Map<string,ID>();

        for( Application__c app  :apps){
            if(!winnerNames.contains(app.Name)){
            winnerNames.add(app.Name);
            winners.add(app.Name);
            entities.put(app.Name, app.id);
            }
        }
		test.startTest();
            LOT_RandomDrawBatch drawBatch = new LOT_RandomDrawBatch(winners,entities,listing.Id);
            Database.executeBatch(drawBatch);
            drawBatch.calculateRank(winners);
        test.stopTest();
    }
    
    
}