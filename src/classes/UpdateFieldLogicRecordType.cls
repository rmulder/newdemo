global class UpdateFieldLogicRecordType implements Database.Batchable<sObject> {
	
	String query;
	
	global UpdateFieldLogicRecordType() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT id,RecordTypeId,Label_Name__c,Field_Name__c FROM Field_Logic_New__c';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<Field_Logic_New__c> fieldLogicToBeUpdated = new List<Field_Logic_New__c>();
		for(sObject s : scope){
			if(s != null){
				Field_Logic_New__c fl = (Field_Logic_New__c)s;
				if(fl.Label_Name__c != null){
					Id pageLabelRecordTypeId = Schema.SObjectType.Field_Logic_New__c.getRecordTypeInfosByName().get('Page Labels').getRecordTypeId();
					fl.RecordTypeId = pageLabelRecordTypeId;
					fieldLogicToBeUpdated.add(fl);
				} else {
					Id fieldLogicRecordTypeId = Schema.SObjectType.Field_Logic_New__c.getRecordTypeInfosByName().get('Field Logic').getRecordTypeId();
					fl.RecordTypeId = fieldLogicRecordTypeId;
					fieldLogicToBeUpdated.add(fl);
				}
			}
		}
		Update fieldLogicToBeUpdated;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}