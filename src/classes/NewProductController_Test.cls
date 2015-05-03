@isTest
private class NewProductController_Test {
    
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
        User loggedInUser;
        PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        String userId=UserInfo.getUserId();
        loggedInUser=[select id,Channel__c,Name,Location__c,Profile.Name,Email from User where Id=:userId];
        String loggedInID = loggedInUser.Id;
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null,'SERVICE', null);
        xmlW.writeAttribute(null,null,'version','1.0');

        // CreatedBy related to User and Branch details
        // CreatedBYUserId attribute
        if(loggedInUser.Id!=null){
            xmlW.writeStartElement(null,'CreatedByUserId',null);
                xmlW.writeAttribute(null,null,'id','8');
                xmlW.writeCharacters(loggedInUser.Id);
            xmlW.writeEndElement(); //Close Logged In User Id
        }

        // CreatdByBranch attribute
        if(loggedInUser.Location__c!=null){
            xmlW.writeStartElement(null,'CreatedByBranch',null);
                xmlW.writeAttribute(null,null,'id','9');
                xmlW.writeCharacters(loggedInUser.Location__c);
            xmlW.writeEndElement(); //Close Branch
        }

        // CreatedByChannel attribute
        if(loggedInUser.Channel__c!=null){
            xmlW.writeStartElement(null,'CreatedByChannel',null);
                xmlW.writeAttribute(null,null,'id','10');
                xmlW.writeCharacters(loggedInUser.Channel__c);
            xmlW.writeEndElement(); //Close Channel
        }

        // Created Email Attribute
        if(loggedInUser.Email!=null){
            xmlW.writeStartElement(null,'CreatedEmailAddress',null);
                xmlW.writeAttribute(null,null,'id','28');
                xmlW.writeCharacters(loggedInUser.Email);
            xmlW.writeEndElement(); //Close Created Email Attribute
        }

        // Current type of fields
        // Current User attribute
        if(loggedInUser.Id!=null){
            xmlW.writeStartElement(null,'CurrentPerson',null);
                xmlW.writeAttribute(null,null,'id','11');
                xmlW.writeCharacters(loggedInUser.Id);
            xmlW.writeEndElement(); //Close Current User ID
        }          

        // Current Branch attribute
        if(loggedInUser.Location__c!=null){
            xmlW.writeStartElement(null,'CurrentBranch',null);
                xmlW.writeAttribute(null,null,'id','12');
                xmlW.writeCharacters(loggedInUser.Location__c);
            xmlW.writeEndElement(); //Close Current Branch
        }          

        // Current Channel attribute
        if(loggedInUser.Channel__c!=null){
            xmlW.writeStartElement(null,'CurrentChannel',null);
                xmlW.writeAttribute(null,null,'id','13');
                xmlW.writeCharacters(loggedInUser.Channel__c);
            xmlW.writeEndElement(); //Close Current Channel
        }

        // Current Email Attribute
        if(loggedInUser.Email!=null){
            xmlW.writeStartElement(null,'CurrentEmailAddress',null);
                xmlW.writeAttribute(null,null,'id','29');
                xmlW.writeCharacters(loggedInUser.Email);
            xmlW.writeEndElement(); //Close Current Email Attribute
        }

        // Application Status  attribute
        xmlW.writeStartElement(null,'ApplicationStatus',null);
            xmlW.writeAttribute(null,null,'id','18');
            xmlW.writeCharacters('Open');
        xmlW.writeEndElement(); //Close Application Status
        
        xmlW.writeEndElement(); //Close SERVICE
        xmlW.writeEndDocument(); //Close XML document
        system.debug('The site url is '+SiteUrl__c.getOrgDefaults().Url__c);
        String xmlStringxmlRes = xmlW.getXmlString();
        //ApexPages.currentPage().getParameters().put('xmldata','<?xml version="1.0" encoding="utf-8"?><SERVICE version="1.0"><CreatedByUserId id="8">loggedInID</CreatedByUserId><CreatedByBranch id="9">Palo Alto - CA</CreatedByBranch><CreatedByChannel id="10">Branch</CreatedByChannel><CreatedEmailAddress id="28">vsakhineti@terafinainc.com</CreatedEmailAddress><CurrentPerson id="11">005o0000000RWpC</CurrentPerson><CurrentBranch id="12">Palo Alto - CA</CurrentBranch><CurrentChannel id="13">Branch</CurrentChannel><CurrentEmailAddress id="29">vsakhineti@terafinainc.com</CurrentEmailAddress><ApplicationStatus id="18">Open</ApplicationStatus></SERVICE>');
        ApexPages.currentPage().getParameters().put('xmldata',xmlStringxmlRes);
        ProductController npc = new ProductController();
        npc.AccountType();
            
    }
    
    @isTest static void test_method_two() {
        testLoadData();
        PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('pd',Product_Names_Mapping__c.getValues('Savings').Product_Name__c);
        ApexPages.currentPage().getParameters().put('spd',Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c);
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
        ApexPages.currentPage().getParameters().put('id',app.Id);
        ProductController npc = new ProductController();
        npc.getProduct();
        npc.getSubProduct();
        npc.AccountType();
    }

    @isTest static void test_method_three() {
        testLoadData();
        PageReference p = Page.ProductPage;
        Promotion__c promo = new Promotion__c();
        promo.CampaignID__c = 'ABCD';
        promo.Description__c = 'test';
        insert promo;
        Product_Codes__c pc = new Product_Codes__c();
        pc.Name = 'BCDB';
        pc.Product__c = 'Business CDs';
        pc.Sub_Product__c = 'Business CDs - Basic';
        insert pc;
        Test.setCurrentPage(p);
        //ApexPages.currentPage().getParameters().put('pd',Product_Names_Mapping__c.getValues('Savings').Product_Name__c);
        ApexPages.currentPage().getParameters().put('spd',pc.Name);
        ApexPages.currentPage().getParameters().put('pid',promo.id);
        //ApexPages.currentPage().getParameters().put('xmldata','<?xml version="1.0" encoding="utf-8"?><SERVICE version="1.0"><CreatedByUserId id="8">005o0000000RWpC</CreatedByUserId><CreatedByBranch id="9">Palo Alto - CA</CreatedByBranch><CreatedByChannel id="10">Branch</CreatedByChannel><CreatedEmailAddress id="28">vsakhineti@terafinainc.com</CreatedEmailAddress><CurrentPerson id="11">005o0000000RWpC</CurrentPerson><CurrentBranch id="12">Palo Alto - CA</CurrentBranch><CurrentChannel id="13">Branch</CurrentChannel><CurrentEmailAddress id="29">vsakhineti@terafinainc.com</CurrentEmailAddress><ApplicationStatus id="18">Open</ApplicationStatus></SERVICE>');
        ProductController npc = new ProductController();
        npc.getProduct();
        npc.getSubProduct();
        npc.AccountType();
            
    }

    @isTest static void test_method_four() {
        testLoadData();
        PageReference p = Page.ProductPage;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('pd',Product_Names_Mapping__c.getValues('Savings').Product_Name__c);
        ApexPages.currentPage().getParameters().put('spd',Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c);
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
        Product_Codes__c pc = new Product_Codes__c();
        pc.Name = 'BCDB';
        pc.Product__c = 'Business CDs';
        pc.Sub_Product__c = 'Business CDs - Basic';
        insert pc;
        ApexPages.currentPage().getParameters().put('id',app.Id);
        ApexPages.currentPage().getParameters().put('spd',pc.Name);
        ProductController npc = new ProductController();
        npc.getProduct();
        npc.getSubProduct();
        npc.AccountType();
    }
    
}