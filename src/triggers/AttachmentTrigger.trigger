trigger AttachmentTrigger on Attachment (after delete, after insert, after update, before delete, before insert, before update) {
    AttachmentAction.runHandler();
}