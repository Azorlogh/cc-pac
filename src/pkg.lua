local json = require("modules.json")
local ccutil = require("modules.ccutil")

local pkg = {}
pkg.__index = pkg

function pkg:fromDir(path)
    local f = fs.open(path.."/meta.json", "r")
    if not f then
        return nil, "couldn't open package"
    end
    local t = {
        meta = json.decode(f.readAll()),
        data = ccutil.loadDir(path.."/files")
    }
    return pkg:fromTable(t)
end

function pkg:fromTable(t)
    setmetatable(t, self)
    return t
end

function pkg:save(path)
    local f = fs.open(path.."/meta.json", "w")
    f.write(json.encode(self.meta))
    f.close()
    
    ccutil.saveDir(path.."/files", self.data)
end

function pkg:getFiles()
    local function go(acc, path, data)
        for k, v in pairs(data) do
            local path = path.."/"..k
            if type(v) == "table" then
                go(acc, path, v)
            else
                table.insert(acc, path)
            end
        end
    end
    local files = {}
    go(files, "", self.data)
    return files
end

return pkg
