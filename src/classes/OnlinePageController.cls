public with sharing class OnlinePageController {
    public String  appid;
    public User loggedInUser{get;set;}     
    Application__c app = new Application__c ();
    Application2__c app2 = new Application2__c ();
    Employment_Information__c emp = new Employment_Information__c();
    Identity_Information__c iden = new Identity_Information__c();
    About_Account__c acc = new About_Account__c();
    Application_Activity__c appact = new Application_Activity__c();
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public OnlinePageController() {
        appId=ApexPages.currentPage().getParameters().get('id');
        String userId=UserInfo.getUserId();
        loggedInUser=[select id,Channel__c,Name,Email,Location__c,Profile.Name from User where Id=:userId];
        if ( appId != null ) {
            app = [SELECT id,Created_Channel__c,Current_Channel__c,Created_timestamp__c,Created_Branch_Name__c,Created_User_Email_Address__c,Created_Person__c,Current_timestamp__c,Current_Branch_Name__c,Current_Person__c,Application_Page__c,Product__c,Sub_Product__c,Type_of_Checking__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Checking__c,Type_Of_Business_Loans__c,Type_Of_Business_Savings__c,Type_of_Certificates__c,Type_of_Credit_Cards__c,Type_Of_Home_Equity__c,Type_of_Investments__c,Type_of_Mortgage_Loan__c,Type_of_Mortgage_Short_Application__c,Type_of_Personal_Loans__c,Type_of_Savings__c,Type_of_Vehicle_Loans__c FROM Application__c WHERE id = :appId];
        }         
    }

    public PageReference ProSub(){
        
        if(appId != null){
            system.debug('The application id is '+ appId);
            Logger.inputSource('OnlinePageController - ProSub', appId); 
        }
           
        CryptoHelper.setAppToken(app);
        if(appId == null){
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

            app.Current_timestamp__c =system.now();
            app.Current_Branch_Name__c = loggedInUser.Location__c;
            app.Created_User_Email_Address__c = loggedInUser.Email;
            app.Current_Person__c =  loggedInUser.Id;
        }
            
        if(appId == null){
            app.Application_Page__c = 'GetStartedPage';
        } else{
            app.Application_Page__c = 'CrossSellPage';
        }
        if (Application__c.SObjectType.getDescribe().isCreateable() && appId == null) {
            insert app;
        } else if(Application__c.SObjectType.getDescribe().isUpdateable() && appId != null){
            update app;
        }

        if(appId == null){
            app2.Application__c= app.Id;
            emp.Application__c= app.Id;
            iden.Application__c= app.Id;
            acc.Application__c= app.Id;
        }

        appact.Application__c= app.Id;
        appact.Channel__c = app.Current_Channel__c;
        appact.Name__c = app.Current_Person__c;
        appact.Action__c = 'Created the Application';
        appact.Activity_Time__c = system.now();

        if(appId == null){
            if (Application2__c.SObjectType.getDescribe().isCreateable()) {insert app2;}
            if (Employment_Information__c.SObjectType.getDescribe().isCreateable()) {insert emp;}
            if (Identity_Information__c.SObjectType.getDescribe().isCreateable()) {insert iden;}
            if (About_Account__c.SObjectType.getDescribe().isCreateable()) {insert acc;}
        }
        if (Application_Activity__c.SObjectType.getDescribe().isCreateable()) {insert appact;}        
        String userToken = CryptoHelper.decrypt(app.User_Token__c);
        Logger.addMessage('Redirecting to INDEX page', system.now().format());
        pagereference p=page.INDEX;
        
        system.debug('before appending to the cookies');
        Cookie id = ApexPages.currentPage().getCookies().get('id');
        Cookie ut = ApexPages.currentPage().getCookies().get('ut');
        Cookie fr = ApexPages.currentPage().getCookies().get('fr');
        id = new Cookie('id',app.Id,null,-1,true);
        ut = new Cookie('ut',userToken,null,-1,true);
        fr = new Cookie('fr','0',null,-1,true);
        system.debug('after appending to the cookies'+id);

        Logger.writeAllLogs();
    
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{id,ut,fr});
        p.setRedirect(false);
        system.debug('app is is: '+ ApexPages.currentPage().getParameters().get('id'));
        
        return p;
    }
    //Checking
    public PageReference CheckingSilver() {
        app.Product__c='Checking';
        app.Sub_Product__c='Checking - Silver';
        app.Type_of_Checking__c='Checking - Silver';
        return ProSub();
    }
    public PageReference CheckingGold() {
        app.Product__c='Checking';
        app.Sub_Product__c='Checking - Gold';
        app.Type_of_Checking__c='Checking - Gold';
        return ProSub();
    }
    //Savings
    public PageReference SavingsSilver() {
        app.Product__c='Savings';
        app.Sub_Product__c='Savings - Silver';
        app.Type_of_Savings__c='Savings - Silver';
        return ProSub();
    }
    public PageReference SavingsGold() {
        app.Product__c='Savings';
        app.Sub_Product__c='Savings - Gold';
        app.Type_of_Savings__c='Savings - Gold';
        return ProSub();
    }
    public PageReference SavingsPlatinum() {
        app.Product__c='Savings';
        app.Sub_Product__c='Savings - Platinum';
        app.Type_of_Savings__c='Savings - Platinum';
        return ProSub();
    }
    //Certificates
    public PageReference Certificates6Months() {
        app.Product__c='Certificates';
        app.Sub_Product__c='Certificates - 6 Months';
        app.Type_of_Certificates__c='Certificates - 6 Months';
        return ProSub();
    }
    public PageReference Certificates12Months() {
        app.Product__c='Certificates';
        app.Sub_Product__c='Certificates - 12 Months';
        app.Type_of_Certificates__c='Certificates - 12 Months';
        return ProSub();
    }
    public PageReference Certificates18Months() {
        app.Product__c='Certificates';
        app.Sub_Product__c='Certificates - 18 Months';
        app.Type_of_Certificates__c='Certificates - 18 Months';
        return ProSub();
    }
    public PageReference Certificates24Months() {
        app.Product__c='Certificates';
        app.Sub_Product__c='Certificates - 24 Months';
        app.Type_of_Certificates__c='Certificates - 24 Months';
        return ProSub();
    }
    public PageReference Certificates36Months() {
        app.Product__c='Certificates';
        app.Sub_Product__c='Certificates - 36 Months';
        app.Type_of_Certificates__c='Certificates - 36 Months';
        return ProSub();
    }
    public PageReference Certificates60Months() {
        app.Product__c='Certificates';
        app.Sub_Product__c='Certificates - 60 Months';
        app.Type_of_Certificates__c='Certificates - 60 Months';
        return ProSub();
    }
    //Credit Cards
    public PageReference CreditCardsSilverIncrease() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Silver - Increase';
        app.Type_of_Credit_Cards__c='Credit Cards - Silver - Increase';
        return ProSub();
    }
    public PageReference CreditCardsSilverAdvantagePointsRewards() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Advantage Points Rewards';
        app.Type_of_Credit_Cards__c='Credit Cards - Advantage Points Rewards';
        return ProSub();
    }
    public PageReference CreditCardsSilverAdvantagePointsRewardsIncrease() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Advantage Points Rewards - Increase';
        app.Type_of_Credit_Cards__c='Credit Cards - Advantage Points Rewards - Increase';
        return ProSub();
    }
    public PageReference CreditCardsAdvantage() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Advantage';
        app.Type_of_Credit_Cards__c='Credit Cards - Advantage';
        return ProSub();
    }
    public PageReference CreditCardsSilver() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Silver';
        app.Type_of_Credit_Cards__c='Credit Cards - Silver';
        return ProSub();
    }
    public PageReference CreditCardsAdvantageSecured() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Advantage Secured';
        app.Type_of_Credit_Cards__c='Credit Cards - Advantage Secured';
        return ProSub();
    }
    public PageReference CreditCardsAdvantageSecuredIncrease() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Advantage Secured Increase';
        app.Type_of_Credit_Cards__c='Credit Cards - Advantage Secured Increase';
        return ProSub();
    }
    public PageReference CreditCardsPlatinum() {
        app.Product__c='Credit Cards';
        app.Sub_Product__c='Credit Cards - Platinum';
        app.Type_of_Credit_Cards__c='Credit Cards - Platinum';
        return ProSub();
    }
    //Home Loans
    public PageReference HomeLoanFixedRateMortgages() {
        app.Product__c='Home Loan';
        app.Sub_Product__c='Home Loan - Fixed Rate Mortgages';
        app.Type_of_Mortgage_Loan__c='Home Loan - Fixed Rate Mortgages';
        return ProSub();
    }
    public PageReference HomeLoanFixedRateJumboMortgages() {
        app.Product__c='Home Loan';
        app.Sub_Product__c='Home Loan - Fixed Rate Jumbo Mortgages';
        app.Type_of_Mortgage_Loan__c='Home Loan - Fixed Rate Jumbo Mortgages';
        return ProSub();
    }
    public PageReference HomeLoanAdjustableRateMortgages() {
        app.Product__c='Home Loan';
        app.Sub_Product__c='Home Loan - Adjustable Rate Mortgages';
        app.Type_of_Mortgage_Loan__c='Home Loan - Adjustable Rate Mortgages';
        return ProSub();
    }
    public PageReference HomeLoanAdjustableRateJumboMortgages() {
        app.Product__c='Home Loan';
        app.Sub_Product__c='Home Loan - Adjustable Rate Jumbo Mortgages';
        app.Type_of_Mortgage_Loan__c='Home Loan - Adjustable Rate Jumbo Mortgages';
        return ProSub();
    }
    //Home Equity
    public PageReference HomeEquityFixedRateHomeEquity() {
        app.Product__c='Home Equity';
        app.Sub_Product__c='Home Equity - Fixed Rate Home Equity';
        app.Type_Of_Home_Equity__c='Home Equity - Fixed Rate Home Equity';
        return ProSub();
    }
    public PageReference HomeEquityAdjustableRateHomeEquity() {
        app.Product__c='Home Equity';
        app.Sub_Product__c='Home Equity - Adjustable Rate Home Equity';
        app.Type_Of_Home_Equity__c='Home Equity - Adjustable Rate Home Equity';
        return ProSub();
    }
    public PageReference HomeEquityFlexityLineofCredit() {
        app.Product__c='Home Equity';
        app.Sub_Product__c='Home Equity - Flexity Line of Credit';
        app.Type_Of_Home_Equity__c='Home Equity - Flexity Line of Credit';
        return ProSub();
    }
    //Personal Loans
    public PageReference PersonalLoansFixedRate() {
        app.Product__c='Personal Loans';
        app.Sub_Product__c='Personal Loans - Fixed Rate';
        app.Type_of_Personal_Loans__c='Personal Loans - Fixed Rate';
        return ProSub();
    }
    public PageReference PersonalLoansPersonalLineofCredit() {
        app.Product__c='Personal Loans';
        app.Sub_Product__c='Personal Loans - Personal Line of Credit';
        app.Type_of_Personal_Loans__c='Personal Loans - Personal Line of Credit';
        return ProSub();
    }
    public PageReference PersonalLoansStockSecuredLoan() {
        app.Product__c='Personal Loans';
        app.Sub_Product__c='Personal Loans - Certificate Secured Loan';
        app.Type_of_Personal_Loans__c='Personal Loans - Certificate Secured Loan';
        return ProSub();
    }
    public PageReference PersonalLoansCertificateSecuredLoan() {
        app.Product__c='Personal Loans';
        app.Sub_Product__c='Personal Loans - Certificate Secured Loan';
        app.Type_of_Personal_Loans__c='Personal Loans - Certificate Secured Loan';
        return ProSub();
    }
    public PageReference PersonalLoansSavingsSecuredLoan() {
        app.Product__c='Personal Loans';
        app.Sub_Product__c='Personal Loans - Savings Secured Loan';
        app.Type_of_Personal_Loans__c='Personal Loans - Savings Secured Loan';
        return ProSub();
    }
    //Vehicle Loans
    public PageReference VehicleLoansNewAutoLoan() {
        app.Product__c='Vehicle Loans';
        app.Sub_Product__c='Vehicle Loans - New Auto Loan';
        app.Type_of_Vehicle_Loans__c='Vehicle Loans - New Auto Loan';
        return ProSub();
    }
    public PageReference VehicleLoansUsedAutoLoan() {
        app.Product__c='Vehicle Loans';
        app.Sub_Product__c='Vehicle Loans - Used Auto Loan';
        app.Type_of_Vehicle_Loans__c='Vehicle Loans - Used Auto Loan';
        return ProSub();
    }
    public PageReference VehicleLoansBoatLoan() {
        app.Product__c='Vehicle Loans';
        app.Sub_Product__c='Vehicle Loans - Boat Loan';
        app.Type_of_Vehicle_Loans__c='Vehicle Loans - Boat Loan';
        return ProSub();
    }
    public PageReference VehicleLoansRVLoan() {
        app.Product__c='Vehicle Loans';
        app.Sub_Product__c='Vehicle Loans - RV Loan';
        app.Type_of_Vehicle_Loans__c='Vehicle Loans - RV Loan';
        return ProSub();
    }
    public PageReference VehicleLoansMotorcycleLoan() {
        app.Product__c='Vehicle Loans';
        app.Sub_Product__c='Vehicle Loans - Motorcycle Loan';
        app.Type_of_Vehicle_Loans__c='Vehicle Loans - Motorcycle Loan';
        return ProSub();
    }
    //Business Products
    public PageReference BusiCheckingSilver() {
        app.Product__c='Business Checking';
        app.Sub_Product__c='Business Checking - Silver';
        app.Type_Of_Business_Checking__c='Business Checking - Silver';
        return ProSub();
    }
    public PageReference BusiCheckingPlatinum() {
        app.Product__c='Business Checking';
        app.Sub_Product__c='Business Checking - Platinum';
        app.Type_Of_Business_Checking__c='Business Checking - Platinum';
        return ProSub();
    }
    public PageReference BusiSavingsSilver() {
        app.Product__c='Business Savings';
        app.Sub_Product__c='Business Savings - Silver';
        app.Type_Of_Business_Savings__c='Business Savings - Silver';
        return ProSub();
    }
    public PageReference BusiSavingsPlatinum() {
        app.Product__c='Business Savings';
        app.Sub_Product__c='Business Savings - Platinum';
        app.Type_Of_Business_Savings__c='Business Savings - Platinum';
        return ProSub();
    }
    public PageReference BusiSavingsMoneyMarket() {
        app.Product__c='Business Savings';
        app.Sub_Product__c='Business Savings - Money Market';
        app.Type_Of_Business_Savings__c='Business Savings - Money Market';
        return ProSub();
    }
    public PageReference BusiCDsBasic() {
        app.Product__c='Business CDs';
        app.Sub_Product__c='Business CDs - Basic';
        app.Type_Of_Business_CDs__c='Business CDs - Basic';
        return ProSub();
    }
    public PageReference BusiCDsJumbo() {
        app.Product__c='Business CDs';
        app.Sub_Product__c='Business CDs - Jumbo';
        app.Type_Of_Business_CDs__c='Business CDs - Jumbo';
        return ProSub();
    }
    public PageReference BusiCCPlatinum() {
        app.Product__c='Business Credit Cards';
        app.Sub_Product__c='Business Credit Cards - Platinum';
        app.Type_Of_Business_Credit_Cards__c='Business Credit Cards - Platinum';
        return ProSub();
    }
    public PageReference BusiCCSapphire() {
        app.Product__c='Business Credit Cards';
        app.Sub_Product__c='Business Credit Cards - Sapphire';
        app.Type_Of_Business_Credit_Cards__c='Business Credit Cards - Sapphire';
        return ProSub();
    }
    public PageReference BusiLoansAdvantage() {
        app.Product__c='Business Loans';
        app.Sub_Product__c='Business Loans - Advantage';
        app.Type_Of_Business_Loans__c='Business Loans - Advantage';
        return ProSub();
    }
    public PageReference BusiLoansTerm() {
        app.Product__c='Business Loans';
        app.Sub_Product__c='Business Loans - Term';
        app.Type_Of_Business_Loans__c='Business Loans - Term';
        return ProSub();
    }
    public PageReference BusiLoansSBA() {
        app.Product__c='Business Loans';
        app.Sub_Product__c='Business Loans - SBA';
        app.Type_Of_Business_Loans__c='Business Loans - SBA';
        return ProSub();
    }
    public PageReference BusiLoansLOC() {
        app.Product__c='Business Loans';
        app.Sub_Product__c='Business Loans - Line of Credit';
        app.Type_Of_Business_Loans__c='Business Loans - Line of Credit';
        return ProSub();
    }
}