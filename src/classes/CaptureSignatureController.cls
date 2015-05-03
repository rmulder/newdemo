global with sharing class CaptureSignatureController {
    public Application__c app{get;set;} 
    //public id appId{get;set;}
    
    
 
    @RemoteAction
    global static String saveSignature(String imageUrl) {
        try{
            Id appId = ApexPages.currentPage().getParameters().get('id'); 
            Attachment accSign = new Attachment();
            accSign.ParentID = appId;
            accSign.Body = EncodingUtil.base64Decode(imageUrl);
            accSign.contentType = 'image/png';
            accSign.Name = 'Signature Image';
            accSign.OwnerId = UserInfo.getUserId();
            insert accSign;
            return 'success';
        }catch(Exception e){
            system.debug('---------- ' + e.getMessage());
            return JSON.serialize(e.getMessage());
        }
        return null; 
    }

}