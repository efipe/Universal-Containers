/**
 * Created by POTERFI on 2/9/2022.
 */

public with sharing class ContractTriggerService {

    public static Task closeTask(Task receivedTask) {
        if (receivedTask.Type__c == 'Contract creation notification') {
            receivedTask.Id = receivedTask.Id;
            receivedTask.isClosed__c = true;
            receivedTask.Task_closure_date__c = Date.today();

        }
        return receivedTask;
    }

}