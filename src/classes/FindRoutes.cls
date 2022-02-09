/**
 * Created by POTERFI on 2/7/2022.
 */

public with sharing class FindRoutes {
    @AuraEnabled
    public static List<Schedule__c> getSchedules(Date startDate, Date endDate, String departure, String arrival) {
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


        return schedules;
    }
}