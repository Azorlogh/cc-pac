local json = require("modules.json")
local log = require("modules.log")

BASE_PATH = "/pac"
CONFIG_PATH = BASE_PATH.."/cfg.json"
HOSTED_PATH = BASE_PATH.."/hosted"
DB_PATH = BASE_PATH.."/db.json"

function getConfig()
    local f = fs.open(CONFIG_PATH, "r")
    return json.decode(f:readAll())
end
config = getConfig()

local cmds = {
    host = require("cmd.host"),
    list = require("cmd._list"),
    info = require("cmd.info"),
    get = require("cmd.get"),
    install = require("cmd.install"),
    uninstall = require("cmd.uninstall"),
    upload = require("cmd.upload"),
    help = require("cmd.help")
}

log.set_info()

local args = {...}
for i=#args, 1, -1 do
    local arg = args[i]
    if arg == "--verbose" or arg == "-v" then
        print("launching in verbose mode...")
        log.set_trace()
        table.remove(args, i)
    end
end

local cmd = table.remove(args, 1)
if cmd == "host" then
    cmds.host(args)
elseif cmd == "list" then
    cmds.list(args)
elseif cmd == "info" then
    cmds.info(args)
elseif cmd == "get" then
    cmds.get(args)
elseif cmd == "install" then
    cmds.install(args)
elseif cmd == "uninstall" then
    cmds.uninstall(args)
elseif cmd == "upload" then
    cmds.upload(args)
elseif cmd == "help" then
    cmds.help(args)
else
    print("Unknown command: "..cmd)
end

rednet.close()
