@isTest
private class OnlinePageController_Test {

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
	
	@isTest static void test_method_1() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CheckingSilver();

	}    
	
	@isTest static void test_method_2() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CheckingGold();

	}	

	@isTest static void test_method_3() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.SavingsSilver();

	}

	@isTest static void test_method_4() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.SavingsGold();

	}

	@isTest static void test_method_5() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.SavingsPlatinum();

	}

	@isTest static void test_method_6() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.Certificates6Months();

	}

	@isTest static void test_method_7() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.Certificates12Months();

	}

	@isTest static void test_method_8() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.Certificates18Months();

	}

	@isTest static void test_method_9() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.Certificates24Months();

	}

	@isTest static void test_method_10() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.Certificates36Months();

	}

	@isTest static void test_method_11() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.Certificates60Months();

	}

	@isTest static void test_method_12() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsSilverIncrease();

	}

	@isTest static void test_method_13() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsSilverAdvantagePointsRewards();

	}

	@isTest static void test_method_14() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsSilverAdvantagePointsRewardsIncrease();

	}

	@isTest static void test_method_15() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsAdvantage();

	}

	@isTest static void test_method_16() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsSilver();

	}

	@isTest static void test_method_17() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsAdvantageSecured();

	}

	@isTest static void test_method_18() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsAdvantageSecuredIncrease();

	}

	@isTest static void test_method_19() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.CreditCardsPlatinum();

	}

	@isTest static void test_method_20() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeLoanFixedRateMortgages();

	}

	@isTest static void test_method_21() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeLoanFixedRateJumboMortgages();

	}

	@isTest static void test_method_22() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeLoanAdjustableRateMortgages();

	}

	@isTest static void test_method_23() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeLoanAdjustableRateJumboMortgages();

	}

	@isTest static void test_method_24() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeEquityFixedRateHomeEquity();

	}

	@isTest static void test_method_25() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeEquityAdjustableRateHomeEquity();

	}

	@isTest static void test_method_26() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.HomeEquityFlexityLineofCredit();

	}

	@isTest static void test_method_27() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.PersonalLoansFixedRate();

	}

	@isTest static void test_method_28() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.PersonalLoansPersonalLineofCredit();

	}

	@isTest static void test_method_29() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.PersonalLoansStockSecuredLoan();

	}

	@isTest static void test_method_30() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.PersonalLoansCertificateSecuredLoan();

	}

	@isTest static void test_method_31() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.PersonalLoansSavingsSecuredLoan();

	}

	@isTest static void test_method_32() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.VehicleLoansNewAutoLoan();

	}

	@isTest static void test_method_33() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.VehicleLoansUsedAutoLoan();

	}

	@isTest static void test_method_34() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.VehicleLoansBoatLoan();

	}

	@isTest static void test_method_35() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.VehicleLoansRVLoan();

	}

	@isTest static void test_method_36() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.VehicleLoansMotorcycleLoan();

	}

	@isTest static void test_method_37() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiCheckingSilver();

	}

	@isTest static void test_method_38() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiCheckingPlatinum();

	}

	@isTest static void test_method_39() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiSavingsSilver();

	}

	@isTest static void test_method_40() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiSavingsPlatinum();

	}

	@isTest static void test_method_41() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiSavingsMoneyMarket();

	}

	@isTest static void test_method_42() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiCDsBasic();

	}

	@isTest static void test_method_43() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiCDsJumbo();

	}

	@isTest static void test_method_44() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiCCPlatinum();

	}

	@isTest static void test_method_45() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiCCSapphire();

	}

	@isTest static void test_method_46() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiLoansAdvantage();

	}

	@isTest static void test_method_47() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiLoansTerm();

	}

	@isTest static void test_method_48() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiLoansSBA();

	}

	@isTest static void test_method_49() {

		testLoadData();
		PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        Application__c app = new Application__c ();
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
	    ApexPages.currentPage().getParameters().put('id',app.Id);
	    OnlinePageController oc = new OnlinePageController();
	    oc.BusiLoansLOC();

	}
		
	
}