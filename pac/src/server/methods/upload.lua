-- pac upload
-- uploads a package to the server
local log = require("modules.log")
local pkg = require("pkg")
local CODE = require("code")

return function(msg)
    local pkg = pkg:fromTable(msg)
    local name = pkg.meta.name
    local path = HOSTED_PATH.."/"..name
    if fs.exists(path) then
        log.warn("replacing package "..name)
        fs.delete(path)
    end
    pkg:save(path)
    log.debug("added package "..name)
    return {
        code = CODE.OK
    }
end
