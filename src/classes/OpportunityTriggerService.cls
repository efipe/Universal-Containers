/**
 * Created by POTERFI on 2/10/2022.
 */

public with sharing class OpportunityTriggerService {

    public List<Task> createNewTaskForOpportunity (List<Opportunity> oppList){

        List<Task> newTasksToAdd = new List<Task>();

        for (Opportunity opportunity : oppList) {
            if (opportunity.StageName == 'Closed Won') {
                Task newTask = new Task();
                String taskName = 'Create contract for opportunity ' + opportunity.Name;
                newTask.OwnerId = opportunity.OwnerId;
                newTask.Subject = taskName;
                newTask.WhatId = opportunity.Id;
                newTask.ActivityDate = Date.today() + 14;
                newTasksToAdd.add(newTask);
            }
        }
        return newTasksToAdd;
    }

}
