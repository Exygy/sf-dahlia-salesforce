public with sharing class ListingApplicationBigObjectAction extends TriggerAction {
	
	private static final String LEASEUP = 'Lease Up';
	Set<ID> listingIDs;
	
    public ListingApplicationBigObjectAction(List<SObject> triggerList) {
		super(triggerList);
	}
	
	public ListingApplicationBigObjectAction(Map<Id,SObject> triggerNewMap, Map<Id,SObject> triggerOldMap) {
		super(triggerNewMap,triggerOldMap);
	}
	
	public override boolean shouldRunOnInsert() {
    	listingIDs = new Set<ID>();
        
 		for (Sobject sobj: triggerList) {
			ID listingID = (ID)sobj.get('Id');
			if ((String)sobj.get('Status__c') == LEASEUP) {
				listingIDs.add(listingID);
			}
 		}
        if (listingIDs.size()>0) {
            return true;
        }
        else return false;
        
    }
    public override boolean shouldRunOnDelete() { 
        return false;
    } 
    
    public override boolean shouldRunOnUpdate() {
        listingIDs = new Set<ID>();
        
	    for (ID theID : triggerNewMap.keyset()) {
	    	SObject newObj = triggerNewMap.get(theID);
	    	SObject oldObj = triggerOldMap.get(theID);
			String newFieldValue = (String)newObj.get('Status__c');
			String oldFieldValue = (String)oldobj.get('Status__c');
			if (newFieldValue == LEASEUP && newFieldValue != oldFieldValue) {
				listingIDs.add(theID);
			}
	    }

        if (listingIDs.size()>0) {
            return true;        
        }
        else return false;
        
    } 
	
	
	public override void doAction() {
    	//insertRecords(listingIDs);
        if (!Test.isRunningTest()) {
    		ID jobID = System.enqueueJob(new ListingApplicationBigObjectQueueable(listingIDs));
        }
    }
	
	/*@future
	public static void insertRecords(Set<Id> listingIDs) {
		List<API_LeaseUp_Application.ShortForm> shortForms = API_LeaseUp_ApplicationService.getShortformByListingIds(listingIDs);
    	List<ShortForm_Application__b> shortformBigList = new List<ShortForm_Application__b>();
    	List<Person__b> personBigList = new List<Person__b>();
    	List<ShortForm_Preference__b> shortformAppBigList = new List<ShortForm_Preference__b>();
    	
    	for (API_LeaseUp_Application.ShortForm sf : shortForms) {
    		shortformBigList.add(sf.toApplicationBig());
    		if (sf.primaryApplicant != null) {
    			personBigList.add(sf.primaryApplicant.toPersonBig());
    		}
    		if (sf.alternateContact != null) {
    			personBigList.add(sf.alternateContact.toPersonBig());
    		}
    		for (API_LeaseUp_Application.Person p : sf.householdMembers) {
    			personBigList.add(p.toPersonBig());
    		}
    		for (API_LeaseUp_Application.ShortFormPreference sfp : sf.shortFormPreferences) {
    			shortformAppBigList.add(sfp.toApplicationPreferenceBig());
    		}
    	}
    	if (shortformBigList.size() > 0) {
    		try {
	    		system.debug(LoggingLevel.INFO,'shortformBigList:::' + shortformBigList);
	    		List<Database.SaveResult> saveResultList = database.insertImmediate(shortformBigList);
	    		for (Database.SaveResult saveResult : saveResultList) {
					system.debug('success:::' + saveResult.isSuccess() + ':::' + saveResult);
	    		}
			} catch (DMLException e) {
    			system.debug(LoggingLevel.INFO,'error:::' + e.getMessage());
    		}
    	}
    	if (personBigList.size() > 0) {
    		system.debug(LoggingLevel.INFO,'personBigList:::' + personBigList);
    		List<Database.SaveResult> saveResultList = database.insertImmediate(personBigList);
			for (Database.SaveResult saveResult : saveResultList) {
				system.debug('success:::' + saveResult.isSuccess() + ':::' + saveResult);
    		}
		}
    	if (shortformAppBigList.size() > 0) {
    		system.debug(LoggingLevel.INFO,'shortformAppBigList:::' + shortformAppBigList);
    		List<Database.SaveResult> saveResultList = database.insertImmediate(shortformAppBigList);
			for (Database.SaveResult saveResult : saveResultList) {
				system.debug('success:::' + saveResult.isSuccess() + ':::' + saveResult);
    		}
		}
	}*/
	
	
	public static void runHandler() {
       
        if (trigger.isAfter && trigger.isInsert) {
            ListingApplicationBigObjectAction action = new ListingApplicationBigObjectAction(trigger.new);
            if (action.shouldRunOnInsert()) {
            	action.doAction();
            }
            return;
        }
        if (trigger.isAfter && trigger.isUpdate) {
            ListingApplicationBigObjectAction action = new ListingApplicationBigObjectAction(trigger.newMap, trigger.oldMap);
            if (action.shouldRunOnUpdate()) {
            	action.doAction(); 
            }
            return;
        }
        
        if (trigger.isAfter && (trigger.isDelete)){ 
            ListingApplicationBigObjectAction action = new ListingApplicationBigObjectAction(Trigger.old);
			if (action.shouldRunOnDelete())  
			     action.doAction(); 
            return;
        }
    }
    
}