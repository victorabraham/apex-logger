public with sharing class LoggerUtils {
    public static void invokeLogWriters(List<LogWrapper> logs, String implementations) {
        if(!logs.isEmpty() && String.isNotBlank(implementations)) {
            List<String> logWriters = implementations.split(',');
            for (String className: logWriters) {
                try {
                    LogWriterInterface customType = (LogWriterInterface)Type.forName(className).newInstance();
                    customType.writeLogs(logs);
                } catch (Exception e) {
                    System.debug(e.getMessage());
                }
            }
        }
    }
}