public class ApexSharingRuleBatch implements Database.Batchable<Sobject>, Database.Stateful {
	
    String queryTarget;
	Set<Id> parentIDS;
    String shareObject;
	String objToQuery;
	String whereClause;
	String parentField;
	String targetField;
    Map<ID,Boolean> ParentFieldValueMap;
    
    public ApexSharingRuleBatch(Set<Id> parentIDS, String shareObject, String objToQuery, String whereClause, String parentField, String targetField, Map<ID,Boolean> ParentFieldValueMap) {
        this.parentIDS = parentIDS;
        this.shareObject = shareObject;
		this.objToQuery = objToQuery;
		this.whereClause = whereClause;
		this.parentField = parentField;
		this.targetField = targetField;
        this.ParentFieldValueMap = ParentFieldValueMap;
        
        queryTarget = 'SELECT ' + parentField;
        queryTarget += (parentField != whereClause) ? ', ' + whereClause : ''; 
        queryTarget += ' FROM ' + objToQuery + ' WHERE ' + whereClause + ' IN :parentIDS'; 
        List<Sobject> targetList = Database.query(queryTarget);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(queryTarget);
	}
    
    public void execute(Database.BatchableContext BC, List<Sobject> scope) {
        List<ID> contactIDs = new List<ID>();
        List<ID> targetIDs = new List<ID>();
        
        for(Sobject result : scope) {
            targetIDs.add((ID)result.get(parentField));
        }

        List<Contact> contactList = [SELECT ID FROM Contact WHERE AccountId IN :targetIDs];
        for(Contact c : contactList) {
            contactIDs.add(c.Id);
        }
        
        String queryUsers = 'SELECT Id, Contact.AccountId FROM User WHERE ContactId IN :contactIDs AND profile.Name = \'MOHCD - Leasing Agent Partner\'';
        
        List<User> userList = Database.query(queryUsers);

		List<Sobject> objectShareListToInsert = new List<Sobject>();
		List<Sobject> objectShareListToDelete = new List<Sobject>();

        for (Sobject result: scope) {  
			
			for(User user : userList) {	

				if(result.get(parentField) == user.Contact.AccountId) {

            		sObject objectShare = Schema.getGlobalDescribe().get(shareObject).newSObject() ;
            
            		// Set the ID of record being shared.
      				objectShare.put('ParentId', result.Id);
        
      				// Set the ID of user or group being granted access.
      				objectShare.put('UserOrGroupId', user.Id);
        
      				// Set the access level.
      				objectShare.put('AccessLevel','Edit');
        
      				// Set rowCause to 'manual' for manual sharing.
      				objectShare.put('RowCause','Leasing_Agent_Listing_Share__c');

                    if(ParentFieldValueMap.get((ID)result.get(whereClause)) != null && ParentFieldValueMap.get((ID)result.get(whereClause)) == true) {
      					objectShareListToInsert.add(objectShare);
                    }
                    else if(ParentFieldValueMap.get((ID)result.get(whereClause)) != null && ParentFieldValueMap.get((ID)result.get(whereClause)) == false) {
      						objectShareListToDelete.add(objectShare);
                    }
				}
			}
            
        }
        
        System.debug(objectShareListToInsert);
        if (objectShareListToInsert.size()>0) {
			insert objectShareListToInsert;
		}
		
		if (objectShareListToDelete.size()>0) {
            Set<ID> objectShareParentIDs = new Set<ID>();
            for(Sobject obj : objectShareListToDelete) {
                objectShareParentIDs.add((ID)obj.get('ParentId'));
            }
            List<Sobject> objectShareIDs = Database.query('SELECT Id FROM ' + shareObject + ' WHERE ParentID IN :objectShareParentIDs AND RowCause = \'Leasing_Agent_Listing_Share__c\'');
			delete objectShareIDs;
		}
    }
    
    public void finish(Database.BatchableContext BC) {
			System.debug('Batch run successful');
    }
    
}