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


module:hook("message/host", function (event)
    local origin, stanza = event.origin, event.stanza;

    local log = stanza:get_child("log", xmlns_log);
    if not log then
        return true;
    end

    local logType = log.attr.id;
    local logMessage = {
        service = log.attr.facility,
        room = log.attr.subject,
    };

    if logType == "metric" then
        for tag in log:childtags("tag", xmlns_log) do
            logMessage.metric = tag.attr.name;
            logMessage.value = tag.attr.value;

            module:log("debug", "METRIC: Event stat: %s", json.encode(logMessage));
            module:fire_event("eventlog-stat", logMessage);
        end
    elseif logType == "log" then
        local level = log_levels[log.attr.type] or "info";
        local message = log:get_child_text("message", xmlns_log);
        if message then
            logMessage.message = message;
            module:log(level, "CLIENTLOG: %s", json.encode(logMessage));
        end
    elseif logType == "peerconnectiontrace" then
        for tag in log:childtags("tag", xmlns_log) do
            local value = tag.attr.value;
            if value[1] == "{" or value[1] == "[" then
                value = json.decode(value);
            end
            logMessage[tag.atter.name] = value;
        end
        module:log("debug", "PEERCONNECTIONTRACE: %s", json.encode(message));
    end

    return true;
end);


module:log("info", "Started event log component");
