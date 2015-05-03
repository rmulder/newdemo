@isTest
private class PromotionsController_Test {
	
	static void testLoadData(){
            // Getting custom object data
            List<sObject> crossSellLogicData = Test.loadData(Cross_Sell_Logic__c.sObjectType,'CrossSellLogicData');
            List<sObject> fieldLogicData=Test.loadData(Field_Logic_New__c.sObjectType,'FieldLogicData');
            List<sObject> termAutoLoansData=Test.loadData(TermAutoLoans__c.sObjectType,'TermAutoLoansData');
            List<sObject> collateralData=Test.loadData(CollateralInfo__c.sObjectType,'CollateralInfoData');
            List<sObject> segEmployerData=Test.loadData(Seg_Employer_Codes__c.sObjectType,'SegEmployerData');
            // Getting List Custom Settings data
            List<sObject> dspStatusRecords=Test.loadData(DSP_Status__c.sObjectType,'DSPStatusData');
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


	static testMethod void test_method_one() {
		
		testLoadData();
		PageReference p = Page.promotions;
        Test.setCurrentPage(p);
		Promotion__c promo = new Promotion__c();
		promo.Description__c ='agsjkf';
        promo.Attachment1__c = 'Sample text';
        promo.Attachment1__c = 'Sample text';
        promo.Attachment1__c = 'Sample text';
        //promo.CampaignID__c
        promo.Keywords__c = 'Sample text';
        promo.RichTextArea1__c = 'Sample text';
        promo.Sub_Product_Code__c = 'Sample text';
        promo.Template__c = 'Sample text';
        promo.TextArea1__c = 'Sample text';
        //promo.URL__c = ''
		insert promo;
		ApexPages.currentPage().getParameters().put('id',promo.Id);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController( [Select Id,Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c Order By Name] );
		PromotionsController pc = new PromotionsController(sc);

		
		Attachment att = new Attachment();
		att.Name= 'Test';
		string m = 'Tetafia';
		Blob myblob = Blob.valueOf(m);
		System.assertEquals('Tetafia', myblob.toString());
		String st = myblob.toString();
		att.Body= myblob;
		att.parentId = promo.Id;
		insert att;

		Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',promo.Id);
        testData.put('debug','true');
        testData.put('attId', att.Id);
        testData.put('fkaslhdf',st);
        testData.put('fjas',att.Name);
        testData.put('1','1');

        PromotionsController.uploadAttachment(Promo.Id,1,st,att.Name,att.Id);
        PromotionsController.deleteAttachment(Promo.Id,1,att.Id);
        PromotionsController.getPromo(Promo.Id);
        PromotionsController.updatePromo(testData);
        PromotionsController.createPromo(Promo.Description__c);
        PromotionsController.deletePromo(Promo.Id);
        pc.getpromotionList();
        pc.firstPage();
        pc.next();
        pc.previous();
        pc.lastPage();
        pc.gethasNext();
        pc.gethasPrevious();
        

	}
	
	static testMethod void test_method_two() {
		
		testLoadData();
		PageReference p = Page.Index;
        Test.setCurrentPage(p);
		Promotion__c promo = new Promotion__c();
        promo.Description__c ='agsjkf';
        promo.Attachment1__c = 'Sample text';
        promo.Attachment1__c = 'Sample text';
        promo.Attachment1__c = 'Sample text';
        //promo.CampaignID__c
        promo.Keywords__c = 'Sample text';
        promo.RichTextArea1__c = 'Sample text';
        promo.Sub_Product_Code__c = 'Sample text';
        promo.Template__c = 'Sample text';
        promo.TextArea1__c = 'Sample text';
        //promo.URL__c = ''
		insert promo;
		ApexPages.currentPage().getParameters().put('id',promo.Id);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController( [Select Id,Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c Order By Name] );
        PromotionsController pc = new PromotionsController(sc);

		Attachment att = new Attachment();
		att.Name= 'Test';
		string m = 'Tetafia';
		Blob myblob = Blob.valueOf(m);
		System.assertEquals('Tetafia', myblob.toString());
		String st = myblob.toString();
		att.Body= myblob;
		att.parentId = promo.Id;
		insert att;

		Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',promo.Id);
        testData.put('debug','true');
        testData.put('attId', att.Id);
        testData.put('fkaslhdf',st);
        testData.put('fjas',att.Name);
        testData.put('1','1');

        PromotionsController.uploadAttachment(Promo.Id,2,st,att.Name,att.Id);
        PromotionsController.deleteAttachment(Promo.Id,2,att.Id);
        pc.getpromotionList();
        pc.firstPage();
        pc.next();
        pc.previous();
        pc.lastPage();
        pc.gethasNext();
        pc.gethasPrevious();
       
	}

	static testMethod void test_method_three() {
		
		testLoadData();
		PageReference p = Page.Index;
        Test.setCurrentPage(p);
		Promotion__c promo = new Promotion__c();
		promo.Description__c ='agsjkf';
        promo.Attachment1__c = 'Sample text';
        promo.Attachment1__c = 'Sample text';
        promo.Attachment1__c = 'Sample text';
        //promo.CampaignID__c
        promo.Keywords__c = 'Sample text';
        promo.RichTextArea1__c = 'Sample text';
        promo.Sub_Product_Code__c = 'Sample text';
        promo.Template__c = 'Sample text';
        promo.TextArea1__c = 'Sample text';
        //promo.URL__c = ''
		insert promo;
		ApexPages.currentPage().getParameters().put('id',promo.Id);
		ApexPages.StandardSetController sc = new ApexPages.StandardSetController( [Select Id,Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c Order By Name] );
        PromotionsController pc = new PromotionsController(sc);

		Attachment att = new Attachment();
		att.Name= 'Test';
		string m = 'Tetafia';
		Blob myblob = Blob.valueOf(m);
		System.assertEquals('Tetafia', myblob.toString());
		String st = myblob.toString();
		att.Body= myblob;
		att.parentId = promo.Id;
		insert att;

		Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',promo.Id);
        testData.put('debug','true');
        testData.put('attId', att.Id);
        testData.put('fkaslhdf',st);
        testData.put('fjas',att.Name);
        testData.put('1','1');

        PromotionsController.uploadAttachment(Promo.Id,3,st,att.Name,att.Id);
        PromotionsController.deleteAttachment(Promo.Id,3,att.Id);
        pc.getpromotionList();
        pc.firstPage();
        pc.next();
        pc.previous();
        pc.lastPage();
        pc.gethasNext();
        pc.gethasPrevious();
        
	}

	
}