/**
 * @author:      Kimiko Roberto
 * @date:        06/05/2014
 * @description: Trigger for Personal Assets.
 * @history:     06/09/2015 - Heidi Tang - Edited
 */
trigger SfmohprgramsPersonalAssetTrigger on Personal_Asset__c (before insert) {
    
	SfmohprgramsPersonalAssetTriggerHandler handler = new SfmohprgramsPersonalAssetTriggerHandler();

    if(trigger.isBefore && trigger.isInsert){
        Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    	if(!isEnabled) {
    		handler.beforeInsert(Trigger.new);
        }
    }
}