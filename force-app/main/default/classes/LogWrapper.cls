public with sharing class LogWrapper {
    public String className;
    public String context;
    public Logger.Level level;
    public String message;
    public Id userId;

    public LogWrapper(String className, Logger.Level level, String message) {
        this.className = className;
        this.context = Request.getCurrent().getQuiddity().toString();
        this.level = level == null ? Logger.Level.DEBUG : level;
        this.message = message;
        this.userId = UserInfo.getUserId();
    }

    public LogWrapper(Log_Event__e logEvent) {
        this.className = logEvent.Class_Name__c;
        this.context = logEvent.Context__c;
        this.level = logEvent.Level__c == null ? Logger.Level.DEBUG : Logger.Level.valueOf(logEvent.Level__c);
        this.message = logEvent.Message__c;
        this.userId = logEvent.User_Id__c;
    }

    public Log_Event__e convertToLogEvent() {
        return new Log_Event__e(
            Class_Name__c = this.className,
            Context__c = this.context,
            Level__c = this.level.name(),
            Message__c = this.message,
            User_Id__c = this.userId
        );
    }
}