public with sharing class ProductController{
    public List<Cross_Sell_Logic__c> Getsubproduct{get;set;}
    public List<Cross_Sell_Logic__c> GetOffers{get;set;}
    String[] OfferResult = new String[]{}; //User selected offer store in this variable
    public String  appid;  
    public String PicklistResult{get;set;}
    public String SubProductResult{get;set;}
    public String prd{get; set;}
    public String sprd{get; set;}
    public User loggedInUser{get;set;}
    public String xmlString;
    public transient Dom.Document xmlData;
    public Dom.XMLNode address;

    public String ipaddress{get;set;}
    public String userAgent{get;set;}
    public String promoId{get; set;}
    public Promotion__c promotion {get; set;}
      
    public ProductController() {
        prd=ApexPages.currentPage().getParameters().get('pd');
        sprd=ApexPages.currentPage().getParameters().get('spd');
        appId=ApexPages.currentPage().getParameters().get('id');
        promoId=ApexPages.currentPage().getParameters().get('pid');
        if(promoId != null) {
            promotion = [SELECT id,CampaignID__c FROM Promotion__c WHERE id = : promoId];
        }
        ipaddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (ipaddress == '') {
            ipaddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
        userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        system.debug('App id is '+appId);
        system.debug('prd---------------'+prd);
        system.debug('sprd---------------'+sprd);
/*        PicklistResult= prd;
        SubProductResult=sprd;*/
        if (sprd != null) {
            if (Product_Codes__c.getValues(sprd) != null) {
                PicklistResult = Product_Codes__c.getValues(sprd).Product__c;
                SubProductResult = Product_Codes__c.getValues(sprd).Sub_Product__c;
            }
        }
        // Xml code
        this.xmlString = ApexPages.currentPage().getParameters().get('xmldata');
        this.xmlData = new DOM.Document();
        system.debug('xmlData is:' + this.xmlString);
        if (this.xmlString != null) {
            this.xmlData.load(this.xmlString);
        }
        String userId=UserInfo.getUserId();
        loggedInUser=[select id,Channel__c,Name,Email,Location__c,Profile.Name from User where Id=:userId];
    } 
   
    
    public List<SelectOption> getProduct(){
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
        Cross_Sell_Logic__c.Products__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }

 
    public List<SelectOption> getSubProduct()
    {
        If (PicklistResult==null) {
            Getsubproduct = [SELECT  Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:'Checking' ];
            system.debug('getvalue@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+Getsubproduct);
            List<SelectOption> options = new List<SelectOption>();
            for (Cross_Sell_Logic__c a :Getsubproduct) {
                options.add(new SelectOption(a.Sub_Products__c,a.Sub_Products__c));
            }
            return options;
        } else {
            Getsubproduct = [SELECT  Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:PicklistResult ];
            system.debug('getvalue@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+Getsubproduct);
            list<SelectOption> options = new List<SelectOption>();
            for (Cross_Sell_Logic__c a :Getsubproduct) {
                options.add(new SelectOption(a.Sub_Products__c,a.Sub_Products__c));
            }
            return options;
        } 
    }
    
    public PageReference Accounttype(){
        Logger.inputSource('ProductController', appId);
        Application__c app = new Application__c ();
        Application2__c app2 = new Application2__c ();
        Employment_Information__c emp = new Employment_Information__c();
        Identity_Information__c iden = new Identity_Information__c();
        About_Account__c acc = new About_Account__c();
        Application_Activity__c appact = new Application_Activity__c();
        PageReference p = null;
        if (appId != null && PicklistResult == null) {
            return null;
        }
        if (xmlString != null) {
            system.debug('xml exists');
            address = xmlData.getRootElement();


            if(xmlString.contains('CreatedByUserId'))
            app.Created_Person__c            = address.getChildElement('CreatedByUserId', null).getText();
            app.Ownerid = address.getChildElement('CreatedByUserId', null).getText();
            if(xmlString.contains('CreatedByBranch'))  
            app.Created_Branch_Name__c   = address.getChildElement('CreatedByBranch', null).getText();
            if(xmlString.contains('CreatedByChannel'))  
            app.Created_Channel__c       = address.getChildElement('CreatedByChannel', null).getText();
            if(xmlString.contains('CreatedEmailAddress'))  
            app.Created_User_Email_Address__c = address.getChildElement('CreatedEmailAddress', null).getText();
            // Current User attributes
            if(xmlString.contains('CurrentPerson'))
            app.Current_Person__c       = address.getChildElement('CurrentPerson', null).getText(); 
            if(xmlString.contains('CurrentBranch'))
            app.Current_Branch_Name__c   = address.getChildElement('CurrentBranch', null).getText();
            if(xmlString.contains('CurrentChannel'))
            app.Current_Channel__c       = address.getChildElement('CurrentChannel', null).getText();
            if(xmlString.contains('CurrentEmailAddress'))
            app.Current_User_Email_Address__c = address.getChildElement('CurrentEmailAddress', null).getText();

            app.Current_Timestamp__c       = System.now();
            app.Created_Timestamp__c       = System.now(); 

            app.Application_Page__c = 'GetStartedPage';
            CryptoHelper.setAppToken(app);
            // Inserting Application and other child records
            if (Application__c.SObjectType.getDescribe().isCreateable()) {
                insert app;
            }
            app2.Application__c= app.Id;
            emp.Application__c= app.Id;
            iden.Application__c= app.Id;
            acc.Application__c= app.Id;

            appact.Application__c= app.Id;
            appact.Channel__c = app.Current_Channel__c;
            appact.Name__c = app.Current_Person__c;
            appact.Action__c = 'Created the Application';
            appact.Activity_Time__c = system.now();
            appact.Branch__c = app.Current_Branch_Name__c;

            if (Application2__c.SObjectType.getDescribe().isCreateable()) {insert app2;}
            if (Employment_Information__c.SObjectType.getDescribe().isCreateable()) {insert emp;}
            if (Identity_Information__c.SObjectType.getDescribe().isCreateable()) {insert iden;}
            if (About_Account__c.SObjectType.getDescribe().isCreateable()) {insert acc;}
            if (Application_Activity__c.SObjectType.getDescribe().isCreateable()) {insert appact;}
            p = Page.Index;
            p.getParameters().put('id',app.Id);
            Logger.addMessage('Obtained XML with data in it', system.now().format());
        } else if (xmlString == null && appId != null) {
            Logger.addMessage('XML obtained is null', system.now().format());
            app = [select id,Product__c,Sub_Product__c,User_Token__c from Application__c where Id = :appId];
            app.Product__c=PicklistResult;
            app.Sub_Product__c=SubProductResult;

            if (PicklistResult != null && PicklistResult.contains(Product_Names_Mapping__c.getValues('Business').Product_Name__c)) {
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
                    app.Type_Of_Business_Checking__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
                    app.Type_Of_Business_Savings__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
                    app.Type_Of_Business_CDs__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
                    app.Type_Of_Business_Credit_Cards__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
                    app.Type_Of_Business_Loans__c=SubProductResult;
                }
            } else {
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
                    app.Type_of_Checking__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                    app.Type_of_Savings__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
                    app.Type_of_Certificates__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
                    app.Type_of_Credit_Cards__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
                    app.Type_of_Vehicle_Loans__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
                    app.Type_of_Personal_Loans__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
                    app.Type_of_Mortgage_Loan__c=SubProductResult;
                }
                if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
                    app.Type_Of_Home_Equity__c=SubProductResult;
                }
            }
            app.Number_of_Products__c = 1;
            if(ipaddress != null){
                app.IP_Address__c =  ipaddress;
            }
            if(userAgent != null) {
                app.User_Agent__c =  userAgent;
            }
            if (promoId != null) {
                app.Promo_ID__c = promoId;
                if(promotion.CampaignID__c != null) {
                    app.Promo_Code__c = promotion.CampaignID__c;
                }   
            }
            if (Application__c.SObjectType.getDescribe().isUpdateable()) {
                update app;
            }
            String userToken = CryptoHelper.decrypt(app.User_Token__c);
            p = Page.Index;
            Cookie id = ApexPages.currentPage().getCookies().get('id');
            Cookie ut = ApexPages.currentPage().getCookies().get('ut');
            Cookie fr = ApexPages.currentPage().getCookies().get('fr');
            id = new Cookie('id',app.Id,null,-1,true);
            ut = new Cookie('ut',userToken,null,-1,true);
            fr = new Cookie('fr','0',null,-1,true);

            // Set the new cookie for the page
            ApexPages.currentPage().setCookies(new Cookie[]{id,ut,fr});
            p.setRedirect(false);   
        } else if (xmlString == null && appId == null){
            try {
                if (Application__c.SObjectType.getDescribe().isCreateable() && Application2__c.SObjectType.getDescribe().isCreateable() && Employment_Information__c.SObjectType.getDescribe().isCreateable() && Identity_Information__c.SObjectType.getDescribe().isCreateable() && About_Account__c.SObjectType.getDescribe().isCreateable()) {
                    //  Logic related to Business accounts
                    if (PicklistResult.contains(Product_Names_Mapping__c.getValues('Business').Product_Name__c)) {
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
                            app.Type_Of_Business_Checking__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
                            app.Type_Of_Business_Savings__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
                            app.Type_Of_Business_CDs__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
                            app.Type_Of_Business_Credit_Cards__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
                            app.Type_Of_Business_Loans__c=SubProductResult;
                        }
                    }
                    //  Logic related to Individual accounts 
                    else {
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
                            app.Type_of_Checking__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                            app.Type_of_Savings__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
                            app.Type_of_Certificates__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
                            app.Type_of_Credit_Cards__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
                            app.Type_of_Vehicle_Loans__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
                            app.Type_of_Personal_Loans__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
                            app.Type_of_Mortgage_Loan__c=SubProductResult;
                        }
                        if (SubProductResult!=null && SubProductResult.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
                            app.Type_Of_Home_Equity__c=SubProductResult;
                        }
                     }
                     
                    // checks if the product and sub product  
                    system.debug('presult is '+PicklistResult);
                    system.debug('spresult is '+SubProductResult);
                    app.Product__c = PicklistResult;
                    app.Sub_Product__c = SubProductResult;
                    app.Number_of_Products__c = 1;
                    CryptoHelper.setAppToken(app);
                    if (loggedInUser.Channel__c == 'Branch') {
                        app.Created_Channel__c = 'Branch';
                        app.Current_Channel__c = 'Branch';
                    } else if (loggedInUser.Channel__c == 'Call Center') {
                        app.Created_Channel__c = 'Call Center';
                        app.Current_Channel__c = 'Call Center';
                    } else if (loggedInUser.Channel__c == 'Online') {
                        app.Created_Channel__c = 'Online';
                        app.Current_Channel__c = 'Online';
                    } else {
                        if (loggedInUser.Channel__c != null) {
                            app.Created_Channel__c=loggedInUser.Channel__c; 
                            app.Current_Channel__c=loggedInUser.Channel__c; 
                        }
                    }
        
                    app.Created_timestamp__c = system.now();
                    app.Created_Branch_Name__c = loggedInUser.Location__c;
                    app.Created_User_Email_Address__c = loggedInUser.Email;
                    app.Created_Person__c =  loggedInUser.Id;
                    app.Ownerid = loggedInUser.Id;
        
                    app.Current_timestamp__c =system.now();
                    app.Current_Branch_Name__c = loggedInUser.Location__c;
                    app.Created_User_Email_Address__c = loggedInUser.Email;
                    app.Current_Person__c =  loggedInUser.Id;
                    app.IP_Address__c =  ipaddress;
                    app.User_Agent__c =  userAgent;
        
                    app.Application_Page__c = 'GetStartedPage';
                    if (promoId != null) {
                        app.Promo_ID__c = promoId;
                        if(promotion.CampaignID__c != null) {
                            app.Promo_Code__c = promotion.CampaignID__c;
                        }   
                    }
                    
                    // Creating Application
                    if (Application__c.SObjectType.getDescribe().isCreateable()) {
                        insert app;
                    }
                    // Assigning App ID to the child record and then inserting those records    
                    app2.Application__c= app.Id;
                    emp.Application__c= app.Id;
                    iden.Application__c= app.Id;
                    acc.Application__c= app.Id;
        
                    appact.Application__c= app.Id;
                    appact.Channel__c = app.Current_Channel__c;
                    appact.Name__c = app.Current_Person__c;
                    appact.Action__c = 'Created the Application';
                    appact.Activity_Time__c = system.now();

                    if (Application2__c.SObjectType.getDescribe().isCreateable()) {insert app2;}
                    if (Employment_Information__c.SObjectType.getDescribe().isCreateable()) {insert emp;}
                    if (Identity_Information__c.SObjectType.getDescribe().isCreateable()) {insert iden;}
                    if (About_Account__c.SObjectType.getDescribe().isCreateable()) {insert acc;}
                    if (Application_Activity__c.SObjectType.getDescribe().isCreateable()) {insert appact;}      
                                        
                    system.debug('########################## application ID'+app.id);
                    Logger.inputSource('ProductController - Accounttype', app.Id);
                    Logger.addMessage('Redirecting to INDEX page', system.now().format());
                    p=page.INDEX;
                    String userToken = CryptoHelper.decrypt(app.User_Token__c);
                    // Storing Application ID and User token as cookies
                    Cookie id = ApexPages.currentPage().getCookies().get('id');
                    Cookie ut = ApexPages.currentPage().getCookies().get('ut');
                    Cookie fr = ApexPages.currentPage().getCookies().get('fr');
                    id = new Cookie('id',app.Id,null,-1,true);
                    ut = new Cookie('ut',userToken,null,-1,true);
                    fr = new Cookie('fr','0',null,-1,true);

                    Logger.writeAllLogs();
                    
                    // Set the new cookie for the page
                    ApexPages.currentPage().setCookies(new Cookie[]{id,ut,fr});
                    p.setRedirect(false);
                        
                } // checking if the User has ability to create Application
            } catch (Exception e) {
                
            }
        }
        system.debug('The appId is '+appId);
        Logger.writeAllLogs();
        return p;

    // checks if the product and sub product  
    
     /*   if (loggedInUser.Channel__c == 'Branch') {
            app.Created_Channel__c = 'Branch';
            app.Current_Channel__c = 'Branch';
        } else if (loggedInUser.Channel__c == 'Call Center') {
            app.Created_Channel__c = 'Call Center';
            app.Current_Channel__c = 'Call Center';
        } else if (loggedInUser.Channel__c == 'Online') {
            app.Created_Channel__c = 'Online';
            app.Current_Channel__c = 'Online';
        } else {
            if (loggedInUser.Channel__c != null) {
                app.Created_Channel__c=loggedInUser.Channel__c; 
                app.Current_Channel__c=loggedInUser.Channel__c; 
            }
        }
        app.Created_timestamp__c = system.now();
        app.Created_Branch_Name__c = loggedInUser.Location__c;
        app.Created_User_Email_Address__c = loggedInUser.Email;
        app.Created_Person__c =  loggedInUser.Id;

        app.Current_timestamp__c =system.now();
        app.Current_Branch_Name__c = loggedInUser.Location__c;
        app.Created_User_Email_Address__c = loggedInUser.Email;
        app.Current_Person__c =  loggedInUser.Id;   */
    } // end of PageReference method   

}  // end of class