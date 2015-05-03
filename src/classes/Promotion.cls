public with sharing class Promotion {
    public String NAMESPACE{get; set;}

    public Promotion() {
        promotionId = ApexPages.currentPage().getParameters().get('id');
        if (promotionId != null) {
            promo = [SELECT id, Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c WHERE id=:promotionId];
        }
        ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'Index'];
        if (ac.NameSpacePrefix == null) {
            NAMESPACE = '';
        } else {
            NAMESPACE = ac.NameSpacePrefix + '__';
        }
    }


    public Promotion__c promo{get;set;}
    public String promotionId;

    public Promotion(ApexPages.StandardController controller) {
        promo = (Promotion__c)controller.getRecord();
        promotionId = ApexPages.currentPage().getParameters().get('id');
        if (promotionId != null) {
            promo = [SELECT id, Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c WHERE id=:promotionId];
        }
        ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'Index'];
        if (ac.NameSpacePrefix == null) {
            NAMESPACE = '';
        } else {
            NAMESPACE = ac.NameSpacePrefix + '__';
        }
    }

    public String getFileId() {
        String fileId = '';
        List<Attachment> attachedFiles = [select Id from Attachment where parentId =:promotionId order By LastModifiedDate DESC limit 1];
        if( attachedFiles != null && attachedFiles.size() > 0 ) {
            fileId = attachedFiles[0].Id;
        }
        return fileId;    
    } 
}