local util = require("modules.util")
local CODE = require("code")

return function(args)
    rednet.open(config.side)
    local id = rednet.lookup("pac-info-req", config.server)
    rednet.send(id, args[1], "pac-info-req")
    local _, res = rednet.receive("pac-info-res")
    if res.code ~= 0 then
        print(CODE[res.code])
        return
    end
    util.printr(res.body)
end
