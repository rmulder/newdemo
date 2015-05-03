public with sharing class CallUpdateAppStatus{
    public PageReference callBatch(){
        ScheduleUpdateAppStatus.ScheduleNow();
        ScheduleUpdateAppStatus.ScheduleNow10();
        ScheduleUpdateAppStatus.ScheduleNow20();
        ScheduleUpdateAppStatus.ScheduleNow30();
        ScheduleUpdateAppStatus.ScheduleNow40();
        ScheduleUpdateAppStatus.ScheduleNow50();

        return null;
    }
}