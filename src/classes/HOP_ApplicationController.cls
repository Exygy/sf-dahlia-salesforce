global without sharing class HOP_ApplicationController {

    public Application__c app {get; set;}
    public Application_Member__c primaryApplicant {get; set;}
    public Boolean editMode {get; set;}
    public Boolean hasErrors {get; set;}
    public List<Attachment> attachments {get; set;}
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    } 

    private List<Attachment> getAttachmentsByParent(String parentId) {
        return [
            SELECT Id, Name, BodyLength
            FROM Attachment
            WHERE ParentId = :parentId
        ];
    }

    private void queryAppAndPrimaryApplicant(String pAppId) {
        List<Application__c> apps = [
            SELECT
                Id, Name, Annual_Income__c, Terms_Acknowledged__c, 
                Housing_Voucher_or_Subsidy__c, Application_Language__c, Applicant__c
            FROM Application__c
            WHERE Id = :pAppId
        ];

        if (apps.size() == 0) {
            app = null;
            primaryApplicant = null;
        } else {
            app = apps[0];

            List<Application_Member__c> primaryApplicants = [
                SELECT
                    First_Name__c, Middle_Name__c, Last_Name__c, Date_of_Birth__c,
                    Email__c, Phone__c, Phone_Type__c, Street__c, City__c, State__c, Zip_Code__c
                FROM Application_Member__c
                WHERE Id = :app.Applicant__c
            ];

            if (primaryApplicants.size() == 0) {
                primaryApplicant = null;
            } else {
                primaryApplicant = primaryApplicants[0];
            }
        }
    }

    public HOP_ApplicationController() {
        editMode = false;
        hasErrors = false;
        attachments = new List<Attachment>();

        String pAppId = ApexPages.currentPage().getParameters().get('id');
        if (String.isBlank(pAppId)) {
            editMode = true;
            app = new Application__c();
            primaryApplicant = new Application_Member__c();
            return;
        }

        queryAppAndPrimaryApplicant(pAppId);
        if (app == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Application record with Id ' + pAppId + ' not found'));
            hasErrors = true;
            return;
        }

        attachments = getAttachmentsByParent(app.Id);
    }

    public void saveApplication() {
        upsert app;
        editMode = false;
        queryAppAndPrimaryApplicant(app.Id);
        attachments = getAttachmentsByParent(app.Id);
    }

    public void processAttachment() {
        attachment.ParentId = app.Id;
        insert attachment;
        attachment = null;
        attachments = getAttachmentsByParent(app.Id);
    }
    
    @RemoteAction
    global static List<Application_Member__c> getApplicationMembers(String query) {
        String nameLike = '%' + query + '%';
        return [SELECT Id, Name__c FROM Application_Member__c WHERE Name__c LIKE :nameLike ORDER BY Name__c];
    }

}