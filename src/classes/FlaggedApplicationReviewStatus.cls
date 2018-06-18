// ***********************************************************************************
// CLASS: FlaggedApplicationReviewStatus
// ***********************************************************************************
//
// Author: Vertiba/Nish
// Date: 04/04/2018
// Description: Class to change value of Status depending on the review status of flag
// ***********************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// ***********************************************************************************
// 
// ***********************************************************************************

public class FlaggedApplicationReviewStatus extends TriggerAction {
     
	Set<ID> AppIDs;
	public static String fieldToExtract = 'Application__c';
    public static String fieldToCheck = 'Review_Status__c';
    public static String keepInLottery = 'Reviewed - Keep in Lottery';
    public static String removeFromLottery = 'Reviewed - Remove from Lottery';
    
	public FlaggedApplicationReviewStatus (List<SObject> triggerList) {
 		super(triggerList);
		 
    }
    
    public FlaggedApplicationReviewStatus (Map<Id,SObject> triggerNewMap, Map<Id,SObject> triggerOldMap) {
 		super(triggerNewMap,triggerOldMap);

    }
     
    public override boolean shouldRunOnInsert() {
    /*	AppIDs = new Set<ID>();
		
 		for (Sobject fa: triggerList) {
			ID AppId = (ID)fa.get(fieldToExtract);
			if (AppId!=null) {
				AppIDs.add(AppId);
			}
 		}
        if (AppIDs.size()>0) {
        	
            return true;        
        }
        else return false; */
        return false;
    }
    
    public override boolean shouldRunOnDelete() { 
        AppIDs = new Set<ID>();
 		for (Sobject fa: triggerList) {
			ID AppID = (ID)fa.get(fieldToExtract);
			if (AppID != null) {
				AppIDs.add(AppID);
			}
 		}
 		
 		
        if (AppIDs.size()>0) {
            return true;        
        }
        else return false;
    
    } 
    public override boolean shouldRunOnUpdate() {
        AppIDs = new Set<ID>();

	    for (ID theID: triggerNewMap.keyset()) {
	    	Sobject newFA = triggerNewMap.get(theID);
	    	Sobject oldFA = triggerOldMap.get(theID);
            
            ID AppID = (ID)newFA.get(fieldToExtract);

			if (newFA.get(fieldToCheck) != oldFA.get(fieldToCheck)){
				AppIDs.add(AppID);
			}
	 
	    }
    
    	
        if (AppIDs.size()>0) {
            return true;        
        }
        else return false;
        
    } 

    public override void doAction() {
        
        /********************************************************************************************************************************************************/
        /********** Check flagged apps in other FRS and set status to 'removed' if atleast one of the application's flag is 'remove from lottery' ***************/
        /********************************************************************************************************************************************************/
        
		Map<ID,String> faMap = new Map<ID,String>();
        List<Flagged_Application__c> faList = [SELECT ID, Application__c, Review_Status__c FROM Flagged_Application__c WHERE Application__c IN : AppIDs Order By Application__c];
        
        for(Flagged_Application__c fa : faList) {
            if(!faMap.containsKey(fa.Application__c)) {
                faMap.put(fa.Application__c, keepInLottery);
            }
            
            
            if(fa.get(fieldToCheck) == removeFromLottery) {
                faMap.put(fa.Application__c, removeFromLottery);
            }
        }
        
        List<Application__c> appList = [SELECT ID, Status__c FROM Application__c WHERE ID IN : faMap.keySet()];
        
        for(Application__c app : appList) {
            if(faMap.get(app.Id) == keepInLottery) {
                app.Status__c = 'Submitted';
            }
            else if(faMap.get(app.Id) == removeFromLottery) {
                app.Status__c = 'Removed';
            }
        }
        
        if (appList.size()>0) {
			update appList;
		}
		
		
   
    }
    
    public static void runHandler() {
       
        if (trigger.isAfter && trigger.isUpdate) {
            FlaggedApplicationReviewStatus action = new FlaggedApplicationReviewStatus(trigger.newMap, trigger.oldMap);
            if (action.shouldRunOnUpdate())  
            	action.doAction(); 
            return;
        }
        
        if (trigger.isAfter && trigger.isDelete){ 
            FlaggedApplicationReviewStatus action = new FlaggedApplicationReviewStatus(Trigger.old);
			if (action.shouldRunOnDelete())  
			     action.doAction(); 
            return;
            
        }
        
        
    }
    
}