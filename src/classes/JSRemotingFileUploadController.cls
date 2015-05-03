global with sharing class JSRemotingFileUploadController {
    public JSRemotingFileUploadController(ApexPages.StandardController c) {
    }
    @RemoteAction
    public static String doUploadAttachment(String promoId, Integer attachmentNumber, String attachmentBody, String attachmentName, String attachmentId) {
        if (promoId != null) {
            Promotion__c promo = getPromo(promoId);
            if (promo != null) {
                if (attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    String newBody = '';
                    if (att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    newBody += attachmentBody;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    if (attachmentId == null) {
                        att.Name = attachmentName;
                        att.parentId = promo.Id;
                    }
                    upsert att;
                    if (attachmentNumber != null) {
                        if (attachmentNumber == 1) {
                            promo.Attachment1__c = att.Id;
                        } else if (attachmentNumber == 2) {
                            promo.Attachment2__c = att.Id;
                        } else {
                            promo.Attachment3__c = att.Id;
                        }
                        update promo;
                    }
                    return att.Id;
                } else {
                    return 'Attachment Body was null';
                }
            } else {
                return 'Promotion could not be found';
            }
        } else {
            return 'Promotion Id was null';
        }
    }
     
    @RemoteAction
    public static String doSubmitForm(String promoId, String description, String website, String phone) {
        if (promoId != null) {
            Promotion__c promo = getPromo(promoId);
            if (promo != null) {
                //promo.Description = description;
                //promo.Website = website;
                //promo.Phone = phone;
                update promo;
                return 'Success';
            } else {
                return 'Promotion could not be found';
            }
        } else {
            return 'Promotion Id was null';
        }
    }
     
    private static Promotion__c getPromo(String promoId) {
        List<Promotion__c> promos = [SELECT id, Description__c, Attachment1__c, Attachment2__c, Attachment3__c FROM Promotion__c WHERE id=:promoId];
        if (promos.isEmpty()) {
            return null;
        } else {
            return promos[0];
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
}