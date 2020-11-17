local db = require("db")
local log = require("modules.log")

return function(args)
    local name = args[1]
    local db = Db:load()
    if not db:isInstalled(name) then
        log.error("Package "..name.." is not installed.")
        return
    end
    write("Uninstall "..name.."? [Y/n] ")
    local ans = read()
    if ans ~= "" and ans ~= "y" and ans ~= "Y" then
        log.warn("Keeping package")
        return
    end
    db:uninstall(name)
    log.info("Successfully uninstalled "..name)
    
    local finished = false
    while not finished do
        finished = true
        local orphans = db:orphans()
        while #orphans > 0 do
            local orphan = table.remove(orphans)
            write("Remove orphan "..orphan.."? [y/N] ")
            local ans = read()
            if ans == "y" or ans == "Y" then
                db:uninstall(orphan)
                finished = false
            end
        end
    end
end
