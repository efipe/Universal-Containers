/**
 * Created by POTERFI on 2/11/2022.
 */

@IsTest
private class TestOpportunityTriggerService {
    @IsTest
    static void TestCreateNewTaskForOpportunity() {

        Opportunity opportunity = new Opportunity();
        opportunity.StageName = 'Closed Won';
        opportunity.Name = 'Test';
        opportunity.OwnerId = UserInfo.getUserId();
        opportunity.CloseDate = Date.today();


        Test.startTest();
        insert opportunity;
        update opportunity;
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Subject, WhatId, OwnerId, Type__c, ActivityDate FROM Task WHERE WhatId = :opportunity.Id] ;

        System.assertEquals(1, tasks.size());
        for (Task task : tasks) {
            System.assertEquals(task.Subject, 'Create contract for opportunity ' + opportunity.Name);
            System.assertEquals(task.WhatId, opportunity.Id);
            System.assertEquals(task.ActivityDate, Date.today() + 14);
            System.assertEquals(task.OwnerId, opportunity.OwnerId);
        }

    }
}