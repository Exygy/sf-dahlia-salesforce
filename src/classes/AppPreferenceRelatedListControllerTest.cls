@isTest
public class AppPreferenceRelatedListControllerTest {
	static testMethod void testApplicationPreferenceRelatedListController() {
        Listing__c listing = new Listing__c();
        listing.Name = 'Test';
        insert listing;
        
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Active__c = true;
        insert lp;
        
        Application__c app = new Application__c();
        app.Listing__c = listing.Id;
        app.Status__c = 'Submitted';
        insert app;
        
        Application_Preference__c appPref = new Application_Preference__c();
        appPref.Application__c = app.Id;
        insert appPref;
                        
        Test.startTest();
        	AppPreferenceRelatedListController ctrl = new AppPreferenceRelatedListController(new ApexPages.StandardController(app));
        	ctrl.EditApp();
        	List<Application_Preference__c> appPrefList = [SELECT Id FROM Application_Preference__c];
        	system.debug('appPrefList::' + appPrefList);
        	system.assertEquals(appPrefList.size(), 1);
        	ctrl.currentAppPrefId = appPrefList[0].Id;
        	ctrl.saveAppPref();
        	ctrl.cancel();
        	ctrl.DelApp();
        	appPrefList = [SELECT Id FROM Application_Preference__c];
        	system.debug('appPrefList::' + appPrefList);
        	system.assertEquals(appPrefList.size(), 0);
        Test.stopTest();
    }
}