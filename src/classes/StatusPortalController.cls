public with sharing class StatusPortalController {
    public Application__c applicationRecord;
    public String applicationId;
    public List<StatusWrapperClass> statusWrapperClassList{get;set;}
    public String callNumber{get;set;}
    public String userToken{get;private set;}
    public List<Documentation_Request__c> docRequestList{get;set;}
    public About_Account__c acc{get;set;}
    public Application__c app{get; set;}
    
    public StatusPortalController(ApexPages.StandardController controller) {
        applicationId=ApexPages.currentPage().getParameters().get('id');
        app = [SELECT id,(SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Application__c WHERE id = :applicationId];
        userToken=ApexPages.currentPage().getParameters().get('ut');
        system.debug('Application id is '+applicationId);
        try {
            if (applicationId!=null) {
                system.debug('Application exists');
                statusWrapperClassList=new List<statusWrapperClass>();
                applicationRecord=[select id,Sub_Product__c,Primary_Offer__c,Second_Offer__c,Third_Offer__c,Primary_Product_Status__c,Primary_Offer_Status__c,Second_Offer_Status__c,Third_Offer_Status__c,Type_of_Mortgage_Loan__c,support_phone_number__c from Application__c where id=:applicationId];
                callNumber=applicationRecord.support_phone_number__c;
                if (applicationRecord.Sub_Product__c!=null) {
                    statusWrapperClassList.add(new statusWrapperClass(applicationRecord.Sub_Product__c,applicationRecord.Primary_Product_Status__c));
                }
                if (applicationRecord.Primary_Offer__c!=null) {
                    statusWrapperClassList.add(new statusWrapperClass(applicationRecord.Primary_Offer__c,applicationRecord.Primary_Offer_Status__c));
                }
                if (applicationRecord.Second_Offer__c!=null) {
                    statusWrapperClassList.add(new statusWrapperClass(applicationRecord.Second_Offer__c,applicationRecord.Second_Offer_Status__c));
                }
                if (applicationRecord.Third_Offer__c!=null) {
                    statusWrapperClassList.add(new statusWrapperClass(applicationRecord.Third_Offer__c,applicationRecord.Third_Offer_Status__c));                        
                }

                docRequestList = [SELECT Id, Type__c, Status__c, (SELECT Id, Name from Attachments) FROM Documentation_Request__c WHERE Application__c=:applicationId];
                acc = [SELECT Id,(SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM About_Account__c WHERE Application__c=:applicationId];
                
                system.debug('hasDocRequestList:' + docRequestList);
            } // Checks if an application Id is in URL    */
        } // end of try
        catch(Exception e){
            system.debug('The error is '+e.getMessage());
        }
    } // end of Constructor

    public PageReference checkAuth() {
        return CryptoHelper.checkAuth(applicationId, userToken);
    }
    
    public boolean gethasDocRequestList() {
        system.debug('hasDocRequestList:' + docRequestList);
        if (docRequestList != null && docRequestList.size() > 0) {
            return true;
        } else {
            return false;
        }
    }
    // Wrapper class
    public class StatusWrapperClass {
        public String subProduct{get;set;}
        public String status{get;set;}

        public StatusWrapperClass(String sp,String st) {
            subProduct=sp;
            status=st;
        }
    } // End of wrapper class

    @RemoteAction
    public static String uploadAttachment(String docReqId, String attachmentBody, String attachmentName, String attachmentId) {
        if (docReqId != null) {
            try {
                Documentation_Request__c docReq = [SELECT Id, Name FROM Documentation_Request__c WHERE Id=:docReqId];
                if (docReq != null) {
                    if (attachmentBody != null) {
                        Attachment att = getAttachment(attachmentId);
                        transient String newBody = '';
                        //String newBody = '';
                        if (att.Body != null) {
                            newBody = EncodingUtil.base64Encode(att.Body);
                        }
                        newBody += attachmentBody;
                        att.Body = EncodingUtil.base64Decode(newBody);
                        if (attachmentId == null) {
                            att.Name = attachmentName;
                            att.parentId = docReq.Id;
                        }
                        if (Attachment.SObjectType.getDescribe().isUpdateable() && Attachment.SObjectType.getDescribe().isCreateable()) {upsert att;}
                        return att.Id;
                    } else {
                        return 'Attachment Body was null';
                    }
                } else {
                    return 'Document Request record could not be found';
                }
            } catch(Exception e) {
                system.debug('The error is ' + e.getMessage());
                return 'Error encountered: ' + e.getMessage();
            }
        } else {
            return 'Document Request Id was null';
        }
    }
     
    @RemoteAction
    public static String deleteAttachment(String attachmentId) {
        Attachment att = getAttachment(attachmentId);
        if (att != null) {
            if (Attachment.SObjectType.getDescribe().isDeletable()) {delete att;}
            return 'Deleted';
        } else {
            return 'Attachment could not be found';
        }
    }

    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attId];
        if (attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }

    @RemoteAction
    public static String addNote(String appId, String noteTitle, String noteBody) {
        if (appId != null) {
            Note note = new Note();
            note.ParentId = appId;
            note.Title = noteTitle;
            note.Body = noteBody;
            if(Attachment.SObjectType.getDescribe().isCreateable()) {
                insert note;    
            }
            return note.Id;
        } else {
            return 'About Account Id was null';
        }
    }
     
}  // End of class