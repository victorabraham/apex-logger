# Logging utility written in apex

## Common Logging Scenarios handled
    - Synchronous single log
    - Synchronous bulk logs
    - Asynchronous single log
    - Asynchronous bulk logs

## Features

-  Easily extend to add more ways of writing logs using dependency injection
    - ```SplunkLogWriterImplementation``` - postman-echo example
    - ```SystemDebugLogWriterImplementation``` - Synchronous logging sample
    - There could be more like these. For example another one writing the data to a custom object
-  Ability to add logs individually as well as bulk
-  Ability to add logs syncrhonously as well as asynchronously
-  Ability to view the logs as tree - Leverages log view component from [Robert](https://github.com/rsoesemann)'s repo https://github.com/rsoesemann/apex-unified-logging/tree/master/force-app/main/default/lwc/logMonitor

## Examples
-  Splunk/postman-echo example makes callout with the log data. Still the log can be added after DMLs.
   ```
    Logger.addLog('Starting');
    Contact c1 = new Contact (LastName = 'John');
    Logger.addLog(c1);
    insert c1;
    Logger.addLog('Test Script', Logger.Level.INFO, JSON.serialize(c1));
    Logger.addLog('Finished');

   ```

## Todo list

- Allow users to set log level in custom setting and respect that in logger
- Add logging mechanisms from flows, process builders, LWCs etc