public with sharing class CaseTriggerHelper {

    public void getQueueForCase (List<Case> newCases, List<Case> oldCases){
        Id desiredQueueId;
        for (Case newCase : newCases){
            newCase.OwnerId = CaseRoutingService.getInstance().getQueueForCase(newCase);
    }
}

    public void getDefaultQueue (List<Case> newCases, List<Case> oldCases){
        for (Case newCase : newCases) {
            if(newCase.OwnerId.getSobjectType() != User.getSObjectType()){
            for (Case oldCase : oldCases) {
                if (oldCase.Preferred_language__c != newCase.Preferred_language__c) {
                    System.debug(newCase.OwnerId);
                    newCase.OwnerId = CaseRoutingService.getInstance().getdefaultQueue(oldCase.OwnerId, LanguageEnum.valueOf(oldCase.Preferred_language__c));
                    System.debug(newCase.OwnerId);
                }
                newCase.OwnerId = CaseRoutingService.getInstance().getQueueForCase(newCase);
            }
        }
    }
}
}
