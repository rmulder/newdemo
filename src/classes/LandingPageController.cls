public with sharing class LandingPageController {

	public String productCode;
	public String subProductCode;
	public String ipaddress;
	public String customerID;
	public User loggedInUser{get;set;}
	public String userId{get; set;}
	public Customer__c customer = null;

	public LandingPageController(){
		this.productCode = ApexPages.currentPage().getParameters().get('prdCode');
		system.debug('The product code is ##### '+ productCode);
		this.subProductCode = ApexPages.currentPage().getParameters().get('subPrdCode');
		system.debug('The Sub Product code is ##### '+ subProductCode);   
		this.ipaddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
		system.debug('The Ip Address is ##### '+ productCode);
		this.customerID = ApexPages.currentPage().getParameters().get('custId');
		system.debug('The customer ID is ##### '+ customerID);
    	if(customerID != null){
    		customer = [SELECT id,First_Name__c,Middle_Name__c,Last_Name__c,Phone_Number__c,Cell_Phone_Number__c,Email_Address__c,Street_Address_1__c,Street_Address_2__c,City__c,State__c,Zip_Code__c,Person_Identifier__c,SSN__c,Date_Of_Birth__c,Company__c FROM Customer__c WHERE id = :customerID];
        }

		userId = UserInfo.getUserId();
		loggedInUser=[SELECT id,Channel__c,Name,Email,Location__c,Profile.Name FROM User WHERE Id=:userId];
	}

	public PageReference beginApp(){
		
		// Instantiating all the required Objects
		Application__c app = new Application__c();
		Application2__c app2 = new Application2__c();
		Employment_Information__c emp = new Employment_Information__c();
		Identity_Information__c iden = new Identity_Information__c();
		About_Account__c acc = new About_Account__c();
		Application_Activity__c appAct = new Application_Activity__c();
		Documentation_Request__c doc = new Documentation_Request__c();
		// Instantiating the custom settings for the producty codes
		Product_Codes__c pc = new Product_Codes__c();

		if(productCode != null){
			pc = Product_Codes__c.getValues(productCode);
		}
		system.debug('product codes are');
		if(pc != null){
			app.Product__c = pc.Product__c;
			app.Sub_Product__c = pc.Sub_Product__c;
		}
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
		if(loggedInUser.Location__c != null) {
			app.Created_Branch_Name__c = loggedInUser.Location__c;
		}
		app.Created_User_Email_Address__c = loggedInUser.Email;
		app.Created_Person__c =  loggedInUser.Id;

		app.Current_timestamp__c =system.now();
		if(loggedInUser.Location__c != null) {
			app.Current_Branch_Name__c = loggedInUser.Location__c;
		}
		app.Created_User_Email_Address__c = loggedInUser.Email;
		app.Current_Person__c =  loggedInUser.Id;

		app.Application_Page__c = 'GetStartedPage';

		//Prefill the customer data
		if(customer != null){
			app.First_Name__c = customer.First_Name__c;
			app.Middle_Name__c = customer.Middle_Name__c;
			app.Last_Name__c = customer.Last_Name__c;
			app.Primary_Phone_Number__c = customer.Phone_Number__c;
			app.Secondary_Phone_Number__c = customer.Cell_Phone_Number__c;
			app.Email_Address__c = customer.Email_Address__c;
			app.Street_Address_1__c = customer.Street_Address_1__c;
			app.Street_Address_2__c = customer.Street_Address_2__c;
			app.City__c = customer.City__c;
			app.State__c = customer.State__c;
			app.Zip_Code__c = customer.Zip_Code__c;
			app.Person_Number__c = customer.Person_Identifier__c;			
			app.Customer__c = customer.id;
			iden.SSN_Prime__c = customer.SSN__c;
			iden.Date_of_Birth__c = customer.Date_Of_Birth__c;
			system.debug('customer ssn:'+customer.SSN__c);
		}

		// To update type of BusinessChecking product selected
		if (app.Product__c.contains(Product_Names_Mapping__c.getValues('Business').Product_Name__c)) {
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
		        app.Type_Of_Business_Checking__c = app.Sub_Product__c;
		    }

		    // To update Type of BusinessSavings Product selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
		        app.Type_Of_Business_Savings__c = app.Sub_Product__c;
		    } 

		    // To update type of BusinessCDs product selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
		        app.Type_Of_Business_CDs__c = app.Sub_Product__c;
		    } 
		    // To update type of BusinessCreditCards selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
		        app.Type_Of_Business_Credit_Cards__c = app.Sub_Product__c;
		    } 

		    // To update type of BusinessLoans selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
		        app.Type_Of_Business_Loans__c = app.Sub_Product__c;
		    } 

		} else {
		    // to update type of Checking Product Selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
		        app.Type_of_Checking__c = app.Sub_Product__c;
		    } 

		    // To update Type of Savings Product selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
		        app.Type_of_Savings__c = app.Sub_Product__c;
		    } 

		    // To update type of Certificates product selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
		        app.Type_of_Certificates__c = app.Sub_Product__c;
		    } 

		    // To update type of Credit Cards selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
		        app.Type_of_Credit_Cards__c = app.Sub_Product__c;
		    } 

		    // To update type of Vehicle Loans selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
		        app.Type_of_Vehicle_Loans__c = app.Sub_Product__c;
		    } 

		    // To update type of Personal Loan selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
		        app.Type_of_Personal_Loans__c = app.Sub_Product__c;
		    } 

		    // To update type of Mortgage Loan product selected
		    if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
		        app.Type_of_Mortgage_Loan__c = app.Sub_Product__c;
		    } 
		                
		    // To update type of Home Equity product selected
		    if (app.Sub_Product__c!=null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
		        app.Type_Of_Home_Equity__c=app.Sub_Product__c;
		    } 
		}

		app.Number_of_Products__c = 1;
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

		if (Application2__c.SObjectType.getDescribe().isCreateable()) {
			insert app2;
		}
		if (Employment_Information__c.SObjectType.getDescribe().isCreateable()) {
			insert emp;
		}
		if (Identity_Information__c.SObjectType.getDescribe().isCreateable()) {
			insert iden;
		}
		if (About_Account__c.SObjectType.getDescribe().isCreateable()) {
			insert acc;
		}
		if (Application_Activity__c.SObjectType.getDescribe().isCreateable()) {
			insert appact;
		}
		
		if (Documentation_Request__c.SObjectType.getDescribe().isCreateable()) {
				doc.Application__c= app.Id;
				doc.Status__c = 'Approved';
				doc.Type__c = 'Upload a photo ID';
				insert doc;
		}

		String userToken = CryptoHelper.decrypt(app.User_Token__c);

		pagereference p=page.INDEX;
		
		Cookie id = ApexPages.currentPage().getCookies().get('id');
		Cookie ut = ApexPages.currentPage().getCookies().get('ut');
		id = new Cookie('id',app.Id,null,-1,true);
		ut = new Cookie('ut',userToken,null,-1,true);

	    // Set the new cookie for the page
	    ApexPages.currentPage().setCookies(new Cookie[]{id,ut});

	    p.setRedirect(false);
		    
		return p;		
	}
}