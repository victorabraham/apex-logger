public with sharing class SystemDebugLogWriterImplementation implements LogWriterInterface{
    public void writeLogs(List<LogWrapper> logs) {
        for(LogWrapper log: logs){
            System.debug(log.className + ' ' + log.level + ' ' + log.message);
        }
    }
}