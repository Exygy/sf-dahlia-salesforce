/**
 * @author:      Ronald Martinez
 * @date:        07/23/2014
 * @description: This is a Test Class for CS_MOHCDCOPCC.
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
@isTest
public with sharing class CS_MOHCDCOPPCCTest{
    
    static testmethod void testCOPP(){
        //Create Account
        Account oAcc = new Account(Name = 'Test Account');
        insert oAcc;
        
        //Create Contacts
        List<Contact> lContacts  = new List<Contact>();
        Integer iNoCon = 1;
        
        for(Integer count = 0; count < iNoCon; count++){
            Contact oCon = new Contact(FirstName = 'Test FN', 
                                        LastName = 'LN:'+count, 
                                        Phone = '987654321',
                                        Email = 'test' +iNoCon+'@email.com',
                                        Street_Number__c = String.valueOf(count),
                                        Street_Name__c = 'Street Name',
                                        Street_Type__c = 'Not Applicable',
                                        Apt_Unit__c = String.valueOf(count), 
                                        Address_Line_2__c = 'AL2',
                                        City__c = 'TestCity',
                                        Zip_Code__c = '11111',
                                        AccountId = oAcc.Id
                                        );
            lContacts.add(oCon);
        }
        
        if(lContacts.size() > 0){
            insert lContacts;
        }
        
        //Profile
        Profile oProf = [Select Id from Profile where Name =: StringConstants.HOUSEHOLD_PROFILE];
        
        //Create User
        User user01 = new User();    
            user01.LanguageLocaleKey='en_US';
            user01.LocaleSidKey='en_US'; 
            user01.TimeZoneSidKey='America/Los_Angeles';
            user01.LastName = 'User01';
            user01.Alias = 'User01';
            user01.Email = 'user01@test.com.test';
            user01.CommunityNickname = 'User01';
            user01.EmailEncodingKey='UTF-8';
            user01.UserName='user01@test.com.test';
            user01.IsActive = true;
            user01.ProfileId = oProf.Id;
            user01.ContactId = lContacts[0].Id;
 
            insert user01;
            
                    
            
        Test.startTest();
        System.RunAs(user01){
            PageReference pageRef = page.mohcdCOPP;
            Test.setCurrentPage(pageRef);
            CS_MOHCDCOPPCC oControl = new CS_MOHCDCOPPCC();
            
            lContacts = new List<Contact>([SELECT Id,
                               AccountId,
                               Name,
                               Phone,
                               Email,
                               Current_Address__c FROM Contact WHERE Id IN :lContacts]);
			system.debug('lContacts:::' + lContacts);
            
            
            for(Integer count = 0; count < iNoCon; count++){
            	system.debug('count:::' + count);
                oControl.selectContact();
                oControl.ConId = lContacts[count].Id;
                oControl.isWestern = FALSE;
                oControl.isHunters = FALSE;
                oControl.getPicklist();
                oControl.selectContact();
                oControl.submitRequest();
                oControl.getErrorsPresent();
                oControl.getSuccessPresent();
                System.assert(oControl.name == lContacts[count].Name,lContacts[count].Name);
                List<Certificate_Program__c> lCP = [Select Id from Certificate_Program__c];
                System.AssertEquals(lCP.size(), 0);
            }
        }
        Test.stopTest();    
    }

    static testmethod void testCOPSubmitRequest(){
        //Create Account
        Account oAcc = new Account(Name = 'Test Account');
        insert oAcc;
        
        //Create Contacts
        List<Contact> lContacts  = new List<Contact>();
        Integer iNoCon = 1;
        
        for(Integer count = 0; count < iNoCon; count++){
            Contact oCon = new Contact(FirstName = 'Test FN', 
                                        LastName = 'LN:'+count, 
                                        Phone = '987654321',
                                        Email = 'test' +iNoCon+'@email.com',
                                        Street_Number__c = String.valueOf(count),
                                        Street_Name__c = 'Street Name',
                                        Street_Type__c = 'Not Applicable',
                                        Apt_Unit__c = String.valueOf(count), 
                                        Address_Line_2__c = 'AL2',
                                        City__c = 'TestCity',
                                        Zip_Code__c = '11111',
                                        AccountId = oAcc.Id
                                        );
            lContacts.add(oCon);
        }
        
        if(lContacts.size() > 0){
            insert lContacts;
        }
        
        //Profile
        Profile oProf = [Select Id from Profile where Name =: StringConstants.HOUSEHOLD_PROFILE];
        
        //Create User
        User user01 = new User();    
            user01.LanguageLocaleKey='en_US';
            user01.LocaleSidKey='en_US'; 
            user01.TimeZoneSidKey='America/Los_Angeles';
            user01.LastName = 'User01';
            user01.Alias = 'User01';
            user01.Email = 'user01@test.com.test';
            user01.CommunityNickname = 'User01';
            user01.EmailEncodingKey='UTF-8';
            user01.UserName='user01@test.com.test';
            user01.IsActive = true;
            user01.ProfileId = oProf.Id;
            user01.ContactId = lContacts[0].Id;
 
            insert user01;
            
                    
            
        Test.startTest();
        System.RunAs(user01){
            PageReference pageRef = page.mohcdCOPP;
            Test.setCurrentPage(pageRef);
            CS_MOHCDCOPPCC oControl = new CS_MOHCDCOPPCC();
            
            lContacts = new List<Contact>([SELECT Id,
                               AccountId,
                               Name,
                               Phone,
                               Email,
                               Current_Address__c FROM Contact WHERE Id IN :lContacts]);

            for(Integer count = 0; count < iNoCon; count++){
                oControl.selectContact();
                oControl.ConId = lContacts[count].Id;
                oControl.isWestern = TRUE;
                oControl.isHunters = TRUE;
                oControl.getPicklist();
                oControl.selectContact();
                oControl.submitRequest();
                System.assert(oControl.name == lContacts[count].Name,lContacts[count].Name);
                List<Certificate_Program__c> lCP = [Select Id from Certificate_Program__c];
                System.assert(lCP.size()==count+1,lCP.size());
            }
        }
        Test.stopTest();    
    }
}