//Leverage some trigger handler framework
public with sharing class LogEventTriggerHandler {
    public static void handleLogEvents(List<Log_Event__e> events) {
        Log_Settings__c logSettings = Log_Settings__c.getInstance(UserInfo.getUserId());
        //If asynchronous log writers are there, those are dynamically invoked
        if(logSettings != null && logSettings.Is_Enabled__c && String.isNotBlank(logSettings.Async_Log_Writer_Implementations__c)) {
            List<LogWrapper> logs = new List<LogWrapper>();
            for(Log_Event__e event: events) {
                logs.add(new LogWrapper(event));
            }
            LoggerUtils.invokeLogWriters(logs, logSettings.Async_Log_Writer_Implementations__c);
        }
    }

}