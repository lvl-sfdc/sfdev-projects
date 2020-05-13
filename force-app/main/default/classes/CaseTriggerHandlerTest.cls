@isTest
public class CaseTriggerHandlerTest {
    
    @isTest
    public static void whenNewCaseInserted(){
        // Create test Account record 
        Account testAcct1 = new Account (
            Name = 'Test Account1'
        );
        insert testAcct1;
        
        // Create test Case record
        Case testCase = new Case (
        	Status = 'New',
        	Origin = 'Phone',
            AccountId = testAcct1.Id
		);
      	insert testCase;
        
        Account testAccount = [SELECT Id, Number_of_Open_Cases__c FROM Account WHERE Id = :testAcct1.Id];
        
        System.assertEquals(1, testAccount.Number_of_Open_Cases__c);    
    }
    
    @isTest
    public static void whenCaseUpdatedToStatusClosed(){
        // Create test Account record 
        Account testAcct2 = new Account (
            Name = 'Test Account2'
        );
        insert testAcct2;
        
        // Create test Case record
        Case testCase2 = new Case (
        	Status = 'New',
        	Origin = 'Phone',
            AccountId = testAcct2.Id
		);
      	insert testCase2;
        
        testCase2.Status = 'Closed';
        update testCase2;
        
        Account testAccount2 = [SELECT Id, Number_of_Open_Cases__c FROM Account WHERE Id = :testAcct2.Id];
        
        System.assertEquals(0, testAccount2.Number_of_Open_Cases__c);    
    }
    
    @isTest
    public static void whenCaseAccountIdUpdated(){
        
        // Create test Account record        
        Account testAcct3 = new Account (
            Name = 'Test Account3'
        );
        insert testAcct3;
     
        // Create test Case record
        Case testCase3 = new Case (
        	Status = 'New',
        	Origin = 'Phone',
            AccountId = testAcct3.Id
		);
      	insert testCase3;
        
        //Create another test Account record
        Account testAcct4 = new Account (
            Name = 'Test Account4'
        );
        insert testAcct4;
        
        testCase3.AccountId = testAcct4.Id;
        update testCase3;
        
        Account testAccount3 = [SELECT Id, Number_of_Open_Cases__c FROM Account WHERE Id = :testAcct3.Id];
        Account testAccount4 = [SELECT Id, Number_of_Open_Cases__c FROM Account WHERE Id = :testAcct4.Id];
        
        System.assertEquals(0, testAccount3.Number_of_Open_Cases__c);
        System.assertEquals(1, testAccount4.Number_of_Open_Cases__c);    
    }
    
    @isTest
    public static void whenCaseDeleted(){
        // Create test Account record 
        Account testAcct5 = new Account (
            Name = 'Test Account5'
        );
        insert testAcct5;
        
        // Create test Case record
        Case testCase5 = new Case (
        	Status = 'New',
        	Origin = 'Phone',
            AccountId = testAcct5.Id
		);
      	insert testCase5;
        delete testCase5;
        
        Account testAccount5 = [SELECT Id, Number_of_Open_Cases__c FROM Account WHERE Id = :testAcct5.Id];
        
        System.assertEquals(0, testAccount5.Number_of_Open_Cases__c);  
    }   
}