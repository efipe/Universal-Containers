trigger CaseTrigger on Case (before insert, before update, after insert, after update) {

    CaseTriggerHelper caseTriggerHelper = new CaseTriggerHelper();
    if (Trigger.isInsert && Trigger.isBefore) {
        caseTriggerHelper.setDateTimeOfLastStatusChange(Trigger.new);
    }

   	 if (Trigger.isUpdate && Trigger.isBefore){
            caseTriggerHelper.getDefaultQueue(Trigger.new, Trigger.old);
            caseTriggerHelper.getQueueForCase(Trigger.new, Trigger.old);
            caseTriggerHelper.incrementTimesOpenedField(Trigger.new, Trigger.old);
            caseTriggerHelper.setDateTimeOfLastStatusChange(Trigger.new, Trigger.old);
            CaseTriggerHelper.calculateTotalCloseDate(Trigger.new, Trigger.old);
       }
}