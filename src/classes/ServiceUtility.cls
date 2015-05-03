public class ServiceUtility{
public static List<Service_Field_Logic__c> fieldsAvailable;
public static Set<String> selectedFields;
public static Set<String> requiredFieldSet;

public Set<String> availFieldset;

	// Call this method to get the Fields to be rendered for a given Service Request
	public Set<String> fieldsToRender(ID serviceFormId){
		fieldsAvailable = new List<Service_Field_Logic__c>();
		selectedFields = new set<String>();

		Service__c serviceForm = [SELECT Product__c,Sub_Product__c,Service_Request__c,Current_Step__c,One_N_Done__c FROM Service__c WHERE id = :serviceFormId];
		fieldsAvaliableList(serviceForm.Product__c,serviceForm.Sub_Product__c,serviceForm.Service_Request__c,serviceForm.Current_Step__c);

		selectedFieldsSet(fieldsAvailable);

		return selectedFields;
	}

	public void selectedFieldsSet(List<Service_Field_Logic__c> fls){
		for(Service_Field_Logic__c fl : fls){
			String s = fl.Field_Name__c;
			selectedFields.add(s);
		}
	}

	public void fieldsAvaliableList(String Product, String SubProduct, String ServiceRequestType, String ActiveStep){
		//if(Product != null && SubProduct != null && ServiceRequestType != null && ActiveStep != null){
			/*fieldsAvailable = [SELECT Field_Name__c FROM Service_Field_Logic__c WHERE Sub_Product__c=:SubProduct AND Service_Request__c=:ServiceRequestType AND Step_Number__c=:ActiveStep AND IsDisplayed__c=true];*/
			fieldsAvailable = [SELECT Field_Name__c FROM Service_Field_Logic__c WHERE Service_Request__c=:ServiceRequestType AND Step_Number__c=:ActiveStep AND IsDisplayed__c=true];
		//}
	}

	public Set<String> retfieldstoExternalCall(String requestName, String currentStep, Boolean giveAllFields){

		availFieldset = new Set<String>();
		List<Service_Field_Logic__c> serviceFieldList = new List<Service_Field_Logic__c>();
		if(giveAllFields == true){	
			serviceFieldList = [SELECT Field_Name__c FROM Service_Field_Logic__c WHERE Service_Request__c=:requestName AND IsDisplayed__c=true];
		} else {
			serviceFieldList = [SELECT Field_Name__c FROM Service_Field_Logic__c WHERE Service_Request__c=:requestName AND Step_Number__c=:currentStep AND IsDisplayed__c=true];
		}
		for(Service_Field_Logic__c sfl : serviceFieldList){
			String st = sfl.Field_Name__c;
			availFieldset.add(st);
		}

		return availFieldset;
	}

	//Call this method to get the Required Fields for a given Service Request
	public Set<String> requiredFields(ID serviceFormId){
		fieldsAvailable = new List<Service_Field_Logic__c>();
		requiredFieldSet = new Set<String>();

		Service__c serviceForm = [SELECT Product__c,Sub_Product__c,Service_Request__c,Current_Step__c,One_N_Done__c FROM Service__c WHERE id = :serviceFormId];
		reqFieldsAvaliableList(serviceForm.Product__c,serviceForm.Sub_Product__c,serviceForm.Service_Request__c,serviceForm.Current_Step__c);

		selectedReqFieldsSet(fieldsAvailable);

		return requiredFieldSet;
	}

	public void selectedReqFieldsSet(List<Service_Field_Logic__c> fls){
		for(Service_Field_Logic__c fl : fls){
			String s = fl.Field_Name__c;
			requiredFieldSet.add(s);
		}
	}

	public void reqFieldsAvaliableList(String Product, String SubProduct, String ServiceRequestType, String ActiveStep){
		//if(Product != null && SubProduct != null && ServiceRequestType != null && ActiveStep != null){
			/*fieldsAvailable = [SELECT Field_Name__c FROM Service_Field_Logic__c WHERE Sub_Product__c=:SubProduct AND Service_Request__c=:ServiceRequestType AND Step_Number__c=:ActiveStep AND IsRequired__c=true];*/
			fieldsAvailable = [SELECT Field_Name__c FROM Service_Field_Logic__c WHERE Service_Request__c=:ServiceRequestType AND Step_Number__c=:ActiveStep AND IsRequired__c=true];
		//}
	}

    public static sObject setData(Map<String,String> appData, sObject obj) {
        String fieldName = '';
        System.debug('appData:' + appData);
        try {
            Map<String, Schema.SObjectField>fieldMap = obj.getSobjectType().getDescribe().fields.getMap();
            String fieldLabel = null;
            Schema.DisplayType fielddataType = null;
            for (String fn : appData.keySet()) {
                fieldName = fn;
                if (fieldMap.get(fn) != null) {
                    fielddataType = fieldMap.get(fn).getDescribe().getType();
                    if (fielddataType != null && fielddataType == Schema.DisplayType.Boolean) {
                        obj.put(fn, Boolean.valueOf(appData.get(fn)));
                    } else if (fielddataType != null && fielddataType == Schema.DisplayType.Currency) {
                        String i = appData.get(fn), s = null;
                        i = i.replace(',', '');
                        if (i != null && i.trim() != '') {
                            s = (Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
                            s = s.substring(0,s.length()-1);
                            s = s.replace(',', '');
                            obj.put(fn, Decimal.valueOf(s));
                        }
                    } else if (fielddataType != null && fielddataType == Schema.DisplayType.Double) {
                        String val = appData.get(fn);
                        if (val != '') {
                            obj.put(fn, Double.valueOf(appData.get(fn)));
                        }
                    } else if (fielddataType != null && fielddataType == Schema.DisplayType.DateTime){
                        String dt = appData.get(fn);
                        if (dt != null & dt != '') {
                            obj.put(fn, DateTime.valueOf(appData.get(fn)));
                        }
                    } else {
                        obj.put(fn, String.escapeSingleQuotes(String.valueOf(appData.get(fn))));
                    }
                }
            }
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            appData.put('debug-server-errors', e.getMessage() + '; field:' + fieldName);
            appData.put('server-errors-stack-trace', e.getStackTraceString()); 
        }
        
        return obj;
    }

    public static Map<String,String> getServerMessages(Map<String,String> data) {
        List<Apexpages.Message> msgsList = ApexPages.getMessages();
        String msgs = '';
        for (Apexpages.Message m: msgsList) {
            msgs += m.getDetail() + '\n';
        }
        if (msgs != '') {
            data.put('server-errors', msgs);
        }
        return data;
	}

    public static Map<String,sObject> getServerMessages(Map<String,sObject> data) {
        List<Apexpages.Message> msgsList = ApexPages.getMessages();
        Note n = new Note();
        String msgs = '';
        for (Apexpages.Message m: msgsList) {
            msgs += m.getDetail() + '\n';
        }
        if (msgs != '') {
        	n.Body = msgs;
            data.put('server-errors', (sObject)n);
        }
        return data;
	}

    public static sObject getMessageObject(String msg) {
        Note n = new Note();
        n.Body = msg;
        return (sObject)n;
    }

    public static Map<String,sObject> getServiceUserToken(Map<String,sObject> data, String ut) {
      
        Note n = new Note();
        if(ut != null){
            n.Body = ut;
            data.put('serviceUt', (sObject)n);
        }
        return data;
    }

    public static Map<String,String> getData(Map<String,String> appData, sObject obj, Boolean buildPickListData) {
        if (obj != null) {
            // Serialize our Sobject into JSON
            String s = JSON.serialize(obj);
            // Deserialize it back into a key/value map
            Map<String,Object> obj1 = (Map<String,Object>) JSON.deserializeUntyped(s);
            // Build a set containing the fields present on our SObject
            Set<String> fieldsPresent = obj1.keyset().clone();
            // Salesforce always adds an extra 'attributes' key to SObjects
            // when you do JSON stuff, so let's get rid of that.
            fieldsPresent.remove('attributes');
            //System.debug(fieldsPresent);
            for (String fn : fieldsPresent) {
                try {
                    //appData.put(obj.getSobjectType() + '.' + fn.toLowerCase(), String.valueOf(obj.get(fn)));
                    appData.put(fn, String.valueOf(obj.get(fn)));
                } catch (Exception e) {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'getData(): Field: ' + fn  + ':' + e.getMessage()));      
                    //appData.put(obj.getSobjectType() + '.' + fn, e.getMessage());    
                    //appData.put('debug-server-errors', e.getMessage());
                    //appData.put('server-errors-stack-trace', e.getStackTraceString());
                }
            }
        }
 
        return appData;
    }

    public static String getPickListFields(sObject obj) {
    	String jsonString = '';
        Schema.DisplayType fielddataType = null;
        List<Schema.PicklistEntry> pick_list_values = null;
        List<String> options = null;
        if (obj != null) {
			JSONGenerator generator = JSON.createGenerator(true);
            Map<String, Schema.SObjectField>fieldMap = obj.getSobjectType().getDescribe().fields.getMap();
            jsonString += '\nSelectFields = ';
            generator.writeStartObject();
            for (String fn : fieldMap.keySet()) {
                fielddataType = fieldMap.get(fn).getDescribe().getType();
                try {
                    if (fielddataType == Schema.DisplayType.Picklist) {
                        pick_list_values = fieldMap.get(fn).getDescribe().getPickListValues();
                        system.debug('picklist values are:'+pick_list_values);
                        options = new List<String>();
                        if (pick_list_values != null && pick_list_values.size() > 0) {
                            for (Schema.PicklistEntry a : pick_list_values) {options.add(a.getLabel() + '_' + a.getValue());}
                            generator.writeStringField(fn, String.join(options, ';'));
                        }
                    }
                } catch (Exception e) {}
            }

            generator.writeEndObject();
            jsonString += generator.getAsString() + ';\n';
        }
 
        return jsonString;
    }
}