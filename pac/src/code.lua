local CODES = {
    OK = 0,
    INVALID_PACKAGE = 1
}

local MSG = {}
for k, v in pairs(CODES) do
    MSG[v] = k
end

for k, v in pairs(MSG) do
    CODES[k] = v
end

return CODES
