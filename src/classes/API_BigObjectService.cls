global class API_BigObjectService {
    
    global static API_LeaseUp_Application.ShortForm getBigObjectRecordBySnapshotId(string snapshotId) {
        List<ShortForm_Application__b> sfa = [SELECT Id, Housing_Counselling_Agency__c, Which_One__c, Other__c, Reserved_Senior__c,ADA_Priorities_Selected__c,Agree_To_Terms__c,Annual_Income__c,Answered_Community_Screening__c,Application__c,Application_Language__c,Application_Record_Type__c,Application_Submission_Date__c,Application_Submission_Type__c,External_Session_Id__c,Form_Metadata__c,Has_Developmental_Disabilities__c,Has_Military_Service__c,Has_Public_Housing__c,Household_Assets__c,Household_Total_Income_With_Assets__c,Household_Vouchers_Subsidies__c,Listing_ID__c,Lottery_Number__c,Lottery_Number_Manual__c,Monthly_Income__c,Name__c,Number_Of_Dependents__c,Processing_Status__c,Referral__c,Rental_Assistance__c,Snapshot_ID__c,Status__c,Total_Monthly_Rent__c FROM ShortForm_Application__b WHERE Snapshot_ID__c = :snapshotId LIMIT 1];
        
        Id shorformId;
        if(sfa.size() > 0 && sfa.size() == 1){
        	shorformId = sfa[0].Application__c;
        	List<Person__b> hms = [SELECT Id, Address__c,Agency__c,Alternate_Contact_Type__c,Alternate_Contact_Type_Other__c,Alternate_Phone__c,Alternate_Phone_Type__c,Application__c,Application_Member__c,Application_Member_Type__c,Candidate_Score__c,City__c,Contact_Id__c,Date_Of_Birth__c,Email__c,Ethnicity__c,First_Name__c,Gender__c,Gender_Other__c,Has_Alternate_Mailing_Address__c,Has_Same_Address_As_Applicant__c,HIV__c,Language__c,Language_Other__c,Last_Name__c,Locator_Used__c,Mailing_Address__c,Mailing_City__c,Mailing_State__c,Mailing_Zip__c,Marital_Status__c,Middle_Name__c,Nickname__c,No_Address__c,No_Email__c,No_Phone__c,Phone__c,Phone_Type__c,Preference_Address_Match__c,Race__c,Relationship__c,Sex_At_Birth__c,Sexual_Orientation__c,Sexual_Orientation_Other__c,State__c,Web_App_Id__c,Work_In_SF__c,X_Coordinate__c,Y_Coordinate__c,Zip__c FROM Person__b WHERE Application__c = :shorformId];
            List<ShortForm_Preference__b> appPrefs = [SELECT Id, Application__c,Application_Member_Id__c,Application_Preference__c,Certificate_Number__c,Individual_Preference__c,LW_Preference_Proof__c,Listing_Preference_Id__c,Natural_Key__c,Opt_Out__c,Preference_Proof__c,Record_Type_Developer_Name__c,Requires_Proof__c FROM ShortForm_Preference__b WHERE Application__c = :shorformId];
            return new API_LeaseUp_Application.ShortForm(sfa[0],hms,appPrefs);
        }
        else return null;
    }
    
    /*global virtual class ShortForm_Application {
        global String snapshotId;
        global String listingId;
        global String applicationId;
        
        global ShortForm_Application() {}
        
        global ShortForm_Application(ShortForm_Application__b app) {
            this.snapshotId = app.Snapshot_ID__c;
            this.listingId = app.Listing_ID__c;
            this.applicationId = app.Application__c;
        }
    }*/
}