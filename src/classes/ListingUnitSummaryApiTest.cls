// *****************************************************************************
// CLASS: ListingUnitSummaryApiTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingUnitSummaryApi.cls and ListingService.cls
//
// *
@isTest
private class ListingUnitSummaryApiTest {

    private static Account acc;
    private static Contact con;
    private static ID listingId;
    
    static void setupTestData() {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = new Account();
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
        
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        listing.Building__c  = build.id;
        listing.Account__c = acc.Id;
        listing.Status__c = 'Active';
        listing.Does_Match__c = true;
        insert listing;
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 200;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Number_of_Bedrooms__c = 1;
        unit.Unit_Square_Footage__c = 10;
        
        Unit__c unit2 = new Unit__c();
        unit2.property__c = build.id;
        unit2.BMR_Rent_Monthly__c = 400;
        unit2.Rent_Multiple__c=3;
        unit2.of_AMI_for_Pricing_Unit__c=55;
        unit2.Listing__c = listing.id;
        unit2.Number_of_Bedrooms__c = 2;
        unit2.Unit_Square_Footage__c = 20;
        insert new List<Unit__c>{unit, unit2};
        
        listingID = listing.id;
    }
	
    
     //* get unit summary by listing id
     
    static testMethod void testGetUnitSummaryByListingID() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/Listing/Units/' + listingID;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        ListingService.UnitSummaries unitSummaries = ListingUnitSummaryApi.doGet();
        
        //check if returned values are correct
        system.assert(unitSummaries.general[0].listingID == listingId);
        system.assert(unitSummaries.general[0].totalUnits == 2);
        system.assert(unitSummaries.general[0].minOccupancy == 1);
        //system.assert(unitSummaries.general[0].maxOccupancy == 2);
        system.assert(unitSummaries.general[0].minSquareFt == 10);
        system.assert(unitSummaries.general[0].maxSquareFt == 20);
        system.assert(unitSummaries.general[0].minMonthlyRent == 200);
        system.assert(unitSummaries.general[0].maxMonthlyRent == 400);
        system.assert(unitSummaries.general[0].minRentalMinIncome == 600);
        system.assert(unitSummaries.general[0].maxRentalMinIncome == 1200);
        
    }
    
    
     //* get unit summary by listing id
     
    static testMethod void testGetUnitSummaryByListingIDParam() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/Listing/Units';  
        req.addParameter('id', listingID);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        ListingService.UnitSummaries unitSummaries = ListingUnitSummaryApi.doGet();
        
        //check if returned values are correct
        system.assert(unitSummaries.general[0].listingID == listingId);
        system.assert(unitSummaries.general[0].totalUnits == 2);
        system.assert(unitSummaries.general[0].minOccupancy == 1);
        //system.assert(unitSummaries.general[0].maxOccupancy == 2);
        system.assert(unitSummaries.general[0].minSquareFt == 10);
        system.assert(unitSummaries.general[0].maxSquareFt == 20);
        system.assert(unitSummaries.general[0].minMonthlyRent == 200);
        system.assert(unitSummaries.general[0].maxMonthlyRent == 400);
        system.assert(unitSummaries.general[0].minRentalMinIncome == 600);
        system.assert(unitSummaries.general[0].maxRentalMinIncome == 1200);
    }
}