@isTest
private class Promotion_Test {
	
	@isTest static void test_method_one() {
		// Implement test code
		Promotion__c promo = new Promotion__c();
		promo.CampaignID__c = 'ABCD';
		promo.Description__c = 'test';
		insert promo;
		PageReference p = Page.Promotion;
		Test.setCurrentPage(p);
		ApexPages.currentPage().getParameters().put('id',promo.id);
		Promotion pro = new Promotion();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		Promotion__c promo = new Promotion__c();
		promo.CampaignID__c = 'ABCD';
		promo.Description__c = 'test';
		insert promo;
		PageReference p = Page.Promotion;
		Test.setCurrentPage(p);
		ApexPages.currentPage().getParameters().put('id',promo.id);

		ApexPages.StandardController sc=new ApexPages.StandardController(promo);
		Promotion pr =new Promotion(sc);


		String s = 'This will form the body of the attachement';
		Attachment att = new Attachment();
		att.name = 'TestPDF';
		att.Body = Blob.valueOf(s);
		att.parentId = promo.id;
		insert att;

		pr.getFileId();
	}
	
}