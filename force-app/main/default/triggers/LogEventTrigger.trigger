Trigger LogEventTrigger on Log_Event__e (after insert) {
    //Use a trigger handler framework
    LogEventTriggerHandler.handleLogEvents(Trigger.new);
}