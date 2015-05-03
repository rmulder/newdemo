global with sharing class timeoutController {

    public String sessionToken {get;set;}
    public String appId {get;set;}

    public Integer secondsToCount {get;set;}
    public Integer secondsToCountPopup {get;set;}

    @remoteAction
    global static String refreshToken(String token, String appId){
        //lookup the user's token and reset it
        return 'refreshToken' + token;
    }

    @remoteAction
    global static String extendExpiration(String token, String appId){
        //lookup the user's token and reset it
        Application__c app =[Select Id, Last_Name__c, First_Name__c from Application__c where Id=:appId];
        CryptoHelper.refreshToken(app);
        return 'refreshToken' + token;
    }

}