// *****************************************************************************
// CLASS: ApplicationTrigger
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-02
// Description: Trigger file for Application__c.
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
trigger ApplicationTrigger on Application__c (before update, after update, after insert, after delete) {
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    if(!isEnabled) {
    	ListingApplicationStatusChangeAction.runHandler(); 
    	ApplicationCreateAppPreferenceAction.runHandler();
        
        						//runHandler(String shareObject, String objToQuery, String whereClause, String parentField, String targetField)
    	if (trigger.isAfter && trigger.isInsert || trigger.isAfter && trigger.isDelete) {
			ApexSharingRuleClass.runHandler('Application__Share', 'Application__c', 'Id', 'Account__c', 'Listing_Shared__c');
    	}
    }
    
    rollUpSummaryAction.runHandler('Listing_Lottery_Preference__c', 'Total_Submitted_Apps__c','Application_Preference__c', 'Listing_Preference_ID__c','Id','Application_Is_Submitted__c = true AND Receives_Preference__c = true', 'Application__c', 'Status__c',
                                   new List<String>{'Application_Is_Submitted__c','Receives_Preference__c'});
    /*rollUpSummaryAction.runHandler('Listing__c', 'nConfirmed_Duplicate_Applications__c','Application__c', 'Listing__c','Id','of_Reviewed_Flagged_Applications__c > 0', 
                                   new List<String>{'of_Reviewed_Flagged_Applications__c'});*/
    rollUpSummaryAction.runHandler('Listing__c', 'nGeneral_Application_Total__c','Application__c', 'Listing__c','Id','(Preferences_Received_Count__c = 0 OR Preferences_Received_Count__c = NULL)', /*'Application__c', 'Status__c',*/
                                   new List<String>{'Preferences_Received_Count__c'});
    rollUpSummaryAction.runHandler('Listing__c', 'nRemoved_from_Lottery__c','Application__c', 'Listing__c','Id','Status__c = \'Removed\'', /*'Application__c', 'Status__c',*/
                                   new List<String>{'Status__c'});
    rollUpSummaryAction.runHandler('Listing__c', 'nSubmitted_Applications__c','Application__c', 'Listing__c','Id','(Status__c = \'Submitted\' OR Status__c = \'Removed\')', /*'Application__c', 'Status__c',*/
                                   new List<String>{'Status__c'});
    rollUpSummaryAction.runHandler('Listing__c', 'nTotal_Applications__c','Application__c', 'Listing__c','Id','Name != null', /*'Application__c', 'Status__c',*/
                                   new List<String>{'Name'});
    rollUpSummaryAction.runHandler('Listing__c', 'nFlagged_Applications__c','Application__c', 'Listing__c','Id','Number_of_Flags__c > 0', /*'Application__c', 'Status__c',*/
                                   new List<String>{'Number_of_Flags__c'});
    rollUpSummaryAction.runHandler('Listing__c', 'Lease_Signed_Application__c','Application__c', 'Listing__c','Id','Processing_Status__c = \'Lease Signed\'',
                                   new List<String>{'Processing_Status__c'});
    
    						
    
 //  ApplicationStatusChangeAction.runHandler(); 

}