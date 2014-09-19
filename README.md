# `mod_eventlog`

Receives XEP-0337 event log data and converts & forwards it to our centralized logging facilities.

## Configuring

Add this as a component entry to your `prosody.cfg`:

```lua
Component "metrics.HOSTNAME" "eventlog"
```
