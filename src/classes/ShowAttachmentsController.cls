public with sharing class ShowAttachmentsController{
    public List<Attachment> attachmentList{get;set;}
    public List<Identity_Information__c> identityRecord{get;set;}
    
    public ShowAttachmentsController(){
        String userId = UserInfo.getUserId();
        User u = [select Application_Id__c from User where Id = :userId];
        identityRecord = [select id from Identity_Information__c where Application__c = :u.Application_Id__c];
        if(identityRecord.size()>0){
            attachmentList = [select id,Body,Name from Attachment where ParentId = :identityRecord.get(0).id];
        }
        
    }
}