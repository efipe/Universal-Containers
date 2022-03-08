public with sharing class CaseTriggerHelper {

    public void getQueueForCase (List<Case> newCases, List<Case> oldCases){
        Id desiredQueueId;
        for (Case newCase : newCases){
            newCase.OwnerId = CaseRoutingService.getInstance().getQueueForCase(newCase);
    }
}
}