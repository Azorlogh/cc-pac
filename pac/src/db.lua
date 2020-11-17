local log = require("modules.log")
local ccutil = require("modules.ccutil")
local json = require("modules.json")

local Db = {}
Db.__index = Db

function Db:load()
    local f = fs.open(DB_PATH, "r")
    local t
    if f then
        t = json.decode(f:readAll())
    else
        log.debug("Database missing. Creating...")
        t = {
            pkgs = {},
            dir_holders = {},
            pkg_holders = {}
        }
    end
    setmetatable(t, self)
    t:save()
    return t
end

function Db:save()
    local f = fs.open(DB_PATH, "w")
    f.write(json.encode(self))
    f.close()
end

function Db:getInstalled()

end

function Db:isInstalled(name)
    return self.pkgs[name] ~= nil
end

function Db:install(pkg, explicit)
    local name = pkg.meta.name
    self.pkgs[name] = {
        contents = {},
        deps = pkg.meta.deps or {},
        explicit = explicit or false
    }
    -- add pkg to its deps' holders
    for _, v in ipairs(pkg.meta.deps or {}) do
        table.insert(self.pkg_holders[v], name)
    end
    -- create holder table for dep
    self.pkg_holders[name] = {parent}
    -- save files while adding dir holder info
    ccutil.saveDir("", pkg.data, function(path, entry)
        if type(entry) == "table" then
            if not self.dir_holders[path] then
                self.dir_holders[path] = {name}
            else
                table.insert(self.dir_holders[path], name)
            end
        end
        table.insert(self.pkgs[name].contents, path)
    end)
    self:save()
end

function Db:uninstall(name)
    local pkg = self.pkgs[name]
    local contents = pkg.contents
    
    -- remove holder from deps
    for _, dep in ipairs(pkg.deps) do
        local holders = self.pkg_holders[dep]
        for i=#holders, 1, -1 do
            if holders[i] == name then
                table.remove(holders, i)
            end
        end
    end
    
    -- remove holder info    
    self.pkg_holders[name] = nil

    -- delete files
    for _, entry in ipairs(contents) do
        if not self.dir_holders[entry] then -- file
            fs.delete(entry)
        end
    end
    -- delete dir holders & dirs
    for _, entry in ipairs(contents) do
        local holders = self.dir_holders[entry]
        if holders then -- dir
            for i=#holders, 1, -1 do
                if holders[i] == name then
                    table.remove(holders, i)
                end
            end
            if #holders == 0 and #fs.list(entry) == 0 then
                fs.delete(entry)
                self.dir_holders[entry] = nil
            end
        end
    end
    self.pkgs[name] = nil
    self:save()
end

function Db:orphans()
    local orphans = {}
    for k, v in pairs(self.pkg_holders) do
        if #v == 0 and not self.pkgs[k].explicit then
            table.insert(orphans, k)
        end
    end
    return orphans
end

return Db
