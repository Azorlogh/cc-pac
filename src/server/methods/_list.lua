-- pac-list
-- lists all packages on the server

local CODE = require("code")
local log = require("modules.log")

return function()
    log.debug("req: list")
    local pkgs = fs.list(HOSTED_PATH)
    return {
        code = CODE.OK,
        body = pkgs
    }        
end
