local args = {...}
args = table.concat(args, " ")
shell.run("/pac/src/main "..args)
