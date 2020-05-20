trigger RegistrationTrigger on Registration__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(Trigger.isBefore && Trigger.isDelete) {
        RegistrationTriggerHandler.emailWhenRegistrationDeleted(Trigger.old);
    }
}