public with sharing class CaseTriggerHelper {

    public void getQueueForCase (List<Case> newCases, List<Case> oldCases){
        for (Case newCase : newCases){
            if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
                Id queueLanguageId = CaseRoutingService.getInstance().getQueueForCase(newCase);
                if(queueLanguageId != null){
                    newCase.OwnerId = queueLanguageId;
                }
            }
        }
    }

    public void getDefaultQueue (List<Case> newCases, List<Case> oldCases){
        for (Case newCase : newCases) {
            for (Case oldCase : oldCases) {
                if (oldCase.Preferred_language__c != newCase.Preferred_language__c) {
                    System.debug(newCase.OwnerId);
                    newCase.OwnerId = CaseRoutingService.getInstance().getdefaultQueue(oldCase.OwnerId, LanguageEnum.valueOf(oldCase.Preferred_language__c));
                    System.debug(newCase.OwnerId);
                }
            }
        }
    }

    public void incrementTimesOpenedField (List<Case> newCases, List<Case> oldCases){
        for (Case newCase : newCases) {
            for (Case oldCase : oldCases) {
                if (oldCase.Status == 'Closed' && oldCase.Status != newCase.Status) {
                    if (newCase.Times_reopened__c != null) {
                        newCase.Times_reopened__c += 1;                                    
                    } else {
                        newCase.Times_reopened__c = 1;
                    }
                }
            }
        }
    }

    public void setDateTimeOfLastStatusChange (List<Case> newCases, List<Case> oldCases){
        for(Case newCase : newCases){
            for (Case oldCase : oldCases) {
                if (oldCase.Status != newCase.Status) {
                    newCase.Last_status_change_date__c = Datetime.now();
                }
            }
        }
    }

    public void setDateTimeOfLastStatusChange (List<Case> newCases){
        for(Case newCase : newCases){
                    newCase.Last_status_change_date__c = Datetime.now();
            }
        }
}



