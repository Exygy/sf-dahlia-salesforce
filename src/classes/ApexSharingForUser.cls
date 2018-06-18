public class ApexSharingForUser implements Database.Batchable<Sobject>, Database.Stateful {
	
    String queryTarget;
	Map<Id,Id> accountUserMap;
    String shareObject;
	String objToQuery;
	String whereClause;
	String parentField;
	String targetField;
    Set<Id> accountIdSet;
    
    public ApexSharingForUser(Map<Id,Id> accountUserMap, String shareObject, String objToQuery, String whereClause, String parentField, String targetField) {
        this.accountUserMap = accountUserMap;
        this.shareObject = shareObject;
		this.objToQuery = objToQuery;
		this.whereClause = whereClause;
		this.parentField = parentField;
		this.targetField = targetField;
        accountIdSet = accountUserMap.keySet();
        
        queryTarget = 'SELECT ' + parentField;
        queryTarget += (parentField != whereClause) ? ', ' + whereClause : ''; 
        queryTarget += ' FROM ' + objToQuery + ' WHERE ' + parentField + ' IN :accountIdSet AND ' + targetField + ' = true'; 
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(queryTarget);
	}
    
    public void execute(Database.BatchableContext BC, List<Sobject> scope) {
		List<Sobject> shareObjToInsert = new List<Sobject>();
        
        for (Sobject result: scope) {  
			
			if(accountUserMap.get((ID)result.get(parentField)) != null) {

            		sObject objectShare = Schema.getGlobalDescribe().get(shareObject).newSObject() ;
            
            		// Set the ID of record being shared.
      				objectShare.put('ParentId', result.Id);
        
      				// Set the ID of user or group being granted access.
      				objectShare.put('UserOrGroupId', (ID)accountUserMap.get((ID)result.get(parentField)));
        
      				// Set the access level.
      				objectShare.put('AccessLevel','Edit');
        
      				// Set rowCause to 'manual' for manual sharing.
      				objectShare.put('RowCause','Leasing_Agent_Listing_Share__c');

                	shareObjToInsert.add(objectShare);
                    
			}
            
        }
        
        if (shareObjToInsert.size()>0) {
			insert shareObjToInsert;
		}
    }
    
    public void finish(Database.BatchableContext BC) {
			System.debug('Batch run successful');
    }
    
}