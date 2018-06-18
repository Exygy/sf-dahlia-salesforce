// *****************************************************************************
// CLASS: HOP_ApplicationsController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_Applications page.
//
// *****************************************************************************

public with sharing class HOP_ApplicationsController extends HOP_ControllerBase {

    public List<SelectOption> listingOptions {get; set;}
    public Id defaultListingId {get; set;}
    public Id filterListingId {get; set;}

    public HOP_ApplicationsController() {
        // The current User license name (logic inherited from HOP_ControllerBase)
        // is used on the page to control what Salesforce DataTables displays.
        super();

        List<Listing__c> listings;
        if (myUser.Profile.UserLicense.Name == COMMUNITY_LICENSE_NAME) {
        	String soql = 'SELECT Listing__c FROM Application__c';
            soql += ' WHERE Listing__r.Account__c = \'' + myUser.Contact.AccountId + '\' AND Status__c != \'' + DRAFT_APPLICATION + '\'';
            soql += ' GROUP BY Listing__c';
            
            List<AggregateResult> ars = Database.query(soql);
            if (ars.size() == 0) return;
            
            Set<Id> listingIds = new Set<Id>();
            for (AggregateResult ar : ars) {
                listingIds.add((Id)ar.get('Listing__c'));
            }
            listings = [SELECT Id, Name FROM Listing__c WHERE Id IN :listingIds ORDER BY Name];
        } else {
            listings = [SELECT Id, Name FROM Listing__c WHERE nSubmitted_Applications__c > 0 ORDER BY Name];
        }
        
        filterListingId = listings[0].Id;
        
        listingOptions = new List<SelectOption>();
        for (Listing__c listing : listings) {
            listingOptions.add(new SelectOption(listing.Id, listing.Name));
        }

        List<Listing__c> recentFutureListings = [
            SELECT Id, Application_Due_Date__c
            FROM Listing__c
            WHERE Id IN :listings AND Application_Due_Date__c >= TODAY
            ORDER BY Application_Due_Date__c ASC
        ];

        if (recentFutureListings.size() > 0) {
            filterListingId = recentFutureListings[0].Id;
        }
        
        List<Listing__c> recentPastListings = [
            SELECT Id, Application_Due_Date__c
            FROM Listing__c
            WHERE Id IN :listings AND Application_Due_Date__c <= TODAY
            ORDER BY Application_Due_Date__c DESC
        ];

        if (recentPastListings.size() > 0) {
            filterListingId = recentPastListings[0].Id;
        }

    }

}