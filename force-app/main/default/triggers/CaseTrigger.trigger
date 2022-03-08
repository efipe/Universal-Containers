trigger CaseTrigger on Case (before insert, before update, after insert, after update) {

    CaseTriggerHelper caseTriggerHelper = new CaseTriggerHelper();
   	 if (Trigger.isUpdate && Trigger.isBefore){
        for (Case newCase : Trigger.new){
            newCase.OwnerId = caseTriggerHelper.getQueueForCase(Trigger.new, Trigger.old);
        }
       }
}