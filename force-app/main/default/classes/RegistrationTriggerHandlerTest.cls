@isTest
public class RegistrationTriggerHandlerTest {
	
    @isTest
    public static void whenRegistrationIsDeleted() {
        
        Event__c event = new Event__c(
        	Name = 'Test Event'
        );  		
     	insert event;
        
        Registration__c reg = new Registration__c(
        	First_Name__c = 'Fname',
        	Last_Name__c = 'Lname',
            Email__c = 'laralazaro@gmail.com',
            Event__c = event.Id
        );
        insert reg;
        delete reg;
    }    
}