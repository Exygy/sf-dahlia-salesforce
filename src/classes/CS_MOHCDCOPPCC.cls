/**
 * @author:      Ronald Martinez
 * @date:        07/21/2014
 * @description: An apex page controller that supports creation of New Certificate Application for users
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public with sharing class CS_MOHCDCOPPCC{

    public String name {get; set;}
    public String address {get; set;}
    public String phone {get; set;}
    public String email {get; set;}
    public String conId {get; set;}
    public Contact con_detail {get; set;}
    public String relToHH {get;set;}
    public String relToHH2 {get;set;}
    public String dpAdd1 {get; set;}
    public String dpAdd2 {get; set;}
    public String yrOfDp {get; set;}
    public String yrOfDp2 {get; set;}
    public String nameOfHHDp {get; set;}
    public String nameOfHHDp2 {get; set;}
    public List<Contact> fetchCon {get; set;}
    public Boolean isWestern {get; set;}
    public Boolean isHunters {get; set;}
    public Boolean isDisplaced {get; set;}
    public List<CS_MOHCDWrapperClass.wContact> wrpContact {get;set;}
    CS_MOHCDWrapperClass conwrap = new CS_MOHCDWrapperClass();

    public CS_MOHCDCOPPCC() {
        fetchCon  = new List<Contact>();
        wrpContact = conwrap.getContacts2();        
    }

    public PageReference selectContact(){
        if(conId == '' || conId == null){
            name = '';
            address = '';
            phone = '';
            email = '';
        }
        else if(conId != '' || conId != null){
            fetchCon = [SELECT Id,
                               AccountId,
                               //FirstName,
                               //LastName,
                               Name,
                               Phone,
                               Email,
                               Current_Address__c
                               FROM Contact
                               WHERE Id =: conId];
            for (Contact c : fetchCon) {
                name = c.Name;
                address = c.Current_Address__c.replace('<br>','   ');
                phone = c.Phone;
                email = c.Email;
            }
        }
        
        return null;
    }
    
    public Boolean getErrorsPresent(){
        return ApexPages.hasMessages(ApexPages.Severity.ERROR);
    }
    
    public Boolean getSuccessPresent(){
        return ApexPages.hasMessages(ApexPages.Severity.CONFIRM);
    }

    public PageReference submitRequest(){
    Boolean isError=FALSE;
    
        if (isWestern==FALSE && isHunters==FALSE) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_COP_CHECKBOX));
            isError=TRUE;
        }
        else if (isWestern==TRUE || isHunters==TRUE) {
            isError=FALSE;
        }
        
        if (fetchCon != null && ! fetchCon.isEmpty() && isError==FALSE) {
            List<Certificate_Program__c> certAppList = new List<Certificate_Program__c>();
            Certificate_Program__c certApp = new Certificate_Program__c();
            Recordtype recTypeId = [SELECT Id from Recordtype where Name=:StringConstants.CERT_RECTYPE_COP AND SObjectType = 'Certificate_Program__c'];

            certApp.RecordTypeId = recTypeId.Id;
            certApp.Household_Contact__c = fetchCon[0].Id;
            certApp.Household_Account__c = fetchCon[0].AccountId;
            certApp.Application_Status__c = 'Submitted';
            certApp.Submit_Date__c = Date.today();
            certApp.Western_Addition_between_1966_and_1975__c = isWestern;
            certApp.Hunters_Point_between_1966_and_1975__c = isHunters;
            certApp.Telephone_Number__c = phone;
            certApp.Email_Address__c = email;
            certApp.Displacement_Address_1__c = dpAdd1;
            certApp.Displacement_Address_2__c = dpAdd2;
            certApp.Name_of_Head_of_Household_when_Displaced__c = nameOfHHDp;
            certApp.Name_of_Head_of_HH_when_Displaced_2__c = nameOfHHDp2;
            certApp.Relationship_to_Head_of_Household__c = relToHH;
            certApp.Relationship_to_Head_of_Household_2__c = relToHH2;
            certApp.In_what_year_were_you_displaced__c = yrOfDp;
            certApp.In_what_year_were_you_displaced_2__c = yrOfDp2;
            certAppList.add(certApp);

            System.debug('********************' + certAppList);

            if (certAppList != null && !certAppList.isEmpty()) {
                insert certAppList;
            }
            
            //Change redirection page Ronald Martinez 07/17/2014 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.SUCCESS_COP_REQUEST));
           
            return null;
        }
        return null;
    }


    public List<SelectOption> getPicklist() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.NONE_OPTION));
            for(CS_MOHCDWrapperClass.wContact cn: wrpContact){
                options.add(new SelectOption(cn.con.Id,cn.con.FirstName));
            }
        return options;
    }
}