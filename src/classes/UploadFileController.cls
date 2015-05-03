public with sharing class UploadFileController {
	public Application__c app{get;set;}
    public String applicationId{get; set;}
    public List<Application__c> applicationRecord;
    public List<Identity_Information__c> identityRecord{get;set;}
    public Attachment myfile;
    public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }
	public UploadFileController() {
		String userId = UserInfo.getUserId();
		User u = [select Application_Id__c from User where Id = :userId];
		identityRecord = [select id from Identity_Information__c where Application__c = :u.Application_Id__c];
	}

	public PageReference uploadAttachment(){
         Attachment a = new Attachment(ParentId = identityRecord.get(0).Id,Name = myfile.name, Body = myfile.body);
         insert a;
         return null;
    }
}