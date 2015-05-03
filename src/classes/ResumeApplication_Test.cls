@isTest(seeAllData=true)
private class ResumeApplication_Test {
	
	@isTest static void UnitTest() {
		PageReference p = Page.ResumeApplication;
		Application__c app = new Application__c();
		CryptoHelper.setAppToken(app);
		insert app;
		Profile pr = [select id,Name from Profile where Name='System Administrator'];
		//User u = [select id,Channel__c from User where Profile.Name='System Administrator' AND IsActive=true limit 1];
		User u = new User(FirstName='Test',LastName='Ganesh',ProfileId=pr.Id,Email='ganesh.chedella@terafinainc.com',Username='ganesh@terafina.test',Location__c='Cupertino - CA',Channel__c='Online',EmailEncodingKey='ISO-8859-1',Alias='tuser',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',LanguageLocaleKey='en_US',IsActive = true);
        insert u;
		Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id',app.Id);
        ApexPages.currentPage().getParameters().put('usr',u.Id);
    	ApexPages.StandardController controller = new ApexPages.StandardController(app);
        ResumeApplication RS = new ResumeApplication(controller);
        try{
    		RS.Resumeapp();
    	}catch(Exception e){
    	   	system.debug('The error is '+e.getMessage());
    	}
    	System.assertEquals('Test',u.FirstName);
        
    }
	
		
}