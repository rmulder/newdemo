@isTest
private class AppStatusPortalController_Test {
	
	static void testLoadData(){
            // Getting custom object data
            List<sObject> crossSellLogicData = Test.loadData(Cross_Sell_Logic__c.sObjectType,'CrossSellLogicData');
            List<sObject> fieldLogicData=Test.loadData(Field_Logic_New__c.sObjectType,'FieldLogicData');
            List<sObject> termAutoLoansData=Test.loadData(TermAutoLoans__c.sObjectType,'TermAutoLoansData');
            List<sObject> collateralData=Test.loadData(CollateralInfo__c.sObjectType,'CollateralInfoData');
            List<sObject> segEmployerData=Test.loadData(Seg_Employer_Codes__c.sObjectType,'SegEmployerData');
            // Getting List Custom Settings data
            List<sObject> dspStatusData=Test.loadData(DSP_Status__c.sObjectType,'DSPStatusData');
            List<sObject> depositData=Test.loadData(Deposit_Amount_Validation__c.sObjectType,'DepositAmountData');
            List<sObject> productNamesMappingData=Test.loadData(Product_Names_Mapping__c.sObjectType,'ProductNamesMappingData');
            List<sObject> testClassProductNamesData=Test.loadData(Test_Class_Product_Names__c.sObjectType,'TestClassProductNamesData');
            // Inserting Hierarchy custom settings Data
            // Confirmation object
            Confirmation__c conf=new Confirmation__c();
            conf.Approved_x1__c='Test';
            conf.ATM_Card_Text__c='test';
            insert conf;
            // Crypto Settings object
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
		
		testLoadData();

		PageReference p = Page.ResumeApplication;
		Application__c app = new Application__c();
		CryptoHelper.setAppToken(app);
		insert app;
		Application2__c app2 = new Application2__c (Application__c =app.id);
	    insert app2;
	    Employment_Information__c emp = new Employment_Information__c(Application__c =app.id);
	    insert emp;
	    Identity_Information__c iden = new Identity_Information__c(Application__c =app.id);
	    insert iden;
	    About_Account__c acc = new About_Account__c(Application__c =app.id);
	    insert acc;
	    Application_Activity__c appact = new Application_Activity__c(Application__c =app.id);
	    insert appact;
	    Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id',app.Id);
		ApexPages.StandardController controller = new ApexPages.StandardController(app);
        AppStatusPortalController AA = new AppStatusPortalController(controller);

        AA.StatusRet();
        AA.uploadAttachment();

	}
	
	
	
}