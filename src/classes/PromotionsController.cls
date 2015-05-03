public with sharing class PromotionsController {

    public Promotion__c promo{get;set;}
    public String promotionId;
    public List<Promotion__c> promotionsList{get;set;}
    public List<String> productList{get;set;}
    public String productListString{get;set;}

    public PromotionsController(ApexPages.StandardSetController controller) {
        //promotionsList = [SELECT id, Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c LIMIT 500];
        this.promo = (promotion__c)controller.getRecord();
        List<Product_Codes__c> prodCodes = Product_Codes__c.getall().values();
        productList = new List<String>();
        if (prodCodes.size() > 0) {
            for (Product_Codes__c pc :prodCodes) {
                productList.add(pc.Name + '_' + pc.Sub_Product__c);
            }
        }
        productListString = JSON.serialize(productList);
    }

    public ApexPages.StandardSetController pro {
        get{
            if(pro == null){
                pro= new ApexPages.StandardSetController(Database.getQueryLocator([Select Id,Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c Order By Name]));
            }
            //sets the number of records in each page set
            pro.setPageSize(10);
            return pro;
        }
        set;
    }

    public List<promotion__c> getpromotionList(){
        return (List<promotion__c>) pro.getRecords();
    }

    public void firstPage(){
        pro.first();
    }

    public void next(){
        pro.next();
    }

    public void previous() {
        pro.previous();
    }

    public void lastPage(){
        pro.last();
    }

    public Boolean gethasNext(){
        return pro.getHasNext();
    }

    public Boolean gethasPrevious(){
        return pro.getHasPrevious();
    }

    public Boolean getCount(){
        Decimal totalSize = pro.getResultSize();
        Decimal pageSize = pro.getPageSize();
 
        Decimal pages = totalSize/pageSize;
        
        if(pages > 1){
            return true;
        }else{
            return false;
        }
    }

    public Integer getPageNumber(){
       return pro.getPageNumber();
    }

    Public Integer getTotalPages(){
 
        Decimal totalSize = pro.getResultSize();
        Decimal pageSize = pro.getPageSize();
 
        Decimal pages = totalSize/pageSize;
 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }


    @RemoteAction
    public static String uploadAttachment(String promoId, Integer attachmentNumber, String attachmentBody, String attachmentName, String attachmentId) {
        if (promoId != null) {
            Promotion__c promo = getPromoRec(promoId);
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
                    if (Attachment.SObjectType.getDescribe().isUpdateable() && Attachment.SObjectType.getDescribe().isCreateable()) {upsert att;}
                    if (attachmentNumber != null) {
                        if (attachmentNumber == 1) {
                            promo.Attachment1__c = att.Id;
                        } else if (attachmentNumber == 2) {
                            promo.Attachment2__c = att.Id;
                        } else {
                            promo.Attachment3__c = att.Id;
                        }
                        if (Promotion__c.SObjectType.getDescribe().isUpdateable()) {update promo;}
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
    public static String deleteAttachment(String promoId, Integer attachmentNumber, String attachmentId) {
        if (promoId != null) {
            Promotion__c promo = getPromoRec(promoId);
            if (promo != null) {
                Attachment att = getAttachment(attachmentId);
                if (Attachment.SObjectType.getDescribe().isDeletable()) {delete att;}
                if (attachmentNumber == 1) {
                    promo.Attachment1__c = null;
                } else if (attachmentNumber == 2) {
                    promo.Attachment2__c = null;
                } else {
                    promo.Attachment3__c = null;
                }
                if (Promotion__c.SObjectType.getDescribe().isUpdateable()) {update promo;}
                return 'Deleted';
            } else {
                return 'Promotion could not be found';
            }
        } else {
            return 'Promotion Id was null';
        }
    }
     
    private static Promotion__c getPromoRec(String promoId) {
        List<Promotion__c> promos = [SELECT id, Attachment1__c, Attachment2__c, Attachment3__c FROM Promotion__c WHERE id=:promoId];
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

    @RemoteAction
    public static Map<String,String> getPromo(Id promotionId) {
        Map<String,String> data = new Map<String,String>();
        Promotion__c promo = [SELECT id, Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c WHERE id=:promotionId];
        //data.put('error_' + field, errMsg);

        IndexUtilityExtension.getData(data, (Promotion__c)promo, true);
        return data;
    }

    @RemoteAction
    public static Map<String,String> updatePromo(Map<String,String> tdata) {
        Map<String,String> data = tdata.clone();
        Id promotionId = data.get('id');
        system.debug('The promotion id is ########################' + promotionId);
        data.remove('id');
        Promotion__c promo = [SELECT id, Description__c, Attachment1__c, Attachment2__c, Attachment3__c, CampaignID__c, Keywords__c, RichTextArea1__c, Sub_Product_Code__c, Template__c, TextArea1__c, URL__c FROM Promotion__c WHERE id=:promotionId];

        IndexUtilityExtension.setData(data, (Promotion__c)promo);
        if (Promotion__c.SObjectType.getDescribe().isUpdateable()) {update promo;}
        IndexUtilityExtension.getData(data, (Promotion__c)promo, true);
        return data;
    }

    @RemoteAction
    public static Map<String,String> createPromo(String description) {
        Map<String,String> data = new Map<String,String>();
        Promotion__c promo = new Promotion__c();
        promo.Description__c = description;
        if (Promotion__c.SObjectType.getDescribe().isCreateable()) {insert promo;}
        IndexUtilityExtension.getData(data, (Promotion__c)promo, true);
        promo.URL__c = SiteUrl__c.getOrgDefaults().Url__c+'Promotion?id='+promo.Id;
        if (Promotion__c.SObjectType.getDescribe().isUpdateable()) {update promo;}
        IndexUtilityExtension.getData(data, (Promotion__c)promo, true);
        return data;
    }

    @RemoteAction
    public static Map<String,String> deletePromo(Id promotionId) {
        Attachment att;
        Map<String,String> data = new Map<String,String>();
        Promotion__c promo = [SELECT id, Attachment1__c, Attachment2__c, Attachment3__c FROM Promotion__c WHERE id=:promotionId];
        //data.put('error_' + field, errMsg);

        if (promo.Attachment1__c != null) {
            att = getAttachment(promo.Attachment1__c);
            if (att != null) {
                if (Attachment.SObjectType.getDescribe().isDeletable()) {delete att;}
            }
        }
        if (promo.Attachment2__c != null) {
            att = getAttachment(promo.Attachment2__c);
            if (att != null) {
                if (Attachment.SObjectType.getDescribe().isDeletable()) {delete att;}
            }
        }
        if (promo.Attachment3__c != null) {
            att = getAttachment(promo.Attachment3__c);
            if (att != null) {
                if (Attachment.SObjectType.getDescribe().isDeletable()) {delete att;}
            }
        }
        if (Promotion__c.SObjectType.getDescribe().isDeletable()) {delete promo;}

        return data;
    }
}