// *****************************************************************************
// CLASS: ListingService
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: class that stores all logic for APIs service calls - classes starting with "Listing"
// *

global  class ListingService {
	
	private static final String LOTTERY_QUERY = 'SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__c where Status__c = \'Winner\'';
	private static final String APPLICATION_QUERY = 'SELECT id, Lottery_Number__c, Lottery_Rank__c, Lottery_Status__c, General_Lottery__c, General_Lottery_Rank__c, (SELECT Id, Preference_Lottery_Rank__c, Preference_Name__c, Receives_Preference__c, Listing_Preference_ID__c, Listing_Preference_ID__r.Total_Submitted_Apps__c, Listing_Preference_ID__r.Available_Units__c FROM Application_Preferences__r) FROM Application__c';
	private static final String LISTING_QUERY ='SELECT Name, In_Lottery__c, Program_Type__c, Units_Available__c, SASE_Required_for_Lottery_Ticket__c, nGeneral_Application_Total__c, Listing_Other_Notes__c, Reserved_Community_Requirement__c, Office_Hours__c, Lottery_Status__c, Building_Name__c, Project_ID__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Description__c, Neighborhood__c, Year_Built__c, LastModifiedDate, Marketing_URL__c, Marketing_Short_Code__c, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, Application_Organization__c, Application_Street_Address__c, Application_City__c, Application_State__c, Application_Postal_Code__c, Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_End__c, Lottery_End_Time__c, Lottery_Venue__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_Date__c, Lottery_Preferences__c, Lottery_Results__c, Lottery_URL__c, LotteryResultsURL__c, Accepting_Online_Applications__c, Lottery_Winners__c, AMI_Percentage__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Leasing_Agent_Street__c, Leasing_Agent_City__c, Leasing_Agent_State__c, Leasing_Agent_Zip__c, Download_URL__c, Download_URL_Cantonese__c, Download_URL_Spanish__c, Download_URL_Tagalog__c, Accepting_applications_at_leasing_agent__c, Accepting_applications_by_PO_Box__c, Blank_paper_application_can_be_picked_up__c,Fee__c, Deposit_Min__c, Deposit_Max__c, Costs_Not_Included__c, Amenities__c, Accessibility__c, Building_Selection_Criteria__c, Required_Documents__c,Smoking_Policy__c, Pet_Policy__c, Reserved_community_maximum_age__c, Reserved_community_minimum_age__c, Reserved_community_type__c, Reserved_community_type_description__c, hasWaitlist__c, Number_of_people_currently_on_waitlist__c, Maximum_waitlist_size__c, Total_waitlist_openings__c, Total_number_of_building_units__c, Services_Onsite__c, Units_Building_Special_Message__c, (SELECT Date__c, Start_Time__c, End_Time__c, Venue__c, Street_Address__c, City__c FROM Information_Sessions__r), (SELECT Date__c, Start_Time__c, End_Time__c FROM Open_Houses__r), (SELECT Id, Total_Submitted_Apps__c, Order__c, Available_Units__c, PDF_URL__c, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r), (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Status__c, Rent_percent_of_income__c, Property_Type__c, Priority_Type__c, Priority_Grouping__c, Reserved_Type__c, isReservedCommunity__c, AMI_chart_type__c, AMI_chart_year__c, of_AMI_for_Pricing_Unit__c FROM Units__r ORDER BY Unit_Type__c), (SELECT id, Name, Image_URL__c FROM Listing_Images__r) from Listing__c';//, (SELECT Id, Rent_percent_of_income__c, Priority_Type__c, Reserved_Type__c, AMI_chart_type__c, AMI_chart_year__c, AMI_Percent__c, Unit__r.Status__c FROM Listing_Units__r)
	private static final String LISTING_PREFERENCE_QUERY ='SELECT Name, Available_Units__c, Description__c, Listing__c, Requires_Proof__c, NRHP_District__c, Order__c, Lottery_Preference__c, PDF_URL__c, Lottery_Preference__r.Name, Preference_Name__c, Read_More_URL__c, Preference_Proof_Requirement_Description__c from Listing_Lottery_Preference__c';
	private static final String LISTING_QUERY_ORDER = ' ORDER BY Unit_Type__c';	
	
	private static final String UNIT_BY_LISTING_QUERY = 'SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Number_of_Bathrooms__c, Status__c, Rent_percent_of_income__c, Property_Type__c, Priority_Type__c, Priority_Grouping__c, Reserved_Type__c, isReservedCommunity__c, AMI_chart_type__c, AMI_chart_year__c, of_AMI_for_Pricing_Unit__c FROM Unit__c where Listing__c = :listingID  ORDER BY Unit_Type__c ';
	
	
	private static final String LIVE_WORK_PREFERENCE = 'liveWorkPreference';
	private static final String COP_PREFERENCE = 'certOfPreference';
	private static final String DTHP_PREFERENCE = 'displacedPreference';
	private static final String NEIGHBORHOOD_PREFERENCE = 'neighborhoodPreference';
	private static final String GENERAL_PREFERENCE = 'generalLottery';
	private static final String LIVE_WORK_PREFERENCE_NAME = 'Live or Work in San Francisco Preference';
	private static final String COP_PREFERENCE_NAME = 'Certificate of Preference (COP)';
	private static final String DTHP_PREFERENCE_NAME = 'Displaced Tenant Housing Preference (DTHP)';
	private static final String NEIGHBORHOOD_PREFERENCE_NAME = 'Neighborhood Resident Housing Preference (NRHP)';
				
	static String UNIT_QUERY = 'SELECT listing__c, unit__r.Unit_Type__c,count(id)Total, MIN(unit__r.BMR_Rental_Minimum_Monthly_Income_Needed__c) minRentalMinIncome,  MAX(unit__r.BMR_Rental_Minimum_Monthly_Income_Needed__c) maxRentalMinIncome, MIN(unit__r.BMR_Rent_Monthly__c) minMonthlyRent, MAX(unit__r.BMR_Rent_Monthly__c) maxMonthlyRent, MIN(unit__r.Min_Occupancy__c)Min_Occupancy, Max(unit__r.Max_Occupancy__c)Max_Occupancy, MIN(unit__r.Unit_Square_Footage__c)Sq_Footage_Min, MAX(unit__r.Unit_Square_Footage__c)Sq_Footage_Max, MIN(unit__r.Rent_percent_of_income__c)minPercentIncome, MAX(unit__r.Rent_percent_of_income__c)maxPercentIncome FROM listing_unit__c';
	static String AMI_UNIT_QUERY = 'SELECT listing__c, unit__r.AMI_chart_type__c,unit__r.AMI_chart_year__c, unit__r.of_AMI_for_Pricing_Unit__c FROM listing_unit__c';
	static String LISTING_UNIT_QUERY = 'SELECT listing__c, Priority_Type__c, Reserved_Type__c FROM listing_unit__c';
	static String UNIT_WHERE_GENERAL = 'Reserved_Type__c = null';
	static String UNIT_WHERE_RESERVED = 'Reserved_Type__c != null';
	static String UNIT_PRIORITY = 'Priority_Type__c != null';
	static string UNIT_QUERY_GROUP =  ' GROUP BY listing__c, unit__r.Unit_Type__c ';
	static string UNIT_QUERY_ALL =UNIT_QUERY + UNIT_QUERY_GROUP;
	
	
	global class Eligibility {
		public Id listingId;
		public String householdEligibilityResult;
		public String incomeEligibilityResult;
		public boolean householdMatch;
		public boolean incomeMatch;
		
		public Eligibility() {}
	}
	
	global class criteria {
		public Integer householdSize;
		public Decimal incomelevel;
		public Integer childrenUnder6;
		public string preferenceName;
	} 
	
	global class ListingDetail implements Comparable {
		public ID listingID;
		//public List<UnitSummary> unitSummary;
		public List<AMI> chartTypes;
		public List<PRDescriptor> prioritiesDescriptor;
		public List<PRDescriptor> reservedDescriptor;
		public UnitSummaries unitSummaries;
		public boolean doesMatch;
		public Listing__c listing;
		
		public ListingDetail () {}
		
		public Integer compareTo(Object compareTo) {
			ListingDetail listDetail = (ListingDetail) compareTo;
			
			if(this.listing.Application_Due_Date__c == null) {
				return 1;
			}
			if(this.listing.Application_Due_Date__c > listDetail.listing.Application_Due_Date__c) {
				return -1;
			}
			if(this.listing.Application_Due_Date__c < listDetail.listing.Application_Due_Date__c) {
				return 1;
			}
			return 0;
		}
		
	}
	
	/*global class ListingResult {
		public Id listingId;
		public List<PreferenceBucket> bucketResults;
		public List<ApplicationResult> applicationResults;
		public String URL;
		public String lotteryResultsURL;
		public Decimal liveWorkPreferenceAppTotal;
		public Decimal liveWorkPreferenceUnitsAvailable;
		public Decimal certOfPreferenceAppTotal;
		public Decimal certOfPreferenceUnitsAvailable;
		public Decimal displacedPreferenceAppTotal;
		public Decimal displacedPreferenceUnitsAvailable;
		public Decimal neighborhoodPreferenceAppTotal;
		public Decimal neighborhoodPreferenceUnitsAvailable;
		public Decimal generalLotteryAppTotal;
		public String lotteryCity;
		public Datetime lotteryDate;
		public String lotteryEndTime;
		public String lotteryPreferences;
		public boolean lotteryResults;
		public String officeHours;
		
		public ListingResult() {}
	}*/
	
	global class LotteryResult {
		public Id listingId;
		public List<LotteryBucket> lotteryBuckets;
		public String URL;
		public String lotteryResultsURL;
		public Decimal lotteryAppTotal;
		public String lotteryCity;
		public Datetime lotteryDate;
		public String lotteryEndTime;
		public String lotteryPreferences;
		public boolean lotteryResults;
		public String officeHours;
		
		public LotteryResult() {}
	}
	
	global class LotteryBucket implements comparable {
		public String preferenceName;
		public Decimal preferenceOrder;
		public Decimal totalSubmittedApps;
		public Decimal unitsAvailable;
		public List<PreferenceResult> preferenceResults;
		
		public LotteryBucket() {}
		
		public Integer compareTo(Object compareTo) {
			LotteryBucket pr = (LotteryBucket) compareTo;
			
			if(this.preferenceOrder == null) {
				return 1;
			}
			if(this.preferenceOrder < pr.preferenceOrder) {
				return -1;
			}
			if(this.preferenceOrder > pr.preferenceOrder) {
				return 1;
			}
			return 0;
		}
	}
	
	global class PreferenceResult implements comparable {
		public String applicationID;
		public String lotteryNumber;
		public Decimal preferenceRank;
		public Decimal lotteryRank;
		
		public PreferenceResult() {}
		
		public Integer compareTo(Object compareTo) {
			PreferenceResult pr = (PreferenceResult) compareTo;
			
			if(this.preferenceRank == null) {
				return 1;
			}
			if(this.preferenceRank < pr.preferenceRank) {
				return -1;
			}
			if(this.preferenceRank > pr.preferenceRank) {
				return 1;
			}
			return 0;
		}
	}
	
	
	/*global class ApplicationResult {
		public Id applicationId;
		public boolean liveWorkPreference;
		public decimal liveWorkPreferenceRank;
		
		public boolean displacedPreference;
		public decimal displacedPreferenceRank;
		
		public boolean certOfPreference;
		public decimal certOfPreferenceRank;
		
		public boolean neighborhoodPreference;
		public decimal neighborhoodPreferenceRank;
		
		public decimal generalLotteryRank;
		
		public String lotteryNumber;
		public decimal lotteryRank;
		
		public ApplicationResult() {}
	}*/
	
	global class PRDescriptor {
		public String listingId;
		public String name;
		public String shortDescription;
		public decimal numberOfUnits;
	}
	
	/*global class PreferenceBucket {
		public String preferenceName;
		public List<BucketResult> bucketResults;
	}
	
	global class BucketResult implements comparable {
		public String applicationID;
		public string lotteryNumber;
		public Decimal preferenceRank;
		public Decimal lotteryRank;
		
		public Integer compareTo(Object compareTo) {
			BucketResult br = (BucketResult) compareTo;
			
			if(this.preferenceRank == null) {
				return 1;
			}
			if(this.preferenceRank < br.preferenceRank) {
				return -1;
			}
			if(this.preferenceRank > br.preferenceRank) {
				return 1;
			}
			return 0;
		}
	}*/
	
	global class ListingPreference {
		public String listingPreferenceID;
		public String listingId;
		public String name;
		public String preferenceName;
		public Decimal order;
		public String pdfUrl;
		public String description;
		public String readMoreUrl;
		public String NRHPDistrict;
		public Boolean requiresProof;
		public Decimal appTotal;
		public Decimal unitsAvailable;
		public String preferenceProofRequirementDescription;
	}
	
	global class UnitSummary{
		public ID listingID;
		public String unitType;
		public Decimal totalUnits;
		public Decimal minOccupancy;
		public Decimal maxOccupancy;
		public Decimal minSquareFt;
		public Decimal maxSquareFt;
		
		public Decimal minMonthlyRent;
		public Decimal maxMonthlyRent;
		public Decimal maxRentalMinIncome;
		public Decimal minRentalMinIncome;
		public Decimal minPercentIncome;
		public Decimal maxPercentIncome;
		public List<String> priorities;
		
		public UnitSummary (AggregateResult result) {
			listingID = (ID)result.get('Listing__c');
			unitType = (String)result.get('Unit_Type__c');
			totalUnits = (Decimal)result.get('Total');
			minOccupancy = (Decimal)result.get('Min_Occupancy');
			maxOccupancy = (Decimal)result.get('Max_Occupancy');
			minSquareFt = (Decimal)result.get('Sq_Footage_Min');
			maxSquareFt = (Decimal)result.get('Sq_Footage_Max');
			
			minMonthlyRent = (Decimal)result.get('minMonthlyRent');
			maxMonthlyRent = (Decimal)result.get('maxMonthlyRent');
			maxRentalMinIncome = (Decimal)result.get('maxRentalMinIncome');
			minRentalMinIncome = (Decimal)result.get('minRentalMinIncome');
			minPercentIncome = (Decimal)result.get('minPercentIncome');
			maxPercentIncome = (Decimal)result.get('maxPercentIncome');
		}
	}
	
	global class UnitSummaries {
		public List<UnitSummary> general;
		public List<UnitSummary> reserved;
		
		public UnitSummaries() {
			general = new List<UnitSummary>();
			reserved = new List<UnitSummary>();
		}
		
		public UnitSummaries(List<UnitSummary> general, List<UnitSummary> reserved) {
			this.general = general;
			this.reserved = reserved;
		}
	}
	
	
	global class AMI {
		public Decimal percent;
		public Decimal numOfHousehold;
		public Decimal amount;
		public Decimal year;
		public String chartType;
	
		global AMI() {
			
		}
		global AMI(AMI_Chart__mdt ami) {
			percent = ami.Percent_of_Median__c;
			numOfHousehold = ami.Num_of_HouseHold__c;
			amount = ami.Amount__c;
			year = ami.Year__c;
			chartType = ami.Type__c;
		}
		
		public String getFilterString() {
			String filter = '';
			if (year > 0) {
				filter = ' Year__c=' + String.valueof(year);
			}
			if (!String.isEmpty(chartType)) {
				filter += (filter.length() > 0 ) ? ' and ' : ''; 
				filter += ' Type__c=\'' + chartType + '\'';
			}
			if (percent > 0) {
				filter += (filter.length() > 0 ) ? ' and ' : ''; 
				filter += ' Percent_of_Median__c=' + String.valueof(percent);
			}
			if (numOfHousehold > 0) {
				filter += (filter.length() > 0 ) ? ' and ' : ''; 
				filter += ' Num_of_HouseHold__c=' + String.valueof(numOfHousehold);
			}
			if (amount > 0) {
				filter += (filter.length() > 0) ? ' and ' : '';
				filter += ' Amount__c>=' + String.valueof(amount) + ' order by Amount__c asc limit 1';
			} 
			return filter;
		}
		public String getCalcFilter() {
			String filter = '';
			if (year > 0) {
				filter = ' Year__c=' + String.valueof(year);
			}
			if (!String.isEmpty(chartType)) {
				filter += (filter.length() > 0 ) ? ' and ' : ''; 
				filter += ' Type__c=\'' + chartType + '\'';
			}
			if (percent > 0) {
				filter += (filter.length() > 0 ) ? ' and ' : ''; 
				filter += ' Percent_of_Median__c=100';
			}
			if (numOfHousehold > 0) {
				filter += (filter.length() > 0 ) ? ' and ' : '';
				filter += ' Num_of_HouseHold__c=' + String.valueof(numOfHousehold);
			}
			
			return filter;
		}
	}
	
	global class UnitStat{
		ID listingID;
		String unitType;
		Decimal totalUnits;
		Decimal minOccupancy;
		Decimal maxOccupancy;
		Decimal minSquareFt;
		Decimal maxSquareFt;
		public UnitStat (AggregateResult result) {
			listingID = (ID)result.get('Listing__c');
			unitType = (String)result.get('Unit_Type__c');
			totalUnits = (Decimal)result.get('Total');
			minOccupancy = (Decimal)result.get('Min_Occupancy');
			maxOccupancy = (Decimal)result.get('Max_Occupancy');
			minSquareFt = (Decimal)result.get('Sq_Footage_Min');
			maxSquareFt = (Decimal)result.get('Sq_Footage_Max');
		}
		
	}
	
	global static List<ListingPreference>  getListingPreferenceByListingID(String listingID)
	{ 
		ID theID = ID.valueof(listingID);
		String query = LISTING_PREFERENCE_QUERY;
		String queryFilter='';
		if (theID != null) {
			queryFilter += ' Listing__c = \'' + theID + '\' order by Order__c asc nulls last';
		}
		query += (queryFilter.length() > 0) ? ' where ' + queryFilter: '';
		List<Listing_Lottery_Preference__c> listingPreferenceList = (List<Listing_Lottery_Preference__c>) Database.Query(query);
		
		List<ListingPreference> listingPreferences = new List<ListingPreference>();
		ListingPreference listingPref;
		for (Listing_Lottery_Preference__c listPref : listingPreferenceList) {
			listingPref = new ListingPreference();
			listingPref.listingPreferenceID = listPref.Id;
			listingPref.listingId = listPref.Listing__c;
			listingPref.name = listPref.Name;
			listingPref.order = listPref.Order__c;
			listingPref.pdfUrl = listPref.PDF_URL__c;
			listingPref.description = listPref.Description__c;
			listingPref.readMoreUrl = listPref.Read_More_URL__c;
			listingPref.NRHPDistrict = listPref.NRHP_District__c;
			listingPref.requiresProof = listPref.Requires_Proof__c;
			listingPref.preferenceProofRequirementDescription = listPref.Preference_Proof_Requirement_Description__c;
			listingPref.unitsAvailable = listPref.Available_Units__c;
			listingPref.preferenceName = listPref.Lottery_Preference__r.Name;
			listingPreferences.add(listingPref);
		}
		return listingPreferences;
	}
	
	global static List<Listing__c>  getListingByID(String listingID)
	{ 
		return getListingByID(listingID,null);
	}
	
	global static List<Listing__c>  getListingByID(String listingID,String otherclause)
	{ 
		system.debug('listingID:::' + listingID);
		ID theID = ID.valueof(listingID);
		Set<ID> listingIDs = new Set<ID> {theID};
		return getListingByIDs(listingIDs,otherclause);
		
	} 
	global static List<Listing__c>  getListingByIDs(List<String> sListingIDS,String otherclause){
		Set<ID> listingIDS = new Set<ID>();
		for (String sID : sListingIDS) {
			ID theID = ID.valueof(sID);
			listingIDS.add(theID);  
		}
		return getListingByIDs(listingIDS,otherclause);
	}
		
	
	global static List<Listing__c>  getListingByIDs(Set<ID> listingIds,String otherclause)
	{
		return  getListingByFilter(listingIds,null,otherclause);
	}
	
	global static List<Listing__c> getListingByFilter(Set<ID> listingIDs,String filter,String otherclause)
	{ 
		String query = LISTING_QUERY;
		String queryFilter='';
		if (listingIds!=null && listingIDs.size()>0) {
			queryFilter+= ' id in :listingIDs';
		}
		if (filter!=null) {
			if (queryFilter.length()>0) {
				queryFilter+=' and ';
			} 
			queryFilter += filter; 
		}
		query += (queryFilter.length()>0)? ' where ' + queryFilter: '';
		query += otherclause != null ? ' ' + otherclause : '';
		system.debug('query:::' + query) ;
		List<Listing__c> listings = (List<Listing__c>) Database.Query(query);
		return listings;
	} 
    
    global static List<Listing__c> getListingByMarketingURL(String marketURL,String otherclause)
	{ 
		String query = LISTING_QUERY;
		String queryFilter='';
		if (marketURL!=null) {
			queryFilter+= ' Marketing_URL__c = :marketURL';
		}
		query += (queryFilter.length()>0)? ' where ' + queryFilter: '';
		query += otherclause != null ? ' ' + otherclause : '';
		List<Listing__c> listings = (List<Listing__c>) Database.Query(query);
		return listings;
	} 
	/* old style preferences LL 
	global static List<Listing__c> getActiveListingsByPreference(string preferenceName){
		string llpQuery = LISTING_PREFERENCE_QUERY + ' WHERE Lottery_Preference__r.Name = \'' + preferenceName + '\'';
		List<Listing_Lottery_Preference__c> llps = database.query(llpQuery);
		Set<Id> listingIds = new Set<ID>();
		for(Listing_Lottery_Preference__c llp : llps){
			listingIds.add(llp.Listing__c);
		}
		List<Listing__c> listings = new List<Listing__c>();
		if(!listingIds.isEmpty()){
			listings = getListingByFilter(listingIds, ' Status__c = \'Active\'');
		}
		return listings;
	}
	*/
	global static List<Listing__c>  getAllActiveListings(String otherclause)
	{
		return getListingByFilter(new Set<ID>(), ' Status__c = \'Active\'', otherclause);
 
	} 
	
	public static List<ListingDetail> getListingDetailByCriteria(Criteria crit,String otherclause)
	{
		Set<ID> ids = findMatching(crit);
		system.debug('ids:::' + ids);
		List<Listing__c> listings = getAllActiveListings(otherclause);
		Map<Id,Listing__c> listingMap = new Map<Id,Listing__c>();
		
		for (Listing__c listing: listings){ // can and probably should move this to listing detail
			listingMap.put(listing.Id,listing);
			listing.Does_Match__c = (ids.contains(listing.id))? true:false;
			if(crit.PreferenceName != null && crit.PreferenceName != '' && listing.Does_Match__c){
				boolean prefFound = false;
				for(Listing_Lottery_Preference__c llp : listing.Listing_Lottery_Preferences__r){
					if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
						prefFound = true;
						break;
					}
				}
				listing.Does_Match__c = prefFound;
			}
		}
		
		List<ListingDetail> listingDetails = getListingDetails(getListingByCriteria(crit, otherclause));
		for (ListingDetail detail : listingDetails) {
			detail.doesMatch =  (ids.contains(detail.listingID))? true:false;
			//check if preference was met
			if(listingMap.containsKey(detail.listingID)){
				Listing__c chkListing = listingMap.get(detail.listingID);
				boolean prefFound = false;
				for(Listing_Lottery_Preference__c llp : chkListing.Listing_Lottery_Preferences__r){
					if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
						prefFound = true;
						break;
					}
				}
				detail.doesMatch = prefFound;
			}
		}
		listingDetails.sort();
		return listingDetails;
	
	}
    
    global static  List<ListingDetail> getListingDetailByMarketingURL (String marketURL,String otherclause ) {
		return getListingDetails(getListingByMarketingURL(marketURL, otherclause));
	}
	
	global static  List<ListingDetail> getListingDetailByID (String listingID,String otherclause ) {
		List<ListingDetail> listingDetailList = getListingDetailByIDs(new List<String> {listingID},otherclause );
		listingDetailList.sort();
		return listingDetailList;
	}
	
	global static  List<ListingDetail> getListingDetailByIDs (List<String> sIDs,String otherclause ) {
		return getListingDetails(getListingByIDs(sIDs, otherclause));
	}
	
	global static  List<ListingDetail> getAllActiveListingDetails (String otherclause ) {
		return getListingDetails(getAllActiveListings( otherclause));
	}
	
	public static List<Listing__c> getListingByCriteria(Criteria crit,String otherclause)
	{
	 
		Set<ID> ids = findMatching(crit);
		List<Listing__c> listings = new List<Listing__c>();
		List<Listing__c> matchedListings = new List<Listing__c>();
		
		listings = getAllActiveListings(otherclause);
		
		for (Listing__c listing: listings){ // can and probably should move this to listing detail
			listing.Does_Match__c = (ids.contains(listing.id))? true:false;
			if(crit.PreferenceName != null && crit.PreferenceName != '' && listing.Does_Match__c){
				boolean prefFound = false;
				for(Listing_Lottery_Preference__c llp : listing.Listing_Lottery_Preferences__r){
					if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
						prefFound = true;
						break;
					}
				}
				system.debug('prefFound: ' + prefFound);
				listing.Does_Match__c = prefFound;
			}
			
		}
		system.debug('listings: ' + listings);
		
		return listings;
	}
	
	private static Set<ID> findMatching(Criteria crit) {
		system.debug('amiAmount:::' + crit);
		Integer houseHoldSize = crit.householdSize;
		Decimal Income = crit.incomelevel;
		List<Unit__c> relevantUnits = new List<Unit__c>();
		Set<ID> listingIDS = new Set<ID>();
		Integer maxHouseHold = houseHoldSize-crit.childrenUnder6;
		Integer minHouseHold = houseHoldSize;
		
		for (Unit__c unit : [select id, BMR_Minimum_Annual_Income_Needed__c, of_AMI_for_Pricing_Unit__c, Listing__c, Max_Occupancy__c, AMI_chart_type__c, AMI_chart_year__c from Unit__c  where Max_Occupancy__c>= :maxHouseHold and Min_Occupancy__c<=:minHouseHold]) {
			Decimal amiAmount = getAMIChart(unit.AMI_chart_type__c, Integer.valueOf(unit.AMI_chart_year__c), houseHoldSize, Integer.valueOf(unit.of_AMI_for_Pricing_Unit__c));
			system.debug('amiAmount:::' + amiAmount);
			system.debug('Income:::' + Income);
			system.debug('unit.BMR_Minimum_Annual_Income_Needed__c:::' + unit.BMR_Minimum_Annual_Income_Needed__c);
			if (unit.BMR_Minimum_Annual_Income_Needed__c <= Income && Income <= amiAmount) {
				relevantUnits.add(unit);
				listingIDS.add(unit.Listing__c);
			}
		}
		return listingIDS;
	}
	
	//check if the Listing is matching passed criteria
	public static Eligibility checkEligibility(Criteria crit, Id ListingId) {
		Integer houseHoldSize = crit.householdSize;
		Decimal Income = crit.incomelevel;
		List<Unit__c> relevantUnits = new List<Unit__c>();
		Set<ID> listingIDS = new Set<ID>();
		Integer maxHouseHold = houseHoldSize-crit.childrenUnder6;
		Integer minHouseHold = houseHoldSize;
		Eligibility eg = new Eligibility();
		eg.ListingId = ListingId;
		
		//retrieve all units related to the listing
		List<Unit__c> units = [select id, BMR_Minimum_Annual_Income_Needed__c, of_AMI_for_Pricing_Unit__c, Listing__c, Max_Occupancy__c, Min_Occupancy__c, Number_of_bedrooms_formula__c, Unit_Type__c, AMI_chart_type__c, AMI_chart_year__c
								from Unit__c 
								where Listing__c = :ListingId];
		String notHouseholdEligible = '';
		String notIncomeEligible = '';
		
		//go through all units and check if do we have a match
		for (Unit__c unit : units) {
			system.debug('unit.Max_Occupancy__c:::' + unit.Max_Occupancy__c);
			system.debug('unit.Number_of_bedrooms_formula__c' + unit.Number_of_bedrooms_formula__c);
			system.debug('unit.Unit_Type__c:::' + unit.Unit_Type__c);
			system.debug('maxHouseHold:::' + maxHouseHold);
			system.debug('unit.Min_Occupancy__c:::' + unit.Min_Occupancy__c);
			system.debug('minHouseHold:::' + minHouseHold);
			//check household size
			if (unit.Max_Occupancy__c >= maxHouseHold && unit.Min_Occupancy__c <= minHouseHold) {
				eg.householdEligibilityResult = 'Match';
				eg.householdMatch = true;
			} else if (unit.Max_Occupancy__c < maxHouseHold) {
				notHouseholdEligible = 'Too Big';
			} else if (unit.Min_Occupancy__c > minHouseHold) {
				notHouseholdEligible = 'Too Small';
			}
			
			//check income
			if (Income > 0) {
				Decimal amiAmount =  getAMIChart(unit.AMI_chart_type__c, Integer.valueOf(unit.AMI_chart_year__c), houseHoldSize, Integer.valueOf(unit.of_AMI_for_Pricing_Unit__c));
				system.debug('amiAmount:::' + amiAmount);
				system.debug('Income:::' + Income);
				system.debug('unit.BMR_Minimum_Annual_Income_Needed__c:::' + unit.BMR_Minimum_Annual_Income_Needed__c);
				if (unit.BMR_Minimum_Annual_Income_Needed__c <= Income && Income <= amiAmount) {
					eg.incomeEligibilityResult = 'Match';
					eg.incomeMatch = true;
				} else if (unit.BMR_Minimum_Annual_Income_Needed__c <= Income) {
					notIncomeEligible = 'Too High';
				} else {
					notIncomeEligible = 'Too Low';
				}
			}
		}
		
		//if we don't have a match mark this as false
		if (eg.householdEligibilityResult != 'Match') {
			eg.householdEligibilityResult = notHouseholdEligible;
			eg.householdMatch = false;
		}
		
		if (eg.incomeEligibilityResult != 'Match') {
			eg.incomeEligibilityResult = notIncomeEligible;
			eg.incomeMatch = false;
		}
		
		return eg;
	}
	
	/*public static Decimal getAMI(Decimal household, Decimal precentOfMedian ) {
		if (household== null || precentOfMedian == null) {
			return -1;
		}
		Map<Decimal, Decimal> percentMap = AMIMap.get(household);
		if (percentMap==null) {
			system.debug('houldhold not found' +household  + ' ' + AMIMap);
			return -1;
		}
		Decimal amount = percentMap.get(precentOfMedian);
		if (amount==null){
			system.debug('percent not found' +precentOfMedian  + ' ' + percentMap);
			amount=-1;  
		}
		return amount;
	}
	
	private static Map<Decimal,  Map<Decimal,Decimal>> AMIMap { // [household, percent]
		get{
			if (AMIMap!=null) {
				return AMIMap;
			}
		
			AMIMap = new Map<Decimal,  Map<Decimal,Decimal>> (); //household to percent
			for (AMI_Chart__mdt ami : [select id, Year__c, Type__c, Amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI_Chart__mdt]) {
				Map<Decimal,Decimal> percentMap = AMIMap.get(ami.Num_of_HouseHold__c);
				if (percentMap == null) { 
					percentMap = new Map<Decimal,Decimal>();
					AMIMap.put(ami.Num_of_HouseHold__c, percentMap);
				}
				percentMap.put(ami.Percent_of_Median__c,ami.amount__c);
			}
			return AMIMap;
		}
	}
	
	private static Map<Decimal,  Map<Decimal,Decimal>> getAMIMap(){
		if (AMIMap!=null) {
			return AMIMap;
		}
		
		AMIMap = new Map<Decimal,  Map<Decimal,Decimal>> (); //household to percent
		for (AMI__c ami : [select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]) {
			Map<Decimal,Decimal> percentMap = AMIMap.get(ami.Num_of_HouseHold__c);
			if (percentMap == null) { 
				percentMap = new Map<Decimal,Decimal>();
				AMIMap.put(ami.Num_of_HouseHold__c, percentMap);
			}
			percentMap.put(ami.Percent_of_Median__c,ami.amount__c);
		}
		return AMIMap;
	}
	
	*/
	
	public static Decimal getAMIChart(String chartType, Integer year, Integer household, Integer precentOfMedian) {
		if (chartType == null || year == null || household== null || precentOfMedian == null) {
			return -1;
		}
		system.debug('params:::' + chartType  + ' ' + year + ' ' + household + ' ' + precentOfMedian);
		system.debug('AMIChartMap' + AMIChartMap);
		Map<Integer,Map<Integer, Decimal>> chartTypeMap = AMIChartMap.get(year + '#' + chartType);
		system.debug('chartTypeMap' + chartTypeMap);
		if (chartTypeMap==null) {
			system.debug('chart type not found for specified year' +chartType  + ' ' + year + ' ' + chartTypeMap);
			return -1;
		}
		Map<Integer, Decimal> percentMap = chartTypeMap.get(household);
		system.debug('percentMap' + percentMap);
		if (percentMap==null) {
			system.debug('household not found' +household  + ' ' + chartTypeMap);
			return -1;
		}
		Decimal amount = percentMap.get(precentOfMedian);
		if (amount==null){
			system.debug('percent not found' +precentOfMedian  + ' ' + percentMap);
			amount=-1;  
		}
		return amount;
	}
	
	private static Map<String, Map<Integer,  Map<Integer,Decimal>>> AMIChartMap { // [household, percent]
		get{
			if (AMIChartMap!=null) {
				return AMIChartMap;
			}
			AMIChartMap = new Map<String, Map<Integer,  Map<Integer,Decimal>>>(); //year+'#'+type to household to percent
			
			for (AMI_Chart__mdt ami : [select id, Year__c, Type__c, Amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI_Chart__mdt]) {
				Map<Integer,Map<Integer,Decimal>> typeMap = AMIChartMap.get(Integer.valueOf(ami.Year__c) + '#' + ami.Type__c);
				if (typeMap == null) { 
					typeMap = new Map<Integer,Map<Integer,Decimal>>();
					AMIChartMap.put(Integer.valueOf(ami.Year__c) + '#' + ami.Type__c, typeMap);
				}
				Map<Integer,Decimal> percentMap = typeMap.get(Integer.valueOf(ami.Num_of_HouseHold__c));
				if (percentMap == null) { 
					percentMap = new Map<Integer,Decimal>();
					typeMap.put(Integer.valueOf(ami.Num_of_HouseHold__c), percentMap);
				}
				percentMap.put(Integer.valueOf(ami.Percent_of_Median__c),ami.amount__c);
				typeMap.put(Integer.valueOf(ami.Num_of_HouseHold__c),percentMap);
				
			}
			system.debug('AMIChartMap:::' + AMIChartMap);
			return AMIChartMap;
		}
	}
	
	global static List<Unit__c> getUnitsByListingID(String listingID)
	{
		String query =  UNIT_BY_LISTING_QUERY;
		return (List<Unit__c>) Database.query(query);
	} 
	
	/*global static ListingResult getListingResultsByListingID(String listingID)
	{
		return getListingResults(listingID, null, false);
	}
	
	global static ListingResult getListingResultsByListingIDAndLotteryNumber(String listingID, String lotteryNumber)
	{
		return getListingResults(listingID, lotteryNumber, false);
	}*/
	
	global static LotteryResult getListingResults(String listingID, String lotteryNumber,String otherclause)
	{ 
		List<Listing__c> currentListing = getListingByID(listingID,otherclause);
		
		LotteryResult lotteryResult = new LotteryResult();
		if (currentListing != null && currentListing.size() == 1) {
			
			//retrieve all application related to listing
			string appQuery = APPLICATION_QUERY + ' WHERE Listing__c = \'' + currentListing[0].Id + '\'';
			if (lotteryNumber != null) {
				appQuery += ' AND Lottery_Number__c = \'' + lotteryNumber + '\'';
			}
			system.debug('appQuery:::' + appQuery);
			List<Application__c> appResultList = database.query(appQuery);
			
			system.debug('appResultList:::' + appResultList);
			//get listing results on each bucket
			Map<String,List<PreferenceResult>> prefResultsMap = new Map<String,List<PreferenceResult>>();
			
			//build map with listing preferences for getting Available_Units__c and App_Total__c info
			Map<String,Listing_Lottery_Preference__c> listingPrefMap = new Map<String,Listing_Lottery_Preference__c>();
			for (Listing_Lottery_Preference__c listingPref : currentListing[0].Listing_Lottery_Preferences__r) {
				listingPrefMap.put(listingPref.Lottery_Preference__r.Name, listingPref);
				//intialize prefResultsMap with all listing preferences
				if (!prefResultsMap.containsKey(listingPref.Lottery_Preference__r.Name)) {
					prefResultsMap.put(listingPref.Lottery_Preference__r.Name, new List<PreferenceResult>());
				}
			}
			//add General Lottery bucket
			prefResultsMap.put(GENERAL_PREFERENCE,new List<PreferenceResult>());
			
			PreferenceResult prefResult;
			//
			for (Application__c app : appResultList) {
				
				//return only opplication with Lottery Rank filled in
				if (app.Lottery_Rank__c == null) continue;
				
				//if (app.Application_Preferences__r == null || app.Application_Preferences__r.size() == 0) {
				if (app.General_Lottery__c) {
					prefResult = new PreferenceResult();
					prefResult.applicationID = app.Id;
					prefResult.lotteryNumber = app.Lottery_Number__c;
					prefResult.preferenceRank = (Decimal)app.General_Lottery_Rank__c;
					prefResult.lotteryRank = (Decimal)app.Lottery_Rank__c;
					prefResultsMap.get(GENERAL_PREFERENCE).add(prefResult);
					
					continue;
				}
				
				for (Application_Preference__c appPref : app.Application_Preferences__r) {
					if (!appPref.Receives_Preference__c) continue;
					
					prefResult = new PreferenceResult();
					prefResult.applicationID = app.Id;
					prefResult.lotteryNumber = app.Lottery_Number__c;
					prefResult.preferenceRank = appPref.Preference_Lottery_Rank__c;
					prefResult.lotteryRank = (Decimal)app.Lottery_Rank__c;
					prefResultsMap.get(appPref.Preference_Name__c).add(prefResult);
				}
			}
			
			
			List<LotteryBucket> lotBucketList = new List<LotteryBucket>();
			LotteryBucket lotBucket;
			for (String preferenceNameKey : prefResultsMap.keySet()) {
				lotBucket = new LotteryBucket();
				lotBucket.preferenceName = preferenceNameKey;
				if (listingPrefMap.containsKey(preferenceNameKey)) {
					lotBucket.preferenceOrder = listingPrefMap.get(preferenceNameKey).Order__c;
					lotBucket.unitsAvailable = listingPrefMap.get(preferenceNameKey).Available_Units__c;
					lotBucket.totalSubmittedApps = listingPrefMap.get(preferenceNameKey).Total_Submitted_Apps__c;
				}
				if (preferenceNameKey == GENERAL_PREFERENCE) {
					lotBucket.unitsAvailable = currentListing[0].Units_Available__c;
					lotBucket.totalSubmittedApps = currentListing[0].nGeneral_Application_Total__c;
				}
				List<PreferenceResult> prefResList = prefResultsMap.get(preferenceNameKey);
				prefResList.sort();
				lotBucket.preferenceResults = prefResList;
				lotBucketList.add(lotBucket);
			}
			lotBucketList.sort();
			lotteryResult.lotteryBuckets = lotBucketList;
			
			lotteryResult.listingId = currentListing[0].Id;
			lotteryResult.URL = currentListing[0].Lottery_URL__c;
			lotteryResult.lotteryResultsURL = currentListing[0].LotteryResultsURL__c;
			lotteryResult.lotteryAppTotal = currentListing[0].In_Lottery__c;
			lotteryResult.lotteryCity = currentListing[0].Lottery_City__c;
			lotteryResult.lotteryDate = currentListing[0].Lottery_Date__c;
			lotteryResult.lotteryEndTime = currentListing[0].Lottery_End_Time__c;
			lotteryResult.lotteryPreferences = currentListing[0].Lottery_Preferences__c;
			lotteryResult.lotteryResults = currentListing[0].Lottery_Results__c;
			lotteryResult.officeHours = currentListing[0].Office_Hours__c;
		}
		return lotteryResult;
	} 
	
	private static Map<ID,List<UnitSummary>>  processUnitSummaryResults(AggregateResult[] results) {
		Map<ID,List<UnitSummary>> resultMap = new Map<ID,List<UnitSummary>>();
		for (AggregateResult result : results ) {
			UnitSummary unitSummary = new UnitSummary(result);
			List<UnitSummary> summaryList =  (resultMap.containsKey(unitSummary.listingID))?resultMap.get(unitSummary.listingID) : new List<UnitSummary>();
			summaryList.add(unitSummary);
			system.debug (unitSummary);
			resultMap.put(unitSummary.listingID,summaryList);
		}
		return resultMap;
		
	}
	
	
	global static Map<ID,List<UnitSummary>>  getListingDetailAll()
	{
		AggregateResult[] results =Database.query(UNIT_QUERY_ALL);
		Map<ID,List<UnitSummary>>  unitSummary = processUnitSummaryResults (results);
		
		return unitSummary;
	}
	global static Map<ID,List<UnitSummary>> queryListingDetailByIDs(Set<ID> ids, String whereClause)
	{
		String query = UNIT_QUERY;
		query += ' where Listing__c in : ids ';
		query += !String.isEmpty(whereClause) ? ' AND ' + whereClause : '';
		query += UNIT_QUERY_GROUP;
		system.debug(query);
		AggregateResult[] results =Database.query(query);
		Map<ID,List<UnitSummary>>  unitSummary = processUnitSummaryResults (results);
		
		return unitSummary;
	}
	
	global static Map<ID,List<PRDescriptor>> queryListingUnitByListingIDs(Set<ID> ids, String whereClause,Boolean isReserved)
	{
		String query = LISTING_UNIT_QUERY;
		query += ' where Listing__c in : ids ';
		query += !String.isEmpty(whereClause) ? ' AND ' + whereClause : '';
		system.debug(query);
		List<Listing_unit__c> results =Database.query(query);
		Map<ID,List<PRDescriptor>>  unitPriorities = processUnitPrioritiesResults (results,isReserved);
		
		return unitPriorities;
	}
	
	private static Map<ID,List<PRDescriptor>>  processUnitPrioritiesResults(List<Listing_unit__c> results, Boolean isReserved) {
		Map<ID,List<PRDescriptor>> resultMap = new Map<ID,List<PRDescriptor>>();
		
		Map<ID,Map<String,List<Listing_unit__c>>> listingPRMap = new Map<ID,Map<String,List<Listing_unit__c>>>();
		Map<String,List<Listing_unit__c>> prMap = new Map<String,List<Listing_unit__c>>();
		String prField = isReserved ? 'Reserved_Type__c' : 'Priority_Type__c';
		if (isReserved) {
			
		}
		for (Listing_unit__c listingUnit : results ) {
			if (!listingPRMap.containsKey(listingUnit.Listing__c)) {
				listingPRMap.put(listingUnit.Listing__c, new Map<String,List<Listing_unit__c>>());
			}
			prMap = listingPRMap.get(listingUnit.Listing__c);
			if(!prMap.containsKey((String)listingUnit.get(prField))) {
				prMap.put((String)listingUnit.get(prField), new List<Listing_unit__c>());
			}
			prMap.get((String)listingUnit.get(prField)).add(listingUnit);
		}
		for (Id key : listingPRMap.keySet()) {
			List<PRDescriptor> prDescList = new List<PRDescriptor>();
			for (String prName : listingPRMap.get(key).keySet()) {
				PRDescriptor pr = new PRDescriptor();
				pr.listingId = key;
				pr.name = prName;
				pr.numberOfUnits = listingPRMap.get(key).get(prName).size();
				prDescList.add(pr);
			}
			resultMap.put(key,prDescList);
		}
		
		return resultMap;
		
	}
	
	global static Map<ID,List<AMI>> queryAmiListingDetailByIDs(Set<ID> ids, String whereClause)
	{
		String query = AMI_UNIT_QUERY;
		query += ' where Listing__c in : ids ';
		query += !String.isEmpty(whereClause) ? ' AND ' + whereClause : '';
		system.debug(query);
		List<Listing_Unit__c> results =Database.query(query);
		Map<Id,List<AMI>> amiMap = new Map<Id,List<AMI>>();
		Map<Id,Set<String>> existingAmiKeyMap = new Map<Id,Set<String>>();
		for (Listing_Unit__c listingUnit : results) {
			if (!amiMap.containsKey(listingUnit.Listing__c)) {
				amiMap.put(listingUnit.Listing__c, new List<AMI>());
				existingAmiKeyMap.put(listingUnit.Listing__c, new Set<String>());
			}
			if (!existingAmiKeyMap.get(listingUnit.Listing__c).contains(listingUnit.unit__r.AMI_chart_type__c + '#' + listingUnit.unit__r.AMI_chart_year__c + '#' + listingUnit.unit__r.of_AMI_for_Pricing_Unit__c)) {
				AMI returnAMI = new AMI();
				returnAMI.percent = listingUnit.unit__r.of_AMI_for_Pricing_Unit__c == null ? 0 : Math.round(listingUnit.unit__r.of_AMI_for_Pricing_Unit__c);
				returnAMI.year = listingUnit.unit__r.AMI_chart_year__c;
				returnAMI.chartType = listingUnit.unit__r.AMI_chart_type__c;
				
				amiMap.get(listingUnit.Listing__c).add(returnAMI);
				existingAmiKeyMap.get(listingUnit.Listing__c).add(listingUnit.unit__r.AMI_chart_type__c + '#' + listingUnit.unit__r.AMI_chart_year__c + '#' + listingUnit.unit__r.of_AMI_for_Pricing_Unit__c);
			}
		}
		return amiMap;
	}
	
	global static UnitSummaries getUnitSummariesByListingID(ID listingID) {
		UnitSummaries unitSummaries = new UnitSummaries();
		unitSummaries.general = queryListingDetailByIDs(new Set<ID> {listingID}, UNIT_WHERE_GENERAL).get(listingID);
		unitSummaries.reserved = queryListingDetailByIDs(new Set<ID> {listingID}, UNIT_WHERE_RESERVED).get(listingID);
		return unitSummaries;
	}
	
	global static List<ListingDetail> getListingDetails(List<Listing__c> listings)
	{
		Map<ID,Listing__c> listingMap = new Map<ID,Listing__c> (listings);
		Map<ID,List<UnitSummary>> unitSummaryGeneral = queryListingDetailByIDs(listingMap.keyset(),UNIT_WHERE_GENERAL);
		Map<ID,List<UnitSummary>> unitSummaryReserved = queryListingDetailByIDs(listingMap.keyset(),UNIT_WHERE_RESERVED);
		Map<ID,List<PRDescriptor>> unitPRDescriptorGeneral = queryListingUnitByListingIDs(listingMap.keyset(),UNIT_PRIORITY,false);
		Map<ID,List<PRDescriptor>> unitPRDescriptorReserved = queryListingUnitByListingIDs(listingMap.keyset(),UNIT_WHERE_RESERVED,true);
		Map<ID,List<AMI>> amiUnits = queryAmiListingDetailByIDs(listingMap.keyset(),null);
		
		List<ListingDetail> details = new List<ListingDetail> ();
		
		for (ID listingID:listingMap.keyset()) { 
			ListingDetail detail = new ListingDetail();
			detail.listingID = listingID;
			detail.listing = listingMap.get(listingID);
			detail.unitSummaries = new UnitSummaries(unitSummaryGeneral.get(listingID), unitSummaryReserved.get(listingID));
			detail.chartTypes = amiUnits != null ? amiUnits.get(listingID) : null;
			detail.prioritiesDescriptor = unitPRDescriptorGeneral.get(listingId);
			detail.reservedDescriptor = unitPRDescriptorReserved.get(listingId);
			details.add(detail);
		}
		details.sort();
		return details; 
	}
	
	global static List<AMI> Calc(AMI filter)
	{
		String filterString = filter.getCalcFilter();
		
		String query = 'select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c, Year__c, Type__c from AMI_Chart__mdt ' ;
		if (filterstring.length() > 0 ) {
			query += ' where ' + filterString;
		}
		AMI returnAMI = new AMI();
		AMI_Chart__mdt ami = Database.query(query);
		
		returnAMI.percent = Math.round(filter.amount / ami.amount__c*100);
		returnAMI.year = filter.year;
		returnAMI.chartType = filter.chartType;
		returnAMI.numOfHousehold=filter.numOfHousehold; 
		returnAMI.amount=filter.amount;
		List<AMI> amiList = new List<AMI> {returnAMI};
		
		return amiList;
	}
	
	global static List<AMI> getCharts()
	{
		String query = 'select id, Year__c, Type__c from AMI_Chart__mdt order by Year__c, Type__c asc' ;
		
		List<AMI_Chart__mdt> amis = Database.query(query);
		List<AMI> amiList = new List<AMI> ();
		AMI returnAMI;
		for (AMI_Chart__mdt ami : amis) {
			returnAMI = new AMI();
			returnAMI.year = ami.Year__c;
			returnAMI.chartType = ami.Type__c;
			amiList.add(returnAMI);
		}
		system.debug('query::' + query);
		return amiList;
		
	}
	
	global static List<AMI> getByFilter(AMI filter)
	{
		system.debug('filter:::' + filter);
		
		String filterString = filter.getFilterString();
		
		String query = 'select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c, Type__c, Year__c from AMI_Chart__mdt ' ;
		if (filterstring.length() > 0 ) {
			query += ' where ' + filterString;
		}
		system.debug('query::' + query);
		List<AMI_Chart__mdt> amis = Database.query(query);
		List<AMI> amiList = new List<AMI> ();
		for (AMI_Chart__mdt ami : amis) {
			amiList.add(new AMI(ami));
		}
		system.debug('query::' + query);
		return amiList;
	}
	
		
	global static List<UnitStat> getUnitByListingId(string listingID){
		AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Max_Occupancy__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C WHERE Listing__c =: listingID GROUP BY listing__C, Unit_Type__c ];
		List<UnitStat> stats = new List<UnitStat>();
		for (AggregateResult result : results ) {
			stats.add(new UnitStat(result));
		}
		return stats;
	}
	
	global static List<UnitStat> getAll(String listingID)
	{ 
		AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Max_Occupancy__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C GROUP BY listing__C, Unit_Type__c ];
		List<UnitStat> stats = new List<UnitStat>();
		for (AggregateResult result : results ) {
			stats.add(new UnitStat(result));
		}
		return stats;
	} 
	
}