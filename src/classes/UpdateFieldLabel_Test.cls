@isTest
private class UpdateFieldLabel_Test {
	
	@isTest static void test_method_one() {
		
		Field_Logic_New__c fln = new Field_Logic_New__c();
		fln.Field_Label__c = 'First Name';
		fln.Field_Name__c = 'First_Name__c';
		fln.IsDisplayed__c = true;
		fln.IsRequired__c = true;
		insert fln;

		fln.Field_Name__c ='First_Name__c';
		fln.Field_Label__c = 'First';
		fln.IsDisplayed__c = false;
		update fln;
	}
		
}