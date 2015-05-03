@RestResource(urlMapping='/Attachments/v1/*')
global with sharing class AttachmentsRESTAPI
{
  @HttpPost
  global static String attachDoc() {
    System.debug('inside attachDoc');
    RestRequest req = RestContext.request;
    RestResponse res = Restcontext.response;
    //res.addHeader('Access-Control-Allow-Origin', Service_Configuration__c.getOrgDefaults().Siteurl__c);
    //res.addHeader('Content-Type', 'application/json');

    String fName = req.params.get('fileName'); 
    String parentId = req.params.get('parentId');  
    String attachmentId = req.params.get('attachmentId');  
    System.debug('fName:' + fName + '; parentId:' + parentId + '; attachmentId:' + attachmentId);
    Blob postContent = req.requestBody; 

    Attachment att = getAttachment(attachmentId);
    att.ParentId = parentId;
    att.Body = postContent;
    att.Name = fName;
    if (Attachment.SObjectType.getDescribe().isUpdateable() && Attachment.SObjectType.getDescribe().isCreateable()) {
        upsert att;
    }

    return att.Id;
  }

  private static Attachment getAttachment(String attId) {
    Attachment a = new Attachment();
    if (attId != null) {
      List<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attId];
      if (!attachments.isEmpty()) {
          a = attachments[0];
      }
    }

    return a;
  }

}