public with sharing class AppStatusPortalController {
    public String lastName{get;set;}
    public String dob{get;set;}
    public String ssn{get;set;}
    public String email{get;set;}
    public Application__c app{get;set;}
    public String applicationId{get; set;}
    public List<Application__c> applicationRecord;
    public List<Identity_Information__c> identityRecord{get;set;}
    public Attachment myfile;
    public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }
    public AppStatusPortalController(ApexPages.StandardController controller) {
        
        this.app = (Application__c)controller.getrecord();
        applicationId=ApexPages.currentPage().getParameters().get('id');
        applicationRecord = [Select id,Last_Name__c,Email_Address__c from Application__c where id=:applicationId];
        identityRecord=[select id,Date_of_Birth__c,SSN_Last_Four_PA__c from Identity_Information__c where Application__c=:applicationId limit 1];
    }

    public PageReference StatusRet() {
        Logger.inputSource('AppStatusPortalController',applicationId);
        PageReference p =null;
        if(applicationRecord.size()>0 && identityRecord.size()>0){
            if(applicationRecord.get(0).Last_Name__c==lastName && identityRecord.get(0).Date_of_Birth__c==dob && identityRecord.get(0).SSN_Last_Four_PA__c==ssn){
                p = Page.StatusPortal;
                p.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
                p.setRedirect(false);
                Logger.addMessage('Redirecting to Status Portal',system.now().format());

            }
            else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'The Information entered Doesn\'t match the record')); 
                Logger.addMessage('The Information entered does not match the record',system.now().format());
            }
        }
        else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'No application exists')); 
            Logger.addMessage('No application exists',system.now().format());
        }
        Logger.writeAllLogs();
        return p;
    }

    public PageReference uploadAttachment(){
        Logger.inputSource('AppStatusPortalController - uploadAttachment',applicationId);
        try{
            Attachment a = new Attachment(ParentId = identityRecord.get(0).Id,Name = myfile.name, Body = myfile.body);
            insert a;
            return null;
        }catch(exception e){
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            Logger.writeAllLogs();
            return null;
        }
    }
} // End of class