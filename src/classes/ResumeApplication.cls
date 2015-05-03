public with sharing class ResumeApplication {

	public Application__c app{get;set;}
    public String newApplicationId{get; set;}
    public User loggedInUser{get;set;}
    public String usr{get;set;}
    public String id{get; set;}
    public String ut{get; set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public ResumeApplication(ApexPages.StandardController controller) {
        this.app = (Application__c)controller.getrecord();
    
        newApplicationId=ApexPages.currentPage().getParameters().get('id'); 
        usr = ApexPages.currentPage().getParameters().get('usr');
        system.debug('The user is' + usr);
        app=[select id,Application_Status__c,Application_page__c,Current_Channel__c,Current_timestamp__c,Current_Person__c,Current_Branch_Name__c,Current_User_Email_Address__c FROM Application__c where Id=:newApplicationId];
        if(usr!=null){
            loggedInUser=[select id,Email,Channel__c,Location__c,Name from User where Id=:usr];
        }
        if(usr!=null){
            if (loggedInUser.Channel__c == 'Branch') {
                    app.Current_Channel__c = 'Branch';
            }else if(loggedInUser.Channel__c == 'Call Center'){
                app.Current_Channel__c = 'Call Center';
            }else{
                app.Current_Channel__c = loggedInUser.Channel__c;
            }
            app.Current_timestamp__c = system.now();
            app.Current_Person__c = loggedInUser.Id;
            app.Current_Branch_Name__c = loggedInUser.Location__c;
            app.Current_User_Email_Address__c=loggedInUser.Email;
            app.Ownerid = loggedInUser.Id;
        }
        else{
            app.Current_Channel__c='Online'; 
            app.Current_timestamp__c =system.now();
            app.Current_Person__c = loggedInUser.Id;
            app.Current_Branch_Name__c = loggedInUser.Location__c;
            app.Current_User_Email_Address__c=loggedInUser.Email;
        }
    }        

    public PageReference Resumeapp() {
        Logger.inputSource('ResumeApplication - Resumeapp', newApplicationId);
        system.debug('Application Status ' +app.Application_Status__c);
        if(app.Application_Status__c != 'Submitted'){ 
            system.debug('Application is Submitted');
            app.Application_Status__c = 'Open';
            system.debug('Application is Status open'); 
        }
        app.Application_Page__c = 'PersonalInfoPage';
        CryptoHelper.setAppToken(app);
        
        if (Application__c.SObjectType.getDescribe().isUpdateable()) {
            update app;
        }

        String userToken = CryptoHelper.decrypt(app.User_Token__c);
        CryptoHelper.refreshToken(app);
        Application_Activity__c appact = new Application_Activity__c ();
        if (Application__c.SObjectType.getDescribe().isUpdateable()) {
            update app;
        }

        appact.Application__c= app.Id;
        appact.Branch__c = app.Current_Branch_Name__c;
        appact.Channel__c = app.Current_Channel__c;
        appact.Name__c = app.Current_Person__c;
        appact.Action__c = 'Resumed the Application';
        appact.Activity_Time__c = system.now();

        if(Application_Activity__c.SObjectType.getDescribe().isCreateable()) {     
            insert appact;
        }
        Logger.addMessage('Redirecting to INDEX page', system.now().format());
        //pagereference p=page.INDEX;
        pagereference p = null;
        p = new PageReference(SiteUrl__c.getOrgDefaults().Url__c+'index#personal-info');
        Cookie id = ApexPages.currentPage().getCookies().get('id');
        Cookie ut = ApexPages.currentPage().getCookies().get('ut');
        id = new Cookie('id',app.Id,null,-1,true);
        ut = new Cookie('ut',userToken,null,-1,true);
        
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{id,ut});

        p.setRedirect(false);

        Logger.writeAllLogs();
        
        return p;
    }    

}