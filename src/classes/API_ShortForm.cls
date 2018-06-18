// *****************************************************************************
// CLASS: API_ShortForm
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Contains logic for Shortform API service calls
//              GET: /services/apexrest/shortForm/{shortFormId}
//              POST: /services/apexrest/shortForm/
//
// *

@RestResource(urlMapping='/shortForm/*')
global class API_ShortForm {
    
    private static final String ELECTRONIC_SUBMISSION_TYPE = 'Electronic';
    
    @HttpGet
    global static API_Application.ShortForm doGet() {
        

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        API_LoggingService.logRequest(req);
        List<String> tokens = req.requestURI.split('/');
        if (tokens.size() != 3) {
            res.statusCode = 400;
            return null;
        }
        
        String shortFormId = tokens[2];
        API_Application.ShortForm sf = API_ApplicationService.getShortformById(shortFormId);
        if (sf == null) {
            res.statusCode = 400;
            return null;
        }
        
        res.statusCode = 200;
        return sf;
    }

    @HttpPost
    global static API_Application.ShortForm doPost() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        API_LoggingService.logRequest(req);
        /*
        API_Application.ShortForm sf = (API_Application.ShortForm)JSON.deserialize(req.requestBody.toString(), API_Application.ShortForm.class);
        sf.applicationSubmissionType = ELECTRONIC_SUBMISSION_TYPE;
                    system.debug('sf deserialized' + sf);
        */
        API_Application.ShortForm sf = API_Application.newShortForm(req.requestBody.toString());
        
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

            API_Application.ShortForm esf = API_ApplicationService.getShortformById(sf.id);
            if (esf == null) {
                res.statusCode = 404;
                return null;
            }
        }
        
        res.statusCode = 200;
        system.debug('sf:::' + sf);
        
        API_Application.ShortForm existing = null;
        if(sf.id == null && !String.isEmpty(sf.externalSessionId))
            existing = API_ApplicationService.getExistingShortformByCurrentShortForm(sf);
        
        if(existing != null) {
           return API_ApplicationService.upsertShortform(existing); 
        }
        else return API_ApplicationService.upsertShortform(sf);
    }

}