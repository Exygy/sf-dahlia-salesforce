// *****************************************************************************
// CLASS: API_BigObject_ShortForm_Application
// *****************************************************************************
//
// Author: Vertiba
// Date: 04/27/2018
// Description: Contains logic for Big object Application API service calls
//              GET: /services/apexrest/API_BigObject_ShortForm_Application/{snapshotId}
//
// *

@RestResource(urlMapping='/LeasingAgentPortal/shortForm/Archive/*')
global class API_BigObject_ShortForm_Application {
        
    @HttpGet
    global static API_LeaseUp_Application.ShortForm doGet() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<String> tokens = req.requestURI.split('/');
        system.debug('tokens:::' + tokens);
        system.debug('tokens:::' + tokens.size());
        if (tokens.size() != 5) {
            res.statusCode = 400;
            return null;
        }
        
        String snapshotId = tokens[4];
        API_LeaseUp_Application.ShortForm sf = API_BigObjectService.getBigObjectRecordBySnapshotId(snapshotId);
        if (sf == null) {
            res.statusCode = 400;
            return null;
        }
        
        res.statusCode = 200;
        return sf;
    }

}