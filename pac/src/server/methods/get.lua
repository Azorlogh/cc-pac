-- pac-get
-- gets the package content 
local json = require("modules.json")
local log = require("modules.log")
local ccutil = require("modules.ccutil")
local CODE = require("code")
local pkg = require("pkg")

return function(msg)
    log.debug("req: get "..msg)
    local path = msg:gsub("%.", ""):gsub("%/", "")
    if path ~= msg then
        return {
            code = CODE.INVALID_PACKAGE
        }
    end
    path = "/"..path
    local pkg = pkg:fromDir(HOSTED_PATH..path)
    if not pkg then
        return {
            code = CODE.INVALID_PACKAGE
        }
    end
    return {
        code = CODE.OK,
        body = pkg
    }
end
