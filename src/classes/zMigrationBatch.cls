global class zMigrationBatch implements Database.Batchable<sObject>, Database.Stateful {
    String query;
	Set<Id> listingIds;
	Date startDate;
	Date endDate;
    List<Application__c> appsToUpdate;
    String Info;
    String previous;
    List<String> migrationInfo;
    
    // Count the number of applications processed
    Integer count;
	
    global zMigrationBatch(Set<Id> listingIds, Date startDate, Date endDate) {
    	this.listingIds = listingIds;
    	this.startDate = startDate;
    	this.endDate = endDate;
        migrationInfo = new List<String>();
        count = 0;
        
		
		if (listingIds == null || listingIds.size() == 0) {
			Map<ID,Listing__c> allListingMap = new Map<ID,Listing__c>([SELECT Id FROM Listing__c WHERE Id In (SELECT Listing__c FROM Listing_Lottery_Preference__c)]);
            this.listingIds = new Set<Id>(allListingMap.keySet());
		}
		

	
    	
    	query = 'Select id, Listing__c, Listing__r.Name, DTHP_Preference_Member__c,DTHP_Preference_Manual__c,DTHP_Preference_Rank__c, Is_Migrated__c,';
		query += 'DTHP_Opt_Out__c,DTHP_Preference__c,Neighborhood_Preference_Member__c,Neighborhood_Preference_Manual__c,';
		query += 'Neighborhood_Preference_Rank__c,NRHP_Opt_Out__c,Neighborhood_Preference_Proof__c,Neighborhood_Preference__c,';
		query += 'Neighborhood_Preference_Address__c,COP_Preference_Member__c,COP_Preference_Manual__c,COP_Preference_Rank__c,';
		query += 'COP_Opt_Out__c,COP_Preference__c,Live_in_SF_Preference_Member__c,Live_Work_Preference_Paper__c, Work_in_SF_Preference_Proof__c, Work_in_SF_Preference_Member__c, ';
		query += 'Live_Work_Preference_Rank__c,Live_Work_Opt_Out__c,Live_in_SF_Preference_Proof__c,Live_Work_Preference__c ';
		query += 'From Application__c where Listing__c in :listingIds AND Is_Migrated__c = false';
		if (startDate != null) {
			query += ' AND CreatedDate >= :startDate';
		}
		if (endDate != null) {
			query += ' AND CreatedDate <= :endDate';
		}
		system.debug('query:::' + query);
        system.debug(listingIds);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Application__c> scope) {
		previous = '';
        
        appsToUpdate = new List<Application__c>();
        
        List<Application__c> migrationAppList = new List<Application__c>();
        
        for(Application__c app : scope) {
            
            if(previous.length() > 0 && previous != String.valueOf(app.Listing__r.Name)) {
                JSONGenerator generator = JSON.createGenerator(true);
                generator.writeStartObject(); 
                generator.writeStringField('Listing', previous);
                generator.writeNumberField('count', count);
                generator.writeEndObject();
                migrationInfo.add(generator.getAsString());
                count = 0;
            }
            
            if(app.Is_Migrated__c == false) {
                count++;
            	migrationAppList.add(app);               
                //app.Is_Migrated__c = true;
                appsToUpdate.add(app);
            }
             previous = String.valueOf(app.Listing__r.Name);
    	}
        
        
       // count += migrationAppList.size();
       	if(migrationAppList.size()>0)
        zMigrationScript.createApplicationPreference(migrationAppList);
        
        //Update the migrated field on apps
        //update appsToUpdate; 
        
	}
	
	global void finish(Database.BatchableContext BC) {
        JSONParser parser;
        String body ='';

        
       // Send a mail after the applications have been processed 
       List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       List<String> toAddress = new List<String>();
       toAddress.add('donna.nguyen@vertiba.com');
        toAddress.add('nishchith.hebbar@vertiba.com');
       email.setToAddresses(toAddress);
       email.setSubject('Migration complete');
        
        for(Integer i = 0;i<migrationInfo.size();i++) {
		parser = JSON.createParser(migrationInfo[i]);
		while (parser.nextToken() != null) {
    	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
            if(parser.getText() == 'Listing') {
       	 		parser.nextToken();
            	body += parser.getText() + ' : ';
            }
            else {
                parser.nextToken();
            	body += parser.getText() + ' application(s) processed.\n';
            	}
            	
			}
		}
        }
        
        body += previous + ' : ' + count + ' application(s) processed.';

        
       email.setPlainTextBody('The migration script has run successfully.\n\n ' + body);
       emails.add(email);
       Messaging.sendEmail(emails);
        
	}
}