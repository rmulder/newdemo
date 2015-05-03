global class UpdateFieldlogicLabels implements Database.Batchable<sObject> {
	
	String query;
	
	global UpdateFieldlogicLabels() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT id, Field_Name__c, Label__c FROM Field_Logic_New__c';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		Map<String,String> data = new Map<String, String>();
   		Application__c app = new Application__c();
        Application2__c app2 = new Application2__c();
        Employment_Information__c emp = new Employment_Information__c();
        Identity_Information__c iden = new Identity_Information__c();
        About_Account__c acc = new About_Account__c();
        Map<String, Schema.SObjectField>appFieldMap = app.getSobjectType().getDescribe().fields.getMap();
        Map<String, Schema.SObjectField>app2FieldMap = app2.getSobjectType().getDescribe().fields.getMap();
        Map<String, Schema.SObjectField>empFieldMap = emp.getSobjectType().getDescribe().fields.getMap();
        Map<String, Schema.SObjectField>idenFieldMap = iden.getSobjectType().getDescribe().fields.getMap();
        Map<String, Schema.SObjectField>accFieldMap = acc.getSobjectType().getDescribe().fields.getMap();
        Schema.DisplayType fielddataType = null;
        
        Set<String> fieldsSet;
        Set<String> allFieldsSet = new Set<String>();
        String label;
        String fieldName;
        try {
            for (String fn : appFieldMap.keySet()) {
                allFieldsSet.add(fn);
                //fielddataType = appFieldMap.get(fn).getDescribe().getType();
                //data.put('FieldType.' + fn, String.valueOf(appFieldMap.get(fn).getDescribe().getType()));
                data.put('FieldLabel.' + fn, String.valueOf(appFieldMap.get(fn).getDescribe().getLabel()));
                /*
                fieldList = [SELECT Label__c FROM Field_Logic_New__c WHERE Field_Name__c =:fn];
                fieldsSet = new Set<String>();
                for (Field_Logic_New__c fl : fieldList) {
                    fieldsSet.add(fl.Label__c);
                }
                data.put('FieldLogicLabels.' + fn, String.join(new List<String>(fieldsSet), ',').toLowerCase());
                */
            }
            for (String fn : app2FieldMap.keySet()) {
                allFieldsSet.add(fn);
                data.put('FieldLabel.' + fn, String.valueOf(app2FieldMap.get(fn).getDescribe().getLabel()));
            }
            for (String fn : empFieldMap.keySet()) {
                allFieldsSet.add(fn);
                data.put('FieldLabel.' + fn, String.valueOf(empFieldMap.get(fn).getDescribe().getLabel()));
            }
            for (String fn : idenFieldMap.keySet()) {
                allFieldsSet.add(fn);
                data.put('FieldLabel.' + fn, String.valueOf(idenFieldMap.get(fn).getDescribe().getLabel()));
            }
            for (String fn : accFieldMap.keySet()) {
                allFieldsSet.add(fn);
                data.put('FieldLabel.' + fn, String.valueOf(accFieldMap.get(fn).getDescribe().getLabel()));
            }
            //fieldList = [SELECT id, Field_Name__c, Label__c FROM Field_Logic_New__c LIMIT 50000];
            List<Field_Logic_New__c> fieldList = (List<Field_Logic_New__c>)scope;
            Map<String, Schema.SObjectField>fieldMap = fieldList.getSobjectType().getDescribe().fields.getMap();
            List<Schema.PicklistEntry> pick_list_values = fieldMap.get('Field_Name__c').getDescribe().getPickListValues();
            Map<String,String> fmap = new Map<String,String>();
            //Schema.PicklistEntry spe = new Schema.PicklistEntry();
            
            for (Schema.PicklistEntry pe : pick_list_values) {
                fmap.put(pe.getValue().toLowerCase(), pe.getValue());
            }
            for (String s1 : allFieldsSet) {
                if (!s1.toLowerCase().contains('__c')) {
                    allFieldsSet.remove(s1);
                }
            }
            for (String s : allFieldsSet) {
                if (!fmap.containsKey(s.toLowerCase())) {
                    data.put('MissingField.' + s, s);
 
                    /*
                    label = data.get('FieldLabel.' + s);
                    if (label != null && label != '') {
                        Field_Logic_New__c fl = new Field_Logic_New__c();
                        fl.Label__c = label;
                        fl.Field_Name__c = s;
                        fl.IsDisplayed__c = true;
                        fl.IsRequired__c = true;
                        fl.Product__c = 'All';
                        fl.Sub_Products__c = 'All';
                        //if (Field_Logic_New__c.SObjectType.getDescribe().isCreateable()) {insert fl;}    
                    }*/
                }
            }


            fieldsSet = new Set<String>();
            List<Field_Logic_New__c> fl2 = new List<Field_Logic_New__c>();
            for (Field_Logic_New__c fl : fieldList) {
                data.put('FieldLogic.' + fl.Field_Name__c, fl.Label__c);
                fieldName = fl.Field_Name__c.toLowerCase();
                fieldsSet.add(fieldName);
                label = data.get('FieldLabel.' + fieldName);
                if (label != null && label != '') {
                    //data.put('Field Label exists for:' + fl.Field_Name__c, label);
                    fl.Label__c = label;
                    fl2.add(fl);
                } else {
                    data.put('MissingFieldLabel.' + fieldName, label);
                }
            }

            /*List<String> options = new List<String>();
            if (pick_list_values != null && pick_list_values.size() > 0) {
                for (Schema.PicklistEntry a : pick_list_values) {options.add(a.getLabel());}
                data.put('Field_Name__c', String.join(options, ','));
            }*/

            if (Field_Logic_New__c.SObjectType.getDescribe().isUpdateable()) {
                //data.put('Count of Fields', String.valueOf(fl2.size()));
                update fl2;
            }
            data.put('FieldLogicFields', String.join(new List<String>(fieldsSet), ',').toLowerCase());
            data.put('debug-server-errors', 'Called updateData()');
        } catch(Exception e) {
            system.debug('The error is ' + e.getMessage());
            data.put('debug-server-errors', e.getMessage());
            data.put('server-errors-stack-trace', e.getStackTraceString());
        } 
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}