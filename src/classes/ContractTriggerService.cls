/**
 * Created by POTERFI on 2/9/2022.
 */

public with sharing class ContractTriggerService {

    public List<Task> closeTask(List<Task> receivedTasks) {
        for (Task task : receivedTasks) {
            if (task.Type__c == 'Contract creation notification') {
                task.Id = task.Id;
                task.isClosed__c = true;
                task.Task_closure_date__c = Date.today();
            }
        }
        return receivedTasks;
    }

    public List<Task> queryTasksByOpportunities(List<Id> opportunitiesID) {
        List<Task> queriedTasks = [SELECT Id, Type__c, isClosed__c, Task_closure_date__c FROM Task WHERE WhatId = :opportunitiesID];
        return queriedTasks;
    }

    public List<Id> getRelatedOpportunities(List<Contract__c> contracts) {
        List<Id> opportunitiesId = new List<Id>();
        for (Contract__c contract : contracts) {
            opportunitiesId.add(contract.Opportunity__c);
        }
        return opportunitiesId;
    }

}