public without sharing class CryptoHelper {

    private static final String RANDOM_CHARS = 
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    private static blob key {
        private get{
            return EncodingUtil.base64Decode(Crypt__c.getOrgDefaults().key__c);
        }
        private set;
    }

    private static Decimal timeoutSeconds {
        private get{
            Application_Configuration__c ac = Application_Configuration__c.getOrgDefaults();
            return ac.Timeout_Seconds__c;
        }
        private set;
    }

    private static Decimal popupSeconds {
        private get{
            Application_Configuration__c ac = Application_Configuration__c.getOrgDefaults();
            return ac.Popup_Seconds__c;
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
        Crypt__c settings = Crypt__c.getOrgDefaults();
        string newKey = EncodingUtil.base64Encode(crypto.generateAesKey(128));
        settings.key__c = newKey;
        if (Crypt__c.SObjectType.getDescribe().isUpdateable() && Crypt__c.SObjectType.getDescribe().isCreateable()) {upsert settings;}
        
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

    public static void setAppToken(Application__c app){
        String userToken = genUserToken();
        app.User_Token__c = encrypt(userToken);
        app.User_Token_Expires__c = system.now().addMinutes(timeoutMinutes);
    }

    public static void refreshToken(Application__c app){
        app = [Select Id, First_Name__c, Last_Name__c, 
                Primary_Phone_Number__c,Email_Address__c, Third_Offer__c,
                User_Token_Expires__c from Application__c where Id=:app.Id];
        app.User_Token_Expires__c = system.now().addMinutes(timeoutMinutes);
        if (Application__c.SObjectType.getDescribe().isUpdateable()) {
            update app;
        }
    }

    public static void expireToken(Application__c app){
        app.User_Token_Expires__c = system.now().addMinutes(-1);
        if (Application__c.SObjectType.getDescribe().isUpdateable()) {
            update app;
        }
    }


    public static boolean userTokenIsValid(String appId, String unencryptedUserToken){
        Application__c app = [Select Id, User_Token__c,User_Token_Expires__c from Application__c where Id =: appId];
        system.debug('Security token of app record is '+app.User_Token__c);
        String storedToken = decrypt(app.User_Token__c);
        system.debug('STored token is '+storedToken);
        system.debug('Sending token is '+unencryptedUserToken);
        Datetime now = system.now();
        
        if(unencryptedUserToken.equals(storedToken)){
            if(now <= app.User_Token_Expires__c ){

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

   //returns null if user authenticates 
   //or returns to expired page if they do not
   public static PageReference checkAuth(String appId, String userToken){
        
        Boolean valid = userTokenIsValid(appId, userToken);
        
        if(valid){
            return null;
        }else{
          
            PageReference p = Page.SessionExpired;
            p.setRedirect(false);
            return p;
        }
   } 
}