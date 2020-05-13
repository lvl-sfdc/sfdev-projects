public class OpportunityTriggerHandler {
    public static void  validateStageByContactRoles(List<Opportunity> oppsList, Map<Id, Opportunity> newOppMap, Map<Id, Opportunity> oldOppMap) {
        // Create a list of Opportunity Contact Roles for the relevant Opportunities 
    	// Trigger.newMap.keySet() returns all the key values of the map of all the records in the trigger, in this case all the Opp record Ids
    	List<OpportunityContactRole> ocrList = [SELECT Id, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId IN :newOppMap.keySet()];
    
    	// Create a map of the Lists of Opportunity Contact Roles by Opportunity Id
    	Map<Id, List<OpportunityContactRole>> oppIdOcrMap = new Map<Id, List<OpportunityContactRole>>();

    	// Put all OpportunityContactRole OpportunityId's (keys) and each's List of OpportunitContactRoles (values) into the oppIdOcrMap
    	for(OpportunityContactRole ocr : ocrList) {
        
        	//oppIdOcrMap.put(ocr.OpportunityId, ocr);
        	List<OpportunityContactRole> ocrs = oppIdOcrMap.get(ocr.OpportunityId);
        
            if(ocrs == null) {
                ocrs = new List<OpportunityContactRole>();
                oppIdOcrMap.put(ocr.OpportunityId, ocrs);
            }
            
            //oppIdOcrMap.get(ocr.OpportunityId).add(ocr); 
            ocrs.add(ocr);  
        }
    	System.debug('oppIdOcrMap: ' + oppIdOcrMap);
    
        // query the Custom Metadata Type Mappings 
        // future optimization - only query mappings according to oppties that are updated, loop thru trigger.new list of stageNames, in where clause
        List<Stage_OCR_Mapping__mdt> ocrMappingList = [SELECT Stage_value__c, Required_OCR__c FROM Stage_OCR_Mapping__mdt];
        System.debug('ocrMappingList: ' + ocrMappingList);
        System.debug('ocrMappingList.size(): ' + ocrMappingList.size());
        
        Map<String, String> ocrMap = new Map<String, String>();
        
        // Iterate through the Stage-OCR mappings, putting each's Stage value (key) and Required OCR (value) into a map to access later
        for(Stage_OCR_Mapping__mdt ocrMapping : ocrMappingList) {
            ocrMap.put(ocrMapping.Stage_value__c, ocrMapping.Required_OCR__c);
        }
        System.debug('ocrMap: ' + ocrMap);
        
        for(Opportunity opp : oppsList) {
            
            // If Opportunity Stage value is changed
            if(oldOppMap.get(opp.Id).StageName != opp.StageName) {  
                System.debug('Stage has changed!');
                if (ocrList.isEmpty() && ocrMap.containsKey(opp.StageName)) {
                    opp.addError('You must add the required Contact Roles in order to move the Opportunity to this Stage.');
                } else {
                    // Get the required OCRs based on the StageName of the Opportunity, save into a String variable
                    String requiredOcrs = ocrMap.get(opp.StageName);
                    if(requiredOcrs != null) {
                        
                        // Split the comma-separated values of the Required_OCR MTD field, save into a List
                        List<String> requiredOcrsList = requiredOcrs.split(',');
                        System.debug('requiredOcrsList: ' + requiredOcrsList);
                        
                        // Create a list of the existing OCRs of the Opportunity being updated
                        List<OpportunityContactRole> existingOcrs = oppIdOcrMap.get(opp.Id);
                        System.debug('existingOcrs: ' + existingOcrs);
                        
                        // Create a list of existing OCR.Roles
                        List<String> existingRoles = new List<String>();                                 
                        for(OpportunityContactRole existingOcr : existingOcrs){
                            existingRoles.add(existingOcr.role);
                            System.debug('existingRoles: ' + existingRoles);
                        }                    
                        
                        //Compare the lists - Check to see if the existing Roles contains each of the required role values
                        for(String requiredRole : requiredOcrsList) {
                            if (existingRoles.isEmpty() || !existingRoles.contains(requiredRole)){
                                opp.addError('You must add the required Contact Roles in order to move the Opportunity to this Stage.');
                            }
                        } 
                    }
                }                
            }
        }
    }
}