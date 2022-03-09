trigger CaseTrigger on Case (before insert, before update, after insert, after update) {

    CaseTriggerHelper caseTriggerHelper = new CaseTriggerHelper();

   	 if (Trigger.isUpdate && Trigger.isBefore){
        //    caseTriggerHelper.getQueueForCase(Trigger.new, Trigger.old);
            caseTriggerHelper.getDefaultQueue(Trigger.new, Trigger.old);
       }
}