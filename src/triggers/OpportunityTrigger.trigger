/**
 * Created by POTERFI on 2/8/2022.
 */

trigger OpportunityTrigger on Opportunity (before update, after update) {

    if (Trigger.isBefore) {

    }
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            List<Task> newTasksToAdd = new List<Task>();
            Task newTaskCreated = new Task();

            for (Opportunity opportunity : Trigger.new) {

                if (opportunity.StageName == 'Closed Won') {
                    String taskName = 'Create contract for opportunity ' + opportunity.Name;
                    newTaskCreated.OwnerId = opportunity.OwnerId;
                    newTaskCreated.Subject = taskName;
                    newTaskCreated.WhatId = opportunity.Id;
                    newTaskCreated.ActivityDate = Date.today() + 14;
                    newTasksToAdd.add(newTaskCreated);
                }
            }
            if (newTasksToAdd.size() > 0) {
                insert newTasksToAdd;
            }

        }


    }
}