/**
 * Created by POTERFI on 2/8/2022.
 */

trigger OpportunityTrigger on Opportunity (before update, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            List<Task> newTasksToAdd = new List<Task>();
            List<Opportunity> updatedOpportunities = Trigger.new;
            OpportunityTriggerService opportunityTriggerService = new OpportunityTriggerService();

            newTasksToAdd = opportunityTriggerService.createNewTaskForOpportunity(updatedOpportunities);

            if (newTasksToAdd.size() > 0) {
                System.debug(newTasksToAdd);
                insert newTasksToAdd;
            }
        }
    }
}

