/**
 * Created by POTERFI on 2/7/2022.
 */

public with sharing class FindSchedules {
    @AuraEnabled
    public static List<ScheduleWrapper> getSchedules(Date startDate, Date endDate, String departure, String arrival) {
        System.debug(startDate);
        List<Schedule__c> schedules = [
                SELECT Id,
                        Name,
                        Route__r.Name,
                        Vessel__r.Name,
                        Departure_date__c,
                        Arrival_date__c,
                        Route__r.Port_of_Origin__c,
                        Route__r.Port_of_Destination__c

                FROM Schedule__c
                WHERE
                Departure_date__c = :startDate
                AND Arrival_date__c = :endDate
                AND Route__r.Port_of_Origin__c = :departure
                AND Route__r.Port_of_Destination__c = :arrival
        ];

        List<ScheduleWrapper> wrappedSchedules = FindSchedules.getRelatedObjectsNames(schedules);

        return wrappedSchedules;
    }

    public static List<ScheduleWrapper> getRelatedObjectsNames(List<Schedule__c> scheds) {
        ScheduleWrapper wrapper = new ScheduleWrapper();
        List<ScheduleWrapper> wrappedSchedules = new List<ScheduleWrapper>();

        for (Schedule__c schedule : scheds) {
            wrapper.id = schedule.Id;
            wrapper.scheduleName = schedule.Name;
            wrapper.scheduleStartDate = schedule.Departure_date__c;
            wrapper.scheduleEndDate = schedule.Arrival_date__c;
            wrapper.routeName = schedule.Route__r.Name;
            wrapper.vesselName = schedule.Vessel__r.Name;
            wrappedSchedules.add(wrapper);
        }
        return wrappedSchedules;
    }


}