/**
 * Created by POTERFI on 2/18/2022.
 */

public with sharing class AssignRegions implements Database.Batchable<Opportunity> {

    // implement also interface from Schedulable and launch Batch as a Scheduled method
    public Integer recordsProcessed = 0;
    List<User_in_the_region__c> usersAndRegions = [SELECT Id, User__c, Region__c FROM User_in_the_region__c];

    public Iterable<Opportunity> start(Database.BatchableContext param1) {
        // query list of All Opportunities / Schedules
        List<Opportunity> opportunities = [SELECT Id, Name, Region__c, Region_recalculation_disabled__c, OwnerId FROM Opportunity WHERE Region_recalculation_disabled__c = False];
// return Database.Query
        return opportunities;
    }


    public void execute(Database.BatchableContext param1, List<Opportunity> opportunities) {
        // Iterate  over Opportunity / Schedule and check if:

        // 2) record region == record owner region
        Map<String, String> usersInRegions = new Map<String, String>();
        List<Opportunity> updated = new List<Opportunity>();
        for (User_in_the_region__c region : usersAndRegions) {
            usersInRegions.put(region.User__c, region.Region__c);
        }


        for (Opportunity opportunity : opportunities) {
            if (!(opportunity.Region__c == usersInRegions.get(opportunity.OwnerId))) {
                opportunity.Region__c = usersInRegions.get(opportunity.OwnerId);
                updated.add(opportunity);
                recordsProcessed += 1;
            }

        }
        update updated;
    }


    public void finish(Database.BatchableContext param1) {
        // update the returned records
        System.debug(recordsProcessed);
    }


}