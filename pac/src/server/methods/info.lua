-- pac-info
-- gets information about the specified package
local json = require("modules.json")
local CODE = require("code")
local log = require("modules.log")

return function(msg)
    log.debug("req: info "..msg)
    local path = msg:gsub("%.",""):gsub("%/","")
    if msg ~= path then -- name contains . or /
        return {
            code = CODE.INVALID_PACKAGE,
        }
    end
    path = "/"..path
    local f = fs.open(HOSTED_PATH..path.."/meta.json", "r")
    if not f then -- does not exist
        return {
            code = CODE.INVALID_PACKAGE,
        }
    end
    return {
        code = CODE.OK,
        body = json.decode(f:readAll())
    }
end
