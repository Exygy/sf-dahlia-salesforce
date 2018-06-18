@isTest
public class RollUpSummaryActionTest {


	 static testmethod void AutoGrantApplicationRollUpTest() {

         List<Application__c> appList = [SELECT ID, Preferences_Received_Count__c FROM Application__c];
         List<Listing_Lottery_Preference__c> lotList = [SELECT ID FROM Listing_Lottery_Preference__c];

         Application_Preference__c appPref = new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id);
         insert appPref;

 		test.startTest();
         appPref.Lottery_Status__c = 'Valid - Added';
         update appPref;

         appList = [SELECT ID, Preferences_Received_Count__c FROM Application__c];
         System.assertEquals(appList[0].Preferences_Received_Count__c, 1);

         Application_Preference__c appPref2 = new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, Lottery_Status__c = 'Valid - Added');
         insert appPref2;

         appList = [SELECT ID, Preferences_Received_Count__c FROM Application__c];
         System.assertEquals(appList[0].Preferences_Received_Count__c, 2);

         appList[0].Status__c = 'Submitted';
         update appList;

         lotList = [SELECT ID, Total_Submitted_Apps__c FROM Listing_Lottery_Preference__c];
      //   System.assertEquals(appList[0].Preferences_Received_Count__c, 2);

         test.stopTest();

    }


	 static testmethod void AutoGrantApplicationPreferenceRollUpTest() {

         List<Application__c> appList = [SELECT ID, Preferences_Received_Count__c FROM Application__c];
         List<Listing_Lottery_Preference__c> lotList = [SELECT ID FROM Listing_Lottery_Preference__c];


 		test.startTest();

         Application_Preference__c appPref = new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id);
         insert appPref;

         Application_Preference__c appPref2 = new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, Auto_Grants_Preference__c = appPref.Id, Lottery_Status__c = 'Valid - Added');
         insert appPref2;

         List<Application_Preference__c> appPrefList = [SELECT ID, Auto_Grant_Count__c FROM Application_Preference__c];

      //   System.assertEquals(appPrefList[0].Auto_Grant_Count__c, 1);

         delete appPref2;

         appPrefList = [SELECT ID, Auto_Grant_Count__c FROM Application_Preference__c];
      //   System.assertEquals(appPrefList[0].Auto_Grant_Count__c, 0);

         test.stopTest();

    }

    @testSetup static void setup() {
        // Creating common data

        Account acc = new Account(Name='Test Account');
        insert acc;

        Development__c dev = new Development__c(Name_of_Development__c='Test Development', Development_City__c = 'San Francisco', Development_State__c = 'CA', Project_ID__c = '123');
        insert dev;

        Building__c build = new Building__c(Property_Name__c='Test Building', Development__c = dev.id);
        insert build;

        Listing__c listing = new Listing__c(Name='Test Listing', Building__c = build.id, Account__c = acc.id);
        insert listing;

        Lottery_Preference__c lotPref = new Lottery_Preference__c(Name='Test Preference', Active__c = true);
        insert lotPref;

        Listing_Lottery_Preference__c listLotPref = new Listing_Lottery_Preference__c(Listing__c = listing.id, Lottery_Preference__c = lotPref.id);
        insert listlotPref;

        Application__c app = new Application__c(Listing__c = listing.id, Application_Submission_Type__c = 'Electronic');
        insert app;


}
}