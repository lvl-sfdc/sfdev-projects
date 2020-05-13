trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) {

    If(Trigger.isAfter) {
        if(Trigger.isInsert) {
  			CaseTriggerHandler.onAfterInsert(Trigger.New);
        } if (Trigger.isUpdate) {
            CaseTriggerHandler.onAfterUpdate(Trigger.New, Trigger.OldMap);
        } else if (Trigger.isDelete) {
            CaseTriggerHandler.onAfterDelete(Trigger.Old);
        }
    } else if (Trigger.isBefore) {
        if(Trigger.isInsert) {} 
        if(Trigger.isUpdate) {} 
        if(Trigger.isDelete) {}
    }
}