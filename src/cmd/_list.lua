local util = require("modules.util")
local ccutil = require("modules.ccutil")
local CODE = require("code")

return function(args)
    ccutil.rednetOpenAny()
    local id = rednet.lookup("pac-list-req", config.server)
    rednet.send(id, nil, "pac-list-req")
    local _, res = rednet.receive("pac-list-res")
    if res.code ~= 0 then
        print(CODE[res.code])
        return
    end
    util.printr(res.body)
end
