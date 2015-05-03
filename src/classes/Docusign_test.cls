@isTest
private class Docusign_test {
	
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

		Docusign docu = new Docusign();
		docu.main(app.id);

		system.assertEquals('TestDisclosure_DS.pdf',a.Name);

	}
	
	
}