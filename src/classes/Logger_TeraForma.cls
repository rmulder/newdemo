global with sharing class Logger_TeraForma {
    
    global static List<Forms_Debug_Logs__c> logs = new List<Forms_Debug_Logs__c>();
    global static String source;
    global static String servId;
    
    global static void writeAllLogs(){
        try{
            Service_Configuration__c config;
            if(!Test.isRunningTest()) config = Service_Configuration__c.getInstance();
            else config.Debug_Log_Switch__c = true;
            if(config.Debug_Log_Switch__c == true)
                if (Forms_Debug_Logs__c.SObjectType.getDescribe().isCreateable()) {
                	insert logs;
                }
        }catch(exception e1){
            system.debug('exception in the writeAllLogs methods: '+e1);
        }
    }
    
    global static void inputSource(String writeSource, String writeServId){
        try{
            source = writeSource;
            servId = writeServId;
        }catch(exception e2){
            system.debug('exception in the inputSource methods: '+e2);
        }
    }
    
    
    global static void addMessage(String message,Datetime timestamp){
        try{
            Forms_Debug_Logs__c log =  new Forms_Debug_Logs__c();
            log.Debug_Message__c = message;
            log.Timestamp__c = timestamp;
            log.Source__c = source;
            if(servId != NULL){
                log.Service__c = servId;
                logs.add(log);
            }
            system.debug(log);
        }catch(exception e3){
            system.debug('exception in the addMessage methods: '+e3);
        }
    }
}