// *****************************************************************************
// CLASS: ListingLotteryResultApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the Lottery results
//				GET: /services/apexrest/Listing/LotteryResult/{listingID}
//				GET: /services/apexrest/Listing/LotteryResult/{listingID}/{lotteryNumber}
// *

@RestResource(urlMapping='/Listing/LotteryResult/*')
global class ListingLotteryResultApi {
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	@HttpGet
	global static ListingService.LotteryResult doGet () {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		
		List<String> tokens =  req.requestURI.split('/');
		//sample uri = /Listing/LotteryResult/<sfdcid>
		String id;
		if (tokens.size() > 3) {
			id = tokens[3]; 
		} 
		if (id == null) {
			throw new InvalidParamsException('"id" parameter is required');
		}
		String lotteryNumber;
		if (tokens.size() > 4) {
			lotteryNumber = tokens[4]; 
		} 
		/*if (lotteryNumber == null) {
			throw new InvalidParamsException('"lotteryNumber" parameter is required');
		}*/
		
		return ListingService.getListingResults(id, lotteryNumber,label.FOR_VIEW_QUERY_CLAUSE);
		
	}
}