public with sharing class Logger {
    public Enum Level {ERROR, WARN, DEBUG, INFO}
    private static List<LogWrapper> logs = new List<LogWrapper>();
    private static Log_Settings__c logSettings = Log_Settings__c.getInstance(UserInfo.getUserId());

    //We can add a lot of overloaded methods like below for convenience
    public static void addLog(String message) {
        addLog(null, Level.DEBUG, message);
    }

    public static void addLog(Object obj) {
        //Handle non-serializable objects
        addLog(null, Level.DEBUG, JSON.serialize(obj));
    }

    public void log(String className, Exception e) {
        addLog(className, Level.ERROR, e.getMessage() + e.getStackTraceString());
    }

    public static void addLog(String className, Level level, String message) {
        logs.add(new LogWrapper(className, level, message));
        writeLogs();
    }
    
    public static void addLogToQueue(String className, Level level, String message) {
        logs.add(new LogWrapper(className, level, message));
    }

    public static void saveLogsInQueue() {
        if(!logs.isEmpty()) {
            writeLogs();
        }
    }

    private static void writeLogs() {
        if(logSettings != null && logSettings.Is_Enabled__c) {
            //If synchronous logging implementations are there, we invoke those classes synchronously
            if(String.isNotBlank(logSettings.Sync_Log_Writer_Implementations__c)) {
                LoggerUtils.invokeLogWriters(logs, logSettings.Sync_Log_Writer_Implementations__c);
            }

            //If asynchronous logging implementations are there, platform event is fired
            //and the implementations are invoked asynchronously
            if(String.isNotBlank(logSettings.Async_Log_Writer_Implementations__c)) {
                List<Log_Event__e> logEvents = new List<Log_Event__e>();
                for(LogWrapper log: logs) {
                    logEvents.add(log.convertToLogEvent());
                }
                EventBus.publish(logEvents);
            }
        }
        logs.clear();
    }

}