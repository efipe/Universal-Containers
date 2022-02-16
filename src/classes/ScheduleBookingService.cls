/**
 * Created by POTERFI on 2/15/2022.
 */

public with sharing class ScheduleBookingService {

    public List<Id> getAffectedOpportunitiesIds(List<Schedule_booking__c> bookingsProcessed) {
        List<Id> opportunitiesToUpdateIds = new List<Id>();

        for (Schedule_booking__c booking : bookingsProcessed) {
            opportunitiesToUpdateIds.add(booking.Opportunity__c);
        }
        return opportunitiesToUpdateIds;
    }

    public List<Opportunity> getListOfOpportunities(List<Id> affectedOpportunitiesIds) {
        List<Opportunity> opportunitiesToUpdate = [SELECT Id, Name, Amount__c FROM Opportunity WHERE Id = :affectedOpportunitiesIds];
        return opportunitiesToUpdate;
    }

    public List<Opportunity> updateOpportunityAmount(List<Opportunity> opportunitiesToUpdate, List<Schedule_booking__c> bookingsProcessed) {
        Map<String, Decimal> oldBookingValues = new Map<String, Decimal>();
        List<Schedule_booking__c> oldBookings = new List<Schedule_booking__c>();

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

        return opportunitiesToUpdate;
    }

    public List<Schedule__c> getAffectedSchedules(List<Id> relatedSchedulesId) {
        List<Schedule__c> schedules = [SELECT Id, Name, TEU_booked_on_New_Status__c, TEU_booked_on_Locked_Status__c, TEU_booked_on_Booked_status__c, Amount_in_Booked_Status__c, Amount_in_Locked_Status__c, Amount_in_New_Status__c FROM Schedule__c WHERE Id = :relatedSchedulesId];
        return schedules;
    }

    public List<Id> getSchedulesIds(List<Schedule_booking__c> bookingsProcessed) {
        List<Id> relatedSchedulesIds = new List<Id>();
        for (Schedule_booking__c booking : bookingsProcessed) {
            relatedSchedulesIds.add(booking.Schedule__c);
        }
        return relatedSchedulesIds;
    }

    public List<Decimal> getTeuAndAmountNumberInNewStatus(List<Schedule_booking__c> bookingsProcessed) {
        Decimal totalTEU = 0;
        List<Id> relatedSchedulesIds = getSchedulesIds(bookingsProcessed);
        List<Schedule_booking__c> bookings = [SELECT Id, Name, Declared_Teu__c, Schedule__c, Amount__c FROM Schedule_booking__c WHERE Status__c = 'New' AND Schedule__c = :relatedSchedulesIds];
        Decimal totalAmount = 0;

        for (Schedule_booking__c booking : bookings) {
            totalTEU += booking.Declared_Teu__c;
            totalAmount += booking.Amount__c;
        }
        List<Decimal> teusAndAmount = new List<Decimal>{
                totalTEU, totalAmount
        };
        return teusAndAmount;
    }

    public List<Decimal> getTeuAndAmountNumberInLockedStatus(List<Schedule_booking__c> bookingsProcessed) {
        Decimal totalTEU = 0;
        List<Id> relatedSchedulesIds = getSchedulesIds(bookingsProcessed);
        List<Schedule_booking__c> bookings = [SELECT Id, Name, Declared_Teu__c, Schedule__c, Amount__c FROM Schedule_booking__c WHERE Status__c = 'Locked' AND Schedule__c = :relatedSchedulesIds];
        Decimal totalAmount = 0;

        for (Schedule_booking__c booking : bookings) {
            totalTEU += booking.Declared_Teu__c;
            totalAmount += booking.Amount__c;
        }
        List<Decimal> teusAndAmount = new List<Decimal>{
                totalTEU, totalAmount
        };
        return teusAndAmount;
    }

    public List<Decimal> getTeuAndAmountNumberInBookedStatus(List<Schedule_booking__c> bookingsProcessed) {
        Decimal totalTEU = 0;
        List<Id> relatedSchedulesIds = getSchedulesIds(bookingsProcessed);
        List<Schedule_booking__c> bookings = [SELECT Id, Name, Declared_Teu__c, Schedule__c, Amount__c FROM Schedule_booking__c WHERE Status__c = 'Booked' AND Schedule__c = :relatedSchedulesIds];
        Decimal totalAmount = 0;

        for (Schedule_booking__c booking : bookings) {
            totalTEU += booking.Declared_Teu__c;
            totalAmount += booking.Amount__c;
        }
        List<Decimal> teusAndAmount = new List<Decimal>{
                totalTEU, totalAmount
        };

        return teusAndAmount;
    }

    public List<Schedule__c> returnUpdatedSchedules(List<Schedule_booking__c> bookingsProcessed) {
        List<Decimal> newTEU = getTeuAndAmountNumberInNewStatus(bookingsProcessed);
        List<Decimal> lockedTEU = getTeuAndAmountNumberInLockedStatus(bookingsProcessed);
        List<Decimal> bookedTEU = getTeuAndAmountNumberInBookedStatus(bookingsProcessed);

        List<Schedule__c> schedules = getAffectedSchedules(getSchedulesIds(bookingsProcessed));

        for (Schedule__c schedule : schedules) {
            schedule.TEU_booked_on_New_Status__c = newTEU[0];
            schedule.Amount_in_New_Status__c = newTEU[1];

            schedule.TEU_booked_on_Locked_Status__c = lockedTEU[0];
            schedule.Amount_in_Locked_Status__c = lockedTEU[1];

            schedule.TEU_booked_on_Booked_status__c = bookedTEU[0];
            schedule.Amount_in_Booked_Status__c = bookedTEU[1];
        }
        return schedules;
    }


}