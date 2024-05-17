# Logging utility written in apex

## Common Logging Scenarios
    - Synchronous single log
    - Synchronous bulk logs
    - Asynchronous single log
    - Asynchronous bulk logs

## Features

-  We can handle more ways of writing logs using dependency injection
    - SplunkLogWriterImplementation - postman-echo example
    - SystemDebugLogWriterImplementation - Synchronous logging sample
    - There could be more like these. For example another one writing the data to a custom object

## Todo list

- Allow users to set log level in custom setting and respect that in logger