@isTest
public class OpportunityTriggerHandlerTest {
	@isTest  
    public static void whenRequiredOcrsDontExist() {
        
        //create test Account
        Account testAcct = new Account (
            Name = 'Test Account1'
        );
        insert testAcct;
        
        //create Test Opportunity
        Opportunity opp = new Opportunity (
            AccountId = testAcct.Id,
        	Name = 'Test Oppty1',
        	StageName = 'Prospecting',
        	CloseDate = Date.today()
        );
        insert opp;
       
        //Opportunity opp1 = [SELECT Id, StageName FROM Opportunity WHERE Id =:opp.id];
   
        opp.StageName = 'Value Proposition';
        
        try {
            update opp;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('You must add the required Contact Roles in order to move the Opportunity to this Stage.');
			System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    @isTest
    public static void whenRequiredOcrsExist() {
        //create test Account
        Account testAcct2 = new Account (
            Name = 'Test Account2'
        );
        insert testAcct2;
        
        //create Test Opportunity
        Opportunity opp2 = new Opportunity (
            AccountId = testAcct2.Id,
        	Name = 'Test Oppty2',
        	StageName = 'Prospecting',
        	CloseDate = Date.today()
        );
        insert opp2;
        
        Contact testContact = new Contact (
            LastName='TestPerson',
            AccountId = testAcct2.Id
		);
      	insert testContact;
        
        OpportunityContactRole ocr = New OpportunityContactRole (
            OpportunityId = opp2.Id,
            ContactId = testContact.Id,
            Role = 'Business User'
        );
        insert ocr;
        
        opp2.StageName = 'Value Proposition';
        
        update opp2;
  
        System.assertEquals('Value Proposition', opp2.StageName);     
    }
    
    @isTest
    public static void testBulkRecords() {
        
    	// Create test Account
        Account testAcct = new Account (
            Name = 'Test Account'
        );
        insert testAcct;
        
        // Create and insert 200 Opportunity Records
        List<Opportunity> oppsList = new List<Opportunity>();
        
        for (Integer i = 0; i < 200; i++) {
            Opportunity opp = new Opportunity();
            opp.AccountId = testAcct.Id;
            opp.Name = 'Test Opportunity'+ i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today(); 
            oppsList.add(opp);     
        }
        insert oppsList;
        System.debug('****oppsList.size(): ' + oppsList.size());
        
        //List<Opportunity> List1 = [SELECT Id, AccountId, Name, StageName, CloseDate FROM Opportunity WHERE Id IN :oppsList LIMIT 100 OFFSET 0];
        //System.debug('****List1: ' + List1);
        
        //List<Opportunity> List2 = [SELECT Id, AccountId, Name, StageName, CloseDate FROM Opportunity WHERE Id IN :oppsList LIMIT 50 OFFSET 100];
        //System.debug('****List2: ' + List2);
		
        //List<Opportunity> List3 = [SELECT Id, AccountId, Name, StageName, CloseDate FROM Opportunity WHERE Id IN :oppsList LIMIT 50 OFFSET 150];        
        //System.debug('****List3: ' + List3);
        
        
        // Create test Contact Record
        Contact testContact = new Contact (
            LastName='TestPerson',
            AccountId = testAcct.Id
		);
      	insert testContact;
        
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        for(Integer i = 0; i < 100; i++) {
            OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = oppsList.get(i).Id;
            System.debug('****ocr.OpportunityId: ' + ocr.OpportunityId);
            ocr.ContactId = testContact.Id;
            ocr.Role = 'Business User';
            ocrList.add(ocr);
        }
        insert ocrList;
        System.debug('****ocrList.size(): ' + ocrList.size());
        
        
        System.debug('ocrList: ' + ocrList);
        System.debug('ocrList.get(0).OpportunityId: ' + ocrList.get(0).OpportunityId);
        
        update oppsList;
        
        for(Integer i = 0; i < 100; i++) {
            oppsList.get(i).StageName = 'Value Proposition';
        }
        System.debug('****oppsList.get(0).StageName: ' + oppsList.get(0).StageName);
        
        for(Integer i = 100; i < 150; i++) {
            //oppsList.get(i).StageName = 'Proposal Price/Quote';
        System.debug('****oppsList.get(100).StageName: ' + oppsList.get(100).StageName);
        }
        
        for(Integer i = 150; i < 200; i++) {
            oppsList.get(i).StageName = 'Closed Won';
        }
        
        List<Opportunity> listErroredOpps = [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppsList AND StageName = 'Proposal Price/Quote'];
        
        try {
        	update oppsList;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('You must add the required Contact Roles in order to move the Opportunity to this Stage.');
			System.AssertEquals(expectedExceptionThrown, true);
            System.assertEquals(50, listErroredOpps.size());
        }
        
        // Create Opportunity Contact Role for first 100 records, using testContat
        
        //for (Opportunity opp : List1){
        //    OpportunityContactRole ocr = New OpportunityContactRole();
        //    ocr.OpportunityId = opp.Id;
        //    ocr.ContactId = testContact.Id;
        //    ocr.Role = 'Business User';
        //    System.debug('****ocr: ' + ocr);
        //    insert ocr;
        //}  
        //update List1;
        //System.debug('****List1[0].StageName: ' + List1[0].StageName);
        
        // Update first 100 Opportunities to Value Proposition Stage
        //for(Opportunity opp : List1) {
        //    opp.StageName = 'Value Proposition';
        //}
        //update List1;
        //System.debug('****List1[0].StageName: ' + List1[0].StageName);
        
        // Update the next 50 Opportunities to Proposal Price/Quote Stage
        //for(Opportunity opp : List2) {
        //    opp.StageName = 'Proposal Price/Quote';
        //}
       
        //update List2;
        //System.debug('****List2[0].StageName: ' + List2[0].StageName);
        
        // Update the last 50 Opportunities to Closed Won Stage
        //for(Opportunity opp : List3) {
        //    opp.StageName = 'Closed Won';
        //} 
        //update List3;
        //System.debug('****List3[0].StageName: ' + List3[0].StageName);
    }
}