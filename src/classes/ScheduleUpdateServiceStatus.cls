global class ScheduleUpdateServiceStatus implements Schedulable {
	
	//public Static String CRON_EXP = '0 15 * * * ?';
	public Static String CRON_EXP ='0 0 * * * ?';


	public Static String ScheduleNow(){
		ScheduleUpdateServiceStatus SUA = new ScheduleUpdateServiceStatus();
		if(!Test.IsRunningTest())return System.Schedule('ServiceStatus_update',CRON_EXP,SUA);
		else return null;
	}

	global void execute(SchedulableContext sc) {
		UpdateServiceStatus UpdateServStatus = new UpdateServiceStatus();
		Database.executebatch(UpdateServStatus,10);
	}
}