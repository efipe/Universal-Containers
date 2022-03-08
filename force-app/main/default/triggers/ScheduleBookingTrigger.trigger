/**
 * Created by POTERFI on 2/14/2022.
 */

trigger ScheduleBookingTrigger on Schedule_booking__c (after insert, after update) {

    /*

    if (Trigger.isInsert || Trigger.isUpdate) {
        ScheduleBookingService service = new ScheduleBookingService();

        List<Schedule_booking__c> bookingsProcessed = Trigger.new;

        List<Id> opportunitiesToUpdateIds = service.getAffectedOpportunitiesIds(bookingsProcessed);
        List<Opportunity> opportunitiesToUpdate = service.getListOfOpportunities(opportunitiesToUpdateIds);
        opportunitiesToUpdate = service.updateOpportunityAmount(opportunitiesToUpdate, bookingsProcessed);


        List<Schedule__c> schedulesToUpdate = service.returnUpdatedSchedules(bookingsProcessed);

        update opportunitiesToUpdate;
        update schedulesToUpdate;

    }
*/


}