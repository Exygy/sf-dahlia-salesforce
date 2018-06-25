public class AppPrefPreLotteryValidation {
    
    public static String RT_RB_AHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'RB_AHP');
    public static String RT_COP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'COP');
    public static String RT_DTHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'DTHP');
    public static String RT_L_W = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'L_W');
    public static String RT_NRHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'NRHP');
    public static String RT_AG = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'AG');
    public static String RT_Custom = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'Custom');
    public static String RT_ADHP = RecordTypeUtil.getRecordTypeIDByDevName('Application_Preference__c', 'ADHP');
    
    public static final String None = 'None';
    public static final String Unconfirmed = 'Unconfirmed';
    public static final String Confirmed = 'Confirmed';
    public static final String Valid_for_Lottery = 'Valid for Lottery';
    public static final String Invalid_for_Lottery = 'Invalid for Lottery';
    public static final String Valid_Added = 'Valid-Added';
    
    private static List<Application_Preference__c> oldTriggerVal = trigger.new;
    
    public static void SetPreLotteryValidation() {
        
        List<Application_Preference__c> appPrefList = [SELECT Id, Application__r.Total_Monthly_Rent__c, Application__r.Annual_Income__c, Lottery_Status__c, Type_of_proof__c, Opt_Out__c,
                                                       RecordTypeId, Application_Member__c, Application_Member__r.Preference_Address_Match__c, LW_Type_of_Proof__c , Individual_preference__c 
                                                       FROM Application_Preference__c WHERE ID IN : trigger.new];
        for(Application_Preference__c appPref : appPrefList) {
           if(appPref.Opt_Out__c != true) {
            if(appPref.RecordTypeId == RT_RB_AHP) {
                if(appPref.Application__r.Total_Monthly_Rent__c != null && appPref.Application__r.Annual_Income__c != null && appPref.Application__r.Total_Monthly_Rent__c > ((appPref.Application__r.Annual_Income__c)/12)/2 && 
                   appPref.Individual_preference__c == 'Rent Burdened' && (appPref.Lottery_Status__c == null || appPref.Lottery_Status__c == None || appPref.Lottery_Status__c == Unconfirmed)) {
                       appPref.Lottery_Status__c = Valid_for_Lottery;
                   }
                else if(appPref.Individual_preference__c == 'Rent Burdened' && (appPref.Lottery_Status__c == null || appPref.Lottery_Status__c == None || appPref.Lottery_Status__c == Valid_for_Lottery)) {
                    	appPref.Lottery_Status__c = Unconfirmed;
                }
                else if(appPref.Individual_preference__c == 'Assisted Housing') {
                        appPref.Lottery_Status__c = None;
                }
            }
            
            if(appPref.RecordTypeId == RT_COP || appPref.RecordTypeId == RT_DTHP) {
                if(appPref.Application_Member__c != null && (appPref.Lottery_Status__c == null || appPref.Lottery_Status__c == None)) {
                    appPref.Lottery_Status__c = Unconfirmed;
                }
                else if(appPref.Application_Member__c == null && appPref.RecordTypeId == RT_COP) {
                    appPref.Lottery_Status__c = null;
                }
            }
            
            if(appPref.RecordTypeId == RT_NRHP || appPref.RecordTypeId == RT_ADHP) {
                if(appPref.Application_Member__c != null) {
                    if(appPref.Application_Member__r.Preference_Address_Match__c == 'Matched') {
                        appPref.Lottery_Status__c = Valid_for_Lottery;
                    }
                    else {
                        appPref.Lottery_Status__c = Unconfirmed;
                    }
                }
                else if(appPref.Application_Member__c == null && appPref.RecordTypeId == RT_NRHP) {
                    	appPref.Lottery_Status__c = null;
                }
                else if(appPref.Application_Member__c == null && appPref.RecordTypeId == RT_ADHP) {
                    	appPref.Lottery_Status__c = Unconfirmed;
                }
            }
            
            if(appPref.RecordTypeId == RT_L_W) {
                if(appPref.Lottery_Status__c == null || appPref.Lottery_Status__c == Unconfirmed) {
                    appPref.Lottery_Status__c = None;
                }
                
                appPref.Type_of_proof__c = appPref.LW_Type_of_Proof__c != null ? appPref.LW_Type_of_Proof__c : appPref.Type_of_proof__c;
            }
            
            if(appPref.RecordTypeId == RT_Custom) {
                if(appPref.Application_Member__c != null && (appPref.Lottery_Status__c == null || appPref.Lottery_Status__c == Unconfirmed)) {
                    appPref.Lottery_Status__c = None;
                }
                else if(appPref.Application_Member__c == null && (appPref.Lottery_Status__c == null || appPref.Lottery_Status__c == None)) {
                    appPref.Lottery_Status__c = Unconfirmed;
                }
            }
            
            if(appPref.RecordTypeId == RT_AG) {
                if(appPref.Lottery_Status__c == null) {
                    appPref.Lottery_Status__c = None;
                }
            }
                        
        }
      }
        update appPrefList;
    }

    public static void runHandler() {
        Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
        if(!isEnabled) {
            if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
                if(oldTriggerVal[0].Id == trigger.new[0].Id) {
                	if(TriggerContext.shouldRun())
                		SetPreLotteryValidation();
                }
                else {
                    if(TriggerContext.shouldAutoGrantRun())
                    	SetPreLotteryValidation();
                }
            }
        }
        else return;
            
    }
}