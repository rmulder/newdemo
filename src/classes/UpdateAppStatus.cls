global class UpdateAppStatus implements Database.Batchable<sObject> {
	
	String query;
	
	global UpdateAppStatus() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query= 'SELECT id,Application_Status__c,Days_Elapsed__c,User_Token_Expires__c,User_Token_has_Expired__c FROM Application__c WHERE (Application_Status__c=\'Open\' OR Application_Status__c=\'Save for Later\') AND (Application_Status__c != null OR Application_Status__c != \'\') ';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<Application__c> applicationsToBeUpdated=new List<Application__c>();
   		Integer daysLimit = 0;
   		if( Integer.valueOf(Application_Configuration__c.getInstance().Days_to_expire_app__c) != null ) {
   			daysLimit = Integer.valueOf(Application_Configuration__c.getInstance().Days_to_expire_app__c);   			
   		}
   		for(sObject s : scope){
   			if( s != null) { 
	   			Application__c app=(Application__c)s;
	   			Integer days = 0;
	   			if ( app.Days_Elapsed__c != null ) {
	   				days = Integer.valueOf(app.Days_Elapsed__c);
	   			}	
	   			if( app.Application_Status__c == 'Open' && app.User_Token_has_Expired__c == true ) {
	   				app.Application_Status__c = 'Abandoned';
	   				applicationsToBeUpdated.add(app);
	   			} else if( app.Application_Status__c == 'Save for Later' &&  days > daysLimit && app.User_Token_has_Expired__c == true ) {
	   				app.Application_Status__c = 'Abandoned';
	   				applicationsToBeUpdated.add(app);
	   			}
	   		}	
   		}
   		update applicationsToBeUpdated;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}