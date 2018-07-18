/**
 * @author:      Ronald Martinez
 * @date:        12/03/2014
 * @description: Trigger for Dalp Requests.
 * @history:     06/09/2015 - Heidi Tang - Edited
 */
trigger SfmohprgramsDalpTrigger on DALP_Request__c (before insert, before update, after insert, after update) {

	SfmohprgramsDalpTriggerHandler handler = new SfmohprgramsDalpTriggerHandler();
    
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    if(!isEnabled) {

    	if((trigger.isAfter && trigger.isInsert)){
        	handler.afterInsert(Trigger.new);
    	} else if((trigger.isAfter && trigger.isUpdate)){
        	handler.afterUpdate(Trigger.oldMap,Trigger.new);
    	}
    }
}