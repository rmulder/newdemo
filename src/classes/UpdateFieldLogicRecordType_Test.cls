@isTest
private class UpdateFieldLogicRecordType_Test {
	
	@isTest static void test_method_one() {
		// Implement test code
		List<Field_Logic_New__c> fieldLogiclist = new List<Field_Logic_New__c>();
		for(integer i = 0; i < 10; i++){
			Field_Logic_New__c fl = new Field_Logic_New__c();
			fl.Product__c = 'Checking';
			fl.Sub_Products__c = 'Checking - Silver';
			fl.Field_Name__c = 'Account_Holder_Name_CHK__c';
			fl.Label__c = 'CHK - Account Holder Name';

			fieldLogiclist.add(fl);
		}
		insert fieldLogiclist;

		Test.startTest();
		UpdateFieldLogicRecordType uflrt = new UpdateFieldLogicRecordType();
	    Database.executeBatch(uflrt);
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		List<Field_Logic_New__c> fieldLogiclist2 = new List<Field_Logic_New__c>();
		for(integer i = 0; i < 10; i++){
			Field_Logic_New__c fl2 = new Field_Logic_New__c();
			fl2.Page_Name__c = 'GetStartedPage';
			fl2.Value__c = 'Begin your application here';
			fl2.Label_Name__c = 'Get_Started_Heading__c';

			fieldLogiclist2.add(fl2);
		}
		insert fieldLogiclist2;

		Test.startTest();
		UpdateFieldLogicRecordType uflrt = new UpdateFieldLogicRecordType();
	    Database.executeBatch(uflrt);
		Test.stopTest();
	}
	
}