global class RemoveIsdisplayed implements Database.Batchable<sObject> {
	
	String query;
	
	global RemoveIsdisplayed() {
		
	}
	
	global string soql = 'Select Label__c,Field_Name__c,IsDisplayed__c,IsRequired__c,Product__c from Field_Logic_New__c where Product__c = \'Savings\' AND Label__c=\'%Other Income%\'' ;
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(soql);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try{ 	
		 	List<Field_Logic_New__c> listOfApps = (List<Field_Logic_New__c>)scope;
            List<Field_Logic_New__c> updateApps = new List<Field_Logic_New__c>();
            for(integer i=0;i<listOfApps.size();i++){
                Field_Logic_New__c fln = listOfApps[i];
                if(fln.Product__c != NULL && fln.Product__c.contains('Savings') && fln.Label__c == 'Other Income3 $'){
                    fln.IsDisplayed__c = false;
                    fln.IsRequired__c = false;
                }
                updateApps.add(fln);             
               
            }
            try{            
                Database.SaveResult[] SR = Database.update(updateApps );
                
            }catch(exception e1){
                system.debug('The exception is caused in the line number: '+ e1.getLineNumber() + 'and the message is: '+ e1.getMessage());
            }
        }catch(exception e2){
            system.debug('The exception is caused in the line number: '+ e2.getLineNumber() + 'and the message is: '+ e2.getMessage());
        }        

	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}