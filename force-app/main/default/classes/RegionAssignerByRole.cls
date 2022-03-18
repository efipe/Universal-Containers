/**
 * Created by POTERFI on 2/16/2022.
 */


public with sharing class RegionAssignerByRole {
    @AuraEnabled
    public Region__c userRegion = new Region__c();
    public Region__c getRegionOfUser(User user) {
        List<Region__c> userRegions = new List<Region__c>();
        if (user.UserRole.Name.contains('AMER')) {
            userRegions = [SELECT Id, Name, Parent_region__c FROM Region__c WHERE Name = 'AMER'];
        }
        return userRegions[0];
    }

}