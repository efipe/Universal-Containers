/**
 * Created by POTERFI on 2/7/2022.
 */

public with sharing class FindSchedules {

    @AuraEnabled
    public static List<ScheduleWrapper> getSchedules(Date startDate, Date endDate, String departure, String arrival) {

        StringQueryBuilder stringQueryBuilder = new StringQueryBuilder();

        String query = stringQueryBuilder
                .addField('Id')
                .addField('Name')
                .addField('Route__r.Name')
                .addField('Vessel__r.Name')
                .addField('Departure_date__c')
                .addField('Arrival_date__c')
                .addField('Route__r.Port_of_Origin__c')
                .addField('Route__r.Port_of_Destination__c')
                .fromx('Schedule__c')
                .addWhere('Departure_date__c', startDate, '=' )
                .addWhere('Arrival_date__c', endDate, '=')
                .addWhere('Route__r.Port_of_Origin__c', departure, '=')
                .addWhere('Route__r.Port_of_Destination__c', arrival, '=')
                .build();
        System.debug(query);

        List<Schedule__c> schedules = stringQueryBuilder.query();

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