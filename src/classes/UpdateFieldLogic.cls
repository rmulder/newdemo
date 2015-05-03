public with sharing class UpdateFieldLogic{
    public void UpdateLogic() {
        List<Field_Logic_New__c> list_fl = new List<Field_Logic_New__c>();
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new String[]{'Application__c', 'Application2__c', 'Identity_Information__c','Employment_Information__c','About_Account__c'});
        Map<String,String> mp = new Map<String,String>();
        Id rtid = Schema.SObjectType.Field_Logic_New__c.getRecordTypeInfosByName().get('Field Details').getRecordTypeId();

        for(Schema.DescribeSobjectResult res : results) {
            
            Map<String, Schema.SObjectField> objectFields = res.fields.getMap();
            for(String fn : objectFields.keySet()){
                Field_Logic_New__c fl = new Field_Logic_New__c();
                Schema.DescribeFieldResult dr = objectFields.get(fn).getDescribe();
                if(dr.getType() == Schema.DisplayType.String) {
                    fl.Datatype__c = String.valueOf(dr.getType()) + '(' + dr.getLength() + ')'; 
                    fl.Supported_Datatype__c = 'input'; 
                } 
                else if(dr.getType() == Schema.DisplayType.TextArea) {
                    fl.Datatype__c = String.valueOf(dr.getType()) + '(' + dr.getLength() + ')'; 
                    fl.Supported_Datatype__c = 'TextArea'; 
                }                                      
                else if(dr.getType() == Schema.DisplayType.Integer) {
                    fl.Datatype__c = 'Number' + '(' + dr.getDigits() + ', 0)'; 
                    fl.Supported_Datatype__c = 'input'; 
                }

                else if(dr.getType() == Schema.DisplayType.Double) {
                    fl.Datatype__c = 'Number' + '(' + (dr.getPrecision() - dr.getScale()) + ', ' + dr.getScale() + ')'; 
                    fl.Supported_Datatype__c = 'input';                   
                }
                else if(dr.getType() == Schema.DisplayType.Percent || dr.getType() == Schema.DisplayType.Currency) {
                    fl.Datatype__c = String.valueOf(dr.getType()) + '(' + (dr.getPrecision() - dr.getScale()) + ', ' + dr.getScale() + ')';
                    fl.Supported_Datatype__c = 'input'; 
                }
                else if(dr.getType() == Schema.DisplayType.Picklist) {
                    fl.Datatype__c = String.valueOf(dr.getType());
                    fl.Supported_Datatype__c = 'input';
                    List<Schema.PicklistEntry> picklist_fl = dr.getPicklistValues();
                    fl.Picklist_Values__c = picklist_fl[0].getValue();
                    for(integer i=1;i<picklist_fl.size();i++){
                        fl.Picklist_Values__c = fl.Picklist_Values__c + ';' + picklist_fl[i].getValue();
                    }
                }
                else {
                    fl.Datatype__c = String.valueOf(dr.getType());
                    if(fl.Datatype__c == 'Boolean') {
                        fl.Supported_Datatype__c = 'Checkbox';
                    } else {
                        fl.Supported_Datatype__c = 'input';
                    }
                }
                    
                fl.Field_Name__c = dr.getName();
                fl.sObject__c = res.getName();
                fl.RecordTypeId = rtid;
                list_fl.add(fl);    
               
            }
          
        }
        
        insert list_fl;


        /*Updating lables for Field Details record type in Field Logic*/

        /*
        List<Field_Logic_New__c> fl = [Select Label__c,Field_Name__c from Field_Logic_New__c where RecordTypeId = '012170000004InzAAE'];
        List<Field_Logic_New__c> fl2 = [Select Label__c,Field_Name__c from Field_Logic_New__c where RecordTypeId = '012170000004QeCAAU'];
        List<Field_Logic_New__c> update_list = new List<Field_Logic_New__c>();
        Set<string> s = new Set<String>();
        Map<String,String> m = new Map<String,String>();
        for(integer i=0;i<fl.size();i++){
            s.add(fl[i].Field_Name__c + ';' + fl[i].Label__c);        
        }
        for(String sn: s){
            m.put(sn.split(';').get(0),sn.split(';').get(1));
        }
        for(integer i = 0;i<fl2.size();i++){
            if(m.containsKey(fl2[i].Field_Name__c)){
                fl2[i].Label__c = m.get(fl2[i].Field_Name__c);
                update_list.add(fl2[i]);
            }
        }
        update update_list; 
        */
    }       
}