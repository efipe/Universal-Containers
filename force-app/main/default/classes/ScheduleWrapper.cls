/**
 * Created by POTERFI on 2/9/2022.
 */

public with sharing class ScheduleWrapper {


    @AuraEnabled public String id {get; set;}
    @AuraEnabled public String scheduleName{get; set;}
    @AuraEnabled public Date scheduleStartDate{get; set;}
    @AuraEnabled public Date scheduleEndDate{get; set;}
    @AuraEnabled public String routeName {get; set;}
    @AuraEnabled public String vesselName {get; set;}

}