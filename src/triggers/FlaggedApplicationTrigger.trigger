trigger FlaggedApplicationTrigger on Flagged_Application__c (before insert, after insert, before update, after update, after delete) {

    if((trigger.isAfter && trigger.isUpdate) || (trigger.isAfter && trigger.isDelete)) {
        FlaggedApplicationReviewStatus.runHandler();
    }
}