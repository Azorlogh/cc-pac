local util = {}

function util.rednetOpenAny()
    local function try(side)
        if peripheral.getType(side) == "modem" then
            rednet.open(side)
            return true
        end
        return false
    end
    if try("bottom") then return end
    if try("top") then return end
    if try("back") then return end
    if try("front") then return end
    if try("right") then return end
    if try("left") then return end
    print("couldn't find modem")
end

function util.loadDir(path)
    local data = {}
    local items = fs.list(path)
    for _, item in ipairs(items) do
        local p = path.."/"..item
        if fs.isDir(p) then
            data[item] = util.loadDir(p)
        else
            print(p)
            data[item] = fs.open(p, "r").readAll()
        end
    end
    return data
end

function util.saveDir(path, data, cb)
    for k, v in pairs(data) do
        local p = path.."/"..k
        if cb then cb(p, v) end
        if type(v) == "table" then
            fs.makeDir(p)
            util.saveDir(p, v, cb)
        else
            local f = fs.open(p, "w")
            f.write(v)
            f.close()
        end
    end
end

return util
