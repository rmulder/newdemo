@isTest
private class Test_MetadataUpdate {

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
    }
	
	@isTest static void test_method_one() {
		testLoadData();
            Application__c app = new Application__c();
            insert app;
            About_Account__c acc = new About_Account__c();
            acc.Application__c = app.id;
            insert acc;
            Application2__c app2 = new Application2__c();
            app2.Application__c =app.id;
            insert app2;
            Employment_Information__c emp = new Employment_Information__c();
            emp.Application__c = app.id;
            insert emp;
            Identity_Information__c iden = new Identity_Information__c();
            iden.Application__c = app.id;
            insert iden;
            Cross_Sell_Logic__c cross = new Cross_Sell_Logic__c();
            insert cross;
            Docusign_Config__c doc = new Docusign_Config__c();
            doc.Name = 'cred';
            insert doc;
		Field_Logic_New__c fln = new Field_Logic_New__c();
		fln.Field_Name__c = 'First_Name__c'; 
		fln.Label__c = 'First Name'; 
		fln.isRequired__c = true;
		fln.isDisplayed__c = true;
		insert fln;
		ApexPages.StandardController controller = new ApexPages.StandardController(fln);
            MetadataUpdate ff = new MetadataUpdate(controller);
		ff.Meta();
		//ff.getObjectFields(sObject obj , JSONGenerator generator);
	 }
	
	
	
}