trigger UpdateFieldLabel on Field_Logic_New__c (before update, after update, before insert) {
    try{
        if(Trigger.isUpdate){
            if(trigger.isBefore){
                if(StaticClass.beforeCall()== null){
                    StaticClass.afterCall();
                    for(Field_Logic_New__c fl: Trigger.new){
                        if(fl.IsDisplayed__c == false){
                            fl.IsRequired__c = false;
                        }
                    }

                    //Creating A set having same labels
                    Set<String> fieldNames = new Set<String>();
                    Set<ID> fieldLogicIds = new Set<Id>();
                    for (Field_Logic_New__c fl : Trigger.new){
                        fieldNames.add(fl.Field_Name__c);
                        fieldLogicIds.add(fl.Id);
                    }

                    Map<String, List<Field_Logic_New__c>> mapfl = new Map<String, List<Field_Logic_New__c>>();
                    List<Field_Logic_New__c> dummyList ;
                    for(Field_Logic_New__c f : Trigger.new){
                        dummyList = new List<Field_Logic_New__c>();
                        for(Field_Logic_New__c fl : [Select id, Field_Name__c, Label__c, IsDisplayed__c, IsRequired__c From Field_Logic_New__c where Field_Name__c IN: fieldNames AND ID Not IN :fieldLogicIds LIMIT 10000]){
                            if(f.Field_Name__c == fl.Field_Name__c){
                                dummyList.add(fl);
                            }
                        }
                        if(dummyList.size()>0){
                            mapfl.put(f.Field_Name__c,dummyList);
                        }
                       
                    }

                    List<Field_Logic_New__c> recordstoBeUpdated = new List<Field_Logic_New__c>();
                    for(Field_Logic_New__c f : Trigger.new){
                        if(Trigger.oldMap.get(f.Id).Label__c != Trigger.newMap.get(f.Id).Label__c){
                            for(Field_Logic_New__c fl : mapfl.get(f.Field_Name__c)){
                                fl.Label__c = f.Label__c;
                                recordstoBeUpdated.add(fl);
                            }
                        }
                    }

                    try{    
                         update recordstoBeUpdated;
                         system.debug('Update records');
                    }catch(Exception ec){
                            system.debug('Error at line : ' +ec);
                    }
                }
            }else if(trigger.isAfter){
                String sessionId = UserInfo.getSessionId();
                MetadataUpdate.MetadataUpdate(sessionId);
                system.debug('Update meta data called :' + sessionId);
            } 
        } else if(Trigger.isInsert){
            if(Trigger.isbefore){
                //if(StaticClass.beforeCall()== null){
                    //StaticClass.afterCall();
                    //fieldLogicRecordtype();
                    List<Field_Logic_New__c> fieldLogicToBeUpdated = new List<Field_Logic_New__c>();
                    for(Field_Logic_New__c fln : Trigger.new){
                        if(fln.Label_Name__c != null){
                            Id pageLabelRecordTypeId = Schema.SObjectType.Field_Logic_New__c.getRecordTypeInfosByName().get('Page Labels').getRecordTypeId();
                            system.debug('The Record Tpye ID for PAGE LABELS is ##############'+pageLabelRecordTypeId);
                            fln.RecordTypeId = pageLabelRecordTypeId;
                            system.debug('The Record Tpye ID for PAGE LABELS record is ##############'+fln.RecordTypeId);
                            fieldLogicToBeUpdated.add(fln);
                        } else if(fln.Label_Name__c == null){
                            Id fieldLogicRecordTypeId = Schema.SObjectType.Field_Logic_New__c.getRecordTypeInfosByName().get('Field Logic').getRecordTypeId();
                            system.debug('The Record Tpye ID for FIELD LOGIC is ##############'+fieldLogicRecordTypeId);
                            fln.RecordTypeId = fieldLogicRecordTypeId;
                            system.debug('The Record Tpye ID for FIELD LOGIC record is ##############'+fln.RecordTypeId);
                            fieldLogicToBeUpdated.add(fln);
                        }
                    }
                //}    
            }
        }
        
    }catch(Exception e){
        system.debug('Error at line : ' +e);
    }
     
} // End of Trigger