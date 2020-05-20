public class RegistrationTriggerHandler {
	
    public static void emailWhenRegistrationDeleted(List<Registration__c> oldRegList) {
        
        Messaging.reserveSingleEmailCapacity(Trigger.size);
        
        EmailTemplate template = [SELECT Id, Name, Body FROM EmailTemplate WHERE Name ='Deleted Registration Notification'];         
        
        Email_Setting__mdt email_config = [SELECT Id__c, Send_To_Email__c, ContactId__c FROM Email_Setting__mdt WHERE Id__c =:'ManagerId' LIMIT 1];
         
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Registration__c reg: oldRegList) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(email_config.ContactId__c);
            email.setTreatTargetObjectAsRecipient(false);
            email.setWhatId(reg.Id);
            email.setToAddresses(new String[] {email_config.Send_To_Email__c});
            email.setTemplateId(template.Id);
            email.setSenderDisplayName('Top Events Support');
            emails.add(email);       
            System.debug('****reg.Id: ' + reg.Id);
        } 
        if(emails.size() > 0) {
        	Messaging.sendEmail(emails);
			System.debug('***Email sent!');
        }
    }   
}