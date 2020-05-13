trigger IncrementAccountContactsTrigger on Contact (after insert, after update, after delete) {
    // Query relevant Contacts into a collection
    // Query for the contacts that are related to the same account (AccountId)
    Set<Id> contactAccountIds = new Set<Id>();
   
    // If Contact is inserted or updated, add relevant AccountIds to contactAccountIds List
    if(Trigger.isInsert) {
        for(Contact con : Trigger.New) {
            contactAccountIds.add(con.AccountId);
        }
    }
    
    //If the Contacted is Updated, If the Contact's Account is changed to another Account
    if(Trigger.isUpdate) {
        for (Contact con : Trigger.New){
            
            Contact oldCon = Trigger.oldMap.get(con.Id);
            System.debug('oldCon: ' + oldCon);
            
            if (con.AccountId != null){
                if(con.AccountId != oldCon.AccountId){
                    contactAccountIds.add(con.AccountId);
                    contactAccountIds.add(oldCon.AccountId);
                    System.debug('oldmap: ' + Trigger.oldMap);
                    System.debug('oldCon.AccountId: ' + oldCon.AccountId);
                }
           }
        }
    }
    
    // If Contact is deleted, iterate through Trigger.Old values, add relevant AccountIds to contactAccountIds List
    if(Trigger.isDelete){
        for(Contact con : Trigger.Old){
            contactAccountIds.add(con.AccountId);
        }        
    }
    System.debug('*****contactAccountIds: ' + contactAccountIds);
        
    // Query the contacts where AccountId is in contactAccountIds, will return all Contacts for an Account
    //List<Contact> contactsList = new List<Contact>();
    List<Account> accountsList = new List<Account>();
    if(contactAccountIds.size()>0) {
        //contactsList = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :contactAccountIds];
        accountsList = [SELECT Id, Name, Number_of_Contacts__c, (SELECT Id, AccountId from Contacts) FROM Account WHERE Id IN :contactAccountIds];
        //System.debug('****contactsList: ' + contactsList);
        System.debug('****accountsList: ' + accountsList); 
    }

    //Create a map where keys are Account Ids and values are the List of related Contacts
    //Map<Id,List<Contact>> accountContactsMap = new Map<Id,List<Contact>>();
    
    //List<Contact> relatedContacts = new List<Contact>();
    
    //if (contactsList.size()>0){
        //for(Contact con : contactsList){
            //List<Contact> relatedContacts = accountContactsMap.get(con.AccountId);
            
            //if(relatedContacts == null){
                //relatedContacts = new List<Contact>();
               // accountContactsMap.put(con.AccountId, relatedContacts);
            //}
            //relatedContacts.add(con);
            //accountContactsMap.put(con.AccountId, relatedContacts);
            
            //System.debug('****relatedContacts: ' + relatedContacts);
            //System.debug('****accountContactsMap: ' + accountContactsMap);
       //}
    //}
 
   //use that to set the count field on each account and update the field
   //List<Account> accountsList = new List<Account>([SELECT Id, Name, Number_of_Contacts__c FROM Account WHERE Id IN :accountContactsMap.keySet()]);
   
   //System.debug('****accountsList: ' + accountsList); 
    
    //List<Contact> accContactsList = new List<Contact>();
    for(Account acc : accountsList){
        //if(accountContactsMap.isEmpty()){
        //  acc.Number_of_Contacts__c = 0;
        //} else {
        //    List<Contact> accContactsList = accountContactsMap.get(acc.Id);
        //  System.debug('****accContactsList: ' + accContactsList);
            acc.Number_of_Contacts__c = acc.Contacts.size();
        //}
   }
   update accountsList;
}