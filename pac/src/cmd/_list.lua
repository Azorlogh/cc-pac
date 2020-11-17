local util = require("modules.util")
local ccutil = require("modules.ccutil")
local CODE = require("code")
local log = require("modules.log")
local Db = require("db")

function listInstalled()
    local db = Db:load()
    log.info("Packages installed on device:")
    util.printr(db:getInstalled())
end

function listServerPackages()
    ccutil.rednetOpenAny()
    local id = rednet.lookup("pac-list-req", config.server)
    rednet.send(id, nil, "pac-list-req")
    local _, res = rednet.receive("pac-list-res")
    if res.code ~= 0 then
        log.error(CODE[res.code])
        return
    end
    log.info("Packages hosted on server:")
    util.printr(res.body)
end

return function(args)
    local installed = false
    for _, arg in ipairs(args) do
        if arg == "-i" or "--installed" then
            installed = true
        end
    end
    if installed then
        listInstalled()
    else
        listServerPackages()
    end
end
