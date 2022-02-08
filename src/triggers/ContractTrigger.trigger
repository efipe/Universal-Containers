/**
 * Created by POTERFI on 2/8/2022.
 */

trigger ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            Map<Id, List<Task>> opportunitiesWithTaskList = new Map<Id, List<Task>>();
            List<Task> tasksToClose = new List<Task>();

            for (Contract__c contract : Trigger.new) {
                opportunitiesWithTaskList.put(contract.Opportunity__r.Id, contract.Opportunity__r.Tasks);
            }

            for (String KeyId : opportunitiesWithTaskList.keySet()) {
                for (Task task : opportunitiesWithTaskList.get(KeyId)) {
                  //  if (task.IsClosed) {
                        task.Status = 'Completed';
                        task.Description = 'added by Apex Class ContractTrigger';
                        tasksToClose.add(task);
                }
            }
            update tasksToClose;
        }
    }
}