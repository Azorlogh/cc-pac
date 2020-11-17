local server = require("server.mod")

return function(args)
    local serv = server:new()
    parallel.waitForAny(
        function()
            serv:run()
        end,
        function()
            log.info("press enter to stop")
            io.read()
        end
    )
    serv:close()
end
