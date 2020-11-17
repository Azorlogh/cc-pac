-- pac autocomplete

local params = {
    ["help"] = {},
    ["get"] = {},
    ["install"] = {},
    ["uninstall"] = {},
    ["upload"] = {},
    ["host"] = {}
}

shell.setCompletionFunction(
    "bin/pac.lua",
    function(
        shell,
        parNb,
        currText,
        lastText
    )
        local params = params
        for i=2, #lastText do
            if params[lastText[i].." "] then
                params = params
            else
                return {}
            end
        end
        
        local results = {}
        for word, _ in pairs(params) do
            if word:sub(1, #currText) == currText then
                table.insert(results, word:sub(#currText + 1))
            end
        end
        return results
    end
)
