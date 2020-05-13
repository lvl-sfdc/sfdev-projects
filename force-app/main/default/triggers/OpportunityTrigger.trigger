trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandler.validateStageByContactRoles(Trigger.new, Trigger.newMap, Trigger.oldMap);    
    }
}