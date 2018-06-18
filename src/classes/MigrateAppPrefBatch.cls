/**************** Batch Class to migrate Preference to Record Types in Application Preference Object 				*****************/
/**************** Use MigrateAppPrefBatch(ListingId) to migrate all Application Preference of a particular Listing  *****************/
/**************** 											OR														*****************/
/**************** Use MigrateAppPrefBatch() to migrate empty recordType Application Preference in the entire org 	*****************/


/**************** Script to run [ Id batchJobId = Database.executeBatch(new MigrateAppPrefBatch()); ]				*****************/

public class MigrateAppPrefBatch implements Database.Batchable<Sobject>, Database.Stateful {
    public String ListingId;
    public String query;
    public Integer CustomPref;
    public Integer totalAppPref;
    private static final ID RB_AHP_RecordTypeID = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','RB_AHP');
	private static final ID NRHP_RecordTypeID =  RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','NRHP');
    private static final ID L_W_RecordTypeID =  RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','L_W');
    private static final ID COP_RecordTypeID =  RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','COP');
    private static final ID DTHP_RecordTypeID =  RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','DTHP');
    private static final ID Custom_RecordTypeID =  RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','Custom');
    private static final ID ADHP_RecordTypeID =  RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c','ADHP');
    
    public MigrateAppPrefBatch() {
        CustomPref = 0;
        totalAppPref = 0;
        query = 'Select Id, Preference_Name__c, RecordTypeId, RecordType.DeveloperName, Certificate_Number__c, Individual_Preference__c, If_Combined_Individual_Preference__c, Type_of_proof__c, Additional_Details__c From Application_Preference__c';
    }
    
    public MigrateAppPrefBatch(String ListingId) {
        this.ListingId = ListingId;
        CustomPref = 0;
        totalAppPref = 0;
        query = 'Select Id, Preference_Name__c, RecordTypeId, RecordType.DeveloperName, Certificate_Number__c, Individual_Preference__c, If_Combined_Individual_Preference__c, Type_of_proof__c, Additional_Details__c From Application_Preference__c Where Application__r.Listing__c = :ListingId';
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(query);
	}
    
    public void execute(Database.BatchableContext BC, List<Application_Preference__c> scope) {
        for(Application_Preference__c appPref : scope) {
            totalAppPref++;
            if(appPref.Preference_Name__c == 'Anti-Displacement Housing Preference (ADHP)')
                appPref.RecordTypeId = ADHP_RecordTypeID;
            else if(appPref.Preference_Name__c == 'Certificate of Preference (COP)')
                	appPref.RecordTypeId = COP_RecordTypeID;
            else if(appPref.Preference_Name__c == 'Displaced Tenant Housing Preference (DTHP)')
                	appPref.RecordTypeId = DTHP_RecordTypeID;
            else if(appPref.Preference_Name__c == 'Live or Work in San Francisco Preference') {
                	appPref.RecordTypeId = L_W_RecordTypeID;
                	appPref.Individual_preference__c = appPref.If_Combined_Individual_Preference__c;
                	appPref.LW_Type_of_Proof__c = appPref.Type_of_proof__c;   	
            }
            else if(appPref.Preference_Name__c == 'Neighborhood Resident Housing Preference (NRHP)')
                	appPref.RecordTypeId = NRHP_RecordTypeID;
            else if(appPref.Preference_Name__c == 'Rent Burdened / Assisted Housing Preference') {
                	appPref.RecordTypeId = RB_AHP_RecordTypeID;
                	appPref.Certificate_Number__c = appPref.Additional_Details__c;
                	appPref.Individual_preference__c = appPref.If_Combined_Individual_Preference__c;
            }
            else {
                appPref.RecordTypeId = Custom_RecordTypeID;
                CustomPref++;
            }
        }
        
        Database.update(scope,false);
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('Total Number of Application Preference processed : ' + totalAppPref);
        System.debug('Number of Application Preference Custom : ' + CustomPref);
    }
    
}