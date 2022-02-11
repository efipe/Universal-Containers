/**
 * Created by POTERFI on 2/8/2022.
 */

trigger ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Contract__c> contractsUploaded = Trigger.new;

            ContractTriggerService contractTriggerService = new ContractTriggerService();

            List<String> opportunityIDs = contractTriggerService.getRelatedOpportunities(contractsUploaded);

            List<Task> queriedTasksByIds = contractTriggerService.queryTasksByOpportunities(opportunityIDs);

            List<Task> tasksToUpdate = contractTriggerService.closeTask(queriedTasksByIds);


            if (tasksToUpdate.size() > 0) {
                update tasksToUpdate;
            }
        }
    }
}

