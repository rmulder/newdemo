global with sharing class Logger {
    
    //global Debug_Logs__c[] logs;
    global static List<Debug_Logs__c> logs = new List<Debug_Logs__c>();
    global static String source;
    global static String appId;
    
    global static void writeAllLogs(){
        try{
            Application_Configuration__c appConfig;
            if(!Test.isRunningTest()) appConfig = Application_Configuration__c.getInstance();
            else appConfig.Debug_Log_Switch__c = true;
            if(appConfig.Debug_Log_Switch__c == true)
                if (Debug_Logs__c.SObjectType.getDescribe().isCreateable()) {
                    system.debug('alert d');
                    insert logs;
                }
        }catch(exception e1){
            system.debug('exception in the writeAllLogs methods: '+e1);
        }
    }
    
    global static void inputSource(String writeSource, String writeAppId){
        try{
            source = writeSource;
            appId = writeAppId;
        }catch(exception e2){
            system.debug('exception in the inputSource methods: '+e2);
        }
    }
    
    
    global static void addMessage(String message,String timestamp){
        try{
            Debug_Logs__c log =  new Debug_Logs__c();
            log.Debug_Message__c = message;
            log.Timestamp__c = timestamp;
            log.Source__c = source;
            if(appId != NULL){
                log.Application__c = appId;
                logs.add(log);
            }
            system.debug(log);
        }catch(exception e3){
            system.debug('exception in the addMessage methods: '+e3);
        }
    }
}