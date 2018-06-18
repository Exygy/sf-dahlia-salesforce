global class UpdateAttachmentLinkBatch implements Database.Batchable<sObject>{
    
    global UpdateAttachmentLinkBatch() {}
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator('Select id, Parentid from Attachment');
	}

   	global void execute(Database.BatchableContext BC, List<Attachment> scope) {
        
        Map<Id,Attachment> attMap = new Map<Id,Attachment>(scope);
		Set<ID> attachmentIDs = new Set<ID>();
				
		for (Attachment att : attMap.values()) {
		    String objAPIName = att.ParentId.getSObjectType().getDescribe().getName();
		    if (objAPIName.equalsIgnoreCase('Attachment__c')) {
		        attachmentIDs.add(att.Id);
		    }
		}
		
		Set<ID> addedAttachmentIDs = new Set<ID>();
		List<Attachment__c> customAttachmentList = new List<Attachment__c>();
		for (Id attId : attachmentIDs) {
		    if (!addedAttachmentIDs.contains(attMap.get(attId).ParentId)) {
		        customAttachmentList.add(new Attachment__c(Id=attMap.get(attId).ParentId, AttachmentId__c = attId));
		        addedAttachmentIDs.add(attMap.get(attId).ParentId);
		    }
		}
		if (customAttachmentList.size()>0) {
		    update customAttachmentList;
		}
		
	}
	
	global void finish(Database.BatchableContext BC) {
        System.debug('Completed');
	}
}