@isTest(SeeAllData=true)
public class FlaggedApplicationReviewStatusTest {

    public static testmethod void runFlagTest() {
        
      /*  Listing__c listing = new Listing__c();
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
        
        Application_Member__c appMember1 = new Application_Member__c(First_Name__c='FirstTest',Last_Name__c='FirstTest',Date_of_Birth__c=Date.newInstance(2016, 12, 9), Application__c = app.id);
        insert appMember1;
        
        Application_Member__c appMember2 = new Application_Member__c(First_Name__c='FirstTest',Last_Name__c='FirstTest',Date_of_Birth__c=Date.newInstance(2016, 12, 9), Application__c = app.id);
        insert appMember2; */
        
        Flagged_Application__c fa = [SELECT ID, Application__c, Review_Status__c, Flagged_Record_Set__c FROM Flagged_Application__c Limit 1];
        fa.Review_Status__c = 'Reviewed - Remove from Lottery';
        update fa;
        
        Flagged_Application__c faInsert = new Flagged_Application__c(Application__c = fa.Application__c, Flagged_Record_Set__c = fa.Flagged_Record_Set__c, Review_Status__c = 'Reviewed - Remove from Lottery');
        insert faInsert;
        
        delete faInsert;
    }
}