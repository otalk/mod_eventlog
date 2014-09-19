if module:get_host_type() ~= "component" then
    error("Event logger should be loaded as a component, please see http://prosody.im/doc/components", 0);
end


module:add_identity("component", "log", module:get_option_string("name", "Event Logger"));
module:add_feature("urn:xmpp:eventlog");
