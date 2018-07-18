trigger ApplicationPreference on Application_Preference__c (before delete, before insert, before update, after delete, after insert, after update) {
   // ListingApplicationPreferenceRollupAction.runHandler();

    RollUpSummaryAction.runHandler('Listing_Lottery_Preference__c', 'Total_Submitted_Apps__c','Application_Preference__c','Listing_Preference_ID__c', 'Id','Application_Is_Submitted__c = true AND Receives_Preference__c = true',
                                   new List<String>{'Application_Is_Submitted__c','Receives_Preference__c'});
    RollUpSummaryAction.runHandler('Application_Preference__c', 'Auto_Grant_Count__c','Application_Preference__c','Auto_Grants_Preference__c', 'Id','Receives_Preference__c = true', new List<String>{'Receives_Preference__c'});
            
    RollUpSummaryAction.runHandler('Application__c', 'Preferences_Received_Count__c','Application_Preference__c','Application__c', 'Id','Receives_Preference__c = true', new List<String>{'Receives_Preference__c'});
	
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    system.debug('isEnabled:::' + isEnabled);
	if(!isEnabled) {
    	AppPrefPreLotteryValidation.runHandler();
    	ApplicationPreferenceSetAutoGrantAction.runHandler();
    }
    

}