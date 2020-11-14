local CODE = require("code")
local ccutil = require("modules.ccutil")
local db = require("db")
local json = require("modules.json")
local pkg = require("pkg")
local log = require("modules.log")

local function installLocal(name)
    local path = shell.resolve(name)
    local pkg = pkg:fromDir(path)
    if not pkg then
        log.error("path "..path.." is not a package")
        return
    end
    log.debug("successfully parsed package")
    log.trace(pkg)
    local db = db:load()
    for _, dep in ipairs(pkg.meta.deps or {}) do
        log.trace("checking dependency: "..dep)
        if not db:is_installed(dep) then
            log.error("missing dependency: "..dep)
            return
        end
    end
    log.debug("dependencies all installed")
    log.info("installing...")
    db:install(pkg)
end

local function installOnline(name)
    ccutil.rednetOpenAny()
    local srv = rednet.lookup("pac-get-req", config.server)
    local db = db:load()
    local new_files = {} -- to check for conflicts
    local pkgs = {} -- cached packages
    local must_resolve = {name} -- already?deps?
    while #must_resolve > 0 do
        local name = table.remove(must_resolve)
        log.info("resolving "..name)
        if not db:is_installed(name) then
            log.info("is not installed")
            rednet.send(srv, name, "pac-get-req")
            local _, res = rednet.receive()
            if res.code ~= CODE.OK then
                log.error("couldn't fetch package: "..name)
                return
            end
            log.debug("acquired package from server")
            local pkg = pkg:fromTable(res.body)
            table.insert(pkgs, pkg)
            local files = pkg:getFiles()
            log.debug("checking conflicts")
            for _, file in ipairs(files) do
                if new_files[file] or fs.exists(file) then
                    log.error("conflicting files: "..file)
                    return
                end
                new_files[file] = true
            end
            log.debug("checking dependencies")
            for _, dep in ipairs(pkg.meta.deps or {}) do
                log.debug("adding "..dep.." to be resolved")
                table.insert(must_resolve, dep)
            end
        end
    end
    
    for i=#pkgs, 1, -1 do
        local pkg = pkgs[i]
        log.info("Installing "..pkg.meta.name.."...")
        local explicit = pkg.meta.name == name
        db:install(pkg, explicit)
    end
end

return function(args)
    local loc = false
    for i=#args, 1, -1 do
        if args[i] == "--local" or args[i] == "-l" then
            loc = true
            table.remove(args, i)
        end
    end
    local name = args[1]
    if loc then
        installLocal(name)
    else
        installOnline(name)
    end
    return loc
end
