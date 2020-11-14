local util = {}

function util.rednetOpenAny()
    rednet.open("bottom")
    rednet.open("top")
    rednet.open("back")
    rednet.open("front")
    rednet.open("right")
    rednet.open("left")
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
