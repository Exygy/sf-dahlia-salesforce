public with sharing class HOP_HeaderController {
    
    public static String sfInstanceURL {
    	get {
			return System.URL.getSalesforceBaseUrl().toExternalForm();
    	}
	}
    
    public static boolean seeBackButton {
    	get {
    		seeBackButton = false;
    		if (profileIds.contains(UserInfo.getProfileId())) {
    			seeBackButton = true;
    		}
    		return seeBackButton;
    	}
    }
    
    public static Set<Id> profileIds {
    	get {
    		if (profileIds == null) {
    			profileIds = new Set<Id>();
    			for (Staff_Profile__mdt mdtProfile : profileList) {
    				if (profileMap.containsKey(mdtProfile.MasterLabel)) {
    					profileIds.add(profileMap.get(mdtProfile.MasterLabel).Id);
    				}
    			}
    		}
    		return profileIds;
    	}
    }
    
    public static List<Staff_Profile__mdt> profileList {
    	get {
    		if (profileList == null) {
    			profileList = [SELECT Id, MasterLabel FROM Staff_Profile__mdt];
    		}
    		return profileList;
    	}
    }
    
    public static Map<String,Profile> profileMap {
    	get {
    		if (profileMap == null) {
    			List<Profile> existingProfiles = [SELECT Id, Name FROM Profile];
    			profileMap = new Map<String,Profile>();
    			for (Profile profile : existingProfiles) {
    				profileMap.put(profile.Name, profile);
    			}
    		}
    		return profileMap;
    	}
    }
}