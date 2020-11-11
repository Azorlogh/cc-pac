local util = require("modules.util")

_log_level = 0

function log(level, prefix, msg)
    if _log_level >= level then
        write(prefix.." ")
        util.printr(msg)
    end
end

return {
    error = function(msg)
        log(1, "[err]", msg)
    end,
    warn = function(msg)
        log(2, "[war]", msg)
    end,
    info = function(msg)
        log(3, "[inf]", msg)
    end,
    debug = function (msg)
        log(4, "[deb]", msg)
    end,
    trace = function (msg)
        log(5, "[tra]", msg)
    end,
    
    set_error = function() _log_level = 1 end,
    set_warn = function() _log_level = 2 end,
    set_info = function() _log_level = 3 end,
    set_debug = function() _log_level = 4 end,
    set_trace = function() _log_level = 5 end
}
