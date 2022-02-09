/**
 * Created by POTERFI on 2/8/2022.
 */

trigger ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {

    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {

            System.debug('Fired after insertion');
            Map<Id, List<Task>> opportunitiesWithTaskList = new Map<Id, List<Task>>();
            List<Task> tasksToClose = new List<Task>();

            List<Opportunity> opps = [
                    SELECT Id
                    FROM Opportunity
            ];

            for (Contract__c contract : Trigger.new) {
                opportunitiesWithTaskList.put(contract.Id, contract.Opportunity__r.Tasks);
            }

            for (String Id : opportunitiesWithTaskList.keySet()) {
                for (Task task : opportunitiesWithTaskList.get(Id)) {
                    if (task.IsClosed) {
                        task.Status = 'Completed';
                        task.Description = 'added by Apex Class ContractTrigger';
                        tasksToClose.add(task);
                    }
                }
                System.debug('Hello, stack trace below');
                System.debug(tasksToClose);

                update tasksToClose;

            }
        }
    }
}