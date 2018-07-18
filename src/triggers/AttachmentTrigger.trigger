trigger AttachmentTrigger on Attachment (after delete, after insert, after update, before delete, before insert, before update) {
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    system.debug('isEnabled:::' + isEnabled);
	if(!isEnabled) {
    	AttachmentAction.runHandler();
    }
}