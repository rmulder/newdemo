global class UpdateServiceStatus implements Database.Batchable<sObject> {
	
	String query;
	
	global UpdateServiceStatus() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query= 'SELECT id,Status__c,Days_Elapsed__c,User_Token_Expires__c,User_Token_has_Expired__c FROM Service WHERE (Status__c=\'Open\' OR Status__c=\'Save for Later\') AND (Status__c != null OR Status__c != \'\') ';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<Service__c> serviceToBeUpdated=new List<Service__c>();
   		Integer daysLimit = 0;
   		if( Integer.valueOf(Service_Configuration__c.getOrgDefaults().Days_to_expire__c) != null ) {
   			daysLimit = Integer.valueOf(Service_Configuration__c.getOrgDefaults().Days_to_expire__c);   			
   		}
   		for(sObject s : scope){
   			if( s != null) { 
	   			Service__c service=(Service__c)s;
	   			Integer days = 0;
	   			if ( service.Days_Elapsed__c != null ) {
	   				days = Integer.valueOf(service.Days_Elapsed__c);
	   			}	
				if( (service.Status__c == 'Save for Later' || service.Status__c == 'Open') &&  days > daysLimit && service.User_Token_has_Expired__c == true ) {
	   				service.Status__c = 'Closed-Expired';
	   				serviceToBeUpdated.add(service);
	   			}
	   		}	
   		}
   		update serviceToBeUpdated;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}