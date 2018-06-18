// *****************************************************************************
// CLASS: API_LeaseUp_ShortForm
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Contains logic for Shortform API service calls
//				GET: /services/apexrest/LeasingAgentPortal/shortForm/{shortFormId}
//				POST: /services/apexrest/LeasingAgentPortal/shortForm/
//
// *

@RestResource(urlMapping='/LeasingAgentPortal/shortForm/*')
global class API_LeaseUp_ShortForm {
	
	private static final String ELECTRONIC_SUBMISSION_TYPE = 'Electronic';
	
	@HttpGet
    global static API_LeaseUp_Application.ShortForm doGet() {
        

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        API_LoggingService.logRequest(req);
        List<String> tokens = req.requestURI.split('/');
        if (tokens.size() != 4) {
            res.statusCode = 400;
            return null;
        }
        
        String shortFormId = tokens[3];
        API_LeaseUp_Application.ShortForm sf = API_LeaseUp_ApplicationService.getShortformById(shortFormId);
        if (sf == null) {
            res.statusCode = 400;
            return null;
        }
        
        res.statusCode = 200;
        return sf;
    }

    @HttpPost
    global static API_LeaseUp_Application.ShortForm doPost() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
		API_LoggingService.logRequest(req);
		/*
        API_LeaseUp_Application.ShortForm sf = (API_LeaseUp_Application.ShortForm)JSON.deserialize(req.requestBody.toString(), API_LeaseUp_Application.ShortForm.class);
		sf.applicationSubmissionType = ELECTRONIC_SUBMISSION_TYPE;
        			system.debug('sf deserialized' + sf);
        */
        API_LeaseUp_Application.ShortForm sf = API_LeaseUp_Application.newShortForm(req.requestBody.toString());
        if (sf.id != null) {
        	Boolean invalidId = false;
        	try {
        		Id sfId = Id.valueOf(sf.id);
        	} catch (Exception e) {
        		invalidId = true;
        	}
        	if (invalidId) {
        		res.statusCode = 400;
            	return null;
        	}

        	API_LeaseUp_Application.ShortForm esf = API_LeaseUp_ApplicationService.getShortformById(sf.id);
        	if (esf == null) {
            	res.statusCode = 404;
            	return null;
            }
        }
        
        res.statusCode = 200;
        system.debug('sf:::' + sf);
        return API_LeaseUp_ApplicationService.upsertShortform(sf);
    }

}