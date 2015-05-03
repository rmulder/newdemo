@isTest
private class IndexValidationExtension_Test {

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
	
	@isTest static void test_GetStarted() {
        testLoadData();
		Application__c app=new Application__c(Product__c = 'Checking', Sub_Product__c = 'Checking - TestChecking', First_Name__c = 'TestFirst', Last_Name__c = 'TestLast');
        insert app;

        Employment_Information__c emp=new Employment_Information__c();
        emp.Application__c=app.Id;
        insert emp;

        Identity_Information__c iden=new Identity_Information__c();
        iden.Application__c=app.Id;
        insert iden;

        About_Account__c acc=new About_Account__c();
        acc.Application__c=app.Id;
        insert acc;

        Application2__c app2=new Application2__c();
        app2.Application__c=app.Id;
        insert app2;

        List<Field_Logic_New__c> fln = new List<Field_Logic_New__c>();
        List<Deposit_Amount_Validation__c> dav = new List<Deposit_Amount_Validation__c>();


        Field_Logic_New__c f1 = new Field_Logic_New__c(Field_Name__c = 'Street_Address_1__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f2 = new Field_Logic_New__c(Field_Name__c = 'Account_Holder_Name_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f3 = new Field_Logic_New__c(Field_Name__c = 'CHK_Check_Routing_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f4 = new Field_Logic_New__c(Field_Name__c = 'CHK_Check_Account_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f5 = new Field_Logic_New__c(Field_Name__c = 'Select_Account_FI_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f6 = new Field_Logic_New__c(Field_Name__c = 'Dollar_Amount_Internal_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f7 = new Field_Logic_New__c(Field_Name__c = 'Financial_Institution_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f8 = new Field_Logic_New__c(Field_Name__c = 'Routing_Number_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f9 = new Field_Logic_New__c(Field_Name__c = 'Account_type_FI_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f10 = new Field_Logic_New__c(Field_Name__c = 'CHK_Account_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f11 = new Field_Logic_New__c(Field_Name__c = 'Disclosure_AccountDetails_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		
		fln.add(f1);
		fln.add(f2);
		fln.add(f3);
		fln.add(f4);
		fln.add(f5);
		fln.add(f6);
		fln.add(f7);
		fln.add(f8);
		fln.add(f9);
		fln.add(f10);
		fln.add(f11);
		
		insert fln;

		// Testing for PO Box values
        app.Street_Address_1__c = 'PO Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'P O Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'P. O Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'po box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'p o box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'p.o box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'p. o box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'P o Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'P.o Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'P. o Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);

        app.Street_Address_1__c = 'Po Box';
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);
        // End of testing for PO Box values

        //Deposit amount validation in Account Details page.
        app.Type_of_Checking__c = 'Checking - TestChecking';
        Deposit_Amount_Validation__c d1 = new Deposit_Amount_Validation__c (Name = ' TestChecking ',Maximum_Amount__c=500,Minimum_Amount__c=0);
        Deposit_Amount_Validation__c d2 = new Deposit_Amount_Validation__c (Name = 'Dollar Validation Check',Maximum_Amount__c=500,Minimum_Amount__c=0);
        Deposit_Amount_Validation__c d3 = new Deposit_Amount_Validation__c (Name = 'Dollar Validation Cash',Maximum_Amount__c=500,Minimum_Amount__c=0);


        dav.add(d1);
        dav.add(d2);
        dav.add(d3);

        insert dav;


        Product_Names_Mapping__c pcm = new Product_Names_Mapping__c();
        pcm.Product_Name__c ='business';
        pcm.Name = 'business';
        insert pcm;

        acc.funding_type_chk__c = 'Add External Accounts';
        acc.Financial_Institution_CHK__c = '';
        acc.Routing_Number_CHK__c = 'adfd';
        acc.Account_type_FI_CHK__c = '';
        acc.CHK_Account_Number__c = 'sdfsf';
        acc.Disclosure_AccountDetails_chk__c = true;        
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.funding_type_chk__c = 'Internal Accounts';
        acc.select_account_fi_chk__c = '';
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_CHK__c = 'Cash';
        acc.Dollar_Amount_CHK_Cash__c = 600;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_CHK__c = 'Check';
        acc.CHK_Check_Routing_Number__c = '';
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.CHK_Check_Routing_Number__c = 'Afewere34343';
        acc.CHK_Check_Account_Number__c='';
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        
    }
	
	@isTest static void test_method_two() {

	    testLoadData();   
		Application__c app=new Application__c(Product__c = 'Checking', Sub_Product__c = 'Checking - TestChecking', First_Name__c = 'TestFirst', Last_Name__c = 'TestLast');
        insert app;

        Employment_Information__c emp=new Employment_Information__c();
        emp.Application__c=app.Id;
        insert emp;

        Identity_Information__c iden=new Identity_Information__c();
        iden.Application__c=app.Id;
        insert iden;

        About_Account__c acc=new About_Account__c();
        acc.Application__c=app.Id;
        insert acc;

        Application2__c app2=new Application2__c();
        app2.Application__c=app.Id;
        insert app2;

        List<Field_Logic_New__c> fln = new List<Field_Logic_New__c>();
        List<Deposit_Amount_Validation__c> dav = new List<Deposit_Amount_Validation__c>();

        Field_Logic_New__c f1 = new Field_Logic_New__c(Field_Name__c = 'CHK_Check_Routing_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f2 = new Field_Logic_New__c(Field_Name__c = 'Funding_Type_BUS_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f3 = new Field_Logic_New__c(Field_Name__c = 'financial_institution_bus_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f4 = new Field_Logic_New__c(Field_Name__c = 'dollar_amount_external_bus_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f5 = new Field_Logic_New__c(Field_Name__c = 'routing_number_bus_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f6 = new Field_Logic_New__c(Field_Name__c = 'account_type_fi_bus_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f7 = new Field_Logic_New__c(Field_Name__c = 'bus_chk_account_number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f8 = new Field_Logic_New__c(Field_Name__c = 'disclosure_accountdetails_bus_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f9 = new Field_Logic_New__c(Field_Name__c = 'select_account_fi_bus_chk__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f10 = new Field_Logic_New__c(Field_Name__c = 'Dollar_Amount_Internal_Bus_CHK__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f11= new Field_Logic_New__c(Field_Name__c = 'BUSICHK_Check_Routing_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f12= new Field_Logic_New__c(Field_Name__c = 'BUSICHK_Check_Account_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		

		fln.add(f1);
		fln.add(f2);
		fln.add(f3);
		fln.add(f4);
		fln.add(f5);
		fln.add(f6);
		fln.add(f7);
		fln.add(f8);
		fln.add(f9);
		fln.add(f10);
		fln.add(f11);
		fln.add(f12);
		insert fln;

        Deposit_Amount_Validation__c d1 = new Deposit_Amount_Validation__c (Name = 'Dollar Validation Cash',Maximum_Amount__c=500,Minimum_Amount__c=0);
        Deposit_Amount_Validation__c d2 = new Deposit_Amount_Validation__c (Name = 'TestChecking ',Maximum_Amount__c=500,Minimum_Amount__c=0);
        Deposit_Amount_Validation__c d3 = new Deposit_Amount_Validation__c (Name = 'Dollar Validation Check',Maximum_Amount__c=500,Minimum_Amount__c=0);

        dav.add(d1); 
        dav.add(d2);
        dav.add(d3);       

        insert dav;

        app.Type_of_Checking__c = 'Checking - TestChecking';
        app.Type_Of_Business_Checking__c = 'Checking-TestChecking';
        
        acc.Funding_Type_CHK__c = 'Check';
        acc.CHK_Check_Account_Number__c='erwr23422';
        acc.Dollar_Amount_CHK_Check__c = 600;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        app.Type_Of_Business_Checking__c = 'business -checking';
        acc.Funding_Type_BUS_CHK__c = 'Add External Accounts';
        acc.routing_number_bus_chk__c = 'afd2342';
        acc.account_type_fi_bus_chk__c='';
        acc.bus_chk_account_number__c = 'fafasd';
        acc.disclosure_accountdetails_bus_chk__c = true;
        acc.dollar_amount_external_bus_chk__c = 700;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_BUS_CHK__c = 'Internal Accounts';
        acc.select_account_fi_bus_chk__c = '';
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_BUS_CHK__c ='Check';
        acc.BUSICHK_Check_Routing_Number__c = '242efwe';
        acc.BUSICHK_Check_Account_Number__c = 'fsfw';
        acc.Dollar_Amount_BUSICHK_Check__c = 800;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_BUS_CHK__c = 'Cash';
        acc.Dollar_Amount_BUSICHK_Cash__c = 600;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);


		
	}

	@isTest static void test_method_three() {
	    
        testLoadData();   
		Application__c app=new Application__c(Product__c = 'Checking', Sub_Product__c = 'Checking - TestChecking', First_Name__c = 'TestFirst', Last_Name__c = 'TestLast');
        insert app;

        Employment_Information__c emp=new Employment_Information__c();
        emp.Application__c=app.Id;
        insert emp;

        Identity_Information__c iden=new Identity_Information__c();
        iden.Application__c=app.Id;
        insert iden;

        About_Account__c acc=new About_Account__c();
        acc.Application__c=app.Id;
        insert acc;

        Application2__c app2=new Application2__c();
        app2.Application__c=app.Id;
        insert app2;

        List<Field_Logic_New__c> fln = new List<Field_Logic_New__c>();
        List<Deposit_Amount_Validation__c> dav = new List<Deposit_Amount_Validation__c>();

        Field_Logic_New__c f1 = new Field_Logic_New__c(Field_Name__c = 'Funding_Type_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f2 = new Field_Logic_New__c(Field_Name__c = 'Financial_Institution_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f3 = new Field_Logic_New__c(Field_Name__c = 'Routing_Number_Sav__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f4 = new Field_Logic_New__c(Field_Name__c = 'Account_Type_FI_Sav__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f5 = new Field_Logic_New__c(Field_Name__c = 'SAV_Account_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f6 = new Field_Logic_New__c(Field_Name__c = 'Dollar_Amount_External_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f7 = new Field_Logic_New__c(Field_Name__c = 'Disclosure_AccountDetails_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f8 = new Field_Logic_New__c(Field_Name__c = 'Select_Account_FI_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f9 = new Field_Logic_New__c(Field_Name__c = 'Dollar_Amount_Internal_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f10 = new Field_Logic_New__c(Field_Name__c = 'SAV_Check_Routing_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f11= new Field_Logic_New__c(Field_Name__c = 'SAV_Check_Account_Number__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		Field_Logic_New__c f12= new Field_Logic_New__c(Field_Name__c = 'Account_Holder_Name_SAV__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - TestChecking');
		

		fln.add(f1);
		fln.add(f2);
		fln.add(f3);
		fln.add(f4);
		fln.add(f5);
		fln.add(f6);
		fln.add(f7);
		fln.add(f8);
		fln.add(f9);
		fln.add(f10);
		fln.add(f11);
		fln.add(f12);
		insert fln;

        Deposit_Amount_Validation__c d1 = new Deposit_Amount_Validation__c (Name = 'Dollar Validation Cash',Maximum_Amount__c=500,Minimum_Amount__c=0);
        Deposit_Amount_Validation__c d2 = new Deposit_Amount_Validation__c (Name = 'TestSaving ',Maximum_Amount__c=500,Minimum_Amount__c=0);
        Deposit_Amount_Validation__c d3 = new Deposit_Amount_Validation__c (Name = 'Dollar Validation Check',Maximum_Amount__c=500,Minimum_Amount__c=0);

        dav.add(d1); 
        dav.add(d2);
        dav.add(d3);       

        insert dav;

        acc.funding_type_sav__c = 'Add External Accounts';        
        acc.financial_institution_sav__c = '';
        acc.routing_number_sav__c = 'test';
        acc.account_type_fi_sav__c = '';
        acc.sav_account_number__c = 'test';
        acc.disclosure_accountdetails_sav__c = false;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_SAV__c = 'Internal Accounts';
        acc.select_account_fi_sav__c = '';    
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_SAV__c  ='Check';
        acc.SAV_Check_Routing_Number__c = '242efwe';
        acc.SAV_Check_Account_Number__c = 'fsfw';
        acc.Dollar_Amount_SAV_Check__c = 800;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);

        acc.Funding_Type_SAV__c = 'Cash';
        acc.Dollar_Amount_SAV_Cash__c = 600;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);


		
	}
	
}