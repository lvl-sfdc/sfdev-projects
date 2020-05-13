public class ContactTriggerHandler {
    
    public static void onAfterInsert(List<Contact> contactsList){
        Set<Id> contactAccountIds = new Set<Id>();
        for(Contact con : contactsList) {
                contactAccountIds.add(con.AccountId);
        }  
        if(!contactAccountIds.isEmpty()) {
            countAccountContacts(contactAccountIds); 
        }
    }
    
    public static void onAfterUpdate(List<Contact> contactsList, Map<Id,Contact> oldContactMap) {
        Set<Id> contactAccountIds = new Set<Id>();
        for (Contact con : contactsList){
            Contact oldCon = oldContactMap.get(con.Id);
            System.debug('oldCon: ' + oldCon);
            
            if (con.AccountId != null){
                if(con.AccountId != oldCon.AccountId){
                    contactAccountIds.add(con.AccountId);
                    contactAccountIds.add(oldCon.AccountId);
                }
            }
        }
        if(!contactAccountIds.isEmpty()) {
            countAccountContacts(contactAccountIds); 
        }
    }
    
    public static void onAfterDelete(List<Contact> oldContacts) {
        Set<Id> contactAccountIds = new Set<Id>();
        for(Contact con : oldContacts){
            contactAccountIds.add(con.AccountId);
            System.debug('*****contactAccountIds: ' + contactAccountIds);
        }
        if(!contactAccountIds.isEmpty()) {
            countAccountContacts(contactAccountIds); 
        }
    }
 
    public static void countAccountContacts(Set<Id> contactAccountIds) {
        List<Account> accountsList = new List<Account>();
        if(contactAccountIds.size() > 0) {
            accountsList = [SELECT Id, Name, Number_of_Contacts__c, (SELECT Id, AccountId from Contacts) FROM Account WHERE Id IN :contactAccountIds];
            System.debug('****accountsList: ' + accountsList); 
        }
        // Iterate through list of Relevant Account records. 
        // For each Account, set Number_of_Contacts__c equal to the size of the Related Contacts List
        for(Account acc : accountsList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
        }
        update accountsList;
    }   
}