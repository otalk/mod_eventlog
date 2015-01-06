if module:get_host_type() ~= "component" then
    error("Event logger should be loaded as a component, please see http://prosody.im/doc/components", 0);
end

local xmlns_log = "urn:xmpp:eventlog";
local log_levels = {
    Debug = "debug",
    Informational = "info",
    Warning = "warn",
    Error = "error"
};


module:depends("disco");
module:add_identity("component", "log", module:get_option_string("name", "Event Logger"));
module:add_feature("urn:xmpp:eventlog");

local jid = require "util.jid"
module:hook("message/host", function (event)
    local origin, stanza = event.origin, event.stanza;

    local log = stanza:get_child("log", xmlns_log);
    if not log then
        return
    end

    local logType = log.attr.id;

    if logType == "metric" then
        local user, host, resource = jid.prepped_split(stanza.attr.from)
        local from = host
        local service = log.attr.facility:sub(9);
        for tag in log:childtags("tag", xmlns_log) do
            local metric = tag.attr.name;
            local value = tag.attr.value;
            module:log("debug", "METRIC: Event stat: %s = %s", metric, value);
            module:fire_event("eventlog-stat", {
                from = from,
                service = service,
                room = log.attr.subject,
                metric = metric,
                value = value
            });
        end
        return true;
    elseif logType == "log" then
        local level = log_levels[log.attr.type] or "info";
        local message = log:get_child_text("message", xmlns_log);
        if not message then
            return;
        end

        module:log(level, "CLIENTLOG: %s", message);
        return true;
    end
end);


module:log("info", "Started event log component");
