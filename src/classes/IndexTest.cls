/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class IndexTest {   

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
            /*List<sObject> customerDataForTestClasses=Test.loadData(Customer__c.sObjectType,'CustomerDataForTestClasses');
            List<sObject> customerAccountsDataForTestClasses=Test.loadData(Customer_Account__c.sObjectType,'CustomerAccountsDataForTestClasses');
            List<sObject> existingAccountsDataForTestClasses=Test.loadData(Existing_Account__c.sObjectType,'ExistingAccountsDataForTestClasses');
            List<sObject> productCodesForTestClasses=Test.loadData(Product_Codes__c.sObjectType,'productCodesForTestClasses');*/
            //List<sObject> applicationConfigForTestClass=Test.loadData(Application_Configuration__c.sObjectType,'ApplicationConfigForTestClass');
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

    static testMethod void myUnitTest() {
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        Application_Activity__c appAccA = (Application_Activity__c)objects.get(5);
        app.Application_Page__c='IndexPage';
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        update app; 
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        String pageName='IndexPage';
        Index.handleRequest(testData,pageName);
        System.assertEquals('Test',app.First_Name__c);
    }// end of Index method

    static testMethod void indexPageSystemLabelsTest(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='IndexPage';
        update app;
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        String pageName='IndexPage';
        //IndexUtilityExtension.getSystemLabels(testData);
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void getStartedPagePost(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='GetStartedPage';
        update app;  
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        testData.put('Application__c.First_Name__c','Test');
        testData.put('Application__c.Last_Name__c','CLass');
        testData.put('Application__c.Email_Address__c','class@chedella.com');
        testData.put('Application__c.Primary_Phone_Number__c','8337896754');
        Index.handleRequest(testData,'GetStartedPage'); 
        System.assertEquals('Test',app.First_Name__c);
    } // end of get started method
    
    static testMethod void crossSellPage1(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='CrossSellPage';
        app.Product__c=Product_Names_Mapping__c.getValues('Checking').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c;
        update app;  
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('SavingsSubProduct3').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c);
        testData.put('debug','true');
        Index.handleRequest(testData,'CrossSellPage');
        app.Product__c=Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        update app;
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('SavingsSubProduct3').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');        
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void crossSellPage2(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='CrossSellPage';
        app.Product__c=Product_Names_Mapping__c.getValues('Certificates').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c;
        update app;  
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('SavingsSubProduct3').Client_Product_Name__c);
        testData.put('debug','true');
        Index.handleRequest(testData,'CrossSellPage');
        app.Product__c=Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('HomeLoanSubProduct1').Client_Product_Name__c;
        update app;
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('HomeEquitySubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');  
        System.assertEquals('Test',app.First_Name__c);                        
    }
                     
    static testMethod void crossSellPage3(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='CrossSellPage';
        app.Product__c=Product_Names_Mapping__c.getValues('Savings').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct3').Client_Product_Name__c;
        update app;
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');
        app.Product__c=Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        update app;
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('HomeEquitySubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('HomeLoanSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    static testMethod void crossSellPage4(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='CrossSellPage';
        app.Product__c=Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('HomeEquitySubProduct1').Client_Product_Name__c;
        update app;
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('HomeLoanSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c);

        Index.handleRequest(testData,'CrossSellPage');
        app.Product__c=Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c;
        update app;
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('HomeEquitySubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('HomeLoanSubProduct1').Client_Product_Name__c);
        TestData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');            
        System.assertEquals('Test',app.First_Name__c);
    }
    
    // Having Business Accounts
    static testMethod void crossSellPage5(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='CrossSellPage';
        app.Product__c=Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('BusinessCheckingSubProduct1').Client_Product_Name__c;
        update app;
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('BusinessCDSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('BusinessCreditCardsSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');
        
        app.Product__c=Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('BusinessSavingsSubProduct1').Client_Product_Name__c;
        update app;
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('BusinessCheckingSubProduct2').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('BusinessCreditCardsSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');
        
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void crossSellPage6(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='CrossSellPage';
        app.Product__c=Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('BusinessCreditCardsSubProduct1').Client_Product_Name__c;
        update app;
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('BusinessCDSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');
        
        app.Product__c=Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('BusinessSavingsSubProduct1').Client_Product_Name__c;
        update app;
        testData.put('Application__c.Primary_Offer__c',Test_Class_Product_Names__c.getValues('BusinessCheckingSubProduct2').Client_Product_Name__c);
        testData.put('Application__c.Second_Offer__c',Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Third_Offer__c',Test_Class_Product_Names__c.getValues('BusinessSavingsSubProduct1').Client_Product_Name__c);
        Index.handleRequest(testData,'CrossSellPage');
        
        System.assertEquals('Test',app.First_Name__c);
    }   
                  
    static testMethod void personalInfoPage(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='PersonalInfoPage';
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        testData.put('Application__c.First_Name__c','Test');
        testData.put('Application__c.Last_Name__c','Class');
        testData.put('Application__c.Street_Address_1__c','1200 Test');
        testData.put('Application__c.Street_Address_2__c','Street');
        testData.put('Application__c.City__c','testcity');
        testData.put('Application__c.State__c','CA');
        testData.put('Application__c.Zip_code__c','12512');
        testData.put('Application__c.Street_Address_1_Prev__c','Test previous');
        testData.put('Application__c.Street_Address_2_Prev__c','Test Previous2');
        testData.put('Application__c.City_Prev__c','testprevcity');
        testData.put('Application__c.State_Prev__c','CA');
        testData.put('Application__c.Zip_Code_Prev__c','12441');
        testData.put('Application__c.Housing_Status__c','Own');
        testData.put('Application__c.Monthly_Payment__c','123');
        testData.put('Application__c.Marital_Status_J__c','test');
        testData.put('Application__c.Years__c','1.0');
        testData.put('Application__c.Months__c','1');
        testData.put('Application__c.Primary_Phone_Number__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number__c','9814981204');
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J__c','Test');
        testData.put('Application__c.Middle_Name_J__c','Test');
        testData.put('Application__c.Last_Name_J__c','Test');
        testData.put('Application__c.Suffix_J__c','Mr.');
        testData.put('Application__c.Street_Address_J__c','1200 Test');
        testData.put('Application__c.Street_Address_2_J__c','Street');
        testData.put('Application__c.City_J__c','testcity');
        testData.put('Application__c.State_J__c','CA');
        testData.put('Application__c.Zip_code_J__c','12512');
        testData.put('Application__c.Street_Address_1_JP__c','Test previous');
        testData.put('Application__c.Street_Address_2_JP__c','Test Previous2');
        testData.put('Application__c.City_JP__c','testprevcity');
        testData.put('Application__c.State_JP__c','CA');
        testData.put('Application__c.Zip_Code_JP__c','12441');
        testData.put('Application__c.Housing_Status_J__c','Own');
        testData.put('Application__c.Monthly_Payment_J__c','123');
        testData.put('Application__c.Marital_Status_J__c','test');
        testData.put('Application__c.Years_J__c','1.0');
        testData.put('Application__c.Months_J__c','1.0');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J1__c','test');
        testData.put('Application__c.Email_Address_J__c','vamsi023@gmail.com');
        testData.put('Application__c.Primary_Phone_Number_J__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number_J__c','9814981204');
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J2__c','test');
        testData.put('Application__c.Middle_Name_J2__c','test');
        testData.put('Application__c.Last_Name_J2__c','test');
        testData.put('Application__c.Suffix_J2__c','Jr.');
        testData.put('Application__c.Street_Address_1_J2__c','testok');
        testData.put('Application__c.Street_Address_2_J2__c','testok');
        testData.put('Application__c.City_J2__c','casl');
        testData.put('Application__c.State_J2__c','CA');
        testData.put('Application__c.Zip_code_J2__c','12512');
        testData.put('Application__c.Street_Address_1_JP2__c','Test previous');
        testData.put('Application__c.Street_Address_2_JP2__c','Test Previous2');
        testData.put('Application__c.City_JP2__c','testprevcity');
        testData.put('Application__c.State_JP2__c','CA');
        testData.put('Application__c.Zip_Code_JP2__c','12441');
        testData.put('Application__c.Housing_Status_J2__c','Own');
        testData.put('Application__c.Monthly_Payment_J2__c','123');
        testData.put('Application__c.Marital_Status_J2__c','test');
        testData.put('Application__c.Years_J2__c','1.0');
        testData.put('Application__c.Months_J2__c','1');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J2__c','test');
        testData.put('Application__c.Email_Address_J2__c','vamsi023@gmail.com');
        testData.put('Application__c.Primary_Phone_Number_J2__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number_J2__c','9814981204');
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J3__c','test');
        testData.put('Application__c.Middle_Name_J3__c','test');
        testData.put('Application__c.Last_Name_J3__c','test');
        testData.put('Application__c.Suffix_J3__c','Jr.');
        testData.put('Application__c.Street_Address_1_J3__c','testok');
        testData.put('Application__c.Street_Address_2_J3__c','testok');
        testData.put('Application__c.City_J3__c','casl');
        testData.put('Application__c.State_J3__c','CA');
        testData.put('Application__c.Zip_code_J3__c','12512');
        testData.put('Application__c.Street_Address_1_JP3__c','Test previous');
        testData.put('Application__c.Street_Address_2_JP3__c','Test Previous2');
        testData.put('Application__c.City_JP3__c','testprevcity');
        testData.put('Application__c.State_JP3__c','CA');
        testData.put('Application__c.Zip_Code_JP3__c','12441');
        testData.put('Application__c.Housing_Status_J3__c','Own');
        testData.put('Application__c.Monthly_Payment_J3__c','123');
        testData.put('Application__c.Marital_Status_J3__c','test');
        testData.put('Application__c.Years_J3__c','1');
        testData.put('Application__c.Months_J3__c','1');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J3__c','test');
        testData.put('Application__c.Email_Address_J3__c','vamsi023@gmail.com');
        testData.put('Application__c.Primary_Phone_Number_J3__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number_JP3__c','9814981204');
        String pageName='PersonalInfoPage';
        Index.handleRequest(testData, pageName);
        System.assertEquals('Test',app.First_Name__c);
    } // end of personal info method
    
    static testMethod void employmentInfoPage(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='EmploymentPage';
        update app;
        
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        testData.put('Employment_Information__c.Employment_Status__c','Full Time');
        testData.put('Employment_Information__c.Employer__c','Class');
        testData.put('Employment_Information__c.Occupation__c','Test');
        testData.put('Employment_Information__c.Prior_Occupation__c','Test1');
        testData.put('Employment_Information__c.Years_Emp__c','1');
        testData.put('Employment_Information__c.Months_Emp__c','1');
        testData.put('Employment_Information__c.Employer_P__c','Test');
        testData.put('Employment_Information__c.Occupation_P__c','Test1');
        testData.put('Employment_Information__c.Annual_Income__c','12512');
        testData.put('Employment_Information__c.Other_Income_Picklist__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5__c','Social Security');
        testData.put('Employment_Information__c.Other_Income__c','123');
        testData.put('Employment_Information__c.Other_Income2__c','123');
        testData.put('Employment_Information__c.Other_Income3__c','123');
        testData.put('Employment_Information__c.Other_Income4__c','123');
        testData.put('Employment_Information__c.Other_Income5__c','123');
        //First joint Applicant 
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Employment_Information__c.Employment_Status_J1__c','Full Time');
        testData.put('Employment_Information__c.Employer_J1__c','Ganesh');
        testData.put('Employment_Information__c.Occupation__J1_c','Test');
        testData.put('Employment_Information__c.Prior_Occupation_J1__c','Test1');
        testData.put('Employment_Information__c.Years_EmpJ1__c','1');
        testData.put('Employment_Information__c.Months_EmpJ1__c','1');
        testData.put('Employment_Information__c.Employer_JP1__c','Test');
        testData.put('Employment_Information__c.Occupation_JP1__c','Test1');
        testData.put('Employment_Information__c.Annual_Income_J1__c','12512');
        testData.put('Employment_Information__c.Other_Income_Picklist1_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_J1__c','123');
        testData.put('Employment_Information__c.Other_Income2_J1__c','123');
        testData.put('Employment_Information__c.Other_Income3_J1__c','123');
        testData.put('Employment_Information__c.Other_Income4_J1__c','123');
        testData.put('Employment_Information__c.Other_Income5_J1__c','123');
        //Second Joint Applicant
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Employment_Information__c.Employment_Status_J2__c','Full Time');
        testData.put('Employment_Information__c.Employer_J2__c','Class');
        testData.put('Employment_Information__c.Occupation__J2_c','Test');
        testData.put('Employment_Information__c.Prior_Occupation_J2__c','Test2');
        testData.put('Employment_Information__c.Years_EmpJ2__c','2');
        testData.put('Employment_Information__c.Months_EmpJ2__c','2');
        testData.put('Employment_Information__c.Employer_JP2__c','Test');
        testData.put('Employment_Information__c.Occupation_JP2__c','Test2');
        testData.put('Employment_Information__c.Annual_Income_J2__c','22522');
        testData.put('Employment_Information__c.Other_Income_Picklist1_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_J2__c','223');
        testData.put('Employment_Information__c.Other_Income2_J2__c','223');
        testData.put('Employment_Information__c.Other_Income3_J2__c','223');
        testData.put('Employment_Information__c.Other_Income4_J2__c','223');
        testData.put('Employment_Information__c.Other_Income5_J2__c','123');
        //Third Joint Applicant
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        testData.put('Employment_Information__c.Employment_Status_J3__c','Full Time');
        testData.put('Employment_Information__c.Employer_J3__c','Ganesh');
        testData.put('Employment_Information__c.Occupation__J3_c','Test');
        testData.put('Employment_Information__c.Prior_Occupation_J3__c','Test3');
        testData.put('Employment_Information__c.Years_EmpJ3__c','3');
        testData.put('Employment_Information__c.Months_EmpJ3__c','3');
        testData.put('Employment_Information__c.Employer_JP3__c','Test');
        testData.put('Employment_Information__c.Occupation_JP3__c','Test3');
        testData.put('Employment_Information__c.Annual_Income_J3__c','32532');
        testData.put('Employment_Information__c.Other_Income_Picklist1_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_J3__c','323');
        testData.put('Employment_Information__c.Other_Income2_J3__c','323');
        testData.put('Employment_Information__c.Other_Income3_J3__c','323');
        testData.put('Employment_Information__c.Other_Income4_J3__c','323');
        testData.put('Employment_Information__c.Other_Income5_J3__c','123');
        Index.handleRequest(testData,'EmploymentPage');
        System.assertEquals('Test',app.First_Name__c);
    }
        
    static testMethod void identityPage(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='IdentityPage';
        update app;
        
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        testData.put('Identity_Information__c.ID_Type__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_Primary__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued__c','CA');
        testData.put('Identity_Information__c.Issue_Date__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date__c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_Prime__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship__c','US Citizen');
        testData.put('Identity_Information__c.Country_of_Citizenship__c','India');
        //First joint Applicant 
        testData.put('Identity_Information__c.ID_Type_J1__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_J1__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued_J1__c','CA');
        testData.put('Identity_Information__c.Issue_Date_J1__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date_J1__c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth_J1__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_J1__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship_J1__c','US Citizen');
        testData.put('Identity_Information__c.Country_of_Citizenship_J1__c','India');
        //Second Joint Applicant
        testData.put('Identity_Information__c.ID_Type_J2__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_J2__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued_J2__c','CA');
        testData.put('Identity_Information__c.Issue_Date_J2__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date__J2_c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth_J2__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_J2__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship_J2__c','US Citizen');
        testData.put('Identity_Information__c.Country_of_Citizenship_J2__c','India');
        //Third Joint Applicant
        testData.put('Identity_Information__c.ID_Type_J3__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_J3__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued_J3__c','CA');
        testData.put('Identity_Information__c.Issue_Date_J3__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date_J3__c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth_J3__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_J3__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship_J3__c','Immigrant');
        testData.put('Identity_Information__c.Country_of_Citizenship_J3__c','India');

        Index.handleRequest(testData, 'IdentityPage');
        System.assertEquals('Test',app.First_Name__c);      
    }
    // vamsi's code for employment and identity validations
    static testMethod void employmentPageNullValues(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Application_Page__c='EmploymentInfoPage';
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        
         testData.put('Employment_Information__c.Employment_Status__c','');
        testData.put('Employment_Information__c.Employer__c','');
        testData.put('Employment_Information__c.Occupation__c','');
        testData.put('Employment_Information__c.Prior_Occupation__c','');
        testData.put('Employment_Information__c.Years_Emp__c','');
        testData.put('Employment_Information__c.Annual_Income__c','');

        //First joint Applicant 
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Employment_Information__c.Employment_Status_J1__c','');
        testData.put('Employment_Information__c.Employer_J1__c','');
        testData.put('Employment_Information__c.Occupation__J1_c','');
        testData.put('Employment_Information__c.Prior_Occupation_J1__c','');
        testData.put('Employment_Information__c.Years_EmpJ1__c','');
        testData.put('Employment_Information__c.Annual_Income_J1__c','asd');

        //Second Joint Applicant
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Employment_Information__c.Employment_Status_J2__c','');
        testData.put('Employment_Information__c.Employer_J2__c','');
        testData.put('Employment_Information__c.Occupation__J2_c','');
        testData.put('Employment_Information__c.Prior_Occupation_J2__c','');
        testData.put('Employment_Information__c.Years_EmpJ2__c','');
        testData.put('Employment_Information__c.Annual_Income_J2__c','asd');

        //Third Joint Applicant
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        testData.put('Employment_Information__c.Employment_Status_J3__c','');
        testData.put('Employment_Information__c.Employer_J3__c','');
        testData.put('Employment_Information__c.Occupation__J3_c','');
        testData.put('Employment_Information__c.Prior_Occupation_J3__c','');
        testData.put('Employment_Information__c.Years_EmpJ3__c','');
        testData.put('Employment_Information__c.Annual_Income_J3__c','asd');

        String pageName='EmploymentPage';
        Index.handleRequest(testData, pageName);
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void identityPageNullValues(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Application_Page__c='EmploymentInfoPage';
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        
        testData.put('Identity_Information__c.ID_Type__c','');
        testData.put('Identity_Information__c.Identity_Number_Primary__c','');
        testData.put('Identity_Information__c.State_Issued__c','');
        testData.put('Identity_Information__c.Issue_Date__c','');
        testData.put('Identity_Information__c.Expiry_Date__c','');
        testData.put('Identity_Information__c.Date_of_Birth__c','');
        testData.put('Identity_Information__c.SSN_Prime__c','');
        testData.put('Identity_Information__c.Citizenship__c','');
        testData.put('Identity_Information__c.Country_of_Citizenship__c','');
        //First joint Applicant 
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Identity_Information__c.ID_Type_J1__c','');
        testData.put('Identity_Information__c.Identity_Number_J1__c','');
        testData.put('Identity_Information__c.State_Issued_J1__c','');
        testData.put('Identity_Information__c.Issue_Date_J1__c','');
        testData.put('Identity_Information__c.Expiry_Date_J1__c','');
        testData.put('Identity_Information__c.Date_of_Birth_J1__c','');
        testData.put('Identity_Information__c.SSN_J1__c','');
        testData.put('Identity_Information__c.Citizenship_J1__c','');
        testData.put('Identity_Information__c.Country_of_Citizenship_J1__c','');
        //Second Joint Applicant
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Identity_Information__c.ID_Type_J2__c','');
        testData.put('Identity_Information__c.Identity_Number_J2__c','');
        testData.put('Identity_Information__c.State_Issued_J2__c','');
        testData.put('Identity_Information__c.Issue_Date_J2__c','');
        testData.put('Identity_Information__c.Expiry_Date__J2_c','');
        testData.put('Identity_Information__c.Date_of_Birth_J2__c','');
        testData.put('Identity_Information__c.SSN_J2__c','');
        testData.put('Identity_Information__c.Citizenship_J2__c','');
        testData.put('Identity_Information__c.Country_of_Citizenship_J2__c','');
        //Third Joint Applicant
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        testData.put('Identity_Information__c.ID_Type_J3__c','');
        testData.put('Identity_Information__c.Identity_Number_J3__c','');
        testData.put('Identity_Information__c.State_Issued_J3__c','');
        testData.put('Identity_Information__c.Issue_Date_J3__c','');
        testData.put('Identity_Information__c.Expiry_Date_J3__c','');
        testData.put('Identity_Information__c.Date_of_Birth_J3__c','');
        testData.put('Identity_Information__c.SSN_J3__c','');
        testData.put('Identity_Information__c.Citizenship_J3__c','');
        testData.put('Identity_Information__c.Country_of_Citizenship_J3__c','');

        String pageName='IdentityPage';
        Index.handleRequest(testData, pageName);
        System.assertEquals('Test',app.First_Name__c);
    }
    
    // Property Details and Purchase details
    static testMethod void purchasedetailspage(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        About_Account__c acc=(About_Account__c)objects.get(3);
        app.Application_Page__c='IndexPage';
        app.Product__c=Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('HomeLoanSubProduct1').Client_Product_Name__c;
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c; 
        update app; 
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        
        // fields from Purchase Details page

        testData.put('About_Account__c.Mortgage_Applied_For__c','Conventional');
        testData.put('About_Account__c.MortgageType_Other__c','Conventional');
        testData.put('About_Account__c.Purpose_Of_Loan__c','Other');
        testData.put('About_Account__c.MortgagePurchasePurpose_Other__c','test');
        testData.put('About_Account__c.Purchase_P__c','1200');
        testData.put('About_Account__c.Down_Payment__c','234');
        testData.put('About_Account__c.Total_Loan_Amount__c','123456');
        testData.put('About_Account__c.Monthly__c','23');
        testData.put('About_Account__c.Monthly_Insurance__c','12');
        testData.put('About_Account__c.Program_Description_2__c','Fixed 30 Year');
        testData.put('About_Account__c.Discount_Pt_Buy_down_2__c','2');
        
        String pageName='PurchaseDetailsPage';
        Index.handleRequest(testData, pageName);
        System.assertEquals('Test',app.First_Name__c); 
    }
    
    static testMethod void purchasedetailspage_null(){
        testLoadData();
        Application__c app=new Application__c();
        app.Product__c=Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('HomeLoanSubProduct1').Client_Product_Name__c;
        app.First_Name__c='Test';
        app.Last_Name__c='Class';
        insert app;
        Employment_Information__c emp=new Employment_Information__c();
        Identity_Information__c iden=new Identity_Information__c();
        About_Account__c acc=new About_Account__c();
        About_Account__c acc2=new About_Account__c();
        Application2__c app2=new Application2__c();
        emp.Application__c=app.Id;
        iden.Application__c=app.Id;
        
        acc.Application__c=app.Id;
        acc.Options__c = 'New Address';
        acc.Occupancy__c = 'Investment';
        acc.Property_Type__c='High-rise Condo ( 5 or more Stories)';
        app2.Application__c=app.Id;
        
        acc2.Application__c=app.Id;
        acc2.Mortgage_Applied_For__c = 'Other';
        acc2.Purpose_Of_Loan__c = 'Other';
        
        insert emp;
        insert iden;
        insert acc;
        insert acc2;
        insert app2;
        
        app.Application_Page__c='IndexPage';
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        update app; 
        
        Boolean b1 = IndexValidationExtension.isDataValid(app,'PurchaseDetailsPage',app2,emp,iden,acc); 
        Boolean b2 = IndexValidationExtension.isDataValid(app,'PurchaseDetailsPage',app2,emp,iden,acc2);
        Boolean b3 = IndexValidationExtension.isDataValid(app,'PropertyDetailsPage',app2,emp,iden,acc); 
        Boolean b4 = IndexValidationExtension.isDataValid(app,'PropertyDetailsPage',app2,emp,iden,acc2);
        System.assertEquals('Test',app.First_Name__c);    
    }
    static testMethod void declarationsPageNullValues(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Application_Page__c='DeclarationsPage';
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        // Primary Applicant
        testData.put('Application2__c.hmda_info_pa__c', 'false');
        testData.put('Application2__c.HMDA_Sex_PA__c,', '');
        testData.put('Application2__c.HMDA_Ethinicity_PA__c,', '');
        testData.put('Application2__c.HMDA_Race_PA__c', '');
        testData.put('Application2__c.qa_explanation_primapp__c', '');
        testData.put('Application2__c.qa_primapp__c', 'true');
        testData.put('Application2__c.qb_explanation_primapp__c', '');
        testData.put('Application2__c.qb_primapp__c', 'true');
        testData.put('Application2__c.qc_explanation_primapp__c', '');
        testData.put('Application2__c.qc_primapp__c', 'true');
        testData.put('Application2__c.qd_explanation_primapp__c', '');
        testData.put('Application2__c.qd_primapp__c', 'true');
        testData.put('Application2__c.qe_explanation_primapp__c', '');
        testData.put('Application2__c.qe_primapp__c', 'true');
        testData.put('Application2__c.qf_explanation_primapp__c', '');
        testData.put('Application2__c.qf_primapp__c', 'true');
        testData.put('Application2__c.qg_explanation_primapp__c', '');
        testData.put('Application2__c.qg_primapp__c', 'true');
        testData.put('Application2__c.qh_explanation_primapp__c', '');
        testData.put('Application2__c.qh_primapp__c', 'true');
        testData.put('Application2__c.qi_explanation_primapp__c', '');
        testData.put('Application2__c.qi_primapp__c', 'true');
        testData.put('Application2__c.qj_primapp__c', '');
        testData.put('Application2__c.qk_primapp__c', '');
        testData.put('Application2__c.ql_primapp__c', '');
        testData.put('Application2__c.qm_primapp__c', '');
        
        // First Joint Applicant
        testData.put('Application2__c.hmda_info_J1__c', 'false');
        testData.put('Application2__c.HMDA_Sex_J1__c,', '');
        testData.put('Application2__c.HMDA_Ethinicity_J1__c,', '');
        testData.put('Application2__c.HMDA_Race_J1__c', '');
        testData.put('Application2__c.qa_explanation_JP1__c', '');
        testData.put('Application2__c.qa_JP1__c', 'true');
        testData.put('Application2__c.qb_explanation_JP1__c', '');
        testData.put('Application2__c.qb_JP1__c', 'true');
        testData.put('Application2__c.qc_explanation_JP1__c', '');
        testData.put('Application2__c.qc_JP1__c', 'true');
        testData.put('Application2__c.qd_explanation_JP1__c', '');
        testData.put('Application2__c.qd_JP1__c', 'true');
        testData.put('Application2__c.qe_explanation_JP1__c', '');
        testData.put('Application2__c.qe_JP1__c', 'true');
        testData.put('Application2__c.qf_explanation_JP1__c', '');
        testData.put('Application2__c.qf_JP1__c', 'true');
        testData.put('Application2__c.qg_explanation_JP1__c', '');
        testData.put('Application2__c.qg_JP1__c', 'true');
        testData.put('Application2__c.qh_explanation_JP1__c', '');
        testData.put('Application2__c.qh_JP1__c', 'true');
        testData.put('Application2__c.qi_explanation_JP1__c', '');
        testData.put('Application2__c.qi_JP1__c', 'true');
        testData.put('Application2__c.qj_JP1__c', '');
        testData.put('Application2__c.qk_JP1__c', '');
        testData.put('Application2__c.ql_JP1__c', '');
        testData.put('Application2__c.qm_JP1__c', '');
        
        // Second Joint Applicant
        testData.put('Application2__c.hmda_info_J2__c', 'false');
        testData.put('Application2__c.HMDA_Sex_J2__c,', '');
        testData.put('Application2__c.HMDA_Ethinicity_J2__c,', '');
        testData.put('Application2__c.HMDA_Race_J2__c', '');
        testData.put('Application2__c.qa_explanation_JP2__c', '');
        testData.put('Application2__c.qa_JP2__c', 'true');
        testData.put('Application2__c.qb_explanation_JP2__c', '');
        testData.put('Application2__c.qb_JP2__c', 'true');
        testData.put('Application2__c.qc_explanation_JP2__c', '');
        testData.put('Application2__c.qc_JP2__c', 'true');
        testData.put('Application2__c.qd_explanation_JP2__c', '');
        testData.put('Application2__c.qd_JP2__c', 'true');
        testData.put('Application2__c.qe_explanation_JP2__c', '');
        testData.put('Application2__c.qe_JP2__c', 'true');
        testData.put('Application2__c.qf_explanation_JP2__c', '');
        testData.put('Application2__c.qf_JP2__c', 'true');
        testData.put('Application2__c.qg_explanation_JP2__c', '');
        testData.put('Application2__c.qg_JP2__c', 'true');
        testData.put('Application2__c.qh_explanation_JP2__c', '');
        testData.put('Application2__c.qh_JP2__c', 'true');
        testData.put('Application2__c.qi_explanation_JP2__c', '');
        testData.put('Application2__c.qi_JP2__c', 'true');
        testData.put('Application2__c.qj_JP2__c', '');
        testData.put('Application2__c.qk_JP2__c', '');
        testData.put('Application2__c.ql_JP2__c', '');
        testData.put('Application2__c.qm_JP2__c', '');
        
        // Third Joint Applicant
        testData.put('Application2__c.hmda_info_J3__c', 'false');
        testData.put('Application2__c.HMDA_Sex_J3__c,', '');
        testData.put('Application2__c.HMDA_Ethinicity_J3__c,', '');
        testData.put('Application2__c.HMDA_Race_J3__c', '');
        testData.put('Application2__c.qa_explanation_JP3__c', '');
        testData.put('Application2__c.qa_JP3__c', 'true');
        testData.put('Application2__c.qb_explanation_JP3__c', '');
        testData.put('Application2__c.qb_JP3__c', 'true');
        testData.put('Application2__c.qc_explanation_JP3__c', '');
        testData.put('Application2__c.qc_JP3__c', 'true');
        testData.put('Application2__c.qd_explanation_JP3__c', '');
        testData.put('Application2__c.qd_JP3__c', 'true');
        testData.put('Application2__c.qe_explanation_JP3__c', '');
        testData.put('Application2__c.qe_JP3__c', 'true');
        testData.put('Application2__c.qf_explanation_JP3__c', '');
        testData.put('Application2__c.qf_JP3__c', 'true');
        testData.put('Application2__c.qg_explanation_JP3__c', '');
        testData.put('Application2__c.qg_JP3__c', 'true');
        testData.put('Application2__c.qh_explanation_JP3__c', '');
        testData.put('Application2__c.qh_JP3__c', 'true');
        testData.put('Application2__c.qi_explanation_JP3__c', '');
        testData.put('Application2__c.qi_JP3__c', 'true');
        testData.put('Application2__c.qj_JP3__c', '');
        testData.put('Application2__c.qk_JP3__c', '');
        testData.put('Application2__c.ql_JP3__c', '');
        testData.put('Application2__c.qm_JP3__c', '');

        Index.handleRequest(testData,'DeclarationsPage');        
        Index.handleRequest(testData,'PropertyDetailsPage');
        Index.handleRequest(testData,'PurchaseDetailsPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    static testMethod void reviewSubmitPageNullValues(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        Application_Activity__c accAct = (Application_Activity__c)objects.get(5);
        app.Application_Page__c='ReviewSubmitPage'; 
        update app;
        Map<String,sObject> sObjects = new Map<String,sObject>();
        sObjects.put('Application__c',app);
        sObjects.put('Application2__c',app2);
        sObjects.put('Employment_Information__c',emp);
        sObjects.put('Identity_Information__c',iden);
        sObjects.put('About_Account__c',acc);
        sObjects.put('Application_Activity__c',accAct);

        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.years__c','1');
        testData.put('Application__c.years_j__c','1');
        testData.put('Application__c.years_j2__c','1');
        testData.put('Application__c.years_j3__c','1');
        testData.put('Application__c.years_emp__c','1');
        testData.put('Application__c.years_empj1__c','1');
        testData.put('Application__c.years_empj2__c','1');
        testData.put('Application__c.years_empj3__c','1');
        testData.put('About_Account__c.funding_type_chk__c','Add External Accounts');
        testData.put('About_Account__c.funding_type_sav__c','Add External Accounts');
        testData.put('About_Account__c.funding_type_cert__c','Add External Accounts');
        testData.put('About_Account__c.Property_Type__c','High-rise Condo ( 5 or more Stories)');
        testData.put('About_Account__c.Occupancy__c','Investment');
        testData.put('About_Account__c.HE_Property_Type__c','High-rise Condo ( 5 or more Stories)');

        // Calling Utility class to get fields to be rendered
        Utility u = new Utility();
        Set<String> fieldsToBeDisplayed = u.fieldsToRender(app.Id);

        IndexUtilityExtension.getPageVars(testData,'ReviewSubmitPage',fieldsToBeDisplayed,sObjects);

        System.assertEquals('Test',app.First_Name__c);
    }
    //  ReviewSubmit page
    static testMethod void reviewSubmitPage() {
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        Application_Activity__c accAct = (Application_Activity__c)objects.get(5);
        app.Application_Page__c='ReviewSubmitPage'; 
        update app;
        List<Disclosure__c> discList = new List<Disclosure__c>();

        Disclosure__c d1 = new Disclosure__c();
        d1.Name = 'E-Sign';
        discList.add(d1);

        Disclosure__c d2 = new Disclosure__c();
        d2.Name = 'Visa Disclosure';
        discList.add(d2);

        Disclosure__c d3 = new Disclosure__c();
        d3.Name = 'privacy_policy';
        discList.add(d3);

        Disclosure__c d4 = new Disclosure__c();
        d4.Name = 'Truth in_Savings';
        discList.add(d4);

        Disclosure__c d5 = new Disclosure__c();
        d5.Name = 'HANDBOOK_ON_ARM_MORTGAGES';
        discList.add(d5);

        Disclosure__c d6 = new Disclosure__c();
        d6.Name = 'CD_truth in savings_Certificates';
        discList.add(d6);

        Disclosure__c d7 = new Disclosure__c();
        d7.Name = 'Membership Agreement';
        discList.add(d7);

        Disclosure__c d8 = new Disclosure__c();
        d8.Name = 'Lien on Shares Authorization';
        discList.add(d8);

        Disclosure__c d9 = new Disclosure__c();
        d9.Name = 'Authorization v4';
        discList.add(d9);

        Disclosure__c d10 = new Disclosure__c();
        d10.Name = 'ARM Program Disclosure';
        discList.add(d10);

        Disclosure__c d11 = new Disclosure__c();
        d11.Name = 'HELOC Disclosure';
        discList.add(d11);        

        Disclosure__c d12 = new Disclosure__c();
        d12.Name = 'HELOC brochure';
        discList.add(d12);

        insert discList;

        String attachmentContent = 'Sameple test in the attachment';
        List<Attachment> attachments = new List<Attachment>();

        Attachment att1 = new Attachment();
        att1.Body = Blob.valueOf(attachmentContent);
        att1.Name = String.valueOf('E-Sign Consent.pdf');
        /*att1.ParentId = discList.get(0).id;*/
        att1.ParentId = discList[0].id;
        attachments.add(att1);


        Attachment att2 = new Attachment();
        att2.Body = Blob.valueOf(attachmentContent);
        att2.Name = String.valueOf('Visa Disclosure.pdf');
        att2.ParentId = discList[1].id;
        attachments.add(att2);

        Attachment att3 = new Attachment();
        att3.Body = Blob.valueOf(attachmentContent);
        att3.Name = String.valueOf('privacy_policy.pdf');
        att3.ParentId = discList[2].id;
        attachments.add(att3);

        Attachment att4 = new Attachment();
        att4.Body = Blob.valueOf(attachmentContent);
        att4.Name = String.valueOf('Truth in_Savings.pdf');
        att4.ParentId = discList[3].id;
        attachments.add(att4);

        Attachment att5 = new Attachment();
        att5.Body = Blob.valueOf(attachmentContent);
        att5.Name = String.valueOf('HANDBOOK_ON_ARM_MORTGAGES.pdf');
        att5.ParentId = discList[4].id;
        attachments.add(att5);

        Attachment att6 = new Attachment();
        att6.Body = Blob.valueOf(attachmentContent);
        att6.Name = String.valueOf('CD_truth in savings_Certificates.pdf');
        att6.ParentId = discList[5].id;
        attachments.add(att6);

        Attachment att7 = new Attachment();
        att7.Body = Blob.valueOf(attachmentContent);
        att7.Name = String.valueOf('Membership Agreement.pdf');
        att7.ParentId = discList[6].id;
        attachments.add(att7);

        Attachment att8 = new Attachment();
        att8.Body = Blob.valueOf(attachmentContent);
        att8.Name = String.valueOf('Lien on Shares Authorization.pdf');
        att8.ParentId = discList[7].id;
        attachments.add(att8);

        Attachment att9 = new Attachment();
        att9.Body = Blob.valueOf(attachmentContent);
        att9.Name = String.valueOf('Authorization v4.pdf');
        att9.ParentId = discList[8].id;
        attachments.add(att9);

        Attachment att10 = new Attachment();
        att10.Body = Blob.valueOf(attachmentContent);
        att10.Name = String.valueOf('ARM Program Disclosure.pdf');
        att10.ParentId = discList[9].id;
        attachments.add(att10);

        Attachment att11 = new Attachment();
        att11.Body = Blob.valueOf(attachmentContent);
        att11.Name = String.valueOf('HELOC Disclosure.pdf');
        att11.ParentId = discList[10].id;
        attachments.add(att11);

        Attachment att12 = new Attachment();
        att12.Body = Blob.valueOf(attachmentContent);
        att12.Name = String.valueOf('HELOC brochure.pdf');
        att12.ParentId = discList[11].id;
        attachments.add(att12);

        insert attachments;

        IndexUtilityExtension.emailSending(app);

        Map<String,sObject> sObjects = new Map<String,sObject>();
        sObjects.put('Application__c',app);
        sObjects.put('Application2__c',app2);
        sObjects.put('Employment_Information__c',emp);
        sObjects.put('Identity_Information__c',iden);
        sObjects.put('About_Account__c',acc);
        sObjects.put('Application_Activity__c',accAct);

        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));

        // Calling Utility class to get fields to be rendered
        Utility u = new Utility();
        Set<String> fieldsToBeDisplayed = u.fieldsToRender(app.Id);

        // Fields from personal info page
        testData.put('Application__c.First_Name__c','Test');
        testData.put('Application__c.Last_Name__c','Atul');
        testData.put('Application__c.Street_Address_1__c','1200 Test');
        testData.put('Application__c.Street_Address_2__c','Street');
        testData.put('Application__c.City__c','testcity');
        testData.put('Application__c.State__c','CA');
        testData.put('Application__c.Zip_code__c','12512');
        testData.put('Application__c.Street_Address_1_Prev__c','Test previous');
        testData.put('Application__c.Street_Address_2_Prev__c','Test Previous2');
        testData.put('Application__c.City_Prev__c','testprevcity');
        testData.put('Application__c.State_Prev__c','CA');
        testData.put('Application__c.Zip_Code_Prev__c','12441');
        testData.put('Application__c.Housing_Status__c','Own');
        testData.put('Application__c.Monthly_Payment__c','123');
        testData.put('Application__c.Marital_Status_J__c','test');
        testData.put('Application__c.Years__c','1');
        testData.put('Application__c.Months__c','1');
        testData.put('Application__c.Primary_Phone_Number__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number__c','9814981204');
        testData.put('Application__c.Email_Address__c','ganeshchedella@gmail.com');
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J__c','Test');
        testData.put('Application__c.Middle_Name_J__c','Test');
        testData.put('Application__c.Last_Name_J__c','Test');
        testData.put('Application__c.Suffix_J__c','Mr.');
        testData.put('Application__c.Street_Address_J__c','1200 Test');
        testData.put('Application__c.Street_Address_2_J__c','Street');
        testData.put('Application__c.City_J__c','testcity');
        testData.put('Application__c.State_J__c','CA');
        testData.put('Application__c.Zip_code_J__c','12512');
        testData.put('Application__c.Street_Address_1_JP__c','Test previous');
        testData.put('Application__c.Street_Address_2_JP__c','Test Previous2');
        testData.put('Application__c.City_JP__c','testprevcity');
        testData.put('Application__c.State_JP__c','CA');
        testData.put('Application__c.Zip_Code_JP__c','12441');
        testData.put('Application__c.Housing_Status_J__c','Own');
        testData.put('Application__c.Monthly_Payment_J__c','123');
        testData.put('Application__c.Marital_Status_J__c','test');
        testData.put('Application__c.Years_J__c','1');
        testData.put('Application__c.Months_J__c','1');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J1__c','test');
        testData.put('Application__c.Email_Address_J__c','dhiwaratul@gmail.com');
        testData.put('Application__c.Primary_Phone_Number_J__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number_J__c','9814981204');
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J2__c','test');
        testData.put('Application__c.Middle_Name_J2__c','test');
        testData.put('Application__c.Last_Name_J2__c','test');
        testData.put('Application__c.Suffix_J2__c','Jr.');
        testData.put('Application__c.Street_Address_1_J2__c','testok');
        testData.put('Application__c.Street_Address_2_J2__c','testok');
        testData.put('Application__c.City_J2__c','casl');
        testData.put('Application__c.State_J2__c','CA');
        testData.put('Application__c.Zip_code_J2__c','12512');
        testData.put('Application__c.Street_Address_1_JP2__c','Test previous');
        testData.put('Application__c.Street_Address_2_JP2__c','Test Previous2');
        testData.put('Application__c.City_JP2__c','testprevcity');
        testData.put('Application__c.State_JP2__c','CA');
        testData.put('Application__c.Zip_Code_JP2__c','12441');
        testData.put('Application__c.Housing_Status_J2__c','Own');
        testData.put('Application__c.Monthly_Payment_J2__c','123');
        testData.put('Application__c.Marital_Status_J2__c','test');
        testData.put('Application__c.Years_J2__c','1');
        testData.put('Application__c.Months_J2__c','1');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J2__c','test');
        testData.put('Application__c.Email_Address_J2__c','dhiwaratul@gmail.com');
        testData.put('Application__c.Primary_Phone_Number_J2__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number_J2__c','9814981204');
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J3__c','test');
        testData.put('Application__c.Middle_Name_J3__c','test');
        testData.put('Application__c.Last_Name_J3__c','test');
        testData.put('Application__c.Suffix_J3__c','Jr.');
        testData.put('Application__c.Street_Address_1_J3__c','testok');
        testData.put('Application__c.Street_Address_2_J3__c','testok');
        testData.put('Application__c.City_J3__c','casl');
        testData.put('Application__c.State_J3__c','CA');
        testData.put('Application__c.Zip_code_J3__c','12512');
        testData.put('Application__c.Street_Address_1_JP3__c','Test previous');
        testData.put('Application__c.Street_Address_2_JP3__c','Test Previous2');
        testData.put('Application__c.City_JP3__c','testprevcity');
        testData.put('Application__c.State_JP3__c','CA');
        testData.put('Application__c.Zip_Code_JP3__c','12441');
        testData.put('Application__c.Housing_Status_J3__c','Own');
        testData.put('Application__c.Monthly_Payment_J3__c','123');
        testData.put('Application__c.Marital_Status_J3__c','test');
        testData.put('Application__c.Years_J3__c','1');
        testData.put('Application__c.Months_J3__c','1');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J3__c','test');
        testData.put('Application__c.Email_Address_J3__c','dhiwaratul@gmail.com');
        testData.put('Application__c.Primary_Phone_Number_J3__c','9814981204');
        testData.put('Application__c.Secondary_Phone_Number_JP3__c','9814981204');

        // Fields from Employment page
        testData.put('Employment_Information__c.Employment_Status__c','Full Time');
        testData.put('Employment_Information__c.Employer__c','Ganesh');
        testData.put('Employment_Information__c.Occupation__c','Test');
        testData.put('Employment_Information__c.Prior_Occupation__c','Test1');
        testData.put('Employment_Information__c.Years_Emp__c','1');
        testData.put('Employment_Information__c.Months_Emp__c','1');
        testData.put('Employment_Information__c.Employer_P__c','Test');
        testData.put('Employment_Information__c.Occupation_P__c','Test1');
                testData.put('Employment_Information__c.Annual_Income__c','12512');
        testData.put('Employment_Information__c.Other_Income_Picklist__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5__c','Social Security');
        testData.put('Employment_Information__c.Other_Income__c','123');
        testData.put('Employment_Information__c.Other_Income2__c','123');
        testData.put('Employment_Information__c.Other_Income3__c','123');
        testData.put('Employment_Information__c.Other_Income4__c','123');
        testData.put('Employment_Information__c.Other_Income5__c','123');
        //First joint Applicant 
        testData.put('Employment_Information__c.Employment_Status_J1__c','Full Time');
        testData.put('Employment_Information__c.Employer_J1__c','Ganesh');
        testData.put('Employment_Information__c.Occupation__J1_c','Test');
        testData.put('Employment_Information__c.Prior_Occupation_J1__c','Test1');
        testData.put('Employment_Information__c.Years_EmpJ1__c','1');
        testData.put('Employment_Information__c.Months_EmpJ1__c','1');
        testData.put('Employment_Information__c.Employer_JP1__c','Test');
        testData.put('Employment_Information__c.Occupation_JP1__c','Test1');
                testData.put('Employment_Information__c.Annual_Income_J1__c','12512');
        testData.put('Employment_Information__c.Other_Income_Picklist1_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5_J1__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_J1__c','123');
        testData.put('Employment_Information__c.Other_Income2_J1__c','123');
        testData.put('Employment_Information__c.Other_Income3_J1__c','123');
        testData.put('Employment_Information__c.Other_Income4_J1__c','123');
        testData.put('Employment_Information__c.Other_Income5_J1__c','123');
        //Second Joint Applicant
        testData.put('Employment_Information__c.Employment_Status_J2__c','Full Time');
        testData.put('Employment_Information__c.Employer_J2__c','Ganesh');
        testData.put('Employment_Information__c.Occupation__J2_c','Test');
        testData.put('Employment_Information__c.Prior_Occupation_J2__c','Test2');
        testData.put('Employment_Information__c.Years_EmpJ2__c','2');
        testData.put('Employment_Information__c.Months_EmpJ2__c','2');
        testData.put('Employment_Information__c.Employer_JP2__c','Test');
        testData.put('Employment_Information__c.Occupation_JP2__c','Test2');
        testData.put('Employment_Information__c.Annual_Income_J2__c','22522');
        testData.put('Employment_Information__c.Other_Income_Picklist1_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5_J2__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_J2__c','223');
        testData.put('Employment_Information__c.Other_Income2_J2__c','223');
        testData.put('Employment_Information__c.Other_Income3_J2__c','223');
        testData.put('Employment_Information__c.Other_Income4_J2__c','223');
        testData.put('Employment_Information__c.Other_Income5_J2__c','123');
        //Third Joint Applicant
        testData.put('Employment_Information__c.Employment_Status_J3__c','Full Time');
        testData.put('Employment_Information__c.Employer_J3__c','Ganesh');
        testData.put('Employment_Information__c.Occupation__J3_c','Test');
        testData.put('Employment_Information__c.Prior_Occupation_J3__c','Test3');
        testData.put('Employment_Information__c.Years_EmpJ3__c','3');
        testData.put('Employment_Information__c.Months_EmpJ3__c','3');
        testData.put('Employment_Information__c.Employer_JP3__c','Test');
        testData.put('Employment_Information__c.Occupation_JP3__c','Test3');
                testData.put('Employment_Information__c.Annual_Income_J3__c','32532');
        testData.put('Employment_Information__c.Other_Income_Picklist1_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist2_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist3_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist4_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_Picklist5_J3__c','Social Security');
        testData.put('Employment_Information__c.Other_Income_J3__c','323');
        testData.put('Employment_Information__c.Other_Income2_J3__c','323');
        testData.put('Employment_Information__c.Other_Income3_J3__c','323');
        testData.put('Employment_Information__c.Other_Income4_J3__c','323');
        testData.put('Employment_Information__c.Other_Income5_J3__c','123');

        // Fields from identity page
        testData.put('Identity_Information__c.ID_Type__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_Primary__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued__c','CA');
        testData.put('Identity_Information__c.Issue_Date__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date__c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_Prime__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship__c','US Citizen');
                testData.put('Identity_Information__c.Country_of_Citizenship__c','India');
        //First joint Applicant 
        testData.put('Identity_Information__c.ID_Type_J1__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_J1__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued_J1__c','CA');
        testData.put('Identity_Information__c.Issue_Date_J1__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date_J1__c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth_J1__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_J1__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship_J1__c','US Citizen');
                testData.put('Identity_Information__c.Country_of_Citizenship_J1__c','India');
        //Second Joint Applicant
        testData.put('Identity_Information__c.ID_Type_J2__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_J2__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued_J2__c','CA');
        testData.put('Identity_Information__c.Issue_Date_J2__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date__J2_c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth_J2__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_J2__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship_J2__c','US Citizen');
                testData.put('Identity_Information__c.Country_of_Citizenship_J2__c','India');
        //Third Joint Applicant
        testData.put('Identity_Information__c.ID_Type_J3__c','Passport');
        testData.put('Identity_Information__c.Identity_Number_J3__c','123Gdf');
        testData.put('Identity_Information__c.State_Issued_J3__c','CA');
        testData.put('Identity_Information__c.Issue_Date_J3__c','11/11/1999');
        testData.put('Identity_Information__c.Expiry_Date_J3__c','11/11/2019');
        testData.put('Identity_Information__c.Date_of_Birth_J3__c','11/11/1990');
        testData.put('Identity_Information__c.SSN_J3__c','381-21-2123');
        testData.put('Identity_Information__c.Citizenship_J3__c','Immigrant');
                testData.put('Identity_Information__c.Country_of_Citizenship_J3__c','India');

        // fields from Account Details page
        testData.put('About_Account__c.AccountDetailsPageSubmitted', 'false');
        testData.put('About_Account__c.account_type_fi_chk__c', 'Checking');
        testData.put('About_Account__c.account_type_fi_sav__c', 'Checking');
        testData.put('About_Account__c.chk_account_number__c', '22828828');
        testData.put('About_Account__c.debt_consolidation_credit_card__c', '');
        testData.put('About_Account__c.debt_consolidation_personal_loan__c', 'ddss');
        testData.put('About_Account__c.disclosure_accountdetails_chk__c', 'true');
        testData.put('About_Account__c.disclosure_accountdetails_sav__c', 'true');
        testData.put('About_Account__c.dollar_amount_external_chk__c', '231');
        testData.put('About_Account__c.dollar_amount_external_sav__c', '2,13');
        testData.put('About_Account__c.dollar_amount_firsttech_chk__c', '');
        testData.put('About_Account__c.dollar_amount_firsttech_sav__c', '');
        testData.put('About_Account__c.financial_institution_chk__c', ' bpaa');
        testData.put('About_Account__c.financial_institution_sav__c', 'bbssh');
        testData.put('About_Account__c.funding_type_chk__c', 'Add External Accounts');
        testData.put('About_Account__c.funding_type_sav__c', 'Add External Accounts');
        testData.put('About_Account__c.oiau_q1_explanation_pa__c', '');
        testData.put('About_Account__c.oiau_q1_pa__c', 'false');
        testData.put('About_Account__c.oiau_q2_explanation_pa__c', '');
        testData.put('About_Account__c.oiau_q2_pa__c', 'false');
        testData.put('About_Account__c.oiau_q3_explanation_pa__c', '');
        testData.put('About_Account__c.oiau_q3_pa__c', 'false');
        testData.put('About_Account__c.otherpurpose_ccards__c', 'www');
        testData.put('About_Account__c.otherpurpose_personalloans__c', '');
        testData.put('About_Account__c.purpose_ccards__c', 'Other');
        testData.put('About_Account__c.purpose_personalloans__c', 'Debt Consolidation');
        testData.put('About_Account__c.requested_credit_limit_ccards__c', '23,222');
        testData.put('About_Account__c.requested_credit_limit_personalloans__c', '3,221');
        testData.put('About_Account__c.routing_number_chk__c', '727727727');
        testData.put('About_Account__c.routing_number_sav__c', '338822828');
        testData.put('About_Account__c.sav_account_number__c', '3737377');
        testData.put('About_Account__c.select_account_fi_chk__c', '');
        testData.put('About_Account__c.select_account_fi_sav__c', '');

        // fields from Purchase Details page

        testData.put('About_Account__c.Mortgage_Applied_For__c','Conventional');
        testData.put('About_Account__c.Purpose_Of_Loan__c','Purchase');
        testData.put('About_Account__c.Purchase_P__c','1200');
        testData.put('About_Account__c.Down_Payment__c','234');
        testData.put('About_Account__c.Total_Loan_Amount__c','123456');
        testData.put('About_Account__c.Monthly__c','23');
        testData.put('About_Account__c.Monthly_Insurance__c','12');
        testData.put('About_Account__c.Program_Description_2__c','Fixed 30 Year');
        testData.put('About_Account__c.Discount_Pt_Buy_down_2__c','2'); 

        // fields from Property Details page

        testData.put('About_Account__c.Options__c','New Address');
        testData.put('About_Account__c.Street_Address_1_AboutAccount__c','North First Street');
        testData.put('About_Account__c.Street_Address_2_AboutAccount__c','Street');
        testData.put('About_Account__c.City_AboutAccount__c','San Jose');
        testData.put('About_Account__c.State_AboutAccount__c','CA');
        testData.put('About_Account__c.Zip_Code_Account__c','94538');
        testData.put('About_Account__c.County__c','Alameda');
        testData.put('About_Account__c.Year_Built__c','1980');
        testData.put('About_Account__c.Property_Type__c','High-rise Condo ( 5 or more Stories)');
        testData.put('About_Account__c.Number_of_Units__c','2');
        testData.put('About_Account__c.Occupancy__c','Investment');
        testData.put('About_Account__c.Estimated_Gross_Rental_Income__c','2000');
        testData.put('About_Account__c.HOA_Dues__c','2000');

        //fields from Declarations Page

        testData.put('Application2__c.Qa_PrimApp__c','true');
        testData.put('Application2__c.Qa_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qb_PrimApp__c','true');
        testData.put('Application2__c.Qb_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qc_PrimApp__c','true');
        testData.put('Application2__c.Qc_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qd_PrimApp__c','true');
        testData.put('Application2__c.Qd_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qe_PrimApp__c','true');
        testData.put('Application2__c.Qe_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qf_PrimApp__c','true');
        testData.put('Application2__c.Qf_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qg_PrimApp__c','true');
        testData.put('Application2__c.Qg_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qh_PrimApp__c','true');
        testData.put('Application2__c.Qh_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qi_PrimApp__c','true');
        testData.put('Application2__c.Qi_Explanation_PrimApp__c','test');
        testData.put('Application2__c.Qj_PrimApp__c','true');
        testData.put('Application2__c.Qk_PrimApp__c','true');
        testData.put('Application2__c.Qk_2_PrimApp__c','true');
        testData.put('Application2__c.Ql_PrimApp__c','true');
        testData.put('Application2__c.Qm_PrimApp__c','true');
        testData.put('Application2__c.Qm_Type_of_Property_PrimApp__c','test');
        testData.put('Application2__c.Qm_Title_Held_PrimApp__c','test');
        testData.put('Application2__c.HMDA_Info_PA__c','true');
        testData.put('Application2__c.HMDA_Ethinicity_PA__c','test');
        testData.put('Application2__c.HMDA_Sex_PA__c','test');

        testData.put('Application2__c.Qa_JP1__c','true');
        testData.put('Application2__c.Qa_Explanation_JP1__c','test');
        testData.put('Application2__c.Qb_JP1__c','true');
        testData.put('Application2__c.Qb_Explanation_JP1__c','test');
        testData.put('Application2__c.Qc_JP1__c','true');
        testData.put('Application2__c.Qc_Explanation_JP1__c','test');
        testData.put('Application2__c.Qd_JP1__c','true');
        testData.put('Application2__c.Qd_Explanation_JP1__c','test');
        testData.put('Application2__c.Qe_JP1__c','true');
        testData.put('Application2__c.Qe_Explanation_JP1__c','test');
        testData.put('Application2__c.Qf_JP1__c','true');
        testData.put('Application2__c.Qf_Explanation_JP1__c','test');
        testData.put('Application2__c.Qg_JP1__c','true');
        testData.put('Application2__c.Qg_Explanation_JP1__c','test');
        testData.put('Application2__c.Qh_JP1__c','true');
        testData.put('Application2__c.Qh_Explanation_JP1__c','test');
        testData.put('Application2__c.Qi_JP1__c','true');
        testData.put('Application2__c.Qi_Explanation_JP1__c','test');
        testData.put('Application2__c.Qj_JP1__c','true');
        testData.put('Application2__c.Qk_JP1__c','true');
        testData.put('Application2__c.Qk_2_JP1__c','true');
        testData.put('Application2__c.Ql_JP1__c','true');
        testData.put('Application2__c.Qm_JP1__c','true');
        testData.put('Application2__c.Qm_Type_of_Property_JP1__c','test');
        testData.put('Application2__c.Qm_Title_Held_JP1__c','test');
        testData.put('Application2__c.HMDA_Info_J1__c','true');
        testData.put('Application2__c.HMDA_Ethinicity_J1__c','test');
        testData.put('Application2__c.HMDA_Sex_J1__c','test');

        testData.put('Application2__c.Qa_JP2__c','true');
        testData.put('Application2__c.Qa_Explanation_JP2__c','test');
        testData.put('Application2__c.Qb_JP2__c','true');
        testData.put('Application2__c.Qb_Explanation_JP2__c','test');
        testData.put('Application2__c.Qc_JP2__c','true');
        testData.put('Application2__c.Qc_Explanation_JP2__c','test');
        testData.put('Application2__c.Qd_JP2__c','true');
        testData.put('Application2__c.Qd_Explanation_JP2__c','test');
        testData.put('Application2__c.Qe_JP2__c','true');
        testData.put('Application2__c.Qe_Explanation_JP2__c','test');
        testData.put('Application2__c.Qf_JP2__c','true');
        testData.put('Application2__c.Qf_Explanation_JP2__c','test');
        testData.put('Application2__c.Qg_JP2__c','true');
        testData.put('Application2__c.Qg_Explanation_JP2__c','test');
        testData.put('Application2__c.Qh_JP2__c','true');
        testData.put('Application2__c.Qh_Explanation_JP2__c','test');
        testData.put('Application2__c.Qi_JP2__c','true');
        testData.put('Application2__c.Qi_Explanation_JP2__c','test');
        testData.put('Application2__c.Qj_JP2__c','true');
        testData.put('Application2__c.Qk_JP2__c','true');
        testData.put('Application2__c.Qk_2_JP2__c','true');
        testData.put('Application2__c.Ql_JP2__c','true');
        testData.put('Application2__c.Qm_JP2__c','true');
        testData.put('Application2__c.Qm_Type_of_Property_JP2__c','test');
        testData.put('Application2__c.Qm_Title_Held_JP2__c','test');
        testData.put('Application2__c.HMDA_Info_J1__c','true');
        testData.put('Application2__c.HMDA_Ethinicity_J2__c','test');
        testData.put('Application2__c.HMDA_Sex_J2__c','test');

        testData.put('Application2__c.Qa_JP3__c','true');
        testData.put('Application2__c.Qa_Explanation_JP3__c','test');
        testData.put('Application2__c.Qb_JP3__c','true');
        testData.put('Application2__c.Qb_Explanation_JP3__c','test');
        testData.put('Application2__c.Qc_JP3__c','true');
        testData.put('Application2__c.Qc_Explanation_JP3__c','test');
        testData.put('Application2__c.Qd_JP3__c','true');
        testData.put('Application2__c.Qd_Explanation_JP3__c','test');
        testData.put('Application2__c.Qe_JP3__c','true');
        testData.put('Application2__c.Qe_Explanation_JP3__c','test');
        testData.put('Application2__c.Qf_JP3__c','true');
        testData.put('Application2__c.Qf_Explanation_JP3__c','test');
        testData.put('Application2__c.Qg_JP3__c','true');
        testData.put('Application2__c.Qg_Explanation_JP3__c','test');
        testData.put('Application2__c.Qh_JP3__c','true');
        testData.put('Application2__c.Qh_Explanation_JP3__c','test');
        testData.put('Application2__c.Qi_JP3__c','true');
        testData.put('Application2__c.Qi_Explanation_JP3__c','test');
        testData.put('Application2__c.Qj_JP3__c','true');
        testData.put('Application2__c.Qk_JP3__c','true');
        testData.put('Application2__c.Qk_2_JP3__c','true');
        testData.put('Application2__c.Ql_JP3__c','true');
        testData.put('Application2__c.Qm_JP3__c','true');
        testData.put('Application2__c.Qm_Type_of_Property_JP3__c','test');
        testData.put('Application2__c.Qm_Title_Held_JP3__c','test');
        testData.put('Application2__c.HMDA_Info_J3__c','true');
        testData.put('Application2__c.HMDA_Ethinicity_J3__c','test');
        testData.put('Application2__c.HMDA_Sex_J3__c','test');

        // Confirmation complementary offer fields

        testData.put('Application__c.Visa_CashPlus_Check_Card__c','true');
        testData.put('Application__c.ATM_Card__c','true');
        testData.put('Application__c.Card_Design__c','Standard Platinum Rewards');
        testData.put('Application__c.Overdraft_Protection__c','true');
        testData.put('Application__c.Check_Order__c','true');
        testData.put('Application__c.Bill_Pay__c','true');
        testData.put('Application__c.Online_Banking_Enrollment__c','true');
        testData.put('Application__c.eDeposit__c','true');
        testData.put('Application__c.E_Statements__c','true');
        testData.put('Application__c.Gap_Insurance__c','true');
        testData.put('Application__c.Debt_Safe_Protection__c','true');
        testData.put('Application__c.Mechanical_Break_down_Protection__c','true');

        // Disclosure Fields

        testData.put('Application__c.disclosure6__c','true');
        testData.put('Application__c.disclosure1__c','true');
        testData.put('Application__c.disclosure13__c','true');
        testData.put('Application__c.disclosure9__c','true');
        testData.put('Application__c.disclosure8__c','true');
        testData.put('Application__c.disclosure7__c','true');
        testData.put('Application__c.disclosure5__c','true');
        testData.put('Application__c.disclosure10__c','true');
        testData.put('Application__c.disclosure4__c','true');
        testData.put('Application__c.disclosure2__c','true');
        testData.put('Application__c.disclosure3__c','true');

   //     Index.handleRequest(testData,'ReviewSubmitPage');
        IndexUtilityExtension.getPageVars(testData,'ReviewSubmitPage',fieldsToBeDisplayed,sObjects);
        IndexUtilityExtension.schedulePage(testData,'ReviewSubmitPage',fieldsToBeDisplayed,sObjects);
        IndexUtilityExtension.getData(testData,sObjects,true);
        /*IndexUtilityExtension.getAllFields(testData,'APPLICATION_OBJECT');*/
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void reviewSubmitPage2(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='ReviewSubmitPage';
        update app;  
        Map<String,String> testData=new Map<String,String>();
        testData.put('previous','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.disclosure5__c','false');
        testData.put('Application__c.disclosure1__c','false');
        testData.put('Application__c.disclosure13__c','false');
        testData.put('Application__c.disclosure4__c','false');
        testData.put('Application__c.disclosure2__c','false');
        testData.put('Application__c.disclosure7__c','false');
        testData.put('Application__c.disclosure3__c','false');
        testData.put('Application__c.disclosure6__c','false');
        Index.handleRequest(testData,'ReviewSubmitPage');
        System.assertEquals('Test',app.First_Name__c);
    }
            
    
    static testMethod void getStartedPagePrevious(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='GetStartedPage';
        update app;  
        Map<String,String> testData=new Map<String,String>();
        testData.put('previous','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.First_Name__c','Test');
        testData.put('Application__c.Last_Name__c','Ganesh');
        testData.put('Application__c.Email_Address__c','ganesh@chedella.com');
        testData.put('Application__c.Primary_Phone_Number__c','8337896754');
        Index.handleRequest(testData,'GetStartedPage');
        System.assertEquals('Test',app.First_Name__c); 
    } // end of get started method  
    
    static testMethod void personalInfoPageNullValues(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='PersonalInfoPage';
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        //Null values for primary applicant
        testData.put('Application__c.First_Name__c','');
        testData.put('Application__c.Last_Name__c','');
        testData.put('Application__c.Street_Address_1__c','');
        testData.put('Application__c.Street_Address_2__c','');
        testData.put('Application__c.City__c','');
        testData.put('Application__c.State__c','');
        testData.put('Application__c.Zip_code__c','');
        testData.put('Application__c.Housing_Status__c','');
        testData.put('Application__c.Monthly_Payment__c','');
        testData.put('Application__c.Marital_Status_J__c','');
        testData.put('Application__c.Years__c','');
        testData.put('Application__c.Months__c','');
        testData.put('Application__c.Primary_Phone_Number__c','');
        testData.put('Application__c.Secondary_Phone_Number__c','');
        testData.put('Application__c.Email_Address__c','');
        
        // First Joint Applicant
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J__c','');
        testData.put('Application__c.Middle_Name_J__c','');
        testData.put('Application__c.Last_Name_J__c','');
        testData.put('Application__c.Suffix_J__c','');
        testData.put('Application__c.Street_Address_J__c','');
        testData.put('Application__c.Street_Address_2_J__c','');
        testData.put('Application__c.City_J__c','');
        testData.put('Application__c.State_J__c','');
        testData.put('Application__c.Zip_code_J__c','');
        testData.put('Application__c.Street_Address_1_JP__c','');
        testData.put('Application__c.Street_Address_2_JP__c','');
        testData.put('Application__c.City_JP__c','');
        testData.put('Application__c.State_JP__c','');
        testData.put('Application__c.Zip_Code_JP__c','');
        testData.put('Application__c.Housing_Status_J__c','');
        testData.put('Application__c.Monthly_Payment_J__c','');
        testData.put('Application__c.Marital_Status_J__c','');
        testData.put('Application__c.Years_J__c','');
        testData.put('Application__c.Months_J__c','');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J1__c','');
        testData.put('Application__c.Email_Address_J__c','');
        testData.put('Application__c.Primary_Phone_Number_J__c','');
        testData.put('Application__c.Secondary_Phone_Number_J__c','');
        testData.put('Application__c.Email_Address_J__c','');
        
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J2__c','');
        testData.put('Application__c.Middle_Name_J2__c','');
        testData.put('Application__c.Last_Name_J2__c','');
        testData.put('Application__c.Suffix_J2__c','');
        testData.put('Application__c.Street_Address_1_J2__c','');
        testData.put('Application__c.Street_Address_2_J2__c','');
        testData.put('Application__c.City_J2__c','');
        testData.put('Application__c.State_J2__c','');
        testData.put('Application__c.Zip_code_J2__c','');
        testData.put('Application__c.Street_Address_1_JP2__c','');
        testData.put('Application__c.Street_Address_2_JP2__c','');
        testData.put('Application__c.City_JP2__c','');
        testData.put('Application__c.State_JP2__c','');
        testData.put('Application__c.Zip_Code_JP2__c','');
        testData.put('Application__c.Housing_Status_J2__c','');
        testData.put('Application__c.Monthly_Payment_J2__c','');
        testData.put('Application__c.Marital_Status_J2__c','');
        testData.put('Application__c.Years_J2__c','');
        testData.put('Application__c.Months_J2__c','');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J2__c','');
        testData.put('Application__c.Email_Address_J2__c','');
        testData.put('Application__c.Primary_Phone_Number_J2__c','');
        testData.put('Application__c.Secondary_Phone_Number_J2__c','');
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        testData.put('Application__c.First_Name_J3__c','');
        testData.put('Application__c.Middle_Name_J3__c','');
        testData.put('Application__c.Last_Name_J3__c','');
        testData.put('Application__c.Suffix_J3__c','');
        testData.put('Application__c.Street_Address_1_J3__c','');
        testData.put('Application__c.Street_Address_2_J3__c','');
        testData.put('Application__c.City_J3__c','');
        testData.put('Application__c.State_J3__c','');
        testData.put('Application__c.Zip_code_J3__c','');
        testData.put('Application__c.Street_Address_1_JP3__c','');
        testData.put('Application__c.Street_Address_2_JP3__c','');
        testData.put('Application__c.City_JP3__c','');
        testData.put('Application__c.State_JP3__c','');
        testData.put('Application__c.Zip_Code_JP3__c','');
        testData.put('Application__c.Housing_Status_J3__c','');
        testData.put('Application__c.Monthly_Payment_J3__c','');
        testData.put('Application__c.Marital_Status_J3__c','');
        testData.put('Application__c.Years_J3__c','');
        testData.put('Application__c.Months_J3__c','');
        testData.put('Application__c.Relationship_to_Primary_Applicant_J3__c','');
        testData.put('Application__c.Email_Address_J3__c','');
        testData.put('Application__c.Primary_Phone_Number_J3__c','');
        testData.put('Application__c.Secondary_Phone_Number_JP3__c','');
        Index.handleRequest(testData,'PersonalInfoPage');
        System.assertEquals('Test',app.First_Name__c);
    } // end of personal info method
    
    static testMethod void accountDetailsPageNullValues(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Application_Page__c='AccountDetailsPage';
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Email_Address__c='ganesh@gmail.com';
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        update app;  
        Map<String,String> testData=new Map<String,String>();
        testData.put('id',app.Id);
        testData.put('post','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('debug','true');
        testData.put('About_Account__c.AccountDetailsPageSubmitted', 'false');
        // Checking Funding Info
        testData.put('About_Account__c.funding_type_chk__c', '');
        // Savings Funding Info
        testData.put('About_Account__c.funding_type_sav__c', '');
        // Certificates Funding Info
        testData.put('About_Account__c.funding_type_CERT__c', '');
        
        // Other Information Primary Applicant
        testData.put('About_Account__c.oiau_q1_pa__c', 'true');
        testData.put('About_Account__c.oiau_q1_explanation_pa__c', '');
        testData.put('About_Account__c.oiau_q2_pa__c', 'true');
        testData.put('About_Account__c.oiau_q2_explanation_pa__c', '');
        testData.put('About_Account__c.oiau_q3_pa__c', 'true');
        testData.put('About_Account__c.oiau_q3_explanation_pa__c', '');
        // Other Information Joint Applicant 1
        testData.put('About_Account__c.oiau_q1_j1__c', 'true');
        testData.put('About_Account__c.oiau_q2_j1__c', 'true');
        testData.put('About_Account__c.oiau_q3_j1__c', 'true');
        testData.put('About_Account__c.OIAU_Q1_Explanation_J1__c','');
        testData.put('About_Account__c.OIAU_Q2_Explanation_J1__c','');
        testData.put('About_Account__c.OIAU_Q3_Explanation_J1__c','');
        // Other Information Joint Applicant 2    
        testData.put('About_Account__c.oiau_q1_j2__c', 'true');
        testData.put('About_Account__c.oiau_q2_j2__c', 'true');
        testData.put('About_Account__c.oiau_q3_j2__c', 'true');         
        testData.put('About_Account__c.OIAU_Q1_Explanation_J2__c','');
        testData.put('About_Account__c.OIAU_Q2_Explanation_J2__c','');
        testData.put('About_Account__c.OIAU_Q3_Explanation_J2__c','');  
        // Other Information Joint Applicant 3
        testData.put('About_Account__c.oiau_q1_j3__c', 'true');
        testData.put('About_Account__c.oiau_q2_j3__c', 'true');
        testData.put('About_Account__c.oiau_q3_j3__c', 'true');
        testData.put('About_Account__c.OIAU_Q1_Explanation_J3__c','');
        testData.put('About_Account__c.OIAU_Q2_Explanation_J3__c','');
        testData.put('About_Account__c.OIAU_Q3_Explanation_J3__c','');
        
        // Credit Card Info
        testData.put('About_Account__c.requested_credit_limit_ccards__c', '');
        testData.put('About_Account__c.purpose_ccards__c', '');
        Index.handleRequest(testData,'AccountDetailsPage');            
        
         //Internal Funding Info checking
        testData.put('About_Account__c.funding_type_chk__c', 'Internal Accounts');
        testData.put('About_Account__c.dollar_amount_internal_chk__c', '');
        testData.put('About_Account__c.select_account_fi_chk__c', '');
        //Internal Funding Info Savings
        testData.put('About_Account__c.funding_type_sav__c', 'Internal Accounts');
        testData.put('About_Account__c.select_account_fi_sav__c', '');
        testData.put('About_Account__c.dollar_amount_internal_sav__c', '');
        // Internal Funding Info Certificates
        testData.put('About_Account__c.funding_type_CERT__c', 'Internal Accounts');
        testData.put('About_Account__c.select_account_fi_CERT__c', '');
        testData.put('About_Account__c.dollar_amount_internal_CERT__c', '');   
        Index.handleRequest(testData,'AccountDetailsPage');        
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void accountDetailsPageNullValues2(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Application_Page__c='PersonalInfoPage';
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c;
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        //External funding info Checking
        testData.put('About_Account__c.funding_type_chk__c', 'Add External Accounts');
        testData.put('About_Account__c.financial_institution_chk__c', '');
        testData.put('About_Account__c.routing_number_chk__c', '');
        testData.put('About_Account__c.account_type_fi_chk__c', '');
        testData.put('About_Account__c.chk_account_number__c', '');
        testData.put('About_Account__c.dollar_amount_external_chk__c', '');
        testData.put('About_Account__c.disclosure_accountdetails_chk__c', '');
        // External Funding Info Savings
        testData.put('About_Account__c.funding_type_sav__c', 'Add External Accounts');
        testData.put('About_Account__c.financial_institution_sav__c', '');
        testData.put('About_Account__c.routing_number_sav__c', '');
        testData.put('About_Account__c.account_type_fi_sav__c', '');
        testData.put('About_Account__c.sav_account_number__c', '');
        testData.put('About_Account__c.dollar_amount_external_sav__c', '');
        testData.put('About_Account__c.disclosure_accountdetails_sav__c', '');       
        // External Funding Info Certificates
        testData.put('About_Account__c.funding_type_CERT__c', 'Add External Accounts');
        testData.put('About_Account__c.financial_institution_CERT__c', '');
        testData.put('About_Account__c.routing_number_CERT__c', '');
        testData.put('About_Account__c.account_type_fi_CERT__c', '');
        testData.put('About_Account__c.CERT_account_number__c', '');
        testData.put('About_Account__c.dollar_amount_external_CERT__c', '');
        testData.put('About_Account__c.disclosure_accountdetails_CERT__c', '');
        Index.handleRequest(testData,'AccountDetailsPage');         
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        update app;
        //Vehicle Loans Info
        testData.put('About_Account__c.Requested_Loan_Amount_VehicleLoans__c','');
        testData.put('About_Account__c.Term_VehicleLoans__c','');
        testData.put('About_Account__c.Purpose_VehicleLoan__c','');        
        //Personal Loan Info
        testData.put('About_Account__c.Requested_Loan_Amount_PersonalLoans__c','');
        testData.put('About_Account__c.Term_PersonalLoans__c','');
        testData.put('About_Account__c.Purpose_PersonalLoans__c','');
        // Personal Credit Loan Info
        testData.put('About_Account__c.requested_credit_limit_personalloans__c', '');
        testData.put('About_Account__c.Purpose_PersonalLoans__c','');
         //Other purpose credit card validation
        testData.put('About_Account__c.requested_credit_limit_ccards__c', 'Other');
        testData.put('About_Account__c.Otherpurpose_ccards__c', '');
        Index.handleRequest(testData,'AccountDetailsPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    static testMethod void accountDetailsPageNullValues3(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        
        // Debt consolidation Purpose personal Loan
        testData.put('About_Account__c.Purpose_PersonalLoans__c','Other');
        testData.put('About_Account__c.debt_consolidation_personal_loan__c', '');
        // Debt consolidation credit card purpose
        testData.put('About_Account__c.purpose_ccards__c', 'Debt Consolidation');
        testData.put('About_Account__c.debt_consolidation_credit_card__c', '');
        Index.handleRequest(testData,'AccountDetailsPage');
        
        // Other purpose Validation Personal Loan
        testData.put('About_Account__c.Purpose_PersonalLoans__c','Other');
        testData.put('About_Account__c.otherpurpose_personalloans__c', '');
        Index.handleRequest(testData,'AccountDetailsPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void accountDetailsValidValues1(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        Application_Activity__c appAcc = (Application_Activity__c)objects.get(5);
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        app.Person_Number__c = '4432';
        app.Current_Channel__c = 'Branch';
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        
        // Vehicle Loan Values
        testData.put('About_Account__c.Requested_Loan_Amount_VehicleLoans__c','3211');
        testData.put('About_Account__c.Term_VehicleLoans__c', '24');

        // Debt consolidation Purpose personal Loan and Personal Loan values
        testData.put('About_Account__c.Requested_Loan_Amount_PersonalLoans__c','6626');
        testData.put('About_Account__c.Term_PersonalLoans__c', '48');
        testData.put('About_Account__c.Purpose_PersonalLoans__c','Debt Consolidation');
        testData.put('About_Account__c.debt_consolidation_personal_loan__c', 'gfff');
        // Debt consolidation credit card purpose
        testData.put('About_Account__c.requested_credit_limit_ccards__c', '1200');
        testData.put('About_Account__c.purpose_ccards__c', 'Debt Consolidation');
        testData.put('About_Account__c.debt_consolidation_credit_card__c', 'ddss');
         
        testData.put('Application__c.Type_of_Checking__c',Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Savings__c',Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Certificates__c',Test_Class_Product_Names__c.getValues('CertificatesSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Business_Loans__c',Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Personal_Loans__c',Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Vehicle_Loans__c',Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Credit_Cards__c',Test_Class_Product_Names__c.getValues('CreditCardsSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Business_Credit_Cards__c',Test_Class_Product_Names__c.getValues('BusinessCreditCardsSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Business_Checking__c',Test_Class_Product_Names__c.getValues('BusinessCheckingSubProduct1').Client_Product_Name__c);
        testData.put('Application__c.Type_of_Business_Savings__c',Test_Class_Product_Names__c.getValues('BusinessSavingsSubProduct1').Client_Product_Name__c); 
        testData.put('Application__c.Type_of_Business_CDs__c',Test_Class_Product_Names__c.getValues('BusinessCDSubProduct1').Client_Product_Name__c);

        Index.handleRequest(testData,'AccountDetailsPage');
        System.assertEquals('Test',app.First_Name__c);
    }

    static testMethod void propertydetailspage(){
        testLoadData();
       List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        About_Account__c acc=(About_Account__c)objects.get(3);
        app.Application_Page__c='IndexPage';
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c; 
        update app; 
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));        
        
        // fields from Property Details page
        testData.put('About_Account__c.Options__c','New Address');
        testData.put('About_Account__c.Street_Address_1_AboutAccount__c','North First Street');
        testData.put('About_Account__c.Street_Address_2_AboutAccount__c','Street');
        testData.put('About_Account__c.City_AboutAccount__c','San Jose');
        testData.put('About_Account__c.State_AboutAccount__c','CA');
        testData.put('About_Account__c.Zip_Code_Account__c','94538');
        testData.put('About_Account__c.County__c','Alameda');
        testData.put('About_Account__c.Year_Built__c','1980');
        testData.put('About_Account__c.Property_Type__c','High-rise Condo ( 5 or more Stories)');
        testData.put('About_Account__c.Number_of_Units__c','2');
        testData.put('About_Account__c.Occupancy__c','Investment');
        testData.put('About_Account__c.Estimated_Gross_Rental_Income__c','2000');
        testData.put('About_Account__c.HOA_Dues__c','2000');        
        String pageName='PropertyDetailsPage';
        Index.handleRequest(testData, pageName);
        System.assertEquals('Test',app.First_Name__c);
    } 
    
    static testMethod void previous(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        About_Account__c acc=(About_Account__c)objects.get(3);
        
        Map<String,String> testData=new Map<String,String>();
        testData.put('previous','true');
        testData.put('id',app.Id);
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        
        Index.handleRequest(testData, 'PurchaseDetailsPage'); 
        Index.handleRequest(testData, 'PropertyDetailsPage');
        Index.handleRequest(testData, 'PersonalInfoPage');
        Index.handleRequest(testData, 'EmploymentPage');
        Index.handleRequest(testData, 'IdentityPage');
        Index.handleRequest(testData, 'AccountDetailsPage');
        Index.handleRequest(testData, 'DeclarationsPage');
        Index.handleRequest(testData, 'ReviewSubmitPage');
        Index.handleRequest(testData, 'VerifyIdentityPage');
        Index.handleRequest(testData, 'ConfirmationPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    
    // Method which send null values to server to hit validation messages   
    
    static testMethod void personalInfoErrorMessages(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Application_Page__c='PersonalInfoPage';
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('Application__c.First_Joint_Applicant__c','true');
        testData.put('Application__c.Second_Joint_Applicant__c','true');
        testData.put('Application__c.Third_Joint_Applicant__c','true');
        
        // Invalid Email Address and Zip code formats
        testData.put('Application__c.Zip_Code___c','fddds');
        testData.put('Application__c.Zip_Code_Prev__c','swwa');
        testData.put('Application__c.Zip_Code_J__c','fhdhd');
        testData.put('Application__c.Zip_Code_JP__c','fhdhd');
        testData.put('Application__c.Zip_Code_J2__c','fhdhd');
        testData.put('Application__c.Zip_Code_JP2__c','fhdhd');
        testData.put('Application__c.Zip_Code_J3__c','fhdhd');
        testData.put('Application__c.Zip_Code_JP3__c','fhdhd');
        testData.put('Application__c.Email_Address__c','com');
        testData.put('Application__c.Email_Address_J__c','com');
        testData.put('Application__c.Email_Address_J2__c','com');
        testData.put('Application__c.Email_Address_J3__c','com');
        
        // Years less than 2 and not providing previous address for primary applicant
        testData.put('Application__c.Years__c','1');
        testData.put('Application__c.Street_Address_1_Prev__c','');
        testData.put('Application__c.Street_Address_2_Prev__c','');
        testData.put('Application__c.City_Prev__c','');
        testData.put('Application__c.State_Prev__c','');
        
        // Years less than 2 and not providing previous address for first Joint applicant
        testData.put('Application__c.Years_J__c','1');
        testData.put('Application__c.Street_Address_1_JP__c','');
        testData.put('Application__c.Street_Address_2_JP__c','');
        testData.put('Application__c.City_JP__c','');
        testData.put('Application__c.State_JP__c','');
        
        // Years less than 2 and not providing previous address for second second applicant
        testData.put('Application__c.Years_J2__c','1');
        testData.put('Application__c.Street_Address_1_JP2__c','');
        testData.put('Application__c.Street_Address_2_JP2__c','');
        testData.put('Application__c.City_JP2__c','');
        testData.put('Application__c.State_JP2__c','');
        
        // Years less than 2 and not providing previous address for third joint applicant
        testData.put('Application__c.Years_J3__c','1');
        testData.put('Application__c.Street_Address_1_JP3__c','');
        testData.put('Application__c.Street_Address_2_JP3__c','');
        testData.put('Application__c.City_JP3__c','');
        testData.put('Application__c.State_JP3__c','');
        Index.handleRequest(testData,'PersonalInfoPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void remoteGetMethods(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.First_Joint_Applicant__c=true;
        app.Second_Joint_Applicant__c=true;
        app.Third_Joint_Applicant__c=true;
        app.Application_Page__c='PersonalInfoPage';
        app.Type_of_Checking__c=Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c;
        app.Type_of_Savings__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct1').Client_Product_Name__c;
        app.Type_of_Certificates__c=Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c;
        update app;          
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        // code for validateDollarAmount method
        testData.put('field','dollar_amount_external_chk__c');
        testData.put('requested_amount','700');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_external_sav__c');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_external_cert__c');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_external_bus_chk__c');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_external_bus_sav__c');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_external_bus_cds__c');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_busichk_check__c');
        Index.validateDollarAmount(testData);
        testData.put('field','dollar_amount_busichk_cash__c');
        Index.validateDollarAmount(testData);
        // code for saveCardValue
        testData.put('cardSelected','firstCard');
        Index.saveCardValue(testData);        
        testData.put('cardSelected','secondCard');
        Index.saveCardValue(testData);
        // code for uselogin
        Index.userLogin(testData);
        //code for docusign
        Index.callDocusign(app.Id,'Branch');    
        // code for Vehicle Make, Model and Sub-Models
        Index.bringVehicleMakes('2008');
        Index.bringVehicleModels('2008','Pontiac');
        Index.bringVehicleSubModels('2008','Pontiac','Torrent-V6');
        // Code for getting Terms
        app.Type_of_Vehicle_Loans__c = Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct1').Client_Product_Name__c;
        app.Type_of_Personal_Loans__c = Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct1').Client_Product_Name__c;
        app.Type_of_Credit_Cards__c = Test_Class_Product_Names__c.getValues('CreditCardsSubProduct3').Client_Product_Name__c;
        app.Type_Of_Business_Loans__c = Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c;
        app.Type_Of_Business_Loans__c = Test_Class_Product_Names__c.getValues('BusinessLoansSubProduct1').Client_Product_Name__c;
        app.Type_Of_Business_Credit_Cards__c = Test_Class_Product_Names__c.getValues('BusinessCreditCardsSubProduct1').Client_Product_Name__c;
        update app;
        // Error messages execution for Terms
        testData.put('field','requested_loan_amount_vehicleloans__c');
        testData.put('requested_amount','700');
        Index.getTerms(testData);
        testData.put('field','requested_loan_amount_personalloans__c');
        testData.put('requested_amount','300');
        Index.getTerms(testData);
        testData.put('field','requested_credit_limit_ccards__c');
        testData.put('requested_amount','300');
        Index.getTerms(testData);
        testData.put('field','requested_loan_amount_businessloans__c');
        testData.put('requested_amount','300');
        Index.getTerms(testData);
        testData.put('field','requested_credit_limit_bus_ccards__c');
        testData.put('requested_amount','300');
        Index.getTerms(testData);
        // Giving terms by providing valid values
        testData.put('field','requested_loan_amount_vehicleloans__c');
        testData.put('requested_amount','1200');
        Index.getTerms(testData);
        testData.put('field','requested_loan_amount_personalloans__c');
        testData.put('requested_amount','700');
        Index.getTerms(testData);
        testData.put('field','requested_credit_limit_ccards__c');
        testData.put('requested_amount','700');
        Index.getTerms(testData);
        testData.put('field','requested_loan_amount_businessloans__c');
        testData.put('requested_amount','20000');
        Index.getTerms(testData);
        testData.put('field','requested_credit_limit_bus_ccards__c');
        testData.put('requested_amount','25000');
        Index.getTerms(testData);
        // Constructor execution and get Methods
        PageReference p=Page.Index;
        Test.setCurrentPage(p);
        Cookie id = new Cookie('id',app.Id,null,-1,true);
        Cookie ut = new Cookie('ut',app.User_Token__c,null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{id,ut});
        Index i=new Index();
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void productSubProductList(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Index.productList(app.Id);
        Index.subProductList(app.Id);
        Map<String,String> testData=new Map<String,String>();
        testData.put('id',app.Id);
        Index.expireSession(testData);
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void validationUtility(){
        testLoadData();
        ValidationUtilityClass v=new ValidationUtilityClass();
        
        //NOTE: Methods below return if a validation error was found
        System.assert(v.validatePhone('tgddd'));
        System.assert(v.validateEmail('com'));
        System.assert(v.validateEmail('.com'));
        System.assert(v.validateZip('5656663663'));
        System.assert(v.validateRoutingNumber('gdddd','fhfh'));
        System.assert(v.validateRoutingNumber('4433323456','ffjfj'));
        System.assert(v.validateAccountNumber('fghghgh', 'cnfnv'));
    }
    
    static testMethod void accountDetailsIndexValidation(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Primary_Offer__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct2').Client_Product_Name__c;
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c;
        app.Third_Offer__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct2').Client_Product_Name__c;
        app.Type_of_Checking__c=Test_Class_Product_Names__c.getValues('CheckingSubProduct2').Client_Product_Name__c;
        app.Type_of_Savings__c=Test_Class_Product_Names__c.getValues('SavingsSubProduct2').Client_Product_Name__c;
        app.Type_of_Certificates__c=Test_Class_Product_Names__c.getValues('CertificatesSubProduct2').Client_Product_Name__c;
        app.Type_of_Personal_Loans__c=Test_Class_Product_Names__c.getValues('PersonalLoansSubProduct2').Client_Product_Name__c;
        update app;
        acc.Funding_Type_CHK__c='Add External Accounts';
        acc.Funding_Type_SAV__c='Add External Accounts';
        acc.Funding_Type_CERT__c='Add External Accounts';
        update acc;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);
        acc.Purpose_PersonalLoans__c='Debt Consolidation';
        app.Second_Offer__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct3').Client_Product_Name__c;
        app.Type_of_Vehicle_Loans__c=Test_Class_Product_Names__c.getValues('VehicleLoansSubProduct3').Client_Product_Name__c;
        update acc;
        update app;
        IndexValidationExtension.isDataValid(app,'AccountDetailsPage',app2,emp,iden,acc);
        app.disclosure6__c=false;
        app.disclosure1__c=false;
        app.disclosure13__c=false;
        app.disclosure8__c=false;
        app.disclosure7__c=false;
        app.disclosure5__c=false;
        app.disclosure4__c=false;
        app.disclosure9__c=false;
        app.disclosure3__c=false;
        app.disclosure10__c=false;
        app.disclosure2__c=false;
        update app;
        IndexValidationExtension.isDataValid(app,'ReviewSubmitPage',app2,emp,iden,acc);
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void saveForLaterPage(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        Index.handleRequest(testData,'SaveForLaterPage');
        System.assertEquals('Test',app.First_Name__c);
    }
    
    static testMethod void appRetrievalPage(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        app.Email_Address__c='test@test.com';
        iden.Date_of_Birth__c='01/01/1986';
        iden.SSN_Prime__c='666777888';
        update app;
        update iden;
        Map<String,String> testData=new Map<String,String>();
        testData.put('post','true');
        testData.put('id',app.Id);
        testData.put('debug','true');
        testData.put('ut',CryptoHelper.decrypt(app.User_Token__c));
        testData.put('last_name__c','Class');
        testData.put('date_of_birth__c','01/01/1986');
        testData.put('email_address__c','test@test.com');
        testData.put('ssn_prime__c','666777888');
        Index.handleRequest(testData,'AppRetrievalPage');
        System.assertEquals('Test',app.First_Name__c);
    }

    static testMethod void mobileShortFormTest(){
        testLoadData();
        PageReference p=Page.MobileShortForm;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('product',Product_Names_Mapping__c.getValues('Checking').Product_Name__c);
        ApexPages.currentPage().getParameters().put('subproduct',Test_Class_Product_Names__c.getValues('CheckingSubProduct1').Client_Product_Name__c);
        Application__c app=new Application__c();
        Application2__c app2=new Application2__c();
        About_Account__c acc=new About_Account__c();
        Employment_information__c emp=new Employment_information__c();
        Identity_information__c iden=new Identity_information__c();
        app.First_Name__c ='Test';
        app.Last_Name__c = 'Testing';
        app.email_address__c='hhh@gg.com';
        app.Primary_Phone_Number__c='7234448823';
        app.Best_Time_To_Call__c='Evening';
        app.Type_of_Checking__c='Checking';
        app.Type_of_Savings__c='Savings';
        app.Type_of_Certificates__c='Certificates';
        app.Type_of_Mortgage_Loan__c='Home Loan';
        app.Type_Of_Home_Equity__c='Home Equity';
        app.Type_of_Personal_Loans__c='Personal Loans';
        app.Type_of_Credit_Cards__c='Credit Cards';
        insert app;
        app2.Application__c=app.id;
        acc.Application__c=app.id;
        emp.Application__c=app.id;
        iden.Application__c=app.id;
        insert acc;
        insert app2;
        insert emp;
        insert iden;
        ApexPages.currentPage().getParameters().put('id',app.id);
        ApexPages.StandardController sc=new ApexPages.StandardController(app);
        mobileShortFormController msfc=new mobileShortFormController(sc); 
        /*msfc.newApplication.First_Name__c='Test';
        msfc.newApplication.Last_Name__c='Ganesh';
        msfc.newApplication.email_address__c='hhh@gg.com';
        msfc.newApplication.Primary_Phone_Number__c='8838282882';
        msfc.newApplication.Best_Time_To_Call__c='Evening';*/
        msfc.createApplication();
        System.assertEquals('Test',app.First_Name__c);

    }     

    static testMethod void timeOutControllerTest(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        TimeoutController t=new TimeoutController();
        TimeoutController.refreshToken(app.User_Token__c,app.Id);
        TimeoutController.extendExpiration(app.User_Token__c,app.Id);
        System.assertEquals('Test',app.First_Name__c);
    }
    
    // Testing RetrieveApp method to retrieve application
    static testMethod void retrieveStatusTestApp(){
        testLoadData();
        List<sObject> objects = StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app = (Application__c)objects.get(0);
        Identity_Information__c iden = (Identity_Information__c)objects.get(2);
        app.Last_Name__c = 'Test';
        app.Email_Address__c = 'abc@terafinainc.com';
        iden.Date_of_Birth__c = '01/01/1980';
        iden.SSN_Prime__c = '666777888';
        update app;
        update iden;
        Map<String,String> testData = new Map<String,String>();
        testData.put('last_name__c','Test');
        testData.put('date_of_birth__c','01/01/1980'); 
        testData.put('email_address__c','abc@terafinainc.com');
        testData.put('ssn_last_four_pa__c','7888');
        IndexUtilityExtension.retrieveApp(testData,app,iden);
        IndexUtilityExtension.appStatus(testData,app,iden);
        System.assertEquals('Test',app.First_Name__c);   
        
    }

    // IndexValidationExtension methods
    static testMethod void indexValidationMethods(){
        testLoadData();
        List<sObject> objects =StaticApplicationRecord_Test.createApplicationRecord();
        Application__c app=(Application__c)objects.get(0);
        Application2__c app2=(Application2__c)objects.get(4);
        About_Account__c acc=(About_Account__c)objects.get(3);
        Employment_Information__c emp=(Employment_Information__c)objects.get(1); 
        Identity_Information__c iden=(Identity_Information__c)objects.get(2);
        Application_Activity__c appAccA = (Application_Activity__c)objects.get(5);
        app.Email_Address__c = 'fhfh@c.n';
        app.Primary_Phone_Number__c = '';
        update app;
        IndexValidationExtension.isDataValid(app,'GetStartedPage',app2,emp,iden,acc);
        app.Primary_Phone_Number__c = 'euuuewu';
        update app;
        IndexValidationExtension.isDataValid(app,'GetStartedPage',app2,emp,iden,acc);
        app.Street_Address_1__c = 'P.O.Box 1';
        app.Zip_Code__c = 'djsd';
        app.Years__c = 1;
        app.Zip_Code_Prev__c = '';
        app.First_Joint_Applicant__c = true;
        app.Years_J__c = 1;
        app.Street_Address_1_JP__c = '';
        app.City_JP__c = '';
        app.State_JP__c = '';
        app.Zip_Code_JP__c = '';
        app.Second_Joint_Applicant__c = true;
        app.Years_J2__c = 1;
        app.Street_Address_1_JP2__c = '';
        app.City_JP2__c = '';
        app.State_JP2__c = '';
        app.Zip_Code_JP2__c = '';
        app.Email_Address_J2__c = '';
        app.Third_Joint_Applicant__c = true;
        app.Years_J3__c = 1;
        app.Street_Address_1_JP3__c = '';
        app.City_JP3__c = '';
        app.State_JP3__c = '';
        app.Zip_Code_JP3__c = '';
        app.Secondary_Phone_Number_JP3__c = '';
        app.Email_Address_J3__c = '';
        update app;
        IndexValidationExtension.isDataValid(app,'PersonalInfoPage',app2,emp,iden,acc);
    }  
} // end of test class