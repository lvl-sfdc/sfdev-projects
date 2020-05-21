public without sharing class EventRegistrationPageController {
    public String selectedEventId {get;set;}
    public Event__c eventRecord {get;set;}   
    //public Registration__c registration {get;set;}
    public Registration__c registration { 
        get {
        	if(registration == null) {
            	registration = new Registration__c();
            } return registration;
        }
        set;
    }

    public List<SelectOption> getOptions() {
    	List<SelectOption> eventOptionsList = new List<SelectOption>();
            
        List<Event__c> eventsList = [SELECT Id, Name, Price__c FROM Event__c]; 
		eventOptionsList.add(new SelectOption('','--Select an Event--'));
        
        for(Event__c event: eventsList) {
            eventOptionsList.add(new SelectOption(event.Id, event.Name));  
        }     
        return eventOptionsList;     
    }
    
    public EventRegistrationPageController() {
        selectedEventId = '';   
    }
    
    public pageReference updatePrice() {
        System.debug('****selectedEventId: ' + selectedEventId);
        if(selectedEventId!=null&&selectedEventId!=''){
        	eventRecord = [SELECT Id, Name, Price__c FROM Event__c WHERE Id =:selectedEventId];
            System.debug('****eventRecord: ' + eventRecord);
        }
        else eventRecord = null;
        return null;
    }
    // can cache the result of the query
    //set an instance variable that would hold eventLIst query in line 17
    
    public void saveForm(){
        Registration__c reg = new Registration__c();
        reg.Event__c = selectedEventId;
        reg.First_Name__c = registration.First_Name__c;
        reg.Last_Name__c = registration.Last_Name__c;
        reg.Email__c = registration.Email__c;
        reg.Address__c = registration.Address__c;
        reg.Registration_Date__c = Datetime.now();
        
        try {
            insert reg;
            System.debug('****reg: ' + reg);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Registration was saved successfully.'));
        } catch(DmlException e) {
 			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Registration was not saved. Please enter valid data.'));
		}
    }
    
}