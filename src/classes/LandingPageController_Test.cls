@isTest
private class LandingPageController_Test {

	static void loadTestData(){

		List<sObject> productNamesMappingData=Test.loadData(Product_Names_Mapping__c.sObjectType,'ProductNamesMappingData');
		List<sObject> productCodesForTestClasses=Test.loadData(Product_Codes__c.sObjectType,'ProductCodesForTestClasses');

		Crypt__c c=new Crypt__c();
		c.Key__c='7h5EJk6sVmIev/MYVO1sCg==';
		insert c;

		Application_configuration__c ac = new Application_configuration__c();
        ac.Theme__c = 'beta';
        ac.Application_Code__c='324543';
        ac.Enable_IP_Lookup__c=true;
        ac.IP_Field_City__c='3dsfs';
        ac.IP_Field_Latitude__c='sdfs435';
        ac.IP_Field_Longitude__c='dfgd';
        ac.IP_Field_State__c='ddsdf';
        ac.IP_Lookup_Data_Type__c='dxc43';
        ac.IP_Lookup_URL__c='http://www.google.com/';
        ac.Is_Production_Env__c=true;
        ac.Popup_Seconds__c=120;
        ac.Timeout_Seconds__c=600;
        insert ac;
	}
	
	@isTest static void test_method_one() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','BCDB');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	
	@isTest static void test_method_two() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','BCCPNM');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_three() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','BCPNM');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_four() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','BLADV');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_five() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','BSAVMM');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_six() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','CCADV');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_seven() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','CERT12');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

		@isTest static void test_method_eight() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','CKGD');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_nine() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','HEARHE');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_ten() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','HLARM');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_eleven() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','SAVGD');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}

	@isTest static void test_method_twelve() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','VLBL');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}		

	@isTest static void test_method_thirteen() {
		// Implement test code
		loadTestData();
		PageReference p = Page.LandingPage;
		Test.setCurrentPage(p);
/*		Product_Codes__c pc = new Product_Codes__c();
		pc.Name = 'BCDB';
		pc.Product__c = 'Business CDs';
		pc.Sub_Product__c = 'Business CDs - Basic';
		insert pc;*/
		ApexPages.currentPage().getHeaders().put('CipherSuite','rurue');
		ApexPages.currentPage().getParameters().put('prdCode','PLFR');
		ApexPages.currentPage().getParameters().put('subPrdCode','RCKA');
		ApexPages.currentPage().getParameters().put('X-Salesforce-SIP','180.168.1.1');

		LandingPageController lpc =new LandingPageController();
		try{
		    lpc.beginApp();
		}
		catch(DMLException e){
			system.debug('DML exception is '+e);
		}

	}	

	
}