public with sharing class EmailPageController {

    public String subject {get; set;}
    public String body {get; set;}

    public String eMailParam{get; set;}
    public String ccParam{get; set;}
    public String bccParam{get; set;}

    public Customer__c customer{get; set;}
    public String customerID{get; set;}

    public String selectedTemplateId{get; set;}
    public String selectedTemplateBody{get; set;}

    public List<String> folderNamesList{get; set;}

    // Create a constructor that populates the Account object
    public EmailPageController(ApexPages.StandardController controller) {

        customerID = ApexPages.currentPage().getParameters().get('id');
        if(customerID != null){
            customer = [SELECT Id,First_Name__c,Middle_Name__c,Last_Name__c,Phone_Number__c,Cell_Phone_Number__c,Email_Address__c,Street_Address_1__c,Street_Address_2__c,City__c,State__c,Zip_Code__c,Person_Identifier__c,SSN__c,Date_Of_Birth__c,Company__c FROM Customer__c WHERE id = :customerID];
            eMailParam = customer.Email_Address__c;
        } else {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please specify the Customer ID in the URL'));
        }

        Application_Configuration__c appConfig = Application_Configuration__c.getInstance(UserInfo.getUserId());
        folderNamesList = new List<String>();
        if(appConfig.Email_Folder_Name__c != null){
        	folderNamesList = appConfig.Email_Folder_Name__c.split(';');
        	System.debug('The folder name is '+folderNamesList);
        }
    }


    public PageReference send() {

        PageReference p = null;

        System.debug('The value of Subject is '+ subject);
        System.debug('The value of Body is '+ body);
        System.debug('The selected Temaplte id is '+selectedTemplateId);

        if( (subject == null || subject == '') && (selectedTemplateId == null || selectedTemplateId == 'None') ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Oops!! Please, either select an email tempalte or specify the subject of the email you are about to send'));
        } else {

            /*String[] toAddresses = new String[]{eMailParam};*/
            String[] toAddresses = new String[]{};
            String[] ccAddresses = new String[]{};
            String[] bccAddresses = new String[]{};
            toAddresses = eMailParam.split(';');
            if(ccParam != null && ccParam != ''){  
                ccAddresses = ccParam.split(';');
            }
            if(bccParam != null && bccParam != ''){   
                bccAddresses = bccParam.split(';');
            }
            if(selectedTemplateId == null || selectedTemplateId == 'None'){
                // Define the email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                // Sets the paramaters of the email
                email.setSubject(subject);
                email.setToAddresses(toAddresses);
                if(ccAddresses.size() > 0){
                    email.setCcAddresses(ccAddresses);
                }
                if(bccAddresses.size() > 0){
                    email.setBccAddresses(bccAddresses);  
                }
                email.setPlainTextBody(body);
                Messaging.SendEmailResult [] r = null;          
                try{
                   // Sends the email
                   r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
                } catch(Exception e){
                    System.debug('The error while sending an free text email '+e);
                }
            } else {

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(toAddresses);
                if(ccAddresses.size() > 0){
                    email.setCcAddresses(ccAddresses);
                }
                if(bccAddresses.size() > 0){
                    email.setBccAddresses(bccAddresses);  
                }
                email.setTemplateId(selectedTemplateId);
                email.setTargetObjectId(UserInfo.getUserId());
                email.setWhatId(customerID);
                email.setSaveAsActivity(false);
                Messaging.SendEmailResult [] r = null;

                try {
                    r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                } catch(Exception e) {
                    System.debug('The error while sending an email with template '+e);
                }
            }
            p = new PageReference(Application_Configuration__c.getOrgDefaults().Instance_URL__c+customerID);
        }

        return p;
    }

    public List<SelectOption> getTemplateOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        for(String folderName : folderNamesList){
            folderName = folderName.trim();
            for (EmailTemplate t : [SELECT Id,Name,Body FROM EmailTemplate WHERE Folder.Name = :folderName]) {
                System.debug('The template name is '+ t.Name);
                options.add(new SelectOption(t.Id,t.Name));
            }
            System.debug('The List of Options are '+options);
        }

        return options;
    }

}