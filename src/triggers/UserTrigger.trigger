trigger UserTrigger on User (after insert) {

    UserTriggerHandler.runHandler(trigger.new);
}