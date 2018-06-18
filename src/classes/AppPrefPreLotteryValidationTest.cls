@isTest
public class AppPrefPreLotteryValidationTest {


	 static testmethod void PreLotteryValidationTest() {
         
        String RT_RB_AHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'RB_AHP');
    	String RT_COP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'COP');
    	String RT_DTHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'DTHP');
    	String RT_L_W = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'L_W');
    	String RT_NRHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'NRHP');
    	String RT_AG = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'AG');
    	String RT_Custom = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'Custom');
    	String RT_ADHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'ADHP');

         List<Application__c> appList = [SELECT ID, Preferences_Received_Count__c FROM Application__c];
         List<Listing_Lottery_Preference__c> lotList = [SELECT ID FROM Listing_Lottery_Preference__c];
         List<Application_Preference__c> appPrefList = new List<Application_Preference__c>();

         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_RB_AHP, Individual_preference__c = 'Assisted Housing'));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_COP));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_DTHP));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_L_W));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_NRHP));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_AG));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_Custom));
         appPrefList.add(new Application_Preference__c(Application__c = appList[0].Id, Listing_Preference_ID__c = lotList[0].Id, RecordTypeId = RT_ADHP));
         
         test.startTest();
         insert appPrefList;
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