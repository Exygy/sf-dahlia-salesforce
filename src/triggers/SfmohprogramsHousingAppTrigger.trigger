/**
 * @author:      Ronald Martinez
 * @date:        08/01/2014
 * @description: Trigger for Housing Applications.
 * @history:     06/09/2015 - Heidi Tang - Edited
 */
trigger SfmohprogramsHousingAppTrigger on Housing_Application__c (before insert, before update, after insert, after update) {
    
    Boolean isEnabled = FeatureManagement.checkPermission('Bypass_All_Validation_Rules');
    if(!isEnabled) {
 
	    SfmohprogramsHousingAppTriggerHand HAHandler = new SfmohprogramsHousingAppTriggerHand();
	 
	    List<Housing_Application__c> lHANew = new List<Housing_Application__c>();
	    
	    //create list for application updates
	    list<Housing_Application__c> updateApp = new list<Housing_Application__c>();
	
	    //get list of properties for applications in trigger       
	    list<Housing_Application__c> tempProp = [SELECT Property_of_Interest__r.Property_Management_Account__c, Property_of_Interest__c 
	            FROM Housing_Application__c  WHERE Id IN :trigger.new];    
	    
	    if((trigger.isBefore) && (trigger.isInsert)){
	        Set<Id> sId = new Set<Id>();
	        for(Housing_Application__c lHA: Trigger.New){
	            if((lHA.Certificate_of_Preference_Holder__c == TRUE) || (lHA.EAHP_Certificate_Holder__c == TRUE)){
	                lHANew.add(lHA);
	                sId.add(lHA.Property_of_Interest__c); 
	            }
	        }
	
	        if(lHANew.size() > 0){       
	            HAHandler.consumeCertificate(sId, lHANew);
	        }                
	    }//end before insert
	
	    if(trigger.isAfter && trigger.isInsert){       
	        //loop thru list of applications being inserted
	        for(Housing_Application__c housingApp: tempProp){            
	            //check to see if current property is not null
	            if(housingApp.Property_of_Interest__c != null || housingApp.Property_of_Interest__c != ''){                
	                housingApp.Property_Management_Account__c = housingApp.Property_of_Interest__r.Property_Management_Account__c;
	                updateApp.add(housingApp);
	            } 
	        }//end for
	    }//end after insert
	    
	    if((trigger.isBefore) && (trigger.isUpdate)){
	        //This is used to consume certificates
	        Set<Id> sId = new Set<Id>();     
	
	        for(Housing_Application__c lHA: Trigger.New){
	            Housing_Application__c lHAOld = Trigger.OldMap.get(lHA.Id);
	
	            if( ((lHAOld.Certificate_of_Preference_Holder__c == FALSE) && (lHA.Certificate_of_Preference_Holder__c == TRUE) && (lHA.Certificate_of_Preference_Number__c != null))            
	            || ((lHAOld.EAHP_Certificate_Holder__c == FALSE) && (lHA.EAHP_Certificate_Holder__c == TRUE) && (lHA.EAHP_Certificate_Expiration_Date__c != null))){                
	                lHANew.add(lHA); 
	                sId.add(lHA.Property_of_Interest__c);              
	            }            
	        }//end for
	        
	        if(lHANew.size() > 0){
	            HAHandler.consumeCertificate(sId, lHANew);
	        }
	        //End of consume certificate
	    }//end before update
	        
	    if((trigger.isAfter) && (trigger.isUpdate)){       
	        //loop thru applications being updated
	        for(Housing_Application__c housingApp: tempProp){
	            Housing_Application__c oldHousingApp = Trigger.OldMap.get(housingApp.Id);
	            
	            //check to see if current property = old property
	            if(housingApp.Property_of_Interest__c != oldHousingApp.Property_of_Interest__c){                
	                housingApp.Property_Management_Account__c = housingApp.Property_of_Interest__r.Property_Management_Account__c;
	                updateApp.add(housingApp);
	            } 
	        }//end for
	    }//end after update     
	
	    //check for values in list of updated applications
	    if (updateApp.size() > 0){
	        update updateApp;
	    }  
    }
}