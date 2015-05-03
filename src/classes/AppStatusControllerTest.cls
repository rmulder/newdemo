@isTest
global class AppStatusControllerTest{

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

    static testMethod void appStatus(){
        testLoadData();
        Application__c app=new Application__c();
        app.Last_Name__c='Test';
        app.Email_Address__c='test@test.com';
        app.Product__c=Product_Names_Mapping__c.getValues('Savings').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('CheckingSubProduct2').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct2').Client_Product_Name__c;
        app.Primary_Product_Status__c='Pending Review';
        app.Primary_Offer_Status__c='Pending Review';
        app.Second_Offer_Status__c='Pending Review';
        app.Third_Offer_Status__c='Pending Review';
        CryptoHelper.setAppToken(app);
        insert app;
        Identity_Information__c iden=new Identity_Information__c();
        iden.Application__c=app.Id;
        iden.Date_of_Birth__c='01/01/1986';
        iden.SSN_Prime__c='666777888';
        iden.SSN_Last_Four_PA__c='6667';
        insert iden;
        
        PageReference p=Page.appStatus;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id',app.Id);
        ApexPages.StandardController sc=new ApexPages.StandardController(app);
        
        AppStatusController spc1=new AppStatusController(sc);
        spc1.lastName='Test';
        spc1.email='test@test.com';
        spc1.dob='01/01/1986';
        spc1.ssn='6667';
        spc1.statusRet();
        p=Page.StatusPortal;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id',app.Id);
        ApexPages.StandardController scp=new ApexPages.StandardController(app);
        StatusPortalController spc=new StatusPortalCOntroller(scp);
        // Creating Documentation Request record 
        Documentation_Request__c d = new Documentation_Request__c();
        d.Application__c = app.Id;
        d.Status__c = 'Pending';
        d.Type__c = 'Driving License';
        insert d;
        // Creating Attachments
        // Attachment 1
        Attachment a1 = new Attachment();
        a1.Name = 'Attachment 1';
        a1.Body = Blob.valueOf('Attachment 1');
        a1.ParentId = d.Id;
        // Attachment 2
        Attachment a2 = new Attachment();
        a2.Name = 'Attachment 2';
        a2.Body = Blob.valueOf('Attachment 2');
        a2.ParentId = d.Id;
        List<Attachment> attachmentList = new List<Attachment>();
        attachmentList.add(a1);
        attachmentList.add(a2);
        insert attachmentList;
        spc.gethasDocRequestList();
        StatusPortalController.uploadAttachment(String.valueOf(d.Id),'Attachment 1','Attachment 1',String.valueOf(attachmentList.get(0).Id));
        StatusPortalController.deleteAttachment(attachmentList.get(0).Id);
        StatusPortalController.addNote(String.valueOf(d.Id),'Note 1','Note Body');
        System.assertEquals('Test',app.Last_Name__c);
    }
}