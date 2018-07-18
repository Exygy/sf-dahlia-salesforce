// *****************************************************************************
// CLASS: API_ShortForm_UploadFileTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for API_ShortForm_UploadFile.cls
//
// *

@isTest
public class API_ShortForm_UploadFileTest {
    
    static Attachment Attachment1;
	static Listing__c ListingC1;
	static Application__c ApplicationC1;
	
	public static void setupData() { 
		insertListingC1();
		insertApplicationC1();
		insertAttachment1();
	}
	public static void insertListingC1() {
		ListingC1 = new Listing__c();
		ListingC1.Name = '1010 16th Street';
		ListingC1.Status__c = 'Active';
		ListingC1.Building_Listing_Category__c = 'New Rental';
		ListingC1.Min_BR__c = 0;
		ListingC1.Max_BR__c = 3;
		ListingC1.Application_Phone__c = '(866) 276-4191';
		ListingC1.AMI_Percentage__c = 55.00;
		ListingC1.Description__c = 'desc abc';
		ListingC1.sfxId__c = ListingC1.id;
		ListingC1.Fee__c = 35.00;
		ListingC1.Deposit_Min__c = 500.00;
		ListingC1.Deposit_Max__c = 600.00;
		ListingC1.Costs_Not_Included__c = 'ha ha';
		ListingC1.Application_Organization__c = 'abc';
		ListingC1.Lottery_Venue__c = 'Koret Auditorium, San Francisco Public Library';
		ListingC1.Lottery_Street_Address__c = '1 Larkin St';
		ListingC1.Lottery_City__c = 'San Francisco';
		ListingC1.Amenities__c = 'Outdoor Grill Area, 24-Hour Fitness Center, Access Controlled Community, Valet Dry Cleaning Service, Smoke Free Living, WiFi in Lobby, Rooftop Deck, Private Balcony, Wood Plank Flooring, City Skyline Views, Kitchen, Dishwasher';
		ListingC1.Accessibility__c = 'Wheelchair access, Shower grab bars, Accessible Elevator';
		ListingC1.Building_Selection_Criteria__c = '1010 Property Selection Criteria';
		ListingC1.Required_Documents__c = 'For those selected in the lottery, the following documents may be required:';
		ListingC1.Legal_Disclaimers__c = 'Applicants should be informed that BMR <b>rental units in some buildings may </b>convert to ownership units in the future. <i>In the case of conversion, BMR renters </i>will be afforded certain rights as <u>explained in the Inclusionary Affordable </u>Housing Program Monitoring and Procedures Manual 2013. Applicants should inquire with the building contact person listed above to determine if the building has a minimum number of years that it must remain a rental building. (Some buildings may have such restrictions based on government sources of financing for their building.) Most buildings may have no restrictions on conversion at all.<br><br><br><br>It is also important to note that units governed by the Inclusionary Housing Program are NOT governed by the San Francisco Rent Ordinance (also known as “rent control”). Among other rules, rents may increase beyond increases allowed under “rent control.” Please see the Inclusionary Affordable Housing Program Monitoring and Procedures Manual 2013 for more information.';
		ListingC1.Smoking_Policy__c = 'No smoking';
		ListingC1.Pet_Policy__c = '$65 pet rent plus $500 pet deposit at move in';
		ListingC1.Min_Occupancy__c = 1;
		ListingC1.Max_Occupancy__c = 6;
		ListingC1.Min_Income__c = 4000.00;
		ListingC1.Max_Income__c = 50000.00;
		ListingC1.Does_Match__c = false;
		ListingC1.Lottery_Results_Date__c = Date.newInstance(2016, 5, 24);
		ListingC1.Lottery_Summary__c = 'def';
		ListingC1.Lottery_Date__c = DateTime.newInstance(1450145640000L);
		ListingC1.Application_Street_Address__c = '10 Space St';
		ListingC1.Application_City__c = 'San Francisco';
		ListingC1.Application_State__c = 'CA';
		ListingC1.Application_Postal_Code__c = '94111';
		ListingC1.Number_of_Applications__c = 2;
		ListingC1.Application_Due_Date__c = DateTime.newInstance(1463529720000L);
		insert ListingC1;
	}
	public static void insertApplicationC1() {
		ApplicationC1 = new Application__c();
		//ApplicationC1.OwnerId = '00521000000NE2hAAG';
		//ApplicationC1.RecordTypeId = '01221000000ChqdAAC';
		//ApplicationC1.Applicant_Household__c = '00121000004ThVUAA0';
		ApplicationC1.Status__c = 'Draft';
		//ApplicationC1.Alternate_Contact__c = '00321000003o2OoAAI';
		//ApplicationC1.Primary_Applicant__c = '00321000003o3S3AAI';
		ApplicationC1.Is_Resident__c = false;
		ApplicationC1.Listing__c = ListingC1.id;
		ApplicationC1.Lottery_Rank__c = 2;
		ApplicationC1.Total_Household_Size_Entered__c = 0;
		ApplicationC1.Application_Language__c = 'Croatian';
		ApplicationC1.Application_Submission_Type__c = 'Paper';
		insert ApplicationC1;
	}
	public static void insertAttachment1() {
		Attachment1 = new Attachment();
		Attachment1.Name = 'empty.txt';
		Attachment1.IsPrivate = false;
		Attachment1.ContentType = 'text/plain';
		Attachment1.Body = blob.valueOf('empty');
		//Attachment1.OwnerId = '00521000000NGjJAAW';
		Attachment1.ParentId = ApplicationC1.Id;
		insert Attachment1;
	}
	
    
    static testMethod void getPicture() {
        setupData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/shortForm/file/' + Attachment1.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
    }
    
    static testMethod void attachPicture() {
        setupData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/shortForm/file/' + ApplicationC1.Id;
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        req.addHeader('Name','Name');
        req.addHeader('ContentType','jpg');
        req.requestBody = Blob.valueOf('body');
        RestContext.response = res;
    }
}