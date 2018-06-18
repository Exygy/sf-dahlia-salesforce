trigger ListingPreference on Listing_Lottery_Preference__c (before delete, before insert, before update, after delete, after insert, after update) {
   ListingPreferenceSetAutoGrantAction.runHandler();
}