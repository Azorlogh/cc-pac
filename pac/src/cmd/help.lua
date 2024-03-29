local log = require("modules.log")

local HELP = " \
<pkg>: package directory \
<name>: package name (server) \
pac help \
  Display this message. \
pac list \
  List names on server. \
pac info <name> \
  Display info on <name>. \
pac install (name | -l pkg) \
  <name> from server, \
  or local dir <pkg>. \
pac uninstall <name> \
  Uninstall <name>. \
pac upload <pkg> \
  Upload <pkg> on server. \
"

return function()
    log.info(HELP)
end
