global class ScheduleUpdateAppStatus implements Schedulable {
	
	//public Static String CRON_EXP = '0 15 * * * ?';
	public Static String CRON_EXP ='0 0 * * * ?';
	public Static String CRON_EXP_10 ='0 10 * * * ?';
	public Static String CRON_EXP_20 ='0 20 * * * ?';
	public Static String CRON_EXP_30 ='0 30 * * * ?';
	public Static String CRON_EXP_40 ='0 40 * * * ?';
	public Static String CRON_EXP_50 ='0 50 * * * ?';

	public Static String ScheduleNow(){
		ScheduleUpdateAppStatus SUA = new ScheduleUpdateAppStatus();
		if(!Test.IsRunningTest())return System.Schedule('AppStatus_update',CRON_EXP,SUA);
		else return null;
	}

	public Static String ScheduleNow10(){
		ScheduleUpdateAppStatus SUA = new ScheduleUpdateAppStatus();
		if(!Test.IsRunningTest())return System.Schedule('AppStatus_update_10',CRON_EXP_10,SUA);
		else return null;
	}

	public Static String ScheduleNow20(){
		ScheduleUpdateAppStatus SUA = new ScheduleUpdateAppStatus();
		if(!Test.IsRunningTest())return System.Schedule('AppStatus_update_20',CRON_EXP_20,SUA);
		else return null;
	}

	public Static String ScheduleNow30(){
		ScheduleUpdateAppStatus SUA = new ScheduleUpdateAppStatus();
		if(!Test.IsRunningTest())return System.Schedule('AppStatus_update_30',CRON_EXP_30,SUA);
		else return null;
	}

	public Static String ScheduleNow40(){
		ScheduleUpdateAppStatus SUA = new ScheduleUpdateAppStatus();
		if(!Test.IsRunningTest())return System.Schedule('AppStatus_update_40',CRON_EXP_40,SUA);
		else return null;
	}

	public Static String ScheduleNow50(){
		ScheduleUpdateAppStatus SUA = new ScheduleUpdateAppStatus();
		if(!Test.IsRunningTest())return System.Schedule('AppStatus_update_50',CRON_EXP_50,SUA);
		else return null;
	}


	global void execute(SchedulableContext sc) {
		UpdateAppStatus UpdateApplicationStat = new UpdateAppStatus();
		Database.executebatch(UpdateApplicationStat,10);
	}
}