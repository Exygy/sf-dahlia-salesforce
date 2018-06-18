// *****************************************************************************
// CLASS: ListingApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the list of Listings that match criteria
//				GET: /services/apexrest/Listing
//				params: -householdsize
//						-incomelevel
//						-childrenUnder6
//						-preference
// *

@RestResource(urlMapping='/Listing/*')
global without sharing class ListingApi {

    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}
	
	private static final String HOUSEHOLD_SIZE = 'householdsize';
	private static final String INCOME_LEVEL = 'incomelevel';
	private static final String CHILDREN_UNDER_6 = 'childrenUnder6';
//	private static final String PREFERENCE = 'preference';
	
    @HttpGet
    global static List<Listing__c> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
        
        //sample uri = /listing/<sfdcid>
        if (tokens.size()>2) {
            return ListingService.getListingByID(tokens[2], label.FOR_VIEW_QUERY_CLAUSE); 
        } 
        if (req.params.containsKey('id')) {
            return ListingService.getListingByID(req.params.get('id'),label.FOR_VIEW_QUERY_CLAUSE);
        }
        
        if (req.params.containsKey('ids')) {
            String ids = req.params.get('ids');
            List<String> idList  = ids.split(','); 
            return ListingService.getListingByIDs(idList,label.FOR_VIEW_QUERY_CLAUSE); 
        } 
        
        //householdsize && incomelevel
        if (req.params.containsKey(HOUSEHOLD_SIZE) ||  req.params.containsKey(INCOME_LEVEL) ) {
            String childrenUnder6 = req.params.get(CHILDREN_UNDER_6) ;
            String houseHoldSize = req.params.get(HOUSEHOLD_SIZE);
            String incomelevel = req.params.get(INCOME_LEVEL); 
       //     string preferenceName = req.params.get(PREFERENCE);
            
            if (incomelevel== null || houseHoldSize == null) {
                throw new InvalidParamsException('Both parameters "' + HOUSEHOLD_SIZE + '" and "'+ INCOME_LEVEL + '" required');
            }
            ListingService.Criteria crit=  new ListingService.Criteria();
            try { 
                crit.householdSize = Integer.valueof(houseHoldSize);
                crit.incomelevel =Decimal.valueof( incomelevel);
                crit.childrenUnder6  = (childrenUnder6!=null) ? Integer.Valueof(childrenUnder6) : 0;
           //     crit.preferenceName = (preferenceName != null) ? preferenceName : '';
            }
            catch (Exception e) {
                
                throw new InvalidParamsException('Invalid Parameter input: Integer required for "' + HOUSEHOLD_SIZE + '", was passed value : ' + houseHoldSize + '  and Decimal required for "'+ INCOME_LEVEL + '", was passed value:' +  incomelevel +' Integer required for "' + CHILDREN_UNDER_6 + '", was passed value : '  + childrenUnder6); // put friendly message here
                
            }
            return ListingService.getListingByCriteria(crit,label.FOR_VIEW_QUERY_CLAUSE);
        
        } 
        /*
        else if(req.params.containsKey(PREFERENCE) ){
        	string preferenceName = req.params.get(PREFERENCE);
    		if(preferenceName != null && preferenceName != ''){
            	return ListingService.getActiveListingsByPreference(preferenceName);
    		}
        }
        */
        return ListingService.getAllActiveListings(label.FOR_VIEW_QUERY_CLAUSE);
    }
   
}