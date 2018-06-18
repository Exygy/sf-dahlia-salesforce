// *****************************************************************************
// CLASS: ListingFlaggedApplicationActionTest
// *****************************************************************************
//
// Author: Vertiba/Jason Christman
// Date: 2016-07-14
// Description: ListingFlaggedApplicationActionTest controller test methods
// 			  : test methods build test data and insert DuplicateRecordItems to
// 			  : fire DuplicateRecordItemTrigger and run ListingFlaggedApplicationAction
// *****************************************************************************
@isTest(SeeAllData=true)
public class ListingFlaggedApplicationActionTest {

	private static Listing__c theListing;
	private static Set<Id> applicationMemberIDs = new Set<Id>();

	
    private static void setupData(){
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = rtId;
        acc.AccountNumber = '12345';
        insert acc;
        
        Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        dev.Project_ID__c = '123';
        insert dev;
      
        Building__c build = new Building__c();
        build.Development__c = dev.Id;
        build.Developer__c = acc.Id;
       	insert build;
        
        theListing = new Listing__c();
        theListing.name='somelisting';
        theListing.Building__c  = build.id;
        theListing.Account__c = acc.Id;
        theListing.Status__c = 'Active';
        theListing.Does_Match__c = true;
        insert theListing;
        
      
        
        List<Unit__c> units = new  List<Unit__c>();
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = theListing.id;
        unit.Number_of_Bedrooms__c = 3;
        units.add( unit);
        
        Unit__c unit1 = new Unit__c();
        unit1.property__c  = build.id;
        unit1.BMR_Rent_Monthly__c = 400;
        unit1.Rent_Multiple__c=3;
        unit1.of_AMI_for_Pricing_Unit__c=55;
        unit1.Listing__c = theListing.id;
        unit1.Number_of_Bedrooms__c = 3;
        units.add( unit1);
        insert units;
        
        
        
        applicationMemberIDs = new Set<Id>();
        
        Application__c application1= new Application__c();
        application1.Listing__c = theListing.Id;
        application1.status__c = 'Submitted';
        
        
        insert application1;
        
        Application_Member__c member1 = new Application_Member__c();
		member1.Application__c = application1.id;
		member1.Listing_ID__c = theListing.id;
		member1.DOB_Text__c = '1988-04-02';
		member1.Type__c = 'Household Member';
		member1.First_Name__c = 'Dave';
		member1.Last_Name__c = 'Kaplan';
		member1.Identify_as_Lesbian_Gay_Bisexual__c = false;
		member1.Living_with_HIV_AIDS__c = false;
		member1.Email__c = 'test@test.com';
		member1.Neighborhood_Preference__c = false;
		member1.Primary_Language__c = 'English';
		member1.No_Address__c = false;
		member1.No_Email__c = false;
		member1.No_Phone__c = false;
		member1.Date_of_Birth__c = date.today();
		//insert member1;
		applicationMemberIDs.add(member1.id);
		
		Application__c application2= new Application__c();
        application2.Listing__c = theListing.Id;
        application2.status__c = 'Submitted';
        
        insert application2;
		Application_Member__c member2 = new Application_Member__c();
		member2.Application__c = application2.id;
		member2.Listing_ID__c = theListing.id;
		member2.DOB_Text__c = '1996-07-05';
		member2.Type__c = 'Household Member';
		member2.First_Name__c = 'Dave';
		member2.Last_Name__c = 'Kaplan';
		member2.Date_of_Birth__c = Date.newInstance(1996, 7, 5);
		member2.Identify_as_Lesbian_Gay_Bisexual__c = false;
		member2.Living_with_HIV_AIDS__c = false;
		member2.Email__c = 'test@test.com';
		member2.Neighborhood_Preference__c = false;
		member2.Primary_Language__c = 'English';
		member2.No_Address__c = false;
		member2.No_Email__c = false;
		member2.No_Phone__c = false;
		//insert member2;
        
        Application__c application3= new Application__c();
        application3.Listing__c = theListing.Id;
        insert application3;
		Application_Member__c member3 = new Application_Member__c();
		member3.Application__c = application3.id;
		member3.Listing_ID__c = theListing.id;
		member3.DOB_Text__c = '1996-07-05';
		member3.Type__c = 'Primary Applicant';
		member3.First_Name__c = 'Dave';
		member3.Last_Name__c = 'Kaplan';
		member3.Date_of_Birth__c = Date.newInstance(1996, 7, 5);
		member3.Identify_as_Lesbian_Gay_Bisexual__c = false;
		member3.Living_with_HIV_AIDS__c = false;
		member3.Email__c = 'test@test.com';
		member3.Neighborhood_Preference__c = false;
		member3.Primary_Language__c = 'English';
		member3.No_Address__c = false;
		member3.No_Email__c = false;
		member3.No_Phone__c = false;
		//insert member3;
        
        Application__c application4= new Application__c();
        application4.Listing__c = theListing.Id;
        insert application4;
		Application_Member__c member4 = new Application_Member__c();
		member4.Application__c = application4.id;
		member4.Listing_ID__c = theListing.id;
		member4.DOB_Text__c = '1996-07-05';
		member4.Type__c = 'Alternate Contact';
		member4.First_Name__c = 'Dave';
		member4.Last_Name__c = 'Kaplan';
		member4.Date_of_Birth__c = Date.newInstance(1996, 7, 5);
		member4.Identify_as_Lesbian_Gay_Bisexual__c = false;
		member4.Living_with_HIV_AIDS__c = false;
		member4.Email__c = 'test@test.com';
		member4.Neighborhood_Preference__c = false;
		member4.Primary_Language__c = 'English';
		member4.No_Address__c = false;
		member4.No_Email__c = false;
		member4.No_Phone__c = false;
        insert new List<Application_Member__c>{member1, member2, member3, member4};
        
        applicationMemberIDs.add(member4.id);
        // 
        // Duplicate rules should of fired and caught the duplicate members being inserted
        // However the rules seem to run and never actually catch anything to create the 
        // DuplicateRecordSet and DuplicateRecordItem enteries. 
        // To cause the DuplicateRecoredItemTrigger to fire we are selecting the duplicate rule
        // and building the DuplicateRecordSet and DuplicateRecordItem records.  
        // To do this you can use a create() or an upsert()  
        // I was getting item declared when trying the create so I used the uspert method
        // This inserts the duplicateRecordItem that fires the trigger and 
        // then runs ListingFlaggedApplicationAction
        // 
        DuplicateRule rule = [SELECT Id, sObjectType FROM DuplicateRule WHERE sObjectType = 'Application_Member__c' LIMIT 1];
        DuplicateRecordSet drs = new DuplicateRecordSet();
        drs.DuplicateRuleId = rule.Id;
		upsert drs;
        system.debug('drs: ' + drs);
        
        List<DuplicateRecordItem> dris = new List<DuplicateRecordItem>();
        DuplicateRecordItem dri = new DuplicateRecordItem();
        dri.DuplicateRecordSetId = drs.Id;
        dri.RecordId = member2.Id;    
        dris.add(dri);
        //upsert dri;
        system.debug('dri: ' + dri);
        
        DuplicateRecordItem dri2 = new DuplicateRecordItem();
        dri2.DuplicateRecordSetId = drs.Id;
        dri2.RecordId = member3.Id;        
        //upsert dri2;
        dris.add(dri2);
        system.debug('dri2: ' + dri2);
        
        DuplicateRecordItem dri3 = new DuplicateRecordItem();
        dri3.DuplicateRecordSetId = drs.Id;
        dri3.RecordId = member4.Id;        
        //upsert dri3;
        dris.add(dri3);
        upsert dris;
        system.debug('dri3: ' + dri3);
        //Flagged_Record_Set__c flaggedRecordSet = [SELECT Id, DuplicateRecordSetID__c FROM Flagged_Record_Set__c WHERE DuplicateRecordSetID__c = : drs.Id];
        //system.assert(flaggedRecordSet.DuplicateRecordSetID__c == drs.Id);
    
        //Flagged_Application__c flaggedApplication = [SELECT Id, DuplicateRecordItem__c FROM Flagged_Application__c WHERE DuplicateRecordItem__c = : dri.Id ];
        //system.assert(flaggedApplication.DuplicateRecordItem__c == dri.Id);
        
    }
    
    private static testMethod void runTest(){
    	
    	Integer dupRecordCount = [SELECT COUNT() FROM DuplicateRecordItem];
    	system.debug('current dupRecordCount1'  + dupRecordCount);
    	
    	setupData();

		test.startTest();
    	
        dupRecordCount = [SELECT COUNT() FROM DuplicateRecordItem];
    	system.debug('final dupRecordCount1'  + dupRecordCount);
    	test.stopTest();
    	
		
    }
    
    
    private static testMethod void runTest2(){
    	test.startTest();
    	
    	Integer dupRecordCount = [SELECT COUNT() FROM DuplicateRecordItem];
    	system.debug('current dupRecordCount2'  + dupRecordCount);
    	
    	
    	Contact c1 = new Contact();
    	c1.lastname='duptest';
    	c1.firstname='guy';
    	c1.email='this@that.com';
    	c1.phone='123456789';
    	Contact c2 = new Contact();
    	c2.lastname='duptest';
    	c2.firstname='guy';
    	c2.phone='123456789';
    	insert c1;
    	insert c2;

		dupRecordCount = [SELECT COUNT() FROM DuplicateRecordItem];
    	system.debug('final dupRecordCount2'  + dupRecordCount);
    	test.stopTest();
    	
		
    }
   	private static void insertMember1() { 
	    Application_Member__c member1 = new Application_Member__c();
		member1.Application__c = 'a0tf0000000mN2fAAE';
		member1.Listing_ID__c = 'a0WU000000BmpBdMAJ';
		member1.DOB_Text__c = '1988-04-02';
		member1.Type__c = 'Household Member';
		member1.First_Name__c = 'Dave';
		member1.Last_Name__c = 'Kaplan';
		member1.Identify_as_Lesbian_Gay_Bisexual__c = false;
		member1.Living_with_HIV_AIDS__c = false;
		member1.Email__c = 'test@test.com';
		member1.Neighborhood_Preference__c = false;
		member1.Primary_Language__c = 'English';
		member1.No_Address__c = false;
		member1.No_Email__c = false;
		member1.No_Phone__c = false;
		insert member1;
	}

	private static void insertMember2() {
		Application_Member__c member2 = new Application_Member__c();
		member2.Application__c = 'a0tf0000000mJK6AAM';
		member2.Listing_ID__c = 'a0WU000000BmpBdMAJ';
		member2.DOB_Text__c = '1996-07-05';
		member2.Type__c = 'Household Member';
		member2.First_Name__c = 'Dave';
		member2.Last_Name__c = 'Kaplan';
		member2.Date_of_Birth__c = Date.newInstance(1996, 7, 5);
		member2.Identify_as_Lesbian_Gay_Bisexual__c = false;
		member2.Living_with_HIV_AIDS__c = false;
		member2.Email__c = 'test@test.com';
		member2.Neighborhood_Preference__c = false;
		member2.Primary_Language__c = 'English';
		member2.No_Address__c = false;
		member2.No_Email__c = false;
		member2.No_Phone__c = false;
		insert member2;
	}
	
	static Application_Member__c member1;
 	static Application_Member__c member2;
 

}