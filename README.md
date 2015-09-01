# mod\_eventlog

Receives XEP-0337 event log data and converts & forwards it to our centralized logging facilities.

## Configuring

Add this as a component entry to your `prosody.cfg`:

```lua
Component "metrics.HOSTNAME" "eventlog"
```


## Log ID patterns:

- `log`

    Log events will write directly to the Prosody log.

- `web-ui-metric-X`

    Track the metric X in the 'web' category. Generates `eventlog-stat` event.

- `ios-ui-metric-X`

    Track the metric X in the 'ios' category. Generates `eventlog-stat` event.

- `webrtc-metric-X`

    Track the metric X in the 'webrtc' category. Generates `eventlog-stat` event.

- `webrtc-trace`

    Save a trace from a WebRTC session. Generates `eventlog-trace` event.

- `session-event`

    Save a trace from a Jingle session. Generates `eventlog-trace` event.


## Events

- `eventlog-stat`

The `eventlog-stat` event looks like:

```json
{
    "category": "str",               // 'web', 'ios', 'webrtc', etc
    "from": "users.example.com",     // Domain serving the user that generated the event
    "service": "hosted.talky.io",    // MUC domain of the Talky instance used here
    "room": "foo",                   // Talky room name
    "metric": "clicked-button",      // Name of the metric we're logging
    "value": 1,                      // Value of the tracked metric
    "meta": { ... }                  // Optional additional key/value pairs for metadata
                                     //     about the metric (e.g. browser/os versions)
}
```

- `eventlog-trace`

The `eventlog-trace` event looks like:

```json
{
    "category": "str",               // 'web', 'ios', 'webrtc', etc
    "from": "users.example.com",     // Domain serving the user that generated the event
    "service": "hosted.talky.io",    // MUC domain of the Talky instance used here
    "room": "foo",                   // Talky room name
    "trace": { ... }                 // Key/value pairs of the trace data
}
```
