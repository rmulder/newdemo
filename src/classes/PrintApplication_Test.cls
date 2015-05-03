@isTest
private class PrintApplication_Test {
	
	@isTest static void test_method_one() {
		// Implement test code
		Application__c app=new Application__c(Product__c='Checking',Sub_Product__c='Checking-Dividend Rewards Checking',First_Name__c='Test',Last_Name__c='Ganesh',Primary_Offer__c='Credit Cards-Visa Platinum Points Rewards',Second_Offer__c='Savings-Instant Access Savings',Third_Offer__c='Certificates-6-Month Certificate',Type_of_Checking__c='Checking-Dividend Rewards Checking',Type_of_Savings__c='Savings-Instant Access Savings',Type_of_Credit_Cards__c='Credit Cards-Visa Platinum Points Rewards',Type_of_Personal_Loans__c='Personal Loans-Personal Line of Credit',Type_of_Certificates__c='Certificates-6-Month Certificate',Type_of_Vehicle_Loans__c='Vehicle Loans-New Auto Loan');
		app.Person_Number__c='1994';
		app.Current_Channel__c='Online';
		insert app;

		PageReference p = Page.PrintApplication;
		Test.setCurrentPage(p);
		ApexPages.currentPage().getParameters().put('id',app.Id);

		ApexPages.StandardController sc=new ApexPages.StandardController(app);
		PrintApplication pa =new PrintApplication(sc);

	}
	
	@isTest static void test_method_two() {
		// Implement test code
		// Implement test code
		Application__c app=new Application__c(Product__c='Checking',Sub_Product__c='Checking-Dividend Rewards Checking',First_Name__c='Test',Last_Name__c='Ganesh',Primary_Offer__c='Credit Cards-Visa Platinum Points Rewards',Second_Offer__c='Savings-Instant Access Savings',Third_Offer__c='Certificates-6-Month Certificate',Type_of_Checking__c='Checking-Dividend Rewards Checking',Type_of_Savings__c='Savings-Instant Access Savings',Type_of_Credit_Cards__c='Credit Cards-Visa Platinum Points Rewards',Type_of_Personal_Loans__c='Personal Loans-Personal Line of Credit',Type_of_Certificates__c='Certificates-6-Month Certificate',Type_of_Vehicle_Loans__c='Vehicle Loans-New Auto Loan');
		app.Person_Number__c='1994';
		app.Current_Channel__c='Online';
		insert app;
		About_Account__c acc = new About_Account__c();
		acc.Application__c = app.id;
		insert acc;

		PageReference p = Page.PrintApplication;
		Test.setCurrentPage(p);
		ApexPages.currentPage().getParameters().put('id',app.Id);

		ApexPages.StandardController sc=new ApexPages.StandardController(app);
		PrintApplication pa =new PrintApplication(sc);
	}
	
}