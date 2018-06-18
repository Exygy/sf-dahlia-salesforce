// *****************************************************************************
// CLASS: API_ApplicationService
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Contains all logic for API service calls - classes starting with "API".
//
// *****************************************************************************

global without sharing class API_ApplicationService {
    
    private static final String CONTACT_APPLICANT_RT_DEVELOPER_NAME = 'Applicant';
    private static final String ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME = 'Household';
    private static final String PRIMARY_APPLICANT = 'Primary Applicant';
    private static final String ALTERNATE_CONTACT = 'Alternate Contact';
    private static final String HOUSEHOLD_MEMBER = 'Household Member';
    private static final integer InsertRetry = Integer.valueOf(Label.INSERT_RETRY_NUMBER);
    
    private static final ID CONTACT_APPLICANT_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Contact',CONTACT_APPLICANT_RT_DEVELOPER_NAME);
    private static final ID ACCOUNT_HOUSEHOLD_RT_ID =  RecordTypeUtil.getRecordTypeIDByDevName('Account',ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME);
    
    
    /*
private static final String PRIMARY_TYPE = 'Primary';
private static final String ALTERNATE_TYPE = 'Alternate';
private static final String HOUSEHOLD_MEMBER_TYPE = 'Household Member';
*/
    
    private static final String HOUSEHOLD_FIELDLIST =
        'Id, Name, RecordTypeId';
    
    private static final String CONTACT_FIELDLIST =
        'Id, AccountId, RecordTypeId, FirstName, Middle_Name__c, LastName, Birthdate, Email, Phone, Street_Name__c, City__c, State__c, Zip_Code__c,' +
        ' MailingStreet, MailingCity, MailingState, MailingPostalCode, Work_Street__c, Work_City__c, Work_State__c, Work_Postal_Code__c,' +
        ' Gender__c, Certificate_of_Preference_Holder__c, Displaced_Tenant_Preference__c, Relationship_to_Head_of_Household__c,' +
        ' Phone_Type__c, Work_Phone__c, Second_Phone_Type__c, Ethnicity__c, Race__c, Primary_Language__c, Work_in_SF__c,Webapp_Id__c,' +
        ' Prior_Tax_Year_Total_Income_Amount__c, Living_with_disabling_HIVAIDS__c, Sexual_Orientation__c, Sexual_Orientation_Other__c'; //, incomeType
    
    private static final String APPLICATION_MEMBER_FIELDLIST =
        'Id, Contact__c, First_Name__c, Middle_Name__c, Last_Name__c, Date_of_Birth__c, Email__c,' +
        ' Phone__c, Phone_Type__c, Second_Phone__c, Second_Phone_Type__c,' +
        ' Street__c, City__c, State__c, Zip_Code__c, Application__c, Application__r.Status__c, Contact_WebappID__c,' +
        ' Mailing_Street__c, Mailing_City__c, Mailing_State__c, Mailing_Zip_Code__c,' +
        ' Work_in_SF__c, Relationship_to_Applicant__c, Living_with_HIV_AIDS__c, Sexual_Orientation__c, Sexual_Orientation_Other__c,' +
        ' Gender__c, Gender_Other__c, Ethnicity__c, Race__c, Sex_at_birth__c, Type__c, Primary_Language__c, Other_Language__c,' +
        ' Candidate_Score__c, Which_component_of_locator_was_used__c, X_Coordinate__c, Y_Coordinate__c,' +
        ' No_Phone__c, No_Email__c, No_Address__c, Has_Alt_Mailing_Address__c,' +
        ' Alternate_Contact_Type__c, Alternate_Contact_Type_Other__c, Agency_Name__c, Same_Address_as_Applicant__c, Preference_Address_Match__c';
    
    private static final String SHORTFORM_PREFERENCE_FIELDLIST =
        'Id, Application__c, RecordTypeId, Listing_Preference_ID__c, Application_Member__c, Post_Lottery_Validation__c, Certificate_Number__c, LW_Type_of_Proof__c, Type_of_proof__c, Lottery_Status__c, Individual_preference__c, Opt_Out__c, Requires_Proof__c, Street__c, City__c, State__c, Zip_Code__c';
    
    private static final String LISTING_PREFERENCE_FIELDLIST =
        'Id, Listing__c, Lottery_Preference__c, Preference_Name__c, Lottery_Preference__r.Record_Type_For_App_Preferences__c, Requires_Proof__c';
    
    
    private static final String SHORTFORM_FIELDLIST =
        'Id, recordtypeid, Applicant_Household__c, Listing__c,' +
        prefixQuery('Applicant__r.', APPLICATION_MEMBER_FIELDLIST) +
        ', ' +
        prefixQuery('Alternate_Contact__r.', APPLICATION_MEMBER_FIELDLIST) +
        ', Status__c, Is_Resident__c, Referral_Source__c, Housing_Voucher_or_Subsidy__c, Total_Monthly_Rent__c ' +
        ', Terms_Acknowledged__c, Name, Application_Submission_Type__c, Primary_Applicant__c, Live_Work_Preference_Paper__c, Reserved_Senior__c, Applicant_used_housing_counseling_agency__c, Which_One__c, Other__c ' +
        ', Live_Work_Opt_Out__c, DTHP_Opt_Out__c, COP_Opt_Out__c, NRHP_Opt_Out__c' +
        ', COP_Preference_Member__c, DTHP_Preference_Member__c, Neighborhood_Preference_Member__c, Lottery_Number__c, Lottery_Number_Manual__c, Form_Metadata__c' +
        ', Work_in_SF_Preference_Member__c, Live_in_SF_Preference_Member__c, Total_Household_Gross_Income__c, Application_Language__c, Application_Submitted_Date__c ' +
        ', Live_in_SF_Preference_Proof__c, Neighborhood_Preference_Proof__c, Work_in_SF_Preference_Proof__c, Annual_Income__c, Monthly_Income__c, Third_Party_External_ID__c' +
        ', Has_Military_Service__c, Has_Rent_Burden_HUD__c, Has_DevelopmentalDisability__c, Answered_Community_Screening__c, Has_ADA_Priorities_Selected__c, ' +
        '(SELECT ' + SHORTFORM_PREFERENCE_FIELDLIST + ' FROM Application_Preferences__r)';
    
    private static final String APPLICATION_FIELDLIST =
        'Id, Applicant_Household__c, Listing__c, Name,' +
        prefixQuery('Applicant__r.Contact__r.', CONTACT_FIELDLIST) +
        ', ' +
        prefixQuery('Alternate_Contact__r.Contact__r.', CONTACT_FIELDLIST) +
        ', Live_Work_Opt_Out__c, DTHP_Opt_Out__c, COP_Opt_Out__c, NRHP_Opt_Out__c, Total_Monthly_Rent__c' +
        ', Status__c, Is_Resident__c, Referral_Source__c, Housing_Voucher_or_Subsidy__c , Application_Submitted_Date__c' +
        ', Terms_Acknowledged__c, Total_Household_Gross_Income__c, Application_Language__c, Application_Submission_Type__c, Lottery_Number__c, Lottery_Number_Manual__c, Form_Metadata__c' +
        ', Annual_Income__c, Monthly_Income__c, Primary_Applicant__c, Live_Work_Preference_Paper__c';
    
    private static String prefixQuery(String prefix, String query) {
        return prefix + query.replaceAll(', ', ', ' + prefix);
    }
    
    private static Id contactApplicantRtId {
        get {
            if (contactApplicantRtId == null) {
                contactApplicantRtId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :CONTACT_APPLICANT_RT_DEVELOPER_NAME limit 1].Id;
            }
            return contactApplicantRtId;
        }
    }
    
    private static Id accountHouseholdRtId {
        get {
            if (accountHouseholdRtId == null) {
                accountHouseholdRtId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = :ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME limit 1].Id;
            }
            return accountHouseholdRtId;
        }
    }
    
    
    //for Communities High volume users cannot own accounts as such we are setting a default owner for the account.
    
    public static ID getDefaultAccoutOwner() {
        Id currentUserProfileId = UserInfo.getProfileId();
        Leasing_Settings__c leasingSettings = Leasing_Settings__c.getInstance(currentUserProfileId);
        return leasingSettings.Default_Owner__c;
    }
    
    public static Boolean isCommunityUser(Id currentUserProfileId) {
        boolean isCommunityUser = false;
        UserLicense customerCommunity = [SELECT Id, LicenseDefinitionKey FROM UserLicense WHERE LicenseDefinitionKey = 'PID_Customer_Community_Login'];
        List<Profile> customerCommunityProfiles = [SELECT Id, Name FROM Profile WHERE UserLicenseId = :customerCommunity.Id];
        Map<Id, Profile> profilesMap = new Map<Id,Profile>();
        for (Profile p : customerCommunityProfiles) {
            profilesMap.put(p.id, p);
        }
        System.debug('profilesMap:::' + profilesMap);
        if (profilesMap.containsKey(currentUserProfileId)) {
            isCommunityUser = true;
        }
        return isCommunityUser;
    }
    
    public static Account getHouseholdById(Id householdId) {
        List<Account> accs = Database.query(
            'SELECT ' +
            HOUSEHOLD_FIELDLIST +
            ' FROM Account' +
            ' WHERE Id = :householdId'
        );
        
        if (accs.size() != 1) {
            return null;
        } else {
            return accs[0];
        }
    }
    
    public static Application_Member__c getApplicationMembersById(Id amId) {
        List<Application_Member__c> am = Database.query(
            'SELECT ' +
            APPLICATION_MEMBER_FIELDLIST +
            ' FROM Application_Member__c' +
            ' WHERE Id = :amId'
        );
        
        if (am.size() != 1) {
            return null;
        } else {
            return am[0];
        }
    }
    
    public static List<Application_Member__c> getApplicationMembersByApplicationIds(Set<Id> appIds) {
        return Database.query(
            'SELECT ' +
            APPLICATION_MEMBER_FIELDLIST +
            ' FROM Application_Member__c' +
            ' WHERE Application__c IN :appIds'
        );
    }
    
    public static List<Application_Preference__c> getShortformPreferencesByApplicationIds(Set<Id> appIds) {
        return Database.query(
            'SELECT ' +
            SHORTFORM_PREFERENCE_FIELDLIST +
            ' FROM Application_Preference__c' +
            ' WHERE Application__c IN :appIds'
        );
    }
    
    public static List<Listing_Lottery_Preference__c> getListingPreferencesByListingIds(Set<Id> listingIds) {
        return Database.query(
            'SELECT ' +
            LISTING_PREFERENCE_FIELDLIST +
            ' FROM Listing_Lottery_Preference__c' +
            ' WHERE Listing__c IN :listingIds'
        );
    }
    
    public static List<Application_Member__c> getApplicationMembersByContactIds(Set<Id> cntIds) {
        return Database.query(
            'SELECT ' +
            APPLICATION_MEMBER_FIELDLIST +
            ' FROM Application_Member__c' +
            ' WHERE Contact__c IN :cntIds'
        );
    }
    
    public static List<Application_Member__c> getApplicationMemberByContactId(Id cntId) {
        return getApplicationMembersByContactIds(new Set<Id>{cntId});
    }
    
    public static List<Application_Member__c> getApplicationMembersByApplicationId(Id appId) {
        return getApplicationMembersByApplicationIds(new Set<Id>{appId});
    }
    
    public static List<Contact> getContactsByHouseholdIds(Set<Id> householdIds) {
        return Database.query(
            'SELECT ' +
            CONTACT_FIELDLIST +
            ' FROM Contact' +
            ' WHERE AccountId IN :householdIds'
        );
    }
    
    public static List<Contact> getContactsByHouseholdId(Id householdId) {
        return getContactsByHouseholdIds(new Set<Id>{householdId});
    }
    
    public static Contact getContactById(Id contactId) {
        List<Contact> cs = Database.query(
            'SELECT ' +
            CONTACT_FIELDLIST +
            ' FROM Contact' +
            ' WHERE Id = :contactId'
        );
        
        if (cs.size() != 1) {
            return null;
        } else {
            return cs[0];
        }
    }
    
    public static API_Application.Person getPersonById(Id contactId) {
        Contact c = getContactById(contactId);
        
        if (c == null) {
            return null;
        } else {
            return new API_Application.Person(c);
        }
    }
    
    public static API_Application.Person getPersonByContactId(Id contactId) {
        Contact c = getContactById(contactId);
        
        if (c == null) {
            return null;
        } else {
            return new API_Application.Person(c);
        }
    }
    
    public static API_Application.Person getPersonByApplicationMemberId(Id amId) {
        Application_Member__c am = getApplicationMembersById(amId);
        
        if (am == null) {
            return null;
        } else {
            return new API_Application.Person(am);
        }
    }
    
    public static Application__c getApplicationById(Id shortformId) {
        List<Application__c> apps = Database.query(
            'SELECT ' +
            SHORTFORM_FIELDLIST +
            ' FROM Application__c' +
            ' WHERE Id = :shortformId'
        );
        
        if (apps != null && apps.size() != 1) {
            return null;
        } else {
            return apps[0];
        }
    }
    
    public static List<Application__c> getApplicationsByPrimaryApplicantId(Id contactId) {
        system.debug('SELECT ' +
                     SHORTFORM_FIELDLIST +
                     ' FROM Application__c' +
                     ' WHERE Primary_Applicant__c = :contactId');
        return Database.query(
            'SELECT ' +
            SHORTFORM_FIELDLIST +
            ' FROM Application__c' +
            ' WHERE Primary_Applicant__c = :contactId'
        );
    }
    
    public static Application__c getApplicationByExternalId(String externalId) {
        List<Application__c> apps = Database.query(
            'SELECT ' +
            SHORTFORM_FIELDLIST +
            ' FROM Application__c' +
            ' WHERE Third_Party_External_ID__C = :externalId'
        );
        
        if (apps != null && apps.size() > 0) {
            return apps[0];
        } else {
            return null;
        }
    }
    
    public static API_Application.ShortForm getShortformById(Id shortformId) {
        Application__c app = getApplicationById(shortformId);
        
        if (app == null) {
            return null;
        } else {
            List<Application_Member__c> hms = getApplicationMembersByApplicationId(app.Id);
            return  API_Application.newShortForm(app, hms);
        }
    }
    
    public static API_Application.ShortForm getExistingShortformByCurrentShortForm(API_Application.ShortForm sf) {
        Application__c app = getApplicationByExternalId(sf.externalSessionId);
        
        if (app == null) {
            return null;
        } else {
            sf.Id = app.Id;
            return  sf;
        }
    }
    
    public static List<API_Application.ShortForm> getShortformsByContactId(Id contactId) {
        List<Application__c> apps = getApplicationsByPrimaryApplicantId(contactId);
        Set<Id> appIds = new Set<Id>();
        for (Application__c app : apps) {
            appIds.add(app.Id);
        }
        //select all household members related to selected apps
        List<Application_Member__c> hms = getApplicationMembersByApplicationIds(appIds);
        
        //group hosehold members on Application
        Map<Id, List<Application_Member__c>> appMemberToAppMap = new Map<Id, List<Application_Member__c>>();
        for (Application_Member__c hm : hms) {
            if (!appMemberToAppMap.containsKey(hm.Application__c)) {
                appMemberToAppMap.put(hm.Application__c, new List<Application_Member__c>());
            }
            appMemberToAppMap.get(hm.Application__c).add(hm);
        }
        
        //create shortform for each app
        List<API_Application.ShortForm> sfs = new List<API_Application.ShortForm>();
        for (Application__c app : apps) {
            sfs.add( API_Application.newShortForm(app, appMemberToAppMap.get(app.Id)));
        }
        return sfs;
    }
    public static Account updateHouseholdAccount(Contact primaryApplicant) {
        Account household;
        system.debug('primaryApplicant.accountId:::' + primaryApplicant.accountid);
        String householdName = primaryApplicant.firstName + ' ' + primaryApplicant.lastName + '\'s Household';
        
        if (primaryApplicant.accountid == null) {
            household = new Account(RecordTypeId = accountHouseholdRtId, Name =householdName);
            //for community users set default owner
            if (isCommunityUser(UserInfo.getProfileId())) {
                household.ownerid = getDefaultAccoutOwner();
            }
            insert household;
            
        }
        else {
            
            household = [select id, name from account where id = :primaryApplicant.accountid];
            if (household.name != householdName) {
                household.name = householdName;
                update household;
                
            }
        }
        return household;
    }
    public static API_Application.Person upsertPrimaryPerson(API_Application.Person person) {
        //update existing contact
        // API_Application.Person updatedPerson = API_ApplicationService.upsertPrimaryContactInfo(person);
        // API_Application.Person initialPerson = person;
        
        Contact primaryContact = person.toContact();  // creates and updates the contact
        //use this to get accountid that it's not stored on person
        Contact existingPrimaryContact = getContactById(person.contactId);
        primaryContact.accountId = existingPrimaryContact != null ? existingPrimaryContact.accountId : primaryContact.accountId;
        
        Account household = updateHouseholdAccount(primaryContact);
        primaryContact.accountid = household.id;
        system.debug('primaryContact:::' + primaryContact);
        upsert primaryContact;
        
        // upsertPrimaryContactAndHousehold(primaryContact);
        //select all household members related to selected apps
        List<Application_Member__c> hms = API_ApplicationService.getApplicationMembersByContactIds(new Set<Id>{(Id)primaryContact.id});
        
        //update application members for all 'Draft' Application related to this Contact
        for (Application_Member__c hm : hms) {
            if (hm.Application__r.Status__c == 'Draft') {
                hm.First_Name__c = person.firstName;
                hm.Middle_Name__c = person.middleName;
                hm.Last_Name__c = person.lastName;
                hm.Email__c = person.email;
                hm.Date_of_Birth__c = person.dob;
            }
        }
        
        if (hms.size() > 0) {
            update hms;
        }
        
        
        //reinitialize contactId and appMemberId
        person.contactid = primaryContact.id;
        
        
        return person;
    }
    /*
public static API_Application.Person insertApplicationMemberPerson(API_Application.Person p, Id appId, String appMemberType) {
if (p == null || appId == null) return null;

Application_Member__c am = getApplicationMember(p, appId, appMemberType);
upsert am;
return new API_Application.Person(am);
}

public static API_Application.Person upsertApplicationMemberPerson(API_Application.Person p) {
if (p == null) return null;

Application_Member__c am = p.toApplicationMember();
upsert am;
return new API_Application.Person(am);
}


private static void deleteExtraApplicationMembers(Set<Id> currentAppMemberIds, Set<Id> existingAppMemberIds) {
List<Application_Member__c> toBeDeletedApplicationMembers = new List<Application_Member__c>();
for (Id existingAppMemberId : existingAppMemberIds) {
if (!currentAppMemberIds.contains(existingAppMemberId)) {
toBeDeletedApplicationMembers.add(new Application_Member__c(Id = existingAppMemberId));
}
}
if (toBeDeletedApplicationMembers.size() > 0) {
delete toBeDeletedApplicationMembers;
}
}
*/
    
    private static Application_Member__c toApplicationMember(API_Application.Person person, String appMemberType,ID appID) {
        
        Application_Member__c householdMemberAppMember = person.toApplicationMember();
        if (person.appMemberId == null) {
            householdMemberAppMember.Application__c = appID;
        }
        householdMemberAppMember.type__c = appMemberType; // if these were set on the person then we wouldnt' need this translations
        
        return householdMemberAppMember;
    }
    
    private static Application__c saveApplication(API_Application.ShortForm sf) {
        ApplicationCreateAppPreferenceAction.disableTrigger = true;
        
        API_Application.Person primaryApplicant = sf.primaryApplicant;
        API_Application.Person alternateContact = sf.alternateContact;
        Application__c app = sf.toApplication();
        
        if (primaryApplicant != null) {
            primaryApplicant.appMemberType = PRIMARY_APPLICANT;
            primaryApplicant = upsertPrimaryPerson(primaryApplicant);
        }
        if (alternateContact != null) {
            alternateContact.appMemberType = ALTERNATE_CONTACT;
        }
        app = sf.toApplication();
        upsert app; // insert it here to get the app id. if its a new record
        
        app = getApplicationById(app.Id);
        
        
        Map<String, Application_Member__c> keyToAppMember = new Map<String, Application_Member__c>();
        List<Application_Member__c> appMembersToUpsert = new List<Application_Member__c>();
        ///add application members
        
        if (sf.householdMembers != null) {
            for (API_Application.Person householdMember : sf.householdMembers) {
                Application_Member__c householdMemberAppMember = toApplicationMember(householdMember,HOUSEHOLD_MEMBER,app.id);
                appMembersToUpsert.add(householdMemberAppMember);
                String key = householdMember.getKey();
                //if (!keyToAppMember.containsKey(key)) {
                keyToAppMember.put(key, householdMemberAppMember);
                //}
            }
        }
        Application_Member__c alternateContactAppMember;
        
        if (alternateContact != null) {
            
            String alternateKey = alternateContact.getKey();
            
            system.debug('alternateContact set');
            
            alternateContactAppMember = toApplicationMember(alternateContact,ALTERNATE_CONTACT,app.id);
            appMembersToUpsert.add(alternateContactAppMember);
            
            //key is unique but if its not. alternate contact overrites household
            keyToAppMember.put(alternateKey, alternateContactAppMember);
        }
        Application_Member__c primaryAppMember;
        
        if (primaryApplicant!=null) {
            String primaryKey = primaryApplicant.getKey();
            
            system.debug('primary contact set:::' + primaryApplicant);
            
            primaryAppMember = toApplicationMember(primaryApplicant,PRIMARY_APPLICANT,app.id);
            appMembersToUpsert.add(primaryAppMember);
            
            //key is unique but if its not. primary contact overrites household
            keyToAppMember.put(primaryKey, primaryAppMember);
            
            
        }
        upsert keyToAppMember.values();
        //upsert appMembersToUpsert;
        system.debug('appMembersToUpsert: ' + appMembersToUpsert);
        system.debug ('alternateContact: ' + alternateContact + 'alternateContactAppMember: ' + alternateContactAppMember);
        // finalize application
        
        //set primary applicant - contact
        app.Primary_Applicant__c = app.Primary_Applicant__c == null && primaryApplicant != null ? primaryApplicant.contactId : app.Primary_Applicant__c;
        //set primary applicant - application member
        app.Applicant__c = primaryApplicant == null ? null : primaryAppMember.id;
        //set aternate application - application member
        app.Alternate_Contact__c = alternateContact == null ? null : alternateContactAppMember.id;
        upsert app;
        
        //set natural keys
        /*if (sf.certOfPreferenceNatKey != null && keyToAppMember.containsKey(sf.certOfPreferenceNatKey.toLowerCase())) {
app.COP_Preference_Member__c = keyToAppMember.get(sf.certOfPreferenceNatKey.toLowerCase()).Id;
}
if (sf.displacedPreferenceNatKey != null && keyToAppMember.containsKey(sf.displacedPreferenceNatKey.toLowerCase())) {
app.DTHP_Preference_Member__c = keyToAppMember.get(sf.displacedPreferenceNatKey.toLowerCase()).Id;
}
if (sf.workInSfPreferenceNatKey != null && keyToAppMember.containsKey(sf.workInSfPreferenceNatKey.toLowerCase())) {
app.Work_in_SF_Preference_Member__c = keyToAppMember.get(sf.workInSfPreferenceNatKey.toLowerCase()).Id;
}
if (sf.liveInSfPreferenceNatKey != null && keyToAppMember.containsKey(sf.liveInSfPreferenceNatKey.toLowerCase())) {
app.Live_in_SF_Preference_Member__c = keyToAppMember.get(sf.liveInSfPreferenceNatKey.toLowerCase()).Id;
}
if (sf.neighborhoodResidencePreferenceNatKey != null && keyToAppMember.containsKey(sf.neighborhoodResidencePreferenceNatKey.toLowerCase())) {
app.Neighborhood_Preference_Member__c = keyToAppMember.get(sf.neighborhoodResidencePreferenceNatKey.toLowerCase()).Id;
}*/
        
        system.debug('keys:::' + keyToAppMember.keySet());
        //ShortForm preferences
        Map<Id,Listing_Lottery_Preference__c> listingPrefMap = new Map<Id,Listing_Lottery_Preference__c>(getListingPreferencesByListingIds(new Set<Id>{sf.listingId}));
        List<Application_Preference__c> appPrefToUpsert = new List<Application_Preference__c>();
        Set<String> usedPrefKeys = new Set<String>();
        Set<Id> existingListingPrefs = listingPrefMap.keySet();
        system.debug('sf.shortFormPreferences:::' + sf.shortFormPreferences);
        if (sf.shortFormPreferences != null) {
            for (API_Application.ShortFormPreference sfPref : sf.shortFormPreferences) {
                if (listingPrefMap == null || !listingPrefMap.containsKey(sfPref.listingPreferenceID)) {
                    sfPref.listingPreferenceID = null;//if listing preference doesn't match throw exception
                }
                system.debug('sfPref.Natkey:::' + sfPref.naturalKey);
                
                if (sfPref.naturalKey != null && keyToAppMember.containsKey(sfPref.naturalKey.toLowerCase())) {
                    sfPref.appMemberID = keyToAppMember.get(sfPref.naturalKey.toLowerCase()).Id;
                }
                if (sfPref.applicationID == null) {
                    sfPref.applicationID = app.Id;
                }
                sfPref.validate();
                
                Application_Preference__c appPref = sfPref.toApplicationPreference();
                if (sfPref.getKey() != null && !usedPrefKeys.contains(sfPref.getKey())) {
                    usedPrefKeys.add(sfPref.getKey());
                }
                appPrefToUpsert.add(appPref);
                existingListingPrefs.remove(sfPref.listingPreferenceID);
                system.debug('appPrefToUpsert:::' + appPrefToUpsert);
            }
        }
        
        for (ID listingPrefID : existingListingPrefs) {
            Id appPrefRtId = String.isEmpty(listingPrefMap.get(listingPrefID).Lottery_Preference__r.Record_Type_For_App_Preferences__c) ? API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(API_Application.CUSTOM_RT_DEVELOPER_NAME) : API_Application.APP_PREF_RT_DEVNAME_TO_ID.get(listingPrefMap.get(listingPrefID).Lottery_Preference__r.Record_Type_For_App_Preferences__c);
            appPrefToUpsert.add(new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefID, RecordTypeId = appPrefRtId));
        }
        
        upsert appPrefToUpsert;
        
        return app;
    }
    
    /*
private static Set<ID> getAppMemberIDSApp(ID appID ) {
Set<ID> appMemberIDS = new Set<ID>();

List<Application_Member__c> appMembers = getApplicationMembersByApplicationId(appID);
for (Application_Member__c appMember: appMembers){
appMemberIDS.add(appMember.id);
}
return appMemberIDS;
}

private static Set<ID> getAppMemberIDSForSF(API_Application.ShortForm sf ) {
Set<ID> appMemberIDS = new Set<ID>();
appMemberIDS.add(sf.primaryContact.appMemberid);
if (sf.alternateContact!=null){
appMemberIDS.add(sf.alternateContact.appMemberid);
}
for (household)
}*/
    private static Application__c updateSF (API_Application.ShortForm sf) {
        
        ApplicationCreateAppPreferenceAction.disableTrigger = true;
        
        API_Application.ShortForm existingSf = getShortformById(sf.Id);
        if (existingSf.status != 'Submitted' && sf.status == 'Submitted') {
            sf.validateLotteryRun();
        }
        system.debug('existing sf' + existingSf);
        system.debug('submitted sf' + sf);
        
        //appmember= select id from appmember where appmember.applicationid = sf.id and contactid = sf.contact.id
        //primaryApplicant.appmemberid = appmember.id
        //Set<ID> existingAppMemberIDS = getAppMemberIDSApp(sf.ID);
        
        Map<String,ID> existingMemberMap = new Map<String,ID>();
        Set<ID> existingIDS = new Set<ID>();
        
        //add alternate contact Id
        if (existingSf.alternateContact != null && existingSf.alternateContact.appMemberId != null) {
            existingMemberMap.put(existingSf.alternateContact.getkey(),existingSf.alternateContact.appMemberId);
            existingIDS.add(existingSf.alternateContact.appMemberId);
        }
        if (existingSf.householdMembers != null) {
            //add application members Ids
            for (API_Application.Person householdMember : existingSf.householdMembers) {
                existingMemberMap.put(householdMember.getKey(),householdMember.appMemberId);
                existingIDS.add(householdMember.appMemberId);
            }
        }
        system.debug('existingMemberMap' + existingMemberMap);
        
        if (sf.primaryApplicant != null && existingSf.primaryApplicant!=null ) {
            sf.primaryApplicant.contactId = String.isEmpty(sf.primaryApplicant.contactId) ? existingSf.primaryApplicant.contactId : sf.primaryApplicant.contactId;
            sf.primaryApplicant.appmemberid = String.isEmpty(sf.primaryApplicant.appmemberid) ? existingSf.primaryApplicant.appmemberid : sf.primaryApplicant.appmemberid;
            existingIDS.remove(sf.primaryApplicant.appmemberid);
        }
        //not sure this line is needed-  ll it adds alternate contact to the current app member list
        
        if (sf.alternateContact != null  && existingSf.alternateContact!=null) {
            sf.alternateContact.appMemberId = String.isEmpty(sf.alternateContact.appMemberId) ? existingSf.alternateContact.appMemberId : sf.alternateContact.appMemberId;
            
            if (sf.alternateContact.appMemberId != null) {
                existingIDS.remove(sf.alternateContact.appMemberId);
                
            }
        }
        if (sf.householdMembers != null) {
            for (API_Application.Person householdMember : sf.householdMembers) {
                String key  = householdMember.getKey();
                if (existingMemberMap.containsKey(key)) {
                    ID appMemberID = existingMemberMap.get(key);
                    if (householdMember.appmemberid == null) {
                        householdMember.appmemberid = appMemberID;
                        // a key can only be used once
                        
                        existingMemberMap.remove(key);
                        system.debug('HH key removed');
                        
                    }
                    //existing householdmember appid
                }
                if (householdMember.appmemberid != null) {
                    system.debug('HH key removed');
                    
                    existingIDS.remove(householdMember.appmemberid);
                    
                }
            }
        }
        
        Set<Id> existingPrefIds = new Set<Id>();
        //Set<Id> existingListingPrefIds = new Set<Id>();
        //List<Listing_Lottery_Preference__c> existingListingPref = getListingPreferencesByListingIds(new Set<Id>{existingSf.listingID});
        //for (Listing_Lottery_Preference__c listingLotPref : existingListingPref) {
        //    existingListingPrefIds.add(listingLotPref.Id);
        //}
        Map<String,ID> existingPrefMap = new Map<String,ID>();
        if (existingSf.shortFormPreferences != null) {
            //add existing shortformPreference Ids
            for (API_Application.ShortFormPreference sfPref : existingSf.shortFormPreferences) {
                if (sfPref.getKey() != null) {
                    existingPrefMap.put(sfPref.getKey(),sfPref.shortformPreferenceID);
                }
                existingPrefIds.add(sfPref.shortformPreferenceID);
            }
        }
        
        system.debug('existingPrefMap:::' + existingPrefMap);
        if (sf.shortFormPreferences != null) {
            for (API_Application.ShortFormPreference sfPref : sf.shortFormPreferences) {
                String key = sfPref.getKey();
                system.debug('key:::' + key);
                if (existingPrefMap.containsKey(key)) {
                    ID sfPrefID = existingPrefMap.get(key);
                    if (sfPref.shortformPreferenceID == null) {
                        sfPref.shortformPreferenceID = sfPrefID;
                        // a key can only be used once
                        existingPrefMap.remove(key);
                        system.debug('Pref key removed');
                    }
                    //existing pref appid
                }
                if (sfPref.shortformPreferenceID != null) {
                    system.debug('Pref key removed');
                    existingPrefIds.remove(sfPref.shortformPreferenceID);
                    //existingListingPrefIds.remove(sfPref.listingPreferenceID);
                }
            }
        }
        
        
        system.debug('sf:::' + sf);
        Application__c app = saveApplication(sf);
        
        List<Application_Member__c> toBeDeletedApplicationMembers = new List<Application_Member__c>();
        for (ID appMemberID :existingIDS) {
            toBeDeletedApplicationMembers.add(new Application_Member__c(Id = appMemberID));
            
        }
        delete toBeDeletedApplicationMembers;
        
        List<Application_Preference__c> toBeDeletedApplicationPrefs = new List<Application_Preference__c>();
        for (ID prefID : existingPrefIds) {
            toBeDeletedApplicationPrefs.add(new Application_Preference__c(Id = prefID));
            
        }
        delete toBeDeletedApplicationPrefs;
        
        /*List<Application_Preference__c> toBeCreatedApplicationPrefs = new List<Application_Preference__c>();
for (ID listingPrefID : existingListingPrefIds) {
toBeCreatedApplicationPrefs.add(new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefID));
}

if (toBeCreatedApplicationPrefs.size() > 0) {
insert toBeCreatedApplicationPrefs;
}*/
        /*
Set<ID> currentAppMemberIDS = getAppMemberIDSApp(sf.ID);
// extra app members are deleted - they are previous (exising - current (after save) app members)
existingAppMemberIDS.removeAll(currentAppMemberIDS);


List<Application_Member__c> toBeDeletedApplicationMembers = new List<Application_Member__c>();
for (ID existingAppMemberId :existingAppMemberIDS) {
toBeDeletedApplicationMembers.add(new Application_Member__c(Id = existingAppMemberId));

}

delete toBeDeletedApplicationMembers;
*/
        return  app;
        
    }
    
    public static API_Application.ShortForm upsertShortform(API_Application.ShortForm sf) {
        if (sf == null) return null;
        if (sf.status != 'Draft') {
            sf.validate();
        }
        
        Application__c app;
        if (sf.id==null) {
            app = saveApplication(sf);
        } else {
            app = updateSF(sf);
        }
        
        return getShortformById(app.Id);
    }
    
    
    
    
    public static void deleteShortform(API_Application.ShortForm sf) {
        if (sf.id == null) return;
        delete new Application__c(Id = sf.Id);
    }
    
    public static void deletePerson(API_Application.Person p) {
        if (p.contactId == null) return;
        delete new Contact(Id = p.contactId);
    }
    
    public class RecordLockException extends Exception{}
    
    
}