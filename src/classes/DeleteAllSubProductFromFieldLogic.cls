global class DeleteAllSubProductFromFieldLogic implements Database.Batchable<sObject> {
	
	String query;
	
	global DeleteAllSubProductFromFieldLogic() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT id,Product__c,Sub_Products__c FROM Field_Logic_New__c WHERE Sub_Products__c=\'All\'' ;
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		List<Field_Logic_New__c> delFieldLogiclist = new List<Field_Logic_New__c>();
   		for(sObject s : scope){
   			Field_Logic_New__c fl = (Field_Logic_New__c)s;
   			delFieldLogiclist.add(fl);
   		}
		delete delFieldLogiclist;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}