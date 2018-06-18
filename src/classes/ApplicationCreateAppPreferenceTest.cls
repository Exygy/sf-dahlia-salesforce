@isTest
public class ApplicationCreateAppPreferenceTest {
    static testMethod void testApplicationCreateAppPreference() {
        Listing__c listing = new Listing__c();
        listing.Name = 'Test';
        insert listing;
        
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Active__c = true;
        insert lp;
        
        Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
        llp.Listing__c = listing.Id;
        llp.Lottery_Preference__c = lp.Id;
        insert llp;
        
        Application__c app = new Application__c();
        app.Listing__c = listing.Id;
        app.Status__c = 'Submitted';
        insert app;
        
        Application_Preference__c appPref = new Application_Preference__c();
        appPref.Application__c = app.Id;
        insert appPref;
                
    }

}