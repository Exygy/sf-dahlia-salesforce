/**
 * @author:      Kimiko Roberto
 * @date:        06/05/2014
 * @description: Trigger for Financial Applications.
 * @history:     06/01/2015 - Heidi Tang - Edited
 */
trigger SfmohprogramsFinAppTrigger on Financial_Application__c (before insert,after insert) {

	SfmohprogramsFinAppTriggerHandler handler = new SfmohprogramsFinAppTriggerHandler();
	
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    if(!isEnabled) {
    	if(trigger.isBefore && trigger.isInsert){
    		handler.beforeInsert(Trigger.new);
    	} else if((trigger.isAfter && trigger.isInsert)){
    		handler.afterInsert(Trigger.new);
    	}
    }
}