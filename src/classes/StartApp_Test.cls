@isTest
private class StartApp_Test {
	
	@isTest static void test_method_one() {
	Customer__c customer = new Customer__c();
	insert customer;
	
	PageReference p = Page.OnlinePage;
	Test.setCurrentPage(p);
    ApexPages.currentPage().getParameters().put('id',customer.Id);
	ApexPages.StandardController controller = new ApexPages.StandardController(customer);
    StartApp SA = new StartApp(controller);

    SA.CreateApp();
	}
	
}