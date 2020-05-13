trigger CountAccountContactsTrigger on Contact (after insert, after update, after delete) {
   
    Set<Id> contactAccountIds = new Set<Id>();
   
    // If Contact is inserted, add relevant AccountIds to contactAccountIds Set
    if(Trigger.isInsert) {
        for(Contact con : Trigger.New) {
            contactAccountIds.add(con.AccountId);
        }
    }
    
    // If the Contact is Updated/ if the Contact's Account is changed to another Account,
    // add old Account Id value and new Account Id value to contactAccountIds Set
    if(Trigger.isUpdate) {
        for (Contact con : Trigger.New){
            Contact oldCon = Trigger.oldMap.get(con.Id);
            System.debug('oldCon: ' + oldCon);
            
            if (con.AccountId != null){
                if(con.AccountId != oldCon.AccountId){
                    contactAccountIds.add(con.AccountId);
                    contactAccountIds.add(oldCon.AccountId);
                }
            }
        }
    }
    
    // If Contact is deleted, iterate through Trigger.Old values, add relevant AccountIds to contactAccountIds Set
    if(Trigger.isDelete){
        for(Contact con : Trigger.Old){
            contactAccountIds.add(con.AccountId);
            System.debug('*****contactAccountIds: ' + contactAccountIds);
        }        
    }
         
    // Query the Accounts and related Contacts where Id and AccountId are in contactAccountIds
    List<Account> accountsList = new List<Account>();
    if(contactAccountIds.size()>0) {
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