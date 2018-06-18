@isTest
public class ApplicationPrefSetAutoGrantActionTest {
	  static testMethod void ApplicationPrefSetAutoGrantActionTest() {
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

          Lottery_Preference__c lp = new Lottery_Preference__c(Name='Live or Work in San Francisco Preference');
          insert lp;
          Lottery_Preference__c lp2 = new Lottery_Preference__c(Name='Neighborhood Resident Housing Preference (NRHP)',Auto_Grants_Preference__c=lp.Id);
          insert lp2;

          Listing_Lottery_Preference__c llp1 = new Listing_Lottery_Preference__c();
          llp1.Listing__c = listing.id;
          llp1.Lottery_Preference__c = lp2.Id;
          insert llp1;

          Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
          llp.Listing__c = listing.id;
          llp.Lottery_Preference__c = lp.Id;
          insert llp;

          Application__c app = new Application__c();
          app.Listing__c = listing.Id;
          insert app;

          Test.startTest();
              List<Application_Preference__c> appPrefs = [SELECT Id, Auto_Grants_Preference__c, Listing_Preference_ID__c, Application__c, Listing_ID__c FROM Application_Preference__c];
              for (Application_Preference__c appPref : appPrefs) {
                  if (appPref.Listing_Preference_ID__c == llp.Id) {
                      system.assert(appPref.Auto_Grants_Preference__c == null);
                  }
                  if (appPref.Listing_Preference_ID__c == llp1.Id) {
                      system.assert(appPref.Auto_Grants_Preference__c != null);
                  }
              }

          	  /*Application_Preference__c appPref1 = new Application_Preference__c();
              appPref1.Application__c = app.Id;
              appPref1.Listing_Preference_ID__c = llp1.Id;
              insert appPref1;

              appPref1 = [SELECT Id, Auto_Grants_Preference__c FROM Application_Preference__c WHERE Id = :appPref1.Id];
              system.assert(appPref1.Auto_Grants_Preference__c == appPref.Id);

              delete appPref;
              appPref1 = [SELECT Id, Auto_Grants_Preference__c FROM Application_Preference__c WHERE Id = :appPref1.Id];
              system.assert(appPref1.Auto_Grants_Preference__c == NULL);
              delete appPref1;

              appPref1 = new Application_Preference__c();
              appPref1.Application__c = app.Id;
              appPref1.Listing_Preference_ID__c = llp1.Id;
              insert appPref1;

              appPref1 = [SELECT Id, Auto_Grants_Preference__c FROM Application_Preference__c];
              system.assert(appPref1.Auto_Grants_Preference__c == null);

              appPref = new Application_Preference__c();
              appPref.Application__c = app.Id;
              appPref.Listing_Preference_ID__c = llp.Id;
              insert appPref;

              appPref1 = [SELECT Id, Auto_Grants_Preference__c FROM Application_Preference__c WHERE Id = :appPref1.Id];
              system.assert(appPref1.Auto_Grants_Preference__c == appPref.Id);

              appPref1.Auto_Grants_Preference__c = null;
              update appPref1;
              appPref1 = [SELECT Id, Auto_Grants_Preference__c, Application__c, Listing_ID__c FROM Application_Preference__c WHERE Id = :appPref1.Id];
              system.assert(appPref1.Auto_Grants_Preference__c == appPref.Id);*/

							Application_Preference__c prefApp = new Application_Preference__c(Application__c=app.id);
		          insert prefApp;
		          ApplicationPreferenceSetAutoGrantAction trg = new ApplicationPreferenceSetAutoGrantAction(new List<Application_Preference__c>{prefApp});
              boolean del = trg.shouldRunOnDelete();
              boolean ins = trg.shouldRunOnInsert();
              boolean upd = trg.shouldRunOnUpdate();
          Test.stopTest();
    }
}