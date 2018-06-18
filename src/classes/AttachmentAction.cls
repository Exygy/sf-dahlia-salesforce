public with sharing class AttachmentAction extends TriggerAction {
    private Set<ID> attachmentIDs;
    private Map<ID,Attachment> attachmentNewMap;
    
    public AttachmentAction (Map<ID,SObject> objsMap) {
		
		super(objsMap);
		
		attachmentNewMap = (Map<ID,Attachment>)objsMap;
		attachmentIDs = new Set<ID>();
		for (Id objId : objsMap.keySet()) {
			Attachment att = (Attachment) objsMap.get(objId);
			String objAPIName = att.ParentId.getSObjectType().getDescribe().getName();
			if (objAPIName.equalsIgnoreCase('Attachment__c')) {
				attachmentIDs.add(att.Id);
			}
		}
	}
	
	public override boolean shouldRunOnInsert() {
		return true;
		
	}
	public override boolean shouldRunOnDelete() { 
		return true;
	
	} 
	public override boolean shouldRunOnUpdate() {
		return true;
		
	} 
	
	public override void doAction() {
		List<Attachment__c> customAttachmentList = new List<Attachment__c>();
		for (Id attId : attachmentIDs) {
			customAttachmentList.add(new Attachment__c(Id=attachmentNewMap.get(attId).ParentId, AttachmentId__c = attId));
		}
		if (customAttachmentList.size()>0) {
			update customAttachmentList;
		}
	}
	
	public static void runHandler() {
    	if (trigger.isAfter && trigger.isInsert){
        	AttachmentAction action = new AttachmentAction(Trigger.newMap);
            action.doAction(); 
            return;
        }
    }
}