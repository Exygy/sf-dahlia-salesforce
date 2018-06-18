// *****************************************************************************
// CLASS: ListingFlaggedApplicationAction
// *****************************************************************************
//
// Author: Vertiba/Luke Lim
// Date: 2016-08-13
// Description: Takes DuplicateRecordItems and gets the parent DuplicateRecordSet records 
// 			  : then locates if the parent Flagged_Record_Set exists and if not creates
// 			  : then inserts child records for Flagged_Application__c based on DuplicateRecordItem
// 			  :
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************

public without sharing class ListingFlaggedApplicationAction extends TriggerAction{
   // public static boolean hasRun = true;
       boolean shouldRun;
   
    private Map<ID, DuplicateRecordItem> relaventDupItems { get; set; }
    private Map<Id, Application_Member__c> applicationMap ;
    private Map<Id,DuplicateRecordItem> duplicateRecordItemMap;
    private Map<Id,DuplicateRecordSet> duplicateRecordSetMap;
    
    // trigger controller that accepts trigger data
    public ListingFlaggedApplicationAction (Map<Id,SObject> newMap, Map<Id,SObject> oldMap) {
        super(newMap, oldMap);
        Map<ID,sobject> changedMap = new Map<Id,SObject> ();
        
        for (ID objID: newMap.keyset()) {
            SObject newObj = newMap.get(objID);
            SObject oldObj = oldMap.get(objID);
        }
        
    }
     
    // trigger controller that accepts trigger data
    public ListingFlaggedApplicationAction (Map<Id,SObject> newMap) {
        //listing flagged 
        super(newMap);
  
      	Set<ID> duplicateRecordSetIDS = new Set<ID>();
  	    Set<ID> appMemberIds = new Set<ID>();
  	
        System.debug('newMap************ ' + newMap);
      	Map<ID,DuplicateRecordItem> appMemberToDupRecords = new Map<ID,DuplicateRecordItem> ();
        relaventDupItems = new  Map<ID,DuplicateRecordItem>(); 
        for(Id driId : newMap.keySet()){
           DuplicateRecordItem  duplicateRecordItem = (DuplicateRecordItem)newMap.get(driId);
            if(duplicateRecordItem.RecordId.getSObjectType().getDescribe().getName() == 'Application_Member__c') { // && !appIds.contains(duplicateRecordItem.RecordId))	{
         
             	relaventDupItems.put(driId,duplicateRecordItem);
             	duplicateRecordSetIDS.add(duplicateRecordItem.DuplicateRecordSetID);
             	appMemberIds.add(duplicateRecordItem.RecordId);
             	
            }
        } 

	  	if((relaventDupItems == null) ||(relaventDupItems.size() ==0)){
        	
        	system.debug('no relevant records');
        	return ; //
        }
	         	system.debug('relevant relevant records');
        
        system.debug('relaventDupItems************ ' + relaventDupItems);
        system.debug('duplicateRecordSetIDS************ ' + duplicateRecordSetIDS);
	 
		duplicateRecordItemMap = new Map<Id,DuplicateRecordItem>( [Select d.RecordId, d.Name, d.Id, d.DuplicateRecordSetId From DuplicateRecordItem d where DuplicateRecordSetID in :duplicateRecordSetIDS]);	
		duplicateRecordSetMap = new Map<Id,DuplicateRecordSet>( [select id, rule_name__c, duplicateRuleID from DuplicateRecordSet where id in  :duplicateRecordSetIDS]);
		this.applicationMap = new Map<Id,Application_Member__c>([SELECT Id, Application__c, Application__r.Listing__c FROM Application_Member__c WHERE Id in : appMemberIds]);
		    	
		System.debug('duplicateRecordSetMap************ ' + duplicateRecordSetMap);
        System.debug('duplicateRecordItemMap************ ' + duplicateRecordItemMap);
        System.debug('duplicateRecordItemMapCount************ ' + duplicateRecordItemMap.size());
    }
   
    
    // check if action should run on insert if there are relavent duplicate items
    public override Boolean shouldRunOnInsert() { 
        shouldRun = false;
        if(relaventDupItems != null && !relaventDupItems.isEmpty()){
            shouldRun = true;
        }
        
        return shouldRun; 
    }
    
    public override Boolean shouldRunOnDelete() { return shouldRun; } 
    public override Boolean shouldRunOnUpdate() { return shouldRun; } 
    
    // action method if should run true to process duplicate record items and create flagged application items
    //step 1: take the list of duplicate record sets - create flagged recordsets and upsert them.

	//step 2: get the list of flagged record sets
	
	//step 3: take the list of duplicate record items and create flagged applications from duplicaterecordItems and the flagged recordset map
//    	duplicateRecordSetMap
    public override void doAction() {
    	//step 1: take the list of duplicate record sets - create flagged recordsets and upsert them.
    	Map<Id, Id> dprsIDtoListingID = new  Map<Id, Id>();
    	
		for(DuplicateRecordItem dri : relaventDupItems.values()){
	        dprsIDtoListingID.put(dri.DuplicateRecordSetId, applicationMap.get(dri.RecordId).Application__r.Listing__c);
	    }
	
        System.debug('dprsIDtoListingID************ ' + dprsIDtoListingID);
        
		List<Flagged_Record_Set__c> flaggedRecordSet = upsertFlaggedRecordSets(duplicateRecordSetMap,dprsIDtoListingID);
        
        System.debug('flaggedRecordSet************ ' + flaggedRecordSet);

    	//step 2: get the Map of flagged record set ids to recordset items - to set the parent relationship

    	Map<ID,Flagged_Record_Set__c> flaggedRecordSetMap= new Map<id,Flagged_Record_Set__c > (flaggedRecordSet);
    	Map<ID,ID> drsIDtoFrsID = new Map<ID,ID> ();
    	for (Flagged_Record_Set__c frs : flaggedRecordSet) {
    		drsIDtoFrsID.put(Id.valueof(frs.DuplicateRecordSetID__c),frs.id);
    	}
    	
    	//step 3: upsert the list of duplicate record items
	   	upsertFlaggedRecordItems(duplicateRecordItemMap,drsIDtoFrsID);
	     
    } 
    
    // method called from trigger that checks to know if it should run
    public static void runHandler() {
        
        if (!trigger.isAfter && (!trigger.isInsert )) return;
        
        System.debug('Running ListingFlaggedApplicationAction');
        
    	ListingFlaggedApplicationAction action = new ListingFlaggedApplicationAction(Trigger.newMap);
        if (action.shouldRunOnInsert()) {
            action.doAction(); 
        }
        
    }  
    
       // convert duplicate record sets to flagged record sets
    private List<Flagged_Record_Set__c> upsertFlaggedRecordSets ( Map<Id,DuplicateRecordSet> duplicateRecordSetMap,  Map<Id, Id> dprsIDtoListingID)  {
	 List<Flagged_Record_Set__c> flaggedRecordSets = new List<Flagged_Record_Set__c>();
		for(ID id : duplicateRecordSetMap.keyset() ) {   
			DuplicateRecordSet drs = duplicateRecordSetMap.get(id);
			Flagged_Record_Set__c frs = newFlaggedRecordSet(drs,dprsIDtoListingID);
            System.debug('newFlaggedRecordSet********** ' + frs);
			flaggedRecordSets.add(frs);
		}
        System.debug('flaggedRecordSets********** ' + flaggedRecordSets);
        
        upsert flaggedRecordSets DuplicateRecordSetID__c;
        return flaggedRecordSets;
         
    } 
        // convert duplicate record sets to flagged record sets
    private Flagged_Record_Set__c newFlaggedRecordSet (DuplicateRecordSet dprs,Map<Id, Id> dprsIDtoListingID)  {
        Flagged_Record_Set__c flaggedRecordSet = new Flagged_Record_Set__c();
        flaggedRecordSet = new Flagged_Record_Set__c();
        flaggedRecordSet.DuplicateRecordSetID__c= dprs.Id; // external unique key
        
        flaggedRecordSet.Listing__c = dprsIDtoListingID.get(dprs.Id);
        flaggedRecordSet.Rule_Name__c = dprs.Rule_Name__c;
 
        return flaggedRecordSet;
        
    }
    
           // convert duplicate record sets to flagged record sets
    private List<Flagged_Application__c> upsertFlaggedRecordItems ( Map<Id,DuplicateRecordItem> duplicateRecordItemMap, Map<ID,ID> drsIDtoFrsID )  {
	 List<Flagged_Application__c> flaggedRecordItems = new List<Flagged_Application__c>();
		for(ID id : duplicateRecordItemMap.keyset() ) {   
			DuplicateRecordItem dri = duplicateRecordItemMap.get(id);
			Flagged_Application__c frs = newFlaggedApplication(dri,drsIDtoFrsID);
				flaggedRecordItems.add(frs);
			
		} 
		       		system.debug('flaggedRecordItems : ' + flaggedRecordItems);
		
        upsert flaggedRecordItems DuplicateRecordItem__c;
        return flaggedRecordItems;
         
    }  
     
       // Converts duplicate record items to flagged applications
    private Flagged_Application__c newFlaggedApplication(DuplicateRecordItem dri,Map<ID,ID> drsIDtoFrsID ) {
      
        Flagged_Application__c  flaggedApp = new Flagged_Application__c();
       	Application_Member__c appMember = applicationMap.get(dri.RecordId);
       	if (appMember != null) {
   			flaggedApp.Application__c = appMember.Application__c;
   			flaggedApp.Listing__c = applicationMap.get(dri.RecordId).Application__r.Listing__c;
   		
       	}
       	else {
       		system.debug ('dri.RecordId'  + dri.RecordId);
       		system.debug ('applicationMap' +applicationMap);
       	}
        flaggedApp.DuplicateRecordItem__c = dri.Id;
        //ll -	
        flaggedApp.Flagged_Application_Member__c= dri.RecordId; 
        
		//system.debug ('drsIDtoFrsID'  + drsIDtoFrsID);
       	//system.debug ('dri.Id' +dri.DuplicateRecordSetId);
       	       	//system.debug ('frs.Id' +drsIDtoFrsID.get(dri.DuplicateRecordSetId));
       	
       	flaggedApp.Flagged_Record_Set__c = drsIDtoFrsID.get(dri.DuplicateRecordSetId);
        flaggedApp.System_Flagged__c = true;
         
        return flaggedApp;
    }

}