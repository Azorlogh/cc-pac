print("fancy!")

local themes = fs.list("/themes")
for _, v in ipairs(themes) do
    print("fancy "..v.."!")
end
