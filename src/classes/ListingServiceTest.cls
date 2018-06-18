@isTest
private class ListingServiceTest {
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static ListingService.criteria crit;
    static  ID listingID ;
    static List<Id> listListingId;
    static String preferenceName ;
    static AMI__c ami;
    static Application__c app;

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

        //Property__c prop = new Property__c();//
        //prop.development__c=dev.id;//
       // insert prop;//

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
        listing.Min_Occupancy__c = 3;
        insert listing;

        Listing__c listing1 = new Listing__c();
        listing1.name='somelisting1';
        listing1.Building__c  = build.id;
        listing1.Account__c = acc.Id;
        listing1.Status__c = 'Active';
        listing1.Does_Match__c = true;
        insert listing1;


        /*
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Name = 'Test Lottery Preference';
        lp.Status__c = 'New';
        insert lp;
        preferenceName = lp.Name;

        Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
        llp.Listing__c = listing.Id;
        llp.Lottery_Preference__c = lp.Id;
        insert llp;
        */


        Lottery_Preference__c lotPref = new Lottery_Preference__c(Name = 'Neighborhood Resident Housing Preference (NRHP)');
		Lottery_Preference__c lotPref2 = new Lottery_Preference__c(Name = 'Live or Work in San Francisco Preference');
		Lottery_Preference__c lotPref3 = new Lottery_Preference__c(Name = 'Certificate of Preference (COP)');
		Lottery_Preference__c lotPref4 = new Lottery_Preference__c(Name = 'Displaced Tenant Housing Preference (DTHP)');
		List<Lottery_Preference__c> lotPrefList = new List<Lottery_Preference__c>{lotPref,lotPref2,lotPref3,lotPref4};
		insert lotPrefList;

		Listing_Lottery_Preference__c listingPref = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[0].Id);
		Listing_Lottery_Preference__c listingPref2 = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[1].Id);
		Listing_Lottery_Preference__c listingPref3 = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[2].Id);
		Listing_Lottery_Preference__c listingPref4 = new Listing_Lottery_Preference__c(Listing__c = listing.Id, Lottery_Preference__c = lotPrefList[3].Id);
		List<Listing_Lottery_Preference__c> listingPrefList = new List<Listing_Lottery_Preference__c>{listingPref, listingPref2, listingPref3, listingPref4};
		insert listingPrefList;
        
        app = new Application__c();
        app.listing__c = listing.Id;
        app.Lottery_Number_Manual__c  = '1234';
        app.Lottery_Rank__c = 1;
        insert app;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, First_Name__c = 'Test', Last_Name__c = 'lastName', Date_of_Birth__c = date.today().addYears(-20), Neighborhood_Preference_Match__c  = 'Matches');
        insert appM;

		Application_Preference__c appPref = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[0].Id, Application_Member__c = appM.Id);
        Application_Preference__c appPref2 = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[1].Id, Application_Member__c = appM.Id);
        Application_Preference__c appPref3 = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[2].Id, Application_Member__c = appM.Id);
        Application_Preference__c appPref4 = new Application_Preference__c(Application__c = app.Id, Listing_Preference_ID__c = listingPrefList[3].Id, Application_Member__c = appM.Id);
        List<Application_Preference__c> appPrefs = new List<Application_Preference__c>{appPref,appPref2,appPref3,appPref4};
        insert appPrefs;

        Id unitRtId = Schema.SObjectType.Unit__c.getRecordTypeInfosByName().get('BMR Rental').getRecordTypeId();

        Unit__c unit = new Unit__c();
        unit.RecordTypeId = unitRtId;
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=2;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;

        Unit__c unit1 = new Unit__c();
        unit1.RecordTypeId = unitRtId;
        unit1.property__c  = build.id;
        unit1.BMR_Rent_Monthly__c = 400;
        unit1.Rent_Multiple__c=2;
        unit1.of_AMI_for_Pricing_Unit__c=55;
        unit1.Listing__c = listing1.id;
        unit1.Number_of_Bedrooms__c = 3;
        unit1.Priority_Type__c = 'Vision impaired';
        insert unit1;

        Unit__c unit2 = new Unit__c();
        unit2.property__c  = build.id;
        unit2.BMR_Rent_Monthly__c = 400;
        unit2.Rent_Multiple__c=2;
        unit2.of_AMI_for_Pricing_Unit__c=55;
        unit2.Listing__c = listing1.id;
        unit2.Number_of_Bedrooms__c = 3;
        insert unit2;

        listingID = listing.id;
        listListingId = new List<Id>();
        listListingId.add(listingID);

        ami = new AMI__c();
        ami.name='Test Lottery Preference';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=55;
        insert ami;
        //select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]

        crit = new ListingService.criteria();
        crit.childrenUnder6 = 6;
        crit.householdSize = 10;
        crit.incomelevel = 15000;
        crit.PreferenceName = 'Test Lottery Preference';


    }
    static testMethod void testGetListingByID() {
        setupTestData();

        List<Listing__c> testL = new List<Listing__c>();
        testL = ListingService.getListingByID(listingID,' For View ');
        //verify the returned Id is the right one
        system.assert(testL[0].Id == listingId);
    }
    static testMethod void testGetListingByIDs() {
        setupTestData();

        List<Listing__c> testL = new List<Listing__c>();

        testL = ListingService.getListingByIDs(listListingID,' For View ');
        //verify the returned Id is the right one
        system.assert(testL[0].Id == listingId);
    }
    /* removed for now  -LL until we do new preference model
    static testMethod void testGetActiveListingsByPreference() {
        setupTestData();

        List<Listing__c> testL = new List<Listing__c>();

        testL = ListingService.getActiveListingsByPreference(preferenceName);
        //verify the returned Id is the right one
        system.assert(testL[0].Id == listingId);
    }
    */
    static testMethod void testGetAllActiveListings() {
        setupTestData();

        List<Listing__c> testL = new List<Listing__c>();

        testL = ListingService.getAllActiveListings(label.FOR_VIEW_QUERY_CLAUSE);
        //number of expected result is met
        system.assert(testL.size() == 2);
    }

    static testMethod void testGetListingDetailByCriteria() {
        setupTestData();

        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getListingDetailByCriteria(crit,label.FOR_VIEW_QUERY_CLAUSE);
        //number of expected result is met
        system.assert(testLd.size() == 2);
    }
    static testMethod void testGetListingDetailByID() {
        setupTestData();

        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getListingDetailByID(listingId,label.FOR_VIEW_QUERY_CLAUSE);
        //number of expected result is met
        system.assert(testLd.size() == 1);
    }
    static testMethod void testGetListingDetailByIDs() {
        setupTestData();

        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getListingDetailByIDs(listListingId,label.FOR_VIEW_QUERY_CLAUSE);
        //number of expected result is met
        system.assert(testLd.size() == 1);
    }
    static testMethod void testGetAllActiveListingDetails() {
        setupTestData();

        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getAllActiveListingDetails(label.FOR_VIEW_QUERY_CLAUSE);
        List<ListingService.PRDescriptor> prDescriptorList = testLD[0].prioritiesDescriptor;
        system.assertEquals(prDescriptorList.size(), 1);
        //number of expected result is met
        system.assert(testLd.size() == 2);
    }
    static testMethod void testGetUnitsByListingID() {
        setupTestData();

        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();

        List<Unit__c> testU = new List<Unit__c>();
        testU = ListingService.getUnitsByListingID(listingID);
        //number of expected result is met
        system.assert(testU.size() == 1);
     }
    static testMethod void testGetListingDetailAll() {
        setupTestData();

        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();

        //ListingService.getUnitSummaryByListingID(listingId);
        System.assertEquals(ListingService.getListingDetailAll().size(), 2);
        //Map<Decimal,  Map<Decimal,Decimal>> x = ListingService.AMIMap;

    }

      static testMethod void getListingResults() {
          setupTestData();
          System.assertEquals(ListingService.checkEligibility(crit, listingID).incomeEligibilityResult, 'Too High');
          //System.assertEquals(ListingService.getListingResults(listingID, '1234', true,label.FOR_VIEW_QUERY_CLAUSE).listingId, listingID);
          //System.assertEquals(ListingService.getListingResults(listingID, '1234', false,label.FOR_VIEW_QUERY_CLAUSE).listingId, listingID);
      }

    static testMethod void getUnits() {
          setupTestData();
          System.assertEquals(ListingService.getAll(listingID).size(), 2);
          System.assertEquals(ListingService.getUnitByListingId(listingID).size(), 1);
    }

    static testMethod void getAMI() {
          setupTestData();
          AMI_Chart__mdt amiChartMdt = [SELECT id,Amount__c, Num_of_Household__c, Percent_of_Median__c, Type__c, Year__c FROM AMI_Chart__mdt Limit 1];
          ListingService.Ami filter = new ListingService.Ami();
          ListingService.Ami filter1 = new ListingService.Ami(amiChartMdt);
          String x = filter1.getFilterString();
     }
    static testMethod void getListingDetails() {
        setupTestData();
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();

        List<Listing__c> lstList = [SELECT name, Building__c, Account__c, Application_Due_Date__c, Status__c, Does_Match__c, Min_Occupancy__c FROM Listing__c where Name = 'somelisting1'];

        testLD = ListingService.getListingDetails(lstList);
        system.assertEquals(testLD[0].prioritiesDescriptor[0].Name, 'Vision impaired');
        system.assertEquals(testLD[0].prioritiesDescriptor[0].numberOfUnits, 1);
    }
    static testMethod void testListingPreferenceByListingID() {
        setupTestData();

        List<Listing__c> testL = [SELECT name, Building__c, Account__c, Application_Due_Date__c, Status__c, Does_Match__c, Min_Occupancy__c FROM Listing__c];
        List<ListingService.ListingPreference> listingPrefList = new List<ListingService.ListingPreference>();
        listingPrefList = ListingService.getListingPreferenceByListingID(listingID);
        //verify the returned Id is the right one
        system.assert(testL[0].Id == listingId);
    }
    /*static testMethod void testListingResultsByListingID() {
        setupTestData();

        ListingService.ListingResult listRes = new ListingService.ListingResult();
        listRes = ListingService.getListingResultsByListingID(listingID,label.FOR_VIEW_QUERY_CLAUSE);
        //verify the returned Id is the right one
        system.assert(listRes.listingId == listingId);
    }*/

    static testMethod void testListingResults() {
        setupTestData();

        ListingService.LotteryResult lotRes = new ListingService.LotteryResult();
        lotRes = ListingService.getListingResults(listingID, '123',label.FOR_VIEW_QUERY_CLAUSE);
        //verify the returned Id is the right one
        system.assert(lotRes.listingId == listingId);
    }

     static testMethod void testUnitSummariesByListingID() {
        setupTestData();

        ListingService.UnitSummaries unitSum = new ListingService.UnitSummaries();
        unitSum = ListingService.getUnitSummariesByListingID(listingID);
        //verify the returned Id is the right one
        system.assert(unitSum.general[0].listingID == listingId);
    }
    static testMethod void testCalc() {
          setupTestData();
          ListingService.AMI amiObj = new ListingService.AMI();
          amiObj.amount = 75400;
          amiObj.year = 2016;
          amiObj.chartType = 'HCD/TCAC';
          amiObj.numOfHousehold = 1;
          amiObj.percent = 100;

          List<ListingService.AMI> amiList = new List<ListingService.AMI>();
          amiList.addAll(ListingService.Calc(amiObj));
          system.assertEquals(amiList[0].percent, amiObj.percent);
     }
    static testMethod void testCharts() {
          setupTestData();
          List<ListingService.AMI> amiList = new List<ListingService.AMI>();

          amiList = ListingService.getCharts();
          //system.assertEquals(amiList[0].percent, amiObj.percent);
     }
    static testMethod void testGetByFilter() {
          setupTestData();
          List<ListingService.AMI> amiList = new List<ListingService.AMI>();
          ListingService.AMI amiObj = new ListingService.AMI();
          amiObj.amount = 75400;
          amiObj.year = 2016;
          amiObj.chartType = 'HCD/TCAC';
          amiObj.numOfHousehold = 1;
          amiObj.percent = 100;
          amiList = ListingService.getByFilter(amiObj);
          //system.assertEquals(amiList[0].percent, amiObj.percent);
     }
}