// *****************************************************************************
// CLASS: API_ShortForm_UploadAttachment
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to upload a file into salesforce
//				POST: /shortForm/file/<applicaitonid> url
//						header  name - ,content type
//						body  -blob/binary
//				https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_blob_retrieve.htm
//				https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_rest_code_sample_restrequest.htm
//				http://sfdc.arrowpointe.com/2010/02/16/endpoint-for-debugging-http-callouts/
// *

@RestResource(urlMapping='/shortForm/Attachment/*')
global class API_ShortForm_UploadAttachment {

    @HttpPost
    global static void uploadAttachment(){
        RestRequest req = RestContext.request;
        system.debug('rest context '+req);
        String name = req.headers.containsKey('Name') ? req.headers.get('Name') : 'unnamed';
        String contentType = req.headers.containsKey('ContentType') ? req.headers.get('ContentType') : '';

        RestResponse res = RestContext.response;
        Id recordID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        API_Application.Attachment theFile =(API_Application.Attachment) JSON.deserialize(req.requestBody.toString(), API_Application.Attachment.class);

        if (!String.isEmpty(theFile.ApplicationPreferenceID)) {
            Application_Preference__c appPref = [SELECT Id, Requires_Proof__c, Preference_Name__c from Application_Preference__c where Id = :theFile.ApplicationPreferenceID];
            if (appPref.Requires_Proof__c) {
                theFile.fileName = appPref.Preference_Name__c + ' proof';
            }
        }

        Attachment__c customAttachment = new Attachment__c();
        customAttachment.Name = theFile.fileName;
        customAttachment.Related_Application__c = theFile.ApplicationID;
        customAttachment.Related_Application_Member__c = theFile.ApplicationMemberID;
        customAttachment.Related_Application_Preference__c = theFile.ApplicationPreferenceID;
        customAttachment.Upload_Date__c = theFile.uploadDate != null ? theFile.uploadDate : date.today();
        customAttachment.Document_Type__c = theFile.DocumentType;
        insert customAttachment;
        theFile.customAttachmentID = customAttachment.ID;

        Blob blb = theFile.Body;
        Attachment a = new Attachment (ParentId = customAttachment.Id,
                                       Body = blb,
                                       ContentType = contentType,
                                       Name = theFile.fileName,
                                       Description = theFile.Description);
        insert a;
        theFile.attachmentID = a.ID;

        //RestResponse res = RestContext.response;
        //res.addHeader('Content-Type','image/jpg');
        res.responseBody = Blob.valueOf(JSON.serialize(theFile));

        //return theFile;
    }



    @HttpGet
    global static void getAttachment(){

        RestRequest req = RestContext.request;
        Id atID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Attachment__c customAtt =  [select id, Upload_Date__c, Document_Type__c, Related_Application__c, Related_Application_Member__c, Related_Application_Preference__c
                                    from Attachment__c where id=:atID];

        RestResponse res = RestContext.response;
        API_Application.Attachment theFile = new API_Application.Attachment(customAtt);
        res.responseBody = Blob.valueOf(JSON.serialize(theFile));
        //return theFile;
    }
}