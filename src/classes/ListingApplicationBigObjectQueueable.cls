public class ListingApplicationBigObjectQueueable implements Queueable {
    
    public Set<Id> listingIDs;
    
    public ListingApplicationBigObjectQueueable(Set<Id> listingIDs) {
    	this.listingIDs = listingIDs;
    }
    
    public void execute(QueueableContext context) {
        List<API_LeaseUp_Application.ShortForm> shortForms = API_LeaseUp_ApplicationService.getShortformByListingIds(listingIDs);
    	List<ShortForm_Application__b> shortformBigList = new List<ShortForm_Application__b>();
    	List<Person__b> personBigList = new List<Person__b>();
    	List<ShortForm_Preference__b> shortformAppBigList = new List<ShortForm_Preference__b>();
    	
    	Map<String, Schema.DescribeFieldResult> shortformBigFieldMap =  getStringFieldDescribeMap('ShortForm_Application__b');
    	Map<String, Schema.DescribeFieldResult> personBigFieldMap =  getStringFieldDescribeMap('Person__b');
    	Map<String, Schema.DescribeFieldResult> shortformAppBigFieldMap =  getStringFieldDescribeMap('ShortForm_Preference__b');
    	
    	
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
    		
    		for (ShortForm_Application__b sfb : shortformBigList) {
    			for (Schema.DescribeFieldResult sfbField : shortformBigFieldMap.values()) {
    				String sfbFieldName = sfbField.getName();
    				if (sfb.get(sfbFieldName) != null) {
    					system.debug('sfbFieldName:::' + sfbFieldName);
						system.debug('sfbFieldType:::' + sfbField.getType());
						system.debug('sfbFieldVal:::' + sfb.get(sfbFieldName));
						sfb.put(sfbFieldName,getMatchingFieldValue(sfbFieldName, (String)sfb.get(sfbFieldName), sfbField.getLength()));
    				}
    			}
    		}
    		
    		
			system.debug(LoggingLevel.INFO,'shortformBigList:::' + shortformBigList);
    		List<Database.SaveResult> saveResultList = database.insertImmediate(shortformBigList);
    		for (Database.SaveResult saveResult : saveResultList) {
				system.debug('success:::' + saveResult.isSuccess() + ':::' + saveResult);
    		}
		}
    	if (personBigList.size() > 0) {
    		
    		for (Person__b pb : personBigList) {
    			for (Schema.DescribeFieldResult pbField : personBigFieldMap.values()) {
    				String pbFieldName = pbField.getName();
    				if (pb.get(pbFieldName) != null) {
    					system.debug('pbFieldName:::' + pbFieldName);
						system.debug('pbFieldType:::' + pbField.getType());
						system.debug('pbFieldVal:::' + pb.get(pbFieldName));
						pb.put(pbFieldName,getMatchingFieldValue(pbFieldName, (String)pb.get(pbFieldName), pbField.getLength()));
    				}
    			}
    		}
    		
    		system.debug(LoggingLevel.INFO,'personBigList:::' + personBigList);
    		List<Database.SaveResult> saveResultList = database.insertImmediate(personBigList);
			for (Database.SaveResult saveResult : saveResultList) {
				system.debug('success:::' + saveResult.isSuccess() + ':::' + saveResult);
    		}
		}
    	if (shortformAppBigList.size() > 0) {
    		
    		for (ShortForm_Preference__b sfpb : shortformAppBigList) {
    			for (Schema.DescribeFieldResult sfpbField : shortformAppBigFieldMap.values()) {
    				String sfpbFieldName = sfpbField.getName();
    				if (sfpb.get(sfpbFieldName) != null) {
    					system.debug('sfpbFieldName:::' + sfpbFieldName);
						system.debug('sfpbFieldType:::' + sfpbField.getType());
						system.debug('sfpbFieldVal:::' + sfpb.get(sfpbFieldName));
						sfpb.put(sfpbFieldName,getMatchingFieldValue(sfpbFieldName, (String)sfpb.get(sfpbFieldName), sfpbField.getLength()));
    				}
    			}
    		}
    		
    		system.debug(LoggingLevel.INFO,'shortformAppBigList:::' + shortformAppBigList);
    		List<Database.SaveResult> saveResultList = database.insertImmediate(shortformAppBigList);
			for (Database.SaveResult saveResult : saveResultList) {
				system.debug('success:::' + saveResult.isSuccess() + ':::' + saveResult);
    		}
		}
    }
    
    public String getMatchingFieldValue(String fieldName, String fieldVal, Integer fieldDescLength) {
    	String finalVal = fieldVal;
    	//if (objectFieldMap == null) return finalVal;
    	
    	//if (objectFieldMap.containsKey(fieldName)) {
    	//	Schema.DescribeFieldResult fieldDesc = objectFieldMap.get(fieldName);
    		Integer fieldValLength = fieldVal != null ? fieldVal.length() : 0;
    		if (fieldValLength > fieldDescLength) {
    			finalVal = fieldVal.left(fieldDescLength);
    		}
    	//}
    	return finalVal;
    }
    
    public static Map<String, Schema.DescribeFieldResult> getStringFieldDescribeMap(String objName) {
        if (String.isEmpty(objName)) {
            return null;
        }
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
        system.debug(LoggingLevel.INFO, 'objName:::' + objName);
        system.debug(LoggingLevel.INFO, 'SObjectTypeObj:::' + SObjectTypeObj);
        Schema.DescribeSObjectResult dsor = SObjectTypeObj.getDescribe();
        
        // the map to be returned with the final data
        Map<String, Schema.DescribeFieldResult> finalMap = new Map<String, Schema.DescribeFieldResult>();
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
    
        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : objectFields.keySet()){
        	if (objectFields.get(field).getDescribe().getType() == Schema.DisplayType.STRING) {
        		// add the results to the map to be returned
            	finalMap.put(field, objectFields.get(field).getDescribe());
        	}
        }
        return finalMap;
    }
}