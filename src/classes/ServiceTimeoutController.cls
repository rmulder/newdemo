global with sharing class ServiceTimeoutController {

	public String sessionToken {get;set;}
	public String servId {get;set;}

	public Integer secondsToCount {get;set;}
	public Integer secondsToCountPopup {get;set;}

	@remoteAction
	global static String refreshToken(String token, String servId){
	    //lookup the user's token and reset it
	    return 'refreshToken' + token;
	}

	@remoteAction
	global static String extendExpiration(String token, String servId){
	    //lookup the user's token and reset it
	    Service__c serv =[Select Id,Field1__c,One_N_Done__c from Service__c where Id=:servId];
	    ServiceCryptoHelper.refreshToken(serv);
	    return 'refreshToken' + token;
	}
}