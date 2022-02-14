/**
 * Created by POTERFI on 2/14/2022.
 */

trigger ScheduleBookingTrigger on Schedule_booking__c (after insert, after update) {

    if (Trigger.isInsert || Trigger.isUpdate) {

        List<Schedule_booking__c> bookingsProcessed = Trigger.new;
        List<Id> opportunitiesToUpdateIds = new List<Id>();

        List<Schedule_booking__c> oldBookings = new List<Schedule_booking__c>();
        Map<String, Decimal> oldBookingValues = new Map<String, Decimal>();

        if (Trigger.isUpdate) {
            oldBookings = Trigger.old;
            for (Schedule_booking__c oldBooking : oldBookings) {
                if (oldBooking.Amount__c == null) {
                   oldBookingValues.put(oldBooking.Name, 0);
                } else {
                    oldBookingValues.put(oldBooking.Name, oldBooking.Amount__c);
                }
            }
        }

        for (Schedule_booking__c booking : bookingsProcessed) {
            opportunitiesToUpdateIds.add(booking.Opportunity__c);
        }

        List<Opportunity> opportunitiesToUpdate = [SELECT Id, Name, Amount__c FROM Opportunity WHERE Id = :opportunitiesToUpdateIds];

        for (Opportunity opportunity : opportunitiesToUpdate) {
            for (Schedule_booking__c booking : bookingsProcessed) {
                if (opportunity.Id == booking.Opportunity__c) {
                    if (Trigger.isInsert) {
                        opportunity.Amount__c += booking.Amount__c;
                    } else if (Trigger.isUpdate) {
                        Decimal difference = booking.Amount__c - oldBookingValues.get(booking.Name);
                        opportunity.Amount__c = opportunity.Amount__c + difference;
                    }
                }
            }
        }
        update opportunitiesToUpdate;
    }

}