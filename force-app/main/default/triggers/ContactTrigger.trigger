trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {

    If(Trigger.isAfter) {
        if(Trigger.isInsert) {
  			ContactTriggerHandler.onAfterInsert(Trigger.New);
        } if (Trigger.isUpdate) {
            ContactTriggerHandler.onAfterUpdate(Trigger.New, Trigger.OldMap);
        } else if (Trigger.isDelete) {
            ContactTriggerHandler.onAfterDelete(Trigger.Old);
        }
    } else if (Trigger.isBefore) {
        if(Trigger.isInsert) {} 
        if(Trigger.isUpdate) {} 
        if(Trigger.isDelete) {}
    }
}