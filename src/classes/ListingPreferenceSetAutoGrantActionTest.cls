@isTest
public class ListingPreferenceSetAutoGrantActionTest {

    
    @isTest static void ListingPreferenceSetAutoGrantActionTest() {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        Account acc = new Account();
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
        
        Application__c app = new Application__c();
        app.Listing__c = listing.Id;
        insert app;
        
        Lottery_Preference__c lp = new Lottery_Preference__c(Name='Live or Work in San Francisco Preference');
        insert lp;
        Lottery_Preference__c lp2 = new Lottery_Preference__c(Name='Neighborhood Resident Housing Preference (NRHP)',Auto_Grants_Preference__c=lp.Id);
        insert lp2;
        
        Test.startTest();
            Listing_Lottery_Preference__c llp1 = new Listing_Lottery_Preference__c();
            llp1.Listing__c = listing.id;
            llp1.Lottery_Preference__c = lp.Id;
            insert llp1;
        	
        	llp1 = [SELECT Id, Auto_Grants_Preference__c FROM Listing_Lottery_Preference__c];
        	system.assert(llp1.Auto_Grants_Preference__c == null);
        
            Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
            llp.Listing__c = listing.id;
            llp.Lottery_Preference__c = lp2.Id;
            insert llp;
        	
        	llp = [SELECT Id, Auto_Grants_Preference__c FROM Listing_Lottery_Preference__c WHERE ID = :llp.id];
        	system.assert(llp.Auto_Grants_Preference__c == llp1.Id);
        	
            delete llp1;
            llp = [SELECT Id, Auto_Grants_Preference__c FROM Listing_Lottery_Preference__c];
            system.assert(llp.Auto_Grants_Preference__c == null);
            delete llp;
        	
        
        	llp = new Listing_Lottery_Preference__c();
            llp.Listing__c = listing.id;
            llp.Lottery_Preference__c = lp2.Id;
            insert llp;
        	
        	llp = [SELECT Id, Auto_Grants_Preference__c FROM Listing_Lottery_Preference__c WHERE ID = :llp.id];
        	system.assert(llp.Auto_Grants_Preference__c == null);
        
        	llp1 = new Listing_Lottery_Preference__c();
            llp1.Listing__c = listing.id;
            llp1.Lottery_Preference__c = lp.Id;
            insert llp1;
        	
        	llp = [SELECT Id, Auto_Grants_Preference__c FROM Listing_Lottery_Preference__c WHERE ID = :llp.id];
        	system.assert(llp.Auto_Grants_Preference__c == llp1.Id);
        	
            llp.Auto_Grants_Preference__c = null;
            update llp;
        	llp = [SELECT Id, Auto_Grants_Preference__c, Listing__c FROM Listing_Lottery_Preference__c WHERE ID = :llp.id];
            system.assert(llp.Auto_Grants_Preference__c == llp1.Id);
        
        	ListingPreferenceSetAutoGrantAction trg = new ListingPreferenceSetAutoGrantAction(new List<Listing_Lottery_Preference__c>{llp});
            boolean del = trg.shouldRunOnDelete();
            boolean ins = trg.shouldRunOnInsert();
            boolean upd = trg.shouldRunOnUpdate();
        Test.stopTest();
        
    }
    
}