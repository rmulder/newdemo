@isTest
private class UpdateAppStatus_Test {
	
	@isTest static void test_method_one() {
		// Implement test code
		List<Application__c> appList=new List<Application__c>();
		for(integer i=0;i<10;i++){
			Application__c app = new Application__c();
			app.First_Name__c='JamesTestClass';
			app.Last_Name__c='BondTestClass';
			app.Application_Status__c='Open';
			DateTime myDateTime = DateTime.newInstance(2014, 1, 31, 7, 8, 16);
			app.User_Token_Expires__c=myDateTime;
			//app.Annual_Income__c=i;
			//app.Time_Elapsed__c=90;
			appList.add(app);
		}

		Application_Configuration__c config = new Application_Configuration__c();
		config.Application_Code__c = 'static';
		config.Theme__c = 'static';
		config.Days_to_expire_app__c = 1;
		insert config;
		insert appList;

		Test.startTest();
		UpdateAppStatus UAS = new UpdateAppStatus();
		Database.executeBatch(UAS);
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		List<Application__c> appList=new List<Application__c>();
		for(integer i=0;i<10;i++){
			Application__c app = new Application__c();
			app.First_Name__c='JamesTestClass';
			app.Last_Name__c='BondTestClass';
			app.Application_Status__c='Save for Later';
			DateTime myDateTime = DateTime.newInstance(2014, 1, 31, 7, 8, 16);
			app.User_Token_Expires__c=myDateTime;
			//app.Annual_Income__c=i;
			//app.Time_Elapsed__c=90;
			appList.add(app);
		}

		Application_Configuration__c config = new Application_Configuration__c();
		config.Application_Code__c = 'static';
		config.Theme__c = 'static';
		config.Days_to_expire_app__c = -1;
		insert config;
		insert appList;

		Test.startTest();
		UpdateAppStatus UAS = new UpdateAppStatus();
		Database.executeBatch(UAS);
		Test.stopTest();
	}
	
}