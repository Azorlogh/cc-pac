local json = require("modules.json")
local log = require("modules.log")

local server = {}
server.__index = server

function server:new()
    local t = {}
    setmetatable(t, self)
    t.should_close = false
    return t
end

local methods = {
    list = require("server.methods._list"),
    info = require("server.methods.info"),
    get = require("server.methods.get"),
    upload = require("server.methods.upload")
}

function server:run()
    rednet.open(config.side)
    rednet.host("pac-list-req", "pac.io")
    rednet.host("pac-info-req", "pac.io")
    rednet.host("pac-get-req", "pac.io")
    rednet.host("pac-upload-req", "pac.io")
    
    while not self.should_close do
        id, msg, prot = rednet.receive()
        log.info(prot)
        log.info(msg)
        if     prot == "pac-list-req" then
            local res = methods.list(msg)
            rednet.send(id, res, "pac-list-res")
        
        elseif prot == "pac-info-req" then
            local res = methods.info(msg)
            rednet.send(id, res, "pac-info-res")
        
        elseif prot == "pac-get-req" then
            local res = methods.get(msg)
            rednet.send(id, res, "pac-get-res")
        
        elseif prot == "pac-upload-req" then
            local res = methods.upload(msg)
            rednet.send(id, res, "pac-upload-res")
        else
            log.info("invalid message")
        end
    end
end

function server:close()
    rednet.close()
end

return server
