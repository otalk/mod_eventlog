# mod\_eventlog

Receives XEP-0337 event log data and converts & forwards it to our centralized logging facilities.

## Configuring

Add this as a component entry to your `prosody.cfg`:

```lua
Component "metrics.HOSTNAME" "eventlog"
```

## Using

Event log messages with `id="log"` will be converted and logged directly to Prosody's logging system.

Logs with `id="metric"` will trigger `eventlog-stat` events, one for each tag included in the log, and the event payload is an object with `room`, `metric`, and `value` fields.
