@isTest
private class ScheduleUpdateAppStatus_Test {
	
	public Static String CRON_EXP = '0 0 0 1 1 ? 2025'; 

	@isTest static void test_method_one() {
		Test.startTest();
		String jobID = System.schedule('TESTING SCHDULE CLASS FOR UPDATE BATCH CLASS', CRON_EXP, new ScheduleUpdateAppStatus());
		String jobID1 = ScheduleUpdateAppStatus.ScheduleNow();
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Test.startTest();
		String jobID = System.schedule('TESTING SCHDULE CLASS FOR UPDATE BATCH CLASS', CRON_EXP, new ScheduleUpdateAppStatus());
		String jobID1 = ScheduleUpdateAppStatus.ScheduleNow10();
		Test.stopTest();
	}

	@isTest static void test_method_three() {
		Test.startTest();
		String jobID = System.schedule('TESTING SCHDULE CLASS FOR UPDATE BATCH CLASS', CRON_EXP, new ScheduleUpdateAppStatus());
		String jobID1 = ScheduleUpdateAppStatus.ScheduleNow20();
		Test.stopTest();
	}

	@isTest static void test_method_four() {
		Test.startTest();
		String jobID = System.schedule('TESTING SCHDULE CLASS FOR UPDATE BATCH CLASS', CRON_EXP, new ScheduleUpdateAppStatus());
		String jobID1 = ScheduleUpdateAppStatus.ScheduleNow30();
		Test.stopTest();
	}

	@isTest static void test_method_five() {
		Test.startTest();
		String jobID = System.schedule('TESTING SCHDULE CLASS FOR UPDATE BATCH CLASS', CRON_EXP, new ScheduleUpdateAppStatus());
		String jobID1 = ScheduleUpdateAppStatus.ScheduleNow40();
		Test.stopTest();
	}

	@isTest static void test_method_six() {
		Test.startTest();
		String jobID = System.schedule('TESTING SCHDULE CLASS FOR UPDATE BATCH CLASS', CRON_EXP, new ScheduleUpdateAppStatus());
		String jobID1 = ScheduleUpdateAppStatus.ScheduleNow50();
		Test.stopTest();
	}
	
}