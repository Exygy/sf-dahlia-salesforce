// *****************************************************************************
// CLASS: ApplicationMemberTrigger
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-01
// Description: Trigger file for Application_Member__c.
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
trigger ApplicationMemberTrigger on Application_Member__c (before insert, before update) {
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    system.debug('isEnabled:::' + isEnabled);
	if(!isEnabled) {
    	system.debug('isEnabled:::' + isEnabled);
		ListingApplicationMemberDuplicateAction.runHandler();
    }
	//ApplicationMemberDuplicateAction.runHandler(); 
}