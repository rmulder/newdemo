public with sharing class ServiceCryptoHelper {

	 private static final String RANDOM_CHARS = 
	   'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

	 private static blob key {
	     private get{
	         return EncodingUtil.base64Decode(Service_Crypto_Settings__c.getOrgDefaults().key__c);
	     }
	     private set;
	 }

	 private static Decimal timeoutSeconds {
	     private get{
	         Service_Configuration__c sc = Service_Configuration__c.getOrgDefaults();
	         return sc.Timeout_Seconds__c;
	     }
	     private set;
	 }

	 private static Decimal popupSeconds {
	     private get{
	         Service_Configuration__c sc = Service_Configuration__c.getOrgDefaults();
	         return sc.Popup_Seconds__c;
	     }
	     private set;
	 }

	 private static Integer timeoutMinutes {
	     get{
	         return Integer.valueOf(timeoutSeconds / 60);
	     }
	     private set;
	 }

	 public static void genMasterKey(){
	     Service_Crypto_Settings__c settings = Service_Crypto_Settings__c.getOrgDefaults();
	     string newKey = EncodingUtil.base64Encode(crypto.generateAesKey(128));
	     settings.key__c = newKey;
	     if (Service_Crypto_Settings__c.SObjectType.getDescribe().isUpdateable() && Service_Crypto_Settings__c.SObjectType.getDescribe().isCreateable()) {upsert settings;}
	     
	 }

	 public static string encrypt(String clearText){
	     return EncodingUtil.base64Encode(crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(clearText)));
	 }

	 public static string decrypt(String cipherText){
	     return crypto.decryptWithManagedIV('AES128',key, EncodingUtil.base64Decode(cipherText)).toString();
	 }

	 public static string genUserToken(){
	     return getRandomString(25);
	 }

	 public static void setAppToken(Service__c serv){
	     String userToken = genUserToken();
	     serv.User_Token__c = encrypt(userToken);
	     serv.User_Token_Expires__c = system.now().addMinutes(timeoutMinutes);
	 }

	 public static void refreshToken(Service__c serv){
	     serv = [Select Id,User_Token_Expires__c from Service__c where Id=:serv.Id];
	     serv.User_Token_Expires__c = system.now().addMinutes(timeoutMinutes);
	     if (Service__c.SObjectType.getDescribe().isUpdateable()) {
	         update serv;
	     }
	 }

	 public static void expireToken(Service__c serv){
	     serv.User_Token_Expires__c = system.now().addMinutes(-1);
	     if (Service__c.SObjectType.getDescribe().isUpdateable()) {
	         update serv;
	     }
	 }


	 public static boolean userTokenIsValid(String servId, String unencryptedUserToken){
	     Service__c serv = [Select Id, User_Token__c,User_Token_Expires__c from Service__c where Id =:servId];
	     system.debug('Security token of service record is '+serv.User_Token__c);
	     String storedToken = decrypt(serv.User_Token__c);
	     system.debug('STored token is '+storedToken);
	     system.debug('Sending token is '+unencryptedUserToken);
	     Datetime now = system.now();
	     
	     if(unencryptedUserToken.equals(storedToken)){
	         if(now <= serv.User_Token_Expires__c ){

	             return true;
	         }else{
	             system.debug('token expired');
	             return false;
	         }
	         return true;
	     }else{
	         system.debug('token incorrect');
	         return false;
	     }
	     
	 }

	 private static String getRandomString(Integer len){

	   String mode = String.valueOf(RANDOM_CHARS.length() - 1);
	   String retVal = '';
	   if (len != null && len >= 1)
	   {
	      Integer chars = 0;
	      Integer random;
	      do
	      {
	         random = Math.round(Math.random() * Integer.valueOf(mode));
	         retVal += RANDOM_CHARS.substring(random, random + 1);
	         chars++;
	      } while (chars < len);
	   }
	   return retVal;
	}
}