public with sharing class StartApp {

	Customer__c customer = new Customer__c();
	Application__c app = new Application__c();
	Application2__c app2 = new Application2__c();
	Employment_Information__c emp = new Employment_Information__c();
	Identity_Information__c iden = new Identity_Information__c();
	About_Account__c acc = new About_Account__c();
	Application_Activity__c appact = new Application_Activity__c();

    public String customerID{get; set;}
    public User loggedInUser{get;set;}
    public String nameSpace{get; set;}

    public StartApp(ApexPages.StandardController controller) {
    	customerID = ApexPages.currentPage().getParameters().get('id');
    	customer = [SELECT id,First_Name__c,Middle_Name__c,Last_Name__c,Phone_Number__c,Cell_Phone_Number__c,Email_Address__c,Street_Address_1__c,Street_Address_2__c,City__c,State__c,Zip_Code__c,Person_Identifier__c,SSN__c,Date_Of_Birth__c,Company__c FROM Customer__c WHERE id = :customerID];
        String userId=UserInfo.getUserId();
        loggedInUser=[select id,Channel__c,Name,Email,Location__c,Profile.Name from User where Id=:userId];

        if (Application_Configuration__c.getOrgDefaults().Namespace__c == null || Application_Configuration__c.getOrgDefaults().Namespace__c == '') {
            nameSpace = '';
        } else {
            nameSpace = Application_Configuration__c.getOrgDefaults().Namespace__c;
        }
    }

    public PageReference createApp() {
    	if (customerID != null) {
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
            app.Application_Status__c = 'Open';
    		if (Application__c.SObjectType.getDescribe().isCreateable()) {
    			insert app;
    		}

			app2.Application__c= app.Id;
			if (Application2__c.SObjectType.getDescribe().isCreateable()) {
				insert app2;
			}

			iden.Application__c= app.Id;
    		iden.SSN_Prime__c = customer.SSN__c;
    		iden.Date_of_Birth__c = customer.Date_Of_Birth__c;
    		if (Identity_Information__c.SObjectType.getDescribe().isCreateable()) {
    			insert iden;
    		}
    		
			emp.Application__c= app.Id;
    		emp.Employer__c = customer.Company__c;
    		if (Employment_Information__c.SObjectType.getDescribe().isCreateable()) {
    			insert emp;
    		}

    		acc.Application__c= app.Id;
    		if (About_Account__c.SObjectType.getDescribe().isCreateable()) {
    			insert acc;
    		}
    		
    		PageReference p = null;
    		//p = Page.OnlinePage;
            p = new PageReference(SiteUrl__c.getOrgDefaults().Url__c+nameSpace+'onlinepage'); 
    		p.getParameters().put('id',app.Id);
    		p.setRedirect(false);
    		return p;		
    	}

    	return null;
    }

}