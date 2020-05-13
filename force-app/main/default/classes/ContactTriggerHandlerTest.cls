@isTest
public class ContactTriggerHandlerTest {
    @isTest
    public static void whenNewContactInserted() {
        
        // Create test Account record 
        Account testAcct1 = new Account (
            Name = 'Test Account1'
        );
        insert testAcct1;
        
        // Create test Contact record
        Contact testContact = new Contact (
            LastName = 'TestPerson',
            AccountId = testAcct1.Id
		);
      	insert testContact;
        
        Account testAccount = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAcct1.Id];
        
        System.assertEquals(1, testAccount.Number_of_Contacts__c);       
    }
    
    @isTest
    public static void whenContactIsUpdated() {
        
        // Create test Account record 
        Account testAcct2 = new Account (
            Name = 'Test Account2'
        );
        insert testAcct2;
        
        // Create test Contact record
        Contact testContact2 = new Contact (
            LastName = 'TestPerson2',
            AccountId = testAcct2.Id
		);
        insert testContact2;
        
        // Create another test Account record
        Account testAcct3 = new Account (
        	Name = 'Test Account3'
        );
        insert testAcct3;
        
        //Update testContact2 to another Account
        testContact2.AccountId = testAcct3.Id;
        update testContact2;
        
        Account testAccount2 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAcct2.Id];
        Account testAccount3 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAcct3.Id];
        
        System.assertEquals(0, testAccount2.Number_of_Contacts__c);
        System.assertEquals(1, testAccount3.Number_of_Contacts__c);      
    }
    
    @isTest
    public static void whenContactIsDeleted() {
    	
         // Create test Account record 
        Account testAcct = new Account (
            Name = 'Test Account'
        );
        insert testAcct;
        
        // Create test Contact record
        Contact testContact3 = new Contact (
            LastName = 'TestPerson3',
            AccountId = testAcct.Id
		);
        insert testContact3;
        delete testContact3;
        
        Account testAccount = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAcct.Id];
        
		System.assertEquals(0, testAccount.Number_of_Contacts__c);      
    }
	
}