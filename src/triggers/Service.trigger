trigger Service on Service__c (before insert, after insert, after update) {

public List<Service_Progress__c> allServiceProgressList;
public List<Service_Document_Request__c> serviceDocumentList = new List<Service_Document_Request__c>();
public List<Service__c> allServiceList = new List<Service__c>();
public Boolean doInsert;

    if(Trigger.isInsert){
        if(Trigger.isAfter){
            allServiceProgressList = new List<Service_Progress__c>();
            for(Service__c service : Trigger.new){
                      
                List<Service_Type__c> serviceTypeList = [SELECT Id,Name,Documents_Required__c FROM Service_Type__c WHERE Name =:service.Service_Request__c];
                if(serviceTypeList.size() >0){

                    //CReating the steps for the Service_c Object by Creating Service_progress__c records(Child to Service__c
                    List<Service_Flow__c> serviceFlowList = [SELECT Id,Attachments_Allowed__c,Docusign_Required__c,ESign_Required__c,New_Email_Alert__c,New_Outbound_Message__c,New_Task__c,New_Task_SLA__c,Step_Number__c FROM Service_Flow__c WHERE Service_Type__c =:serviceTypeList[0].Id];
                    if(serviceFlowList.size() > 0){
                        for(Service_Flow__c servFlow : serviceFlowList){
                            Service_Progress__c serviceProgress = new Service_Progress__c();
                            serviceProgress.Service__c = service.id;
                            serviceProgress.Step_Number__c = servFlow.Step_Number__c;
                            if(servFlow.Step_Number__c == '1'){
                                serviceProgress.Started_TimeStamp__c = system.now();
                            }
                            serviceProgress.New_Email_Alert__c = servFlow.New_Email_Alert__c;
                            serviceProgress.New_Outbound_Message__c = servFlow.New_Outbound_Message__c;
                            serviceProgress.New_Task__c = servFlow.New_Task__c;
                            serviceProgress.SLA__c = servFlow.New_Task_SLA__c;
        
                            allServiceProgressList.add(serviceProgress);
                        }
                    }

                    //Creating the Document Request Records for pre-determinted document request mentioned in the Service_Type__C Object
                    if(serviceTypeList[0].Documents_Required__c != null){
                        List<String> docRequestList = serviceTypeList[0].Documents_Required__c.split(';');
                        if(docRequestList.size() > 0){
                            for(String st : docRequestList){
                                Service_Document_Request__c servDoc = new Service_Document_Request__c();
                                servDoc.Service__c = service.id;
                                servDoc.Status__c = 'New';
                                servDoc.Type__c = st;

                                serviceDocumentList.add(servDoc);
                            }
                        }
                    }
                    
                }
            }
            insert allServiceProgressList;
            insert serviceDocumentList;
        } 

/*        if(Trigger.isBefore){
            for(Service__c service : Trigger.new){
                if(service.Current_Step__c == null){
                    service.Current_Step__c = '1';
                }
            }    
        }*/
    }

    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            allServiceProgressList = new List<Service_Progress__c>();
            for(Service__c service : Trigger.new){
                if(Trigger.oldMap.get(service.Id).Service_Request__c != Trigger.newMap.get(service.Id).Service_Request__c){
                    List<Service_Type__c> serviceTypeList = [SELECT Id,Name,Documents_Required__c FROM Service_Type__c WHERE Name =:service.Service_Request__c];
                    if(serviceTypeList.size() >0){

                        //CReating the steps for the Service_c Object by Creating Service_progress__c records(Child to Service__c
                        List<Service_Flow__c> serviceFlowList = [SELECT Id,Attachments_Allowed__c,Docusign_Required__c,ESign_Required__c,New_Email_Alert__c,New_Outbound_Message__c,New_Task__c,New_Task_SLA__c,Step_Number__c FROM Service_Flow__c WHERE Service_Type__c =:serviceTypeList[0].Id];
                        if(serviceFlowList.size() > 0){
                            for(Service_Flow__c servFlow : serviceFlowList){
                                Service_Progress__c serviceProgress = new Service_Progress__c();
                                serviceProgress.Service__c = service.id;
                                serviceProgress.Step_Number__c = servFlow.Step_Number__c;
                                if(servFlow.Step_Number__c == '1'){
                                    serviceProgress.Started_TimeStamp__c = system.now();
                                }
                                serviceProgress.New_Email_Alert__c = servFlow.New_Email_Alert__c;
                                serviceProgress.New_Outbound_Message__c = servFlow.New_Outbound_Message__c;
                                serviceProgress.New_Task__c = servFlow.New_Task__c;
                                serviceProgress.SLA__c = servFlow.New_Task_SLA__c;
                    
                                allServiceProgressList.add(serviceProgress);
                            }
                        }

                        //Creating the Document Request Records for pre-determinted document request mentioned in the Service_Type__C Object
                        if(serviceTypeList[0].Documents_Required__c != null){
                            List<String> docRequestList = serviceTypeList[0].Documents_Required__c.split(';');
                            if(docRequestList.size() > 0){
                                for(String st : docRequestList){
                                    Service_Document_Request__c servDoc = new Service_Document_Request__c();
                                    servDoc.Service__c = service.id;
                                    servDoc.Status__c = 'New';
                                    servDoc.Type__c = st;

                                    serviceDocumentList.add(servDoc);
                                }
                            }
                        }
                        
                    }
                    doInsert = true;
                }

                if( Trigger.oldMap.get(service.Id).Current_Step__c != null && (Trigger.oldMap.get(service.Id).Current_Step__c != Trigger.newMap.get(service.Id).Current_Step__c) && ( integer.Valueof(Trigger.oldMap.get(service.Id).Current_Step__c) < integer.Valueof(Trigger.newMap.get(service.Id).Current_Step__c) ) ){
                    allServiceProgressList = new List<Service_Progress__c>();
                    List<Service_Progress__c> serviceProgressOldList = [SELECT Id,Last_Performed_By__c,Completed__c,Customer_Email_Address__c,Step_Completed_Timestamp__c,Service__c FROM Service_Progress__c WHERE Service__c = :service.Id AND Step_Number__c = :Trigger.oldMap.get(service.Id).Current_Step__c LIMIT 1];
                    if(serviceProgressOldList.size() > 0){
                        ServiceUtility su = new ServiceUtility();
                        String step = Trigger.oldMap.get(service.Id).Current_Step__c;
                        System.debug('The Step is '+step);
                        System.debug('The Name of the Service is '+service.Service_Request__c);
                        Set<String> fieldstodisply = su.retfieldstoExternalCall(service.Service_Request__c,step,false);
                        if(fieldstodisply.size() > 0){
                            Set<String> finalFieldstoDisplay = new Set<String>();
                            for(String s : fieldstodisply){
                                if(s.contains('__c')){
                                    finalFieldstoDisplay.add(s);
                                }
                            }                    
                            for(String serviceField : finalFieldstoDisplay){
                                if(Trigger.oldMap.get(service.Id).get(serviceField) != Trigger.newMap.get(service.Id).get(serviceField)){
                                    serviceProgressOldList[0].Last_Performed_By__c=service.Current_Person__c;
                                    serviceProgressOldList[0].Step_Completed_Timestamp__c=System.now();
                                    serviceProgressOldList[0].Completed__c = true;
                                    serviceProgressOldList[0].Customer_Email_Address__c = Service.Field3__c;
                                    allServiceProgressList.add(serviceProgressOldList[0]);
                                    break;
                                }
                            }
                        }
                    }
                    Integer i = Integer.valueOf(Trigger.oldMap.get(service.Id).Current_Step__c);
                    i=i+1;
                    List<Service_Progress__c> serviceProgressNewList = [SELECT Id,Last_Performed_By__c,Started_TimeStamp__c,Step_Completed_Timestamp__c,Service__c FROM Service_Progress__c WHERE Service__c = :service.Id AND Step_Number__c = :String.Valueof(i) LIMIT 1];
                    if(serviceProgressNewList.size() > 0){
                        if(serviceProgressNewList[0].Started_TimeStamp__c == null && allServiceProgressList.size() == 0){
                            serviceProgressOldList[0].Last_Performed_By__c=service.Current_Person__c;
                            serviceProgressOldList[0].Step_Completed_Timestamp__c=System.now();
                            serviceProgressOldList[0].Completed__c = true;
                            serviceProgressOldList[0].Customer_Email_Address__c = Service.Field3__c;
                            allServiceProgressList.add(serviceProgressOldList[0]);
                        }
                        serviceProgressNewList[0].Started_TimeStamp__c = System.now();
                        allServiceProgressList.add(serviceProgressNewList[0]);
                    }
                }
            }
            System.debug('The Service Progress records to be updated are '+allServiceProgressList);
            System.debug('The doInsert value is '+doInsert);
            if(doInsert != null){
                insert allServiceProgressList;
            } else{
                update allServiceProgressList;
            }
            
            insert serviceDocumentList;
        }

    }

}