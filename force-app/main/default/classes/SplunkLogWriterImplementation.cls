//Sample implementation for writing log to external system
public with sharing class SplunkLogWriterImplementation implements LogWriterInterface{
    public void writeLogs(List<LogWrapper> logs) {
        SendToSplunkQueueable splunkQueueable = new SendToSplunkQueueable(logs);
        System.enqueueJob(splunkQueueable);
    }

    public class SendToSplunkQueueable implements Queueable, Database.AllowsCallouts {
        private List<LogWrapper> incomingLogs;
        public  SendToSplunkQueueable(List<LogWrapper> logs) {
            this.incomingLogs = logs;
        }

        public void execute(QueueableContext context) {
            //Errors to be handled
            SplunkApiClient.sendLogs(JSON.serialize(incomingLogs));
        }
    }
}