local util = require("modules.util")
local ccutil = require("modules.ccutil")
local CODE = require("code")
local log = require("modules.log")
local pkg = require("pkg")

return function(args)
    ccutil.rednetOpenAny()
    local id = rednet.lookup("pac-get-req", config.server)
    rednet.send(id, args[1], "pac-get-req")
    local _, res = rednet.receive("pac-get-res")
    if res.code ~= 0 then
        log.error(CODE[res.code])
        return
    end
    log.info(res.body)
    local path = shell.resolve(args[2] or args[1])
    fs.makeDir(path)
    local pkg = pkg:fromTable(res.body)
    pkg:save(path)
end
