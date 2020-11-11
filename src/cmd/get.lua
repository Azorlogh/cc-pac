local util = require("modules.util")
local ccutil = require("modules.ccutil")
local CODE = require("code")

return function(args)
    rednet.open(config.side)
    local id = rednet.lookup("pac-get-req", config.server)
    rednet.send(id, args[1], "pac-get-req")
    local _, res = rednet.receive("pac-get-res")
    if res.code ~= 0 then
        print(CODE[res.code])
        return
    end
    util.printr(res.body)
    local path = shell.resolve(args[2])
    fs.makeDir(path)
    ccutil.saveDir(path, res.body)
end
