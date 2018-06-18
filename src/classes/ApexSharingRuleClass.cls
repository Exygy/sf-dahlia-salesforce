public with sharing class ApexSharingRuleClass extends TriggerAction {
	
	String shareObject;
	String objToQuery;
	String whereClause;
	String parentField;
	String targetField;
	Set<ID> parentIDs;
	Map<ID,Boolean> ParentFieldValueMap;
	
	public ApexSharingRuleClass(List<SObject> triggerList, String shareObject, String objToQuery, String whereClause, String parentField, String targetField) {
		super(triggerList);
		this.shareObject = shareObject;
		this.objToQuery = objToQuery;
		this.whereClause = whereClause;
		this.parentField = parentField;
		this.targetField = targetField;
	}
	
	public ApexSharingRuleClass(Map<Id,SObject> triggerNewMap, Map<Id,SObject> triggerOldMap, String shareObject, String objToQuery, String whereClause, String parentField, String targetField) {
		super(triggerNewMap,triggerOldMap);
		this.shareObject = shareObject;
		this.objToQuery = objToQuery;
		this.whereClause = whereClause;
		this.parentField = parentField;
		this.targetField = targetField;
	}
	
	public override boolean shouldRunOnInsert() {
    	parentIDs = new Set<ID>();
        ParentFieldValueMap = new Map<ID,Boolean>();
		
 		for (Sobject sobj: triggerList) {
			ID parentID = (ID)sobj.get('Id');
			Boolean newFieldValue = (Boolean)sobj.get(targetField);
			if (newFieldValue==true) {
					parentIDs.add(parentID);
					ParentFieldValueMap.put(parentID,newFieldValue);
			}
 		}
        if (parentIDs.size()>0) {
        	
            return true;        
        }
        else return false;
        
    }
    public override boolean shouldRunOnDelete() { 
        parentIDs = new Set<ID>();
        ParentFieldValueMap = new Map<ID,Boolean>();
        
 		for (Sobject sobj: triggerList) {
			ID parentID = (ID)sobj.get('Id');
			if (parentID!=null) {
				parentIDs.add(parentID);
			}
 		}
 		
 		
        if (parentIDs.size()>0) {
            return true;        
        }
        else return false;
    
    } 
    
    public override boolean shouldRunOnUpdate() {
        parentIDs = new Set<ID>();
        ParentFieldValueMap = new Map<ID,Boolean>();

	    for (ID theID : triggerNewMap.keyset()) {
	    	SObject newObj = triggerNewMap.get(theID);
	    	SObject oldObj = triggerOldMap.get(theID);
			Boolean newFieldValue = (Boolean)newObj.get(targetField);
			Boolean oldFieldValue = (Boolean)oldobj.get(targetField);
			if (newFieldValue!=oldFieldValue) {
					parentIDs.add(theID);
					ParentFieldValueMap.put(theID,newFieldValue);
			}
	    }

        if (parentIDs.size()>0) {
            return true;        
        }
        else return false;
        
    } 
	
	
	public override void doAction() {
    	Id JobId = Database.executeBatch(new ApexSharingRuleBatch(parentIDS, shareObject, objToQuery, whereClause, parentField, targetField, ParentFieldValueMap));
		
	}
	
	
	public static void runHandler(String shareObject, String objToQuery, String whereClause, String parentField, String targetField) {
       
        if (trigger.isAfter && trigger.isInsert) {
            ApexSharingRuleClass action = new ApexSharingRuleClass(trigger.new, shareObject, objToQuery, whereClause, parentField, targetField);
            if (action.shouldRunOnInsert())  
            	action.doAction(); 
            return;
        }
        if (trigger.isAfter && trigger.isUpdate) {
            ApexSharingRuleClass action = new ApexSharingRuleClass(trigger.newMap, trigger.oldMap, shareObject, objToQuery, whereClause, parentField, targetField);
            if (action.shouldRunOnUpdate())  
            	action.doAction(); 
            return;
        }
        
        if (trigger.isAfter && (trigger.isDelete)){ 
            ApexSharingRuleClass action = new ApexSharingRuleClass(Trigger.old, shareObject, objToQuery, whereClause, parentField, targetField);
			if (action.shouldRunOnDelete())  
			     action.doAction(); 
            return;
            
        }
    
}
    
}