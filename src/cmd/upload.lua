local log = require("modules.log")
local ccutil = require("modules.ccutil")
local CODE = require("code")
local pkg = require("pkg")

return function(args)
    local path = shell.resolve(args[1])
    if not fs.isDir(path) then
        log.error("path is not a directory")
    end
    local pkg = pkg:fromDir(path)
    ccutil.rednetOpenAny()
    local srv = rednet.lookup("pac-upload-req", config.server)
    
    -- check if already there
    rednet.send(srv, pkg.meta.name, "pac-info-req")
    local _, res = rednet.receive("pac-info-res")
    if res.code == CODE.OK then
        log.warn("Package already exists. Replace ? [y/N]")
        local ans = read()
        if ans ~= "y" and ans ~= "Y" then
            log.warn("Not replacing.")
            return
        end
    end

    -- send package
    log.debug("Uploading package...")
    rednet.send(srv, pkg, "pac-upload-req")
    local _, res = rednet.receive("pac-upload-res")
    if res.code ~= CODE.OK then
        log.error(CODE[res.code])
        return
    end
    log.debug("Successfully uploaded package")
end
