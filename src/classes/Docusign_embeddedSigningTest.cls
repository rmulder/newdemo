@isTest
private class Docusign_embeddedSigningTest {
	
	@isTest static void test_method_one() {
		Field_Logic_New__c fl = new Field_Logic_New__c(Field_Name__c = 'Disclosure1__c',IsDisplayed__c = true,IsRequired__c = true,Product__c = 'Checking',Sub_Products__c = 'Checking - Checking');
		insert fl;
		
		Disclosure__c dl = new Disclosure__c(Name = 'TestDisclosure - DS');
		insert dl;

		Blob b = Blob.valueOf('blob');
		Attachment a = new Attachment(Name = 'TestDisclosure_DS.pdf', body = b, ParentId = dl.id);
		insert a;

		Application__c app = new Application__c(First_Name__c = 'TestFirst',Last_Name__c = 'TestLast', Email_Address__c = 'test@test.com',Product__c = 'Checking',Sub_Product__c = 'Checking - Checking');
		insert app;
		
		Docusign_Config__c doc = new Docusign_Config__c(Name = 'cred', AccountID__c = 'test', Username__c = 'test',Password__c = 'test', IntegratorKey__c = 'test');
		insert doc;

		String searchToken = 'https://demo.docusign.net/restapi/v2/login_information/envelopes/6bde6735-fac9-478a-82a1-e4cd055ef483/views/recipient';
		String st='<viewUrl xmlns="http://www.docusign.com/restapi" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><url>https://demo.docusign.net/Member/StartInSession.aspx?t=785f891b-b4a1-46e6-828c-0312f11573fb</url></viewUrl>';

		Docusign_embeddedSigning docu = new Docusign_embeddedSigning();

		Docusign_embeddedSigning.parseXMLBody(st, searchToken);
		//Docusign_embeddedSigning.main(app.id);

		system.assertEquals('TestDisclosure_DS.pdf',a.Name);
	}

	
}