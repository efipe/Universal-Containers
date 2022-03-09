trigger CaseTrigger on Case (before insert, before update, after insert, after update) {

    CaseTriggerHelper caseTriggerHelper = new CaseTriggerHelper();

   	 if (Trigger.isUpdate && Trigger.isBefore){
            caseTriggerHelper.getDefaultQueue(Trigger.new, Trigger.old);
            caseTriggerHelper.getQueueForCase(Trigger.new, Trigger.old);
            caseTriggerHelper.incrementTimesOpenedField(Trigger.new, Trigger.old);
       }
}