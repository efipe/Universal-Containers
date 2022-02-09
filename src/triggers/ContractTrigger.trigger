/**
 * Created by POTERFI on 2/8/2022.
 */

trigger ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {

            List<String> opportunityIDs = new List<String>();
            List<Task> tasksToUpdate = new List<Task>();

            for (Contract__c contract : Trigger.new) {
                String contractsOppId = contract.Opportunity__c;
                opportunityIDs.add(contractsOppId);
            }

            List<Task> queriedTasksByIds = [
                    SELECT Id, Type__c, isClosed__c, Task_closure_date__c
                    FROM Task
                    WHERE WhatId = :opportunityIDs
            ];

            for (Task queriedTask : queriedTasksByIds) {
                tasksToUpdate.add(ContractTriggerService.closeTask(queriedTask));
            }
            update tasksToUpdate;
        }
    }
}

