public class CaseTriggerHandler {
    
    public static void onAfterInsert(List<Case> casesList){
		Set<Id> caseAccountIds = new Set<Id>();  
        for(Case caseRecord : casesList) {
            if(caseRecord.Status != 'Closed'){
        		caseAccountIds.add(caseRecord.AccountId);
            }
        }
        if(!caseAccountIds.isEmpty()) {
        	countAccountCases(caseAccountIds);
        }
    }
    
    // If the Case is Updated/ if the Case's Account is changed to another Account,
    // add old Account Id value and new Account Id value to caseAccountIds Set
    public static void onAfterUpdate(List<Case> casesList, Map<Id,Case> oldCaseMap) {
        Set<Id> caseAccountIds = new Set<Id>();
        for(Case caseRecord : casesList){
                Case oldCase = oldCaseMap.get(caseRecord.Id);
                System.debug('oldCase: ' + oldCase);
            // implement --  status changed from Closed or to Closed   
            if (caseRecord.AccountId != null){
                if(caseRecord.AccountId != oldCase.AccountId || caseRecord.Status == 'Closed'){
                    caseAccountIds.add(caseRecord.AccountId);
                    caseAccountIds.add(oldCase.AccountId);
                }
            }
    	}
        if(!caseAccountIds.isEmpty()) {
        	countAccountCases(caseAccountIds);
        }
    }
    
    public static void OnAfterDelete(List<Case> oldCases) {
        Set<Id> caseAccountIds = new Set<Id>();
        for(Case caseRecord : oldCases){
            caseAccountIds.add(caseRecord.AccountId);
            System.debug('*****caseAccountIds: ' + caseAccountIds);
        }
        if(!caseAccountIds.isEmpty()) {
        	countAccountCases(caseAccountIds);
        }
     }
    
    public static void countAccountCases(Set<Id> caseAccountIds) {
        List<Account> accountsList = new List<Account>();
    	if(caseAccountIds.size() > 0) {
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
}