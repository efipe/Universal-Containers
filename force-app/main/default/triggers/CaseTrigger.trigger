trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
    
    
   	 if (Trigger.isUpdate && Trigger.isAfter){
       
       List<Case> updatedCases = new List<Case>();
        
        for (Case newCase : Trigger.New){
            Id queueId = CaseRoutingService.getInstance().getQueueForCase(newCase);
            System.debug(queueId);
            
            newCase.OwnerId = queueId;
            updatedCases.add(newCase);
        }
        
        update updatedCases;
        
       }
    
    

}