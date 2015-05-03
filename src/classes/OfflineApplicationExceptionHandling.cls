public with sharing class OfflineApplicationExceptionHandling {
	public static String createApplication(){
		try{
			User u = [select id,Channel__c,Name,Email,Profile.Name,Location__c from User where ID =:UserInfo.getUserId()];
			Application__c app = new Application__c();
			Employment_Information__c emp = new Employment_Information__c();
			Identity_Information__c iden = new Identity_Information__c();
            About_Account__c acc = new About_Account__c();
            Application_Activity__c appact = new Application_Activity__c();
            
            // Created User Attributes
            app.Created_Person__c = u.id;
            app.Created_Branch_Name__c = u.Location__c;
            app.Created_Channel__c = u.Channel__c;
            app.Created_User_Email_Address__c = u.Email;
            
            // Current User Attributes
            app.Current_Person__c = u.id;
            app.Current_Branch_Name__c = u.Location__c;
            app.Current_Channel__c = u.Channel__c;
            app.Current_User_Email_Address__c = u.Email;
            CryptoHelper.setAppToken(app);
                        
            if(Application__c.SObjectType.getDescribe().isCreateable())
                insert app;	
            
            if(Employment_Information__c.SObjectType.getDescribe().isCreateable() && Identity_Information__c.SObjectType.getDescribe().isCreateable() && About_Account__c.SObjectType.getDescribe().isCreateable() && Application_Activity__c.SObjectType.getDescribe().isCreateable()){
            	emp.Application__c = app.Id;
            	iden.Application__c = app.Id;
            	acc.Application__c = app.Id;
            	// Assigning APplication to Application Activity and assigning values to Applicatiin activity
            	appact.Application__c= app.Id;
	            appact.Channel__c = app.Current_Channel__c;
	            appact.Name__c = app.Current_Person__c;
	            appact.Action__c = 'Created the Application';
	            appact.Activity_Time__c = system.now();
	            appact.Branch__c = app.Current_Branch_Name__c;
                  if(Employment_Information__c.SObjectType.getDescribe().isCreateable()) {
            	     insert emp;
                  }
                  if(Identity_Information__c.SObjectType.getDescribe().isCreateable()) {    
            	     insert iden;
                  }
                  if(About_Account__c.SObjectType.getDescribe().isCreateable()) {
            	     insert acc;
                  }
                  if(Application_Activity__c.SObjectType.getDescribe().isCreateable()) {     
            	     insert appact;
                  }
            }
            return app.Id;
        }
		catch(Exception e){
                  system.debug('The error is '+e.getMessage()+' and line number is '+e.getLineNumber());
			return null;
		}
	}
}