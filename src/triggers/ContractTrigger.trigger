/**
 * Created by POTERFI on 2/8/2022.
 */

trigger ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Contract__c> contractsUploaded = Trigger.new;
            List<Task> tasksToUpdate = new List<Task>();

            List<String> opportunityIDs = ContractTriggerService.getRelatedOpportunities(contractsUploaded);

            List<Task> queriedTasksByIds = ContractTriggerService.queryTasksByOpportunities(opportunityIDs);

            update tasksToUpdate = ContractTriggerService.closeTask(queriedTasksByIds);
        }
    }
}

