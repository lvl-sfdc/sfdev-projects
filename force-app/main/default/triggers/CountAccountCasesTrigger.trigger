trigger CountAccountCasesTrigger on Case (after insert, after update, after delete) {
   
    Set<Id> caseAccountIds = new Set<Id>();
   
    // If Cases is inserted, add relevant AccountIds to caseAccountIds Set
    if(Trigger.isInsert) {
        for(Case caseRecord : Trigger.New) {
            if(caseRecord.Status != 'Closed'){
                caseAccountIds.add(caseRecord.AccountId);
            }
        }
    }
    
    // If the Case is Updated/ if the Case's Account is changed to another Account,
    // add old Account Id value and new Account Id value to caseAccountIds Set
    if(Trigger.isUpdate) {
        for(Case caseRecord : Trigger.New){
                Case oldCase = Trigger.oldMap.get(caseRecord.Id);
                System.debug('oldCase: ' + oldCase);
                
            if (caseRecord.AccountId != null){
                if(caseRecord.AccountId != oldCase.AccountId || caseRecord.Status == 'Closed'){
                    caseAccountIds.add(caseRecord.AccountId);
                    caseAccountIds.add(oldCase.AccountId);
                }
            }
        }
    }
    
    // If Case is deleted, iterate through Trigger.Old values, add relevant AccountIds to caseAccountIds Set
    if(Trigger.isDelete){
        for(Case caseRecord : Trigger.Old){
            caseAccountIds.add(caseRecord.AccountId);
            System.debug('*****caseAccountIds: ' + caseAccountIds);
        }        
    }
         
    // Query the Accounts and related Cases where Id and AccountId are in caseAccountIds
    List<Account> accountsList = new List<Account>();
    if(caseAccountIds.size()>0) {
        accountsList = [SELECT Id, Name, Number_of_Open_Cases__c, (SELECT Id, CaseNumber, AccountId, Status from Cases WHERE Status != 'Closed') FROM Account WHERE Id IN :caseAccountIds];
        System.debug('****accountsList: ' + accountsList); 
    }
    // Iterate through list of Relevant Account records. 
    // For each Account, set Number_of_Open_Cases__c equal to the size of the Related Cases List
    for(Account acc : accountsList){
        acc.Number_of_Open_Cases__c = acc.Cases.size();
    }
    update accountsList;
}