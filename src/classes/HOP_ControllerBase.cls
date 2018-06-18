// *****************************************************************************
// CLASS: HOP_ControllerBase
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 03/08/16
// Description: Base virtual class for all HOP controller classes.
//
// *****************************************************************************

global with sharing virtual class HOP_ControllerBase {

    // Current User's record is queried for the licence name and Account Id.
    // Available to all the controllers that implement this base class.
    public User myUser {get; set;}
    
    // Grants access to the following constants on all the controllers that implement this base class
    // The constants are used on several of the HOP pages
    public String COMMUNITY_LICENSE_NAME {get { return HOP_Constants.COMMUNITY_LICENSE_NAME; }}
    public String DRAFT_APPLICATION {get { return HOP_Constants.DRAFT_APPLICATION; }}
    public String PAPER_APPLICATION {get { return HOP_Constants.PAPER_APPLICATION; }}
    
    public HOP_ControllerBase() {
        // Queries the current User's licence name and Account Id
        myUser = [SELECT Id, Contact.AccountId, Profile.UserLicense.Name,TimeZoneSidKey FROM User WHERE Id = :UserInfo.getUserId()];
    	system.debug('user license:::'+myUser.Profile.UserLicense.Name);
    }
    @RemoteAction
    global static dataTableResponse getRecords(string objectName,string fieldList,string whereClause) {
        User myUser = [SELECT Id, Contact.AccountId, Profile.UserLicense.Name,TimeZoneSidKey  FROM User WHERE Id = :UserInfo.getUserId()];
        
        string queryString ='select '+fieldList+' from '+objectName;
        if(whereClause != null && whereClause != ''){
            queryString +=' where '+whereClause;
        }
        system.debug('queryString:::'+queryString);
        list<sobject> sobjList=database.query(queryString);
        List<rowHeaders> rowHeadersList = new List<rowHeaders>();
        Map<String, Schema.SObjectField> dfr = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        system.debug('*'+dfr);
        for(string str:fieldList.split(',')){
            str=str.replaceAll( '\\s+', '').normalizeSpace();
            system.debug('*S'+str);
            if(str.contains('__r')){
                rowHeaders r = new rowHeaders(str);
                rowHeadersList.add(r); 
            }else{
                rowHeaders r = new rowHeaders(dfr.get(str).getDescribe(),str);
                rowHeadersList.add(r); 
            }              
        }
        dataTableResponse dataTableResponseObj = new dataTableResponse();
        dataTableResponseObj.dataRows=sobjList;
        dataTableResponseObj.dataColumns=rowHeadersList;
        //system.debug(dataTableResponseObj);
        return dataTableResponseObj;
    }
    global class dataTableResponse{
        public list<sobject> dataRows;
        public List<rowHeaders> dataColumns;
        
    }
    global class rowHeaders{
        public String title;
        public String data;
        public string type;
        public boolean visible;
        public rowHeaders(string Name){
            this.data=name;
            this.title=name.substring(0,name.indexOfIgnoreCase('__r'));
        }
        public rowHeaders(Schema.DescribeFieldResult field,string Name){
            Schema.DisplayType FldType = field.getType();
            this.data=name;           
            if(FldType==schema.displaytype.reference || FldType==schema.displaytype.id){
                this.visible=false;
                
            }
            if(FldType==schema.displaytype.string || FldType==schema.displaytype.id || FldType==schema.displaytype.phone || FldType==schema.displaytype.reference || FldType==schema.displaytype.url || FldType==schema.displaytype.email){
                type='string';
            }            
            if(FldType==schema.displaytype.date){
                type='date';
            }
            if(FldType==schema.displaytype.datetime){
                type='date';
            }
            if(FldType==schema.displaytype.boolean){
                type='boolean';
            }
            if(FldType==schema.displaytype.Integer || FldType==schema.displaytype.currency){
                type='number';
            }
            if(FldType==schema.displaytype.percent){
                type='percent';
            }
            title=field.getLabel();
        }
    }
}