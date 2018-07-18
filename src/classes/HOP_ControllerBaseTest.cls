// *****************************************************************************
// CLASS: HOP_ControllerBaseTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ControllerBase class.
//
// *****************************************************************************

@isTest
private class HOP_ControllerBaseTest {
    
    @isTest
    static void HOP_ControllerBaseTest() {
        Test.startTest();
        HOP_ControllerBase cb = new HOP_ControllerBase();
        System.assert(cb.myUser != null);
        Test.stopTest();
    }
    
    //test getRecords for application object
    @isTest
    static void getRecordsforApplicationTest() {
        
        HOP_ControllerBase.dataTableResponse response = new HOP_ControllerBase.dataTableResponse();
        
        Account acc = new Account(Name='Test Account');
        insert acc;

        Development__c dev = new Development__c(Name_of_Development__c='Test Development', Development_City__c = 'San Francisco', Development_State__c = 'CA', Project_ID__c = '123');
        insert dev;

        Building__c build = new Building__c(Property_Name__c='Test Building', Development__c = dev.id);
        insert build;

        Listing__c lst = new Listing__c(Name='Test Listing', Building__c = build.id, Account__c = acc.id);
        insert lst;
        Application__c app =new Application__c(Listing__c=lst.Id,Annual_Income__c=100.00,Terms_Acknowledged__c=false);
        insert app;
        Application_Member__c member = new Application_Member__c(First_Name__c='appTestFN',Last_Name__c='appTestLN',Date_of_Birth__c=Date.valueOf('2000-01-01'),Application__c=app.Id,Phone__c= '(800) 555-1212',Email__c='abc@gmail.com');
        insert member;
        app.Applicant__c=member.Id;
        update app;
        string whereClause= 'Listing__c = \'' + lst.Id+ '\'';
        
        Test.startTest();
        response = HOP_ControllerBase.getRecords('Application__c','Id,Listing__c,Listing__r.Name, Name, Last_Name__c, First_Name__c, Application_Submitted_Date__c,Terms_Acknowledged__c,Annual_Income__c,Phone__c,Email__c',whereClause);
        string result = (string)((Application__c)response.dataRows[0]).get(response.dataColumns[4].data);
        
        System.assertEquals('appTestLN', result);
        Test.stopTest();
        
    }
    //test getRecords for Listing object
    @isTest
    static void getRecordsforListingsTest() {
        HOP_ControllerBase.dataTableResponse response = new HOP_ControllerBase.dataTableResponse();
        Account acc = new Account(Name='Test Account');
        insert acc;

        Development__c dev = new Development__c(Name_of_Development__c='Test Development', Development_City__c = 'San Francisco', Development_State__c = 'CA', Project_ID__c = '123');
        insert dev;

        Building__c build = new Building__c(Property_Name__c='Test Building', Development__c = dev.id);
        insert build;

        Listing__c lst = new Listing__c(Name='Test Listing', Building__c = build.id, Account__c = acc.id, AMI_Percentage__c=0.5);
        insert lst;

        string whereClause= 'Id = \'' + lst.Id+ '\'';
        Test.startTest();
        response = HOP_ControllerBase.getRecords('Listing__c','Id,Name,AMI_Percentage__c',whereClause);
        string result = (string)((Listing__c)response.dataRows[0]).get(response.dataColumns[1].data);
        
        System.assertEquals('Test Listing', result);
        Test.stopTest();
    }
    
}